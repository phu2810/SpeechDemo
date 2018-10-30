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

#import <AVFoundation/AVFoundation.h>

#import "SpeechControl.h"
#import "AudioController.h"
#import "SpeechRecognitionService.h"
#import "google/cloud/speech/v1/CloudSpeech.pbrpc.h"
#import "Speech-Swift.h"
#import "Manager.h"
#import "TtsVTCCControl.h"

@interface SpeechControl () <AudioControllerDelegate> {
    NSTimeInterval lastTimeReceiveTranscript;
    NSString *currentText;
    NSTimer *timer;
    int sampleRate;
    BOOL isRecordAllTime;
}
@property (nonatomic, strong) NSMutableData *audioData;
@end

@implementation SpeechControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        [AudioController sharedInstance].delegate = self;
        sampleRate = 16000;
    }
    return self;
}

- (void) recordAudio:(int)rate host:(NSString *)host port:(NSString *)port recordAllTime:(BOOL)recordAllTime{
    
    sampleRate = rate;
    isRecordAllTime = recordAllTime;
    
    [[TtsVTCCControl instance] stopPlayer];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    _audioData = [[NSMutableData alloc] init];
    [[AudioController sharedInstance] prepareWithSampleRate:sampleRate];
    [[SpeechRecognitionService sharedInstance] setSampleRate:sampleRate];
    [[SpeechRecognitionService sharedInstance] setHost:host];
    [[SpeechRecognitionService sharedInstance] setPort:port];
    [[AudioController sharedInstance] start];
    
    [self cancelTimer];
    lastTimeReceiveTranscript = [[NSDate date] timeIntervalSince1970];
    currentText = @"";
    [self timerStopRecording];
}

- (void) stopAudio {
    
    [[AudioController sharedInstance] stop];
    [[SpeechRecognitionService sharedInstance] stopStreaming];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
}

- (void) processSampleData:(NSData *)data {
    NSLog(@"vao day %@", @(data.length));
    [self.audioData appendData:data];
    // We recommend sending samples in 100ms chunks
    // 1 sample = 16bit = 2 byte
    // SampleRate = 8000 sample/1s ==> 16000 byte data / 1s
    // 1s sent 4 VoiceRequest ==> chuck_size = 16000 / 4 = 4000 byte
    int chunk_size = (sampleRate * 2) / 8; // Old code: 0.1 /* seconds/chunk */ * sampleRate * 2 /* bytes/sample */ ; /* bytes/chunk */
    
    if ([self.audioData length] > chunk_size) {
        [[SpeechRecognitionService sharedInstance] streamAudioDataVTCC:self.audioData isRecordAllTime:isRecordAllTime sampleRate:sampleRate withCompletion:^(BOOL done, TextReply * _Nullable response, NSError * _Nullable error) {
            NSLog(@"vtcc recognize %@ - %@", response, error);
            if (error || !response || ![response.msg isEqualToString:@"STATUS_SUCCESS"]) {
                
                [self finishWithFinalText:currentText];
                
            } else if (response && response.hasResult && response.result) {
                BOOL finished = response.result.final;
                
                lastTimeReceiveTranscript = [[NSDate date] timeIntervalSince1970];
                [self cancelTimer];
                
                currentText = @"";
                
                TextReply_Result_Hypothese *result = response.result.hypothesesArray[0];
                currentText = result.transcriptNormed;
                
                if (!finished) {
                    // Update current text to display
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate receiveTextFromSpeech:currentText];
                    });
                    [self timerStopRecording];
                }
                else {
                    [self finishWithFinalText:currentText];
                }
            }
        }];
        
        self.audioData = [[NSMutableData alloc] init];
    }
}
- (void) cancelTimer {
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
- (void) timerStopRecording {
//    [self cancelTimer];
//    if (currentText.length == 0) {
//        timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checkStopRecording) userInfo:nil repeats:NO];
//    }
//    else {
//        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkStopRecording) userInfo:nil repeats:NO];
//    }
}
- (void) checkStopRecording {
    if ([[NSDate date] timeIntervalSince1970] - lastTimeReceiveTranscript >= 2) {
        [self finishWithFinalText:currentText];
    }
}
- (void) finishWithFinalText:(NSString *) text {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate receiveFinalTextFromSpeech:text];
    });
    
    if (![[SpeechRecognitionService sharedInstance] isStreaming]) {
        return;
    }
    
    [self cancelTimer];
    
    if (isRecordAllTime) {
        [[SpeechRecognitionService sharedInstance] stopStreaming];
    }
    else {
        [self.delegate stopRecording];
    }
    currentText = @"";
}
@end

