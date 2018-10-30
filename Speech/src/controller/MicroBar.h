//
//  MicroBar.h
//  Speech
//
//  Created by Phu on 10/18/18.
//  Copyright © 2018 Google. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncDisplayKit.h"

@interface MicroBar : ASDisplayNode

- (void) addTarget:(id)target selector:(SEL)sel;

- (void) setRecording:(BOOL)isRecording;

@end
