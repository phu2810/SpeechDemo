//
//  CheckBoxRememberLogin.h
//  Speech
//
//  Created by Phu on 5/16/18.
//  Copyright © 2018 Google. All rights reserved.
//

#import "AsyncDisplayKit.h"

@interface CheckBoxWithText : ASDisplayNode

- (void) setTitle:(NSString *)title;

- (void) setChecked:(BOOL)checked;

- (void) addTarget:(id)target selector:(SEL)selector;

@end
