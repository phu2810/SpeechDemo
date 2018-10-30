//
// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "SpeechRecognitionService.h"

#import <GRPCClient/GRPCCall+ChannelArg.h>
#import <GRPCClient/GRPCCall+Tests.h>
#import <RxLibrary/GRXBufferedPipe.h>
#import <ProtoRPC/ProtoRPC.h>

@interface SpeechRecognitionService ()

@property (nonatomic, assign) BOOL streaming;
//
@property (nonatomic, strong) StreamVoice *clientVTCC;
@property (nonatomic, strong) GRXBufferedPipe *writer;
@property (nonatomic, strong) GRPCProtoCall *call;

@end

@implementation SpeechRecognitionService

+ (instancetype) sharedInstance {
  static SpeechRecognitionService *instance = nil;
  if (!instance) {
    instance = [[self alloc] init];
    instance.sampleRate = 16000.0; // default value
      instance.host = @"";
      instance.port = @"";
  }
  return instance;
}

- (void) streamAudioDataVTCC:(NSData *_Nullable) audioData isRecordAllTime:(BOOL)recordAllTime sampleRate:(int)rate withCompletion:(SpeechRecognitionVTCCCompletionHandler _Nullable )completion {
    if (!_streaming) {
        // if we aren't already streaming, set up a gRPC connection
        
        NSString *serverIp = [NSString stringWithFormat:@"%@:%@", self.host, self.port];
        
        [GRPCCall useInsecureConnectionsForHost:serverIp];
        //
        _clientVTCC = [[StreamVoice alloc] initWithHost:serverIp];
        //
        _writer = [[GRXBufferedPipe alloc] init];
        //
        _call = [_clientVTCC RPCToSendVoiceWithRequestsWriter:_writer eventHandler:^(BOOL done, TextReply * _Nullable response, NSError * _Nullable error) {
            completion(done, response, error);
        }];
        //
        _call.requestHeaders[@"channels"] = @"1";
        _call.requestHeaders[@"rate"] = [NSString stringWithFormat:@"%d", rate];
        _call.requestHeaders[@"format"] = @"S16LE";
        _call.requestHeaders[@"single_sentence"] = recordAllTime ? @"True" : @"False";
        //_call.requestHeaders[@"token"] = @"demo_token";
        //
        [_call start];
        //
        _streaming = YES;
    }
    VoiceRequest *voiceRequest = [VoiceRequest message];
    voiceRequest.byteBuff = audioData;
    [_writer writeValue: voiceRequest];
}
- (void) stopStreaming {
  if (!_streaming) {
    return;
  }
  [_writer finishWithError:nil];
  _streaming = NO;
}

- (BOOL) isStreaming {
  return _streaming;
}

@end
