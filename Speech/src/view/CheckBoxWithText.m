//
//  CheckBoxRememberLogin.m
//  Speech
//
//  Created by Phu on 5/16/18.
//  Copyright © 2018 Google. All rights reserved.
//

#import "CheckBoxWithText.h"
#import "Utils.h"

@interface CheckBoxWithText () {
    ASImageNode *img;
    ASTextNode *title;
}

@end

@implementation CheckBoxWithText

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        img = [ASImageNode new];
        [self addSubnode:img];
        
        title = [ASTextNode new];
        [self addSubnode:title];
    }
    return self;
}

#pragma mark - public

- (void) setTitle:(NSString *)titleStr {
    title.attributedText = [[NSAttributedString alloc] initWithString:titleStr attributes:[self titleStyle]];
    [self calculateFrame];
}

- (void) setChecked:(BOOL)checked {
    img.image = [Utils image:[UIImage imageNamed:checked?@"checkbox_on":@"checkbox_off"] color:[UIColor colorWithRed:52.0/255.0 green:168.0/255.0 blue:234.0/255.0 alpha:1.0]];
}

- (void) addTarget:(id)target selector:(SEL)selector {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [self.view addGestureRecognizer:gesture];
}

#pragma mark - private

- (void) layout {
    [super layout];
    [self calculateFrame];
}

- (void) calculateFrame {
    if (self.bounds.size.width <= 0 || self.bounds.size.height <= 0) {
        return;
    }
    CGSize size = CGSizeMake(15, 15);
    img.frame = CGRectMake(0, (self.bounds.size.height - size.height)/2.0, size.width, size.height);
    
    size = [title calculateSizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    title.frame = CGRectMake(15 + 10, (self.bounds.size.height - size.height)/2.0, size.width, size.height);
}
- (NSDictionary *) titleStyle {
    UIFont *font = [UIFont systemFontOfSize:16.0];
    
    return @{
             NSFontAttributeName: font,
             NSForegroundColorAttributeName: [UIColor darkGrayColor],
             };
}
@end
