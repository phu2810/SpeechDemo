//
//  SpeechController.m
//  Speech
//
//  Created by Phu on 10/18/18.
//  Copyright © 2018 Google. All rights reserved.
//

#import "SpeechController.h"
#import "Utils.h"
#import "SetUpController.h"
#import "MicroBar.h"
#import "SpeechControl.h"
#import "SpeechRecognitionService.h"
#import "GVUserDefaults+Properties.h"
#import "Manager.h"

@interface SpeechController () <SpeechControlDelegate> {
    MicroBar *microBar;
    BOOL isRecording;
    SpeechControl *speechControl;
    ASTextNode *textNode;
    ASTextNode *allTextNode;
}

@end

@implementation SpeechController

- (instancetype)init
{
    self = [super initWithNode:[ASDisplayNode new]];
    if (self) {
        isRecording = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [Manager instance].speechController = self;
    
    self.node.backgroundColor = [UIColor whiteColor];
    
    microBar = [MicroBar new];
    [microBar addTarget:self selector:@selector(actionMicroButton)];
    [self.node addSubnode:microBar];
    
    textNode = [ASTextNode new];
    [self.node addSubnode:textNode];
    
    allTextNode = [ASTextNode new];
    allTextNode.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:[self allTextStyle]];
    [self.node addSubnode:allTextNode];
    
    [self addNavBar];
    [self.navBar setTitle:@"Speech VTCC"];
    [self.navBar.leftBtn setImage:[Utils image:[UIImage imageNamed:@"more_nav"] size:CGSizeMake(22, 22)] forState:ASControlStateNormal];
    [self.navBar.leftBtn addTarget:self action:@selector(goToSetupController) forControlEvents:ASControlNodeEventTouchUpInside];
    
    [self setUpSpeechControl];
}
- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect contentRect = [self getContentRect];
    
    CGRect frame = CGRectZero;
    frame.origin.x = 0;
    frame.origin.y = contentRect.size.height - 60;
    frame.size.height = 60;
    frame.size.width = contentRect.size.width;
    microBar.frame = frame;
    
    [self updateFrameTextNode];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRecordWhenControllerDisappear];
}
- (void) updateFrameTextNode {
    CGRect frame = CGRectZero;
    
    CGRect contentRect = [self getContentRect];
    frame.size.height = 60;
    frame.size.width = contentRect.size.width - 20;
    
    CGSize size = [textNode calculateSizeThatFits:CGSizeMake(frame.size.width, MAXFLOAT)];
    frame.size.height = size.height;
    frame.origin.x = (contentRect.size.width - size.width)/2.0;
    frame.origin.y = contentRect.size.height - size.height - 60 - 10;
    
    textNode.frame = frame;
    
    frame.size.height = 60;
    frame.size.width = contentRect.size.width - 20;
    size = [allTextNode calculateSizeThatFits:CGSizeMake(frame.size.width, MAXFLOAT)];
    frame.size.height = size.height;
    frame.origin.x = 10;
    frame.origin.y = self.navBar.frame.origin.y + self.navBar.frame.size.height + 10;
    float maxHeight = contentRect.size.height - (60 + 10) - frame.origin.y;
    if (frame.size.height > contentRect.size.height - (60 + 10) - frame.origin.y) {
        frame.size.height = maxHeight;
    }
    allTextNode.frame = frame;
}
#pragma mark - public
- (void) stopRecordWhenControllerDisappear {
    [self setRecordingState:NO];
}
#pragma mark - setup speech control
- (void) setUpSpeechControl {
    if (!speechControl) {
        speechControl = [[SpeechControl alloc] init];
        speechControl.delegate = self;
    }
}
#pragma mark - SpeechControlDelegate
- (void) receiveTextFromSpeech:(NSString *)text {
    textNode.attributedText = [[NSAttributedString alloc] initWithString:text attributes:[self textStyle]];
    [self updateFrameTextNode];
}
- (void) receiveFinalTextFromSpeech:(NSString *)text {
    if ([GVUserDefaults standardUserDefaults].saveHistory.length > 0) {
        NSString *allTextStr = allTextNode.attributedText.string;
        if (text && text.length > 0) {
            if (allTextStr.length > 0) {
                allTextStr = [allTextStr stringByAppendingString:@" . "];
            }
            allTextStr = [allTextStr stringByAppendingString:text];
            allTextNode.attributedText = [[NSAttributedString alloc] initWithString:allTextStr attributes:[self allTextStyle]];
        }
    }
    textNode.attributedText = [[NSAttributedString alloc] initWithString:text attributes:[self textStyle]];
    [self updateFrameTextNode];
}
- (void) stopRecording {
    [self setRecordingState:NO];
}
- (void) startRecording {
    [self setRecordingState:YES];
}
#pragma mark - action button
- (void) goToSetupController {
    SetUpController *controller = [SetUpController new];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void) actionMicroButton {
    isRecording = !isRecording;
    [self setRecordingState:isRecording];
}
- (void) setRecordingState:(BOOL) recording {
    isRecording = recording;
    [microBar setRecording:recording];
    if (recording) {
        int sampleRate = [GVUserDefaults standardUserDefaults].sampleRate.intValue * 1000;
        NSString *host = [GVUserDefaults standardUserDefaults].host;
        NSString *port = [GVUserDefaults standardUserDefaults].port;
        BOOL isRecordAllTime = [GVUserDefaults standardUserDefaults].recordAllTime.length > 0;
        [speechControl recordAudio:sampleRate host:host port:port recordAllTime:isRecordAllTime];
    }
    else {
        [speechControl stopAudio];
    }
}
#pragma mark - text style
- (NSDictionary *) textStyle {
    UIFont *font = [UIFont systemFontOfSize:19.0];
    
    return @{
             NSFontAttributeName: font,
             NSForegroundColorAttributeName: [UIColor blackColor],
             };
}
- (NSDictionary *) allTextStyle {
    UIFont *font = [UIFont systemFontOfSize:17.0];
    
    return @{
             NSFontAttributeName: font,
             NSForegroundColorAttributeName: [UIColor colorWithRed:52.0/255.0 green:168.0/255.0 blue:234.0/255.0 alpha:1.0],
             };
}
@end
