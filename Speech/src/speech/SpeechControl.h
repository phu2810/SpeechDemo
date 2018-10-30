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

#import <UIKit/UIKit.h>

@protocol SpeechControlDelegate <NSObject>

- (void) receiveTextFromSpeech: (NSString *) text;

- (void) receiveFinalTextFromSpeech: (NSString *) text;

- (void) stopRecording;

- (void) startRecording;

@end

@interface SpeechControl : NSObject

@property (nonatomic, weak) id<SpeechControlDelegate> delegate;

- (void) recordAudio:(int)sampleRate host:(NSString *)host port:(NSString *)port recordAllTime:(BOOL)recordAllTime;
- (void) stopAudio;

@end
