//
//  MicroBar.m
//  Speech
//
//  Created by Phu on 10/18/18.
//  Copyright © 2018 Google. All rights reserved.
//

#import "MicroBar.h"
#import "Utils.h"
#import "Speech-Swift.h"

@interface MicroBar () {
    ASDisplayNode *lineTop;
    ASButtonNode *micButton;
    NVActivityIndicatorView *recordingView;
}

@end

@implementation MicroBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        lineTop = [ASDisplayNode new];
        lineTop.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [self addSubnode:lineTop];
        
        micButton = [ASButtonNode new];
        [micButton setImage:[Utils image:[UIImage imageNamed:@"mic_chat_box_with_bound"] size:CGSizeMake(40, 40)] forState:ASControlStateNormal];
        [self addSubnode:micButton];
        
    }
    return self;
}

- (void) layout {
    [super layout];
    [self calculateFrame];
}
- (void) calculateFrame {
    CGRect frame = CGRectZero;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.height = 1;
    frame.size.width = self.bounds.size.width;
    lineTop.frame = frame;
    
    frame = CGRectZero;
    frame.origin.x = (self.bounds.size.width - self.bounds.size.height)/2.0;
    frame.origin.y = 0;
    frame.size.height = self.bounds.size.height;
    frame.size.width = self.bounds.size.height;
    micButton.frame = frame;
    
    frame = self.bounds;
    frame.size.height = 75;
    frame.size.width = 75;
    frame.origin.y = (self.bounds.size.height - frame.size.height)/2.0;
    frame.origin.x = (self.bounds.size.width - frame.size.width)/2.0;
    recordingView.frame = frame;
}
- (void) addTarget:(id)target selector:(SEL)sel {
    [micButton addTarget:target action:sel forControlEvents:ASControlNodeEventTouchUpInside];
}

- (void) setRecording:(BOOL)isRecording {
    if (recordingView) {
        [recordingView removeFromSuperview];
    }
    if (!isRecording) {
        return;
    }
    if (!recordingView) {
        recordingView = [NVActivityIndicatorView createIndicatorView];
        recordingView.type = NVActivityIndicatorTypeBallScaleMultiple;
        recordingView.color = [UIColor colorWithRed:52.0/255.0 green:168.0/255.0 blue:234.0/255.0 alpha:1.0];
        recordingView.padding = 0.0;
        recordingView.frame = CGRectMake(0, 0, 75, 75);
        [recordingView startAnimating];
    }
    [self.view insertSubview:recordingView belowSubview:micButton.view];
    [self calculateFrame];
}

@end
