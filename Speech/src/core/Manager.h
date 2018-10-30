//
//  Manager.h
//  sources
//
//  Created by Phu on 1/25/17.
//
//

#import <Foundation/Foundation.h>
#import "../../library/gvuserdefaults/GVUserDefaults+Properties.h"
#import "SpeechController.h"

@interface Manager : NSObject

+ (Manager*)instance;

@property (nonatomic, weak) SpeechController *speechController;

@end
