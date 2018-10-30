//
//  SetUpController.m
//  Speech
//
//  Created by Phu on 10/18/18.
//  Copyright © 2018 Google. All rights reserved.
//

#import "SetUpController.h"
#import "Utils.h"
#import "JVFloatLabeledTextField.h"
#import "CheckBoxWithText.h"
#import "GVUserDefaults+Properties.h"
#import "Constants.h"

@interface SetUpController () <UITextFieldDelegate> {
    ASScrollNode *contentNode;
    JVFloatLabeledTextField *hostField;
    ASDisplayNode *diviHostField;
    
    JVFloatLabeledTextField *portField;
    ASDisplayNode *diviPortField;
    
    CheckBoxWithText *recordAllTimeCheckBox;
    CheckBoxWithText *saveHistoryCheckBox;
    
    ASTextNode *sampleRateSection;
    CheckBoxWithText * KHz8_CheckBox;
    CheckBoxWithText *KHz16_CheckBox;
    
    ASButtonNode *applyButton;
    ASButtonNode *defaultButton;
    
    ASDisplayNode *overlayNode;
    
    // Data
    BOOL isRecordAllTime;
    BOOL isSaveHistory;
    BOOL is16KHz;
}

@end

@implementation SetUpController

- (instancetype)init
{
    self = [super initWithNode:[ASDisplayNode new]];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)viewDidLoad {
    self.node.backgroundColor = [UIColor whiteColor];

    [self createContent];

    [self addNavBar];
    [self.navBar setTitle:@"SetUp"];
    
    [self.navBar.leftBtn setImage:[Utils image:[Utils image:[UIImage imageNamed:@"back_btn"] size:CGSizeMake(18, 18)] color:[UIColor colorWithRed:52.0/255.0 green:168.0/255.0 blue:234.0/255.0 alpha:1.0]] forState:ASControlStateNormal];
    
    [self.navBar.leftBtn addTarget:self action:@selector(actionBackButton) forControlEvents:ASControlNodeEventTouchUpInside];
}
- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect contentRect = [self getContentRect];
    
    CGRect frame = CGRectZero;
    frame.origin.x = contentRect.origin.x;
    frame.origin.y = self.navBar.frame.origin.y + self.navBar.frame.size.height;
    frame.size.height = contentRect.size.height - frame.origin.y;
    frame.size.width = contentRect.size.width;
    contentNode.frame = frame;
    
    frame = CGRectZero;
    frame.origin.x = 20;
    frame.origin.y = -5;
    frame.size.height = 44;
    frame.size.width = contentNode.frame.size.width - 40;
    hostField.frame = frame;
    
    frame = CGRectZero;
    frame.origin.x = 20;
    frame.origin.y = hostField.frame.origin.y + hostField.frame.size.height + 2;
    frame.size.height = 1;
    frame.size.width = contentNode.frame.size.width - 40;
    diviHostField.frame = frame;
    
    frame = CGRectZero;
    frame.origin.x = 20;
    frame.origin.y = hostField.frame.origin.y + hostField.frame.size.height + 20;
    frame.size.height = 44;
    frame.size.width = contentNode.frame.size.width - 40;
    portField.frame = frame;
    
    frame = CGRectZero;
    frame.origin.x = 20;
    frame.origin.y = portField.frame.origin.y + portField.frame.size.height + 2;
    frame.size.height = 1;
    frame.size.width = contentNode.frame.size.width - 40;
    diviPortField.frame = frame;
    
    frame = CGRectZero;
    frame.origin.x = 20;
    frame.origin.y = portField.frame.origin.y + portField.frame.size.height + 20;
    frame.size.height = 40;
    frame.size.width = contentNode.frame.size.width - 40;
    recordAllTimeCheckBox.frame = frame;
    
    frame = CGRectZero;
    frame.origin.x = 20;
    frame.origin.y = recordAllTimeCheckBox.frame.origin.y + recordAllTimeCheckBox.frame.size.height + 10;
    frame.size.height = 40;
    frame.size.width = contentNode.frame.size.width - 40;
    saveHistoryCheckBox.frame = frame;
    
    CGSize size = [sampleRateSection calculateSizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    frame = CGRectZero;
    frame.origin.x = 20;
    frame.origin.y = saveHistoryCheckBox.frame.origin.y + saveHistoryCheckBox.frame.size.height + 10;
    frame.size.height = size.height;
    frame.size.width = size.width;
    sampleRateSection.frame = frame;
    
    frame = CGRectZero;
    frame.origin.x = 20;
    frame.origin.y = sampleRateSection.frame.origin.y + sampleRateSection.frame.size.height + 10;
    frame.size.height = 40;
    frame.size.width = contentNode.frame.size.width - 40;
    KHz8_CheckBox.frame = frame;
    
    frame = CGRectZero;
    frame.origin.x = 20;
    frame.origin.y = KHz8_CheckBox.frame.origin.y + KHz8_CheckBox.frame.size.height + 5;
    frame.size.height = 40;
    frame.size.width = contentNode.frame.size.width - 40;
    KHz16_CheckBox.frame = frame;
    
    frame = CGRectZero;
    frame.origin.x = 20;
    frame.origin.y = KHz16_CheckBox.frame.origin.y + KHz16_CheckBox.frame.size.height + 15;
    frame.size.height = 40;
    frame.size.width = 120;
    applyButton.frame = frame;
    
    frame = CGRectZero;
    frame.origin.x = applyButton.frame.origin.x + applyButton.frame.size.width + 15;
    frame.origin.y = applyButton.frame.origin.y;
    frame.size.height = 40;
    frame.size.width = 120;
    defaultButton.frame = frame;
    
    [contentNode.view setContentSize:CGSizeMake(contentNode.frame.size.width, defaultButton.frame.origin.y + defaultButton.frame.size.height + 30)];
    
    overlayNode.frame = contentNode.bounds;
}
#pragma mark - action button
- (void) actionBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) actionRecordAllTimeCheckbox {
    isRecordAllTime = !isRecordAllTime;
    [recordAllTimeCheckBox setChecked:isRecordAllTime];
}
- (void) actionSaveHistoryCheckbox {
    isSaveHistory = !isSaveHistory;
    [saveHistoryCheckBox setChecked:isSaveHistory];
}
- (void) action8KHzCheckbox {
    is16KHz = NO;
    [KHz8_CheckBox setChecked:!is16KHz];
    [KHz16_CheckBox setChecked:is16KHz];
    portField.text = @"8122";
}

- (void) action16KHzCheckbox {
    is16KHz = YES;
    [KHz8_CheckBox setChecked:!is16KHz];
    [KHz16_CheckBox setChecked:is16KHz];
    portField.text = @"8121";
}
- (void) actionOverlayNode {
    [hostField resignFirstResponder];
    [portField resignFirstResponder];
    overlayNode.hidden = YES;
}
- (void) actionApplyButton {
    
    NSString *host = hostField.text;
    host = [host stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!host || host.length <= 0) {
        [Utils showToastHUDInView:self.view withMessage:@"Vui lòng nhập host!" withOffset:0];
        return;
    }
    
    NSString *port = portField.text;
    port = [port stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!port || port.length <= 0) {
        [Utils showToastHUDInView:self.view withMessage:@"Vui lòng nhập port!" withOffset:0];
        return;
    }
    
    [GVUserDefaults standardUserDefaults].host = host;
    [GVUserDefaults standardUserDefaults].port = port;
    [GVUserDefaults standardUserDefaults].recordAllTime = isRecordAllTime?@"1":@"";
    [GVUserDefaults standardUserDefaults].sampleRate = is16KHz?@"16":@"8";
    [GVUserDefaults standardUserDefaults].saveHistory = isSaveHistory?@"1":@"";
    
    [Utils showToastHUDInView:self.view withMessage:@"Lưu cấu hình thành công!" withOffset:0];
}
- (void) actionDefaultButton {
    [Utils showSystemUIAlertView:@"Thông báo" withMessage:@"Bạn muốn reset về cấu hình mặc định?" handlerOk:^(UIAlertAction *action) {
        [GVUserDefaults standardUserDefaults].host = HOST;
        [GVUserDefaults standardUserDefaults].port = PORT;
        [GVUserDefaults standardUserDefaults].recordAllTime = @"";
        [GVUserDefaults standardUserDefaults].sampleRate = SAMPLE_RATE;
        [GVUserDefaults standardUserDefaults].saveHistory = @"1";
        
        is16KHz = YES;
        isRecordAllTime = NO;
        isSaveHistory = YES;
        
        hostField.text = [GVUserDefaults standardUserDefaults].host;
        portField.text = [GVUserDefaults standardUserDefaults].port;
        [KHz8_CheckBox setChecked:!is16KHz];
        [KHz16_CheckBox setChecked:is16KHz];
        [recordAllTimeCheckBox setChecked:isRecordAllTime];
        [saveHistoryCheckBox setChecked:isSaveHistory];
        
    } handlerCancel:^(UIAlertAction *action) {
        
    } inController:self];
}
#pragma mark - create content
- (void) createContent {
    
    contentNode = [ASScrollNode new];
    [self.node addSubnode:contentNode];
    
    hostField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectZero];
    hostField.font = [UIFont systemFontOfSize:17];
    hostField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Host"
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    hostField.floatingLabelFont = [UIFont boldSystemFontOfSize:13];
    hostField.floatingLabelTextColor = [UIColor colorWithRed:52.0/255.0 green:168.0/255.0 blue:234.0/255.0 alpha:1.0];
    hostField.clearButtonMode = UITextFieldViewModeWhileEditing;
    hostField.returnKeyType = UIReturnKeyDone;
    hostField.delegate = self;
    hostField.keepBaseline = YES;
    hostField.text = [GVUserDefaults standardUserDefaults].host;
    
    [contentNode.view addSubview:hostField];
    
    diviHostField = [ASDisplayNode new];
    diviHostField.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    [contentNode addSubnode:diviHostField];
    
    portField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectZero];
    portField.font = [UIFont systemFontOfSize:17];
    portField.keyboardType = UIKeyboardTypeNumberPad;
    portField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Port"
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    portField.floatingLabelFont = [UIFont boldSystemFontOfSize:13];
    portField.floatingLabelTextColor = [UIColor colorWithRed:52.0/255.0 green:168.0/255.0 blue:234.0/255.0 alpha:1.0];
    portField.clearButtonMode = UITextFieldViewModeWhileEditing;
    portField.returnKeyType = UIReturnKeyDone;
    portField.delegate = self;
    portField.keepBaseline = YES;
    portField.text = [GVUserDefaults standardUserDefaults].port;
    
    [contentNode.view addSubview:portField];
    
    diviPortField = [ASDisplayNode new];
    diviPortField.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    [contentNode addSubnode:diviPortField];
    
    recordAllTimeCheckBox = [CheckBoxWithText new];
    [recordAllTimeCheckBox setTitle:@"Nhận dạng liên tục"];
    [recordAllTimeCheckBox setChecked:isRecordAllTime];
    [recordAllTimeCheckBox addTarget:self selector:@selector(actionRecordAllTimeCheckbox)];
    
    [contentNode addSubnode:recordAllTimeCheckBox];
    
    saveHistoryCheckBox = [CheckBoxWithText new];
    [saveHistoryCheckBox setTitle:@"Lưu lại văn bản"];
    [saveHistoryCheckBox setChecked:isSaveHistory];
    [saveHistoryCheckBox addTarget:self selector:@selector(actionSaveHistoryCheckbox)];
    
    [contentNode addSubnode:saveHistoryCheckBox];
    
    sampleRateSection = [ASTextNode new];
    sampleRateSection.attributedText = [[NSAttributedString alloc] initWithString:@"Sample rate" attributes:[self sectionStyle]];
    
    [contentNode addSubnode:sampleRateSection];
    
    KHz8_CheckBox = [CheckBoxWithText new];
    [KHz8_CheckBox setTitle:@"8 KHz"];
    [KHz8_CheckBox setChecked:!is16KHz];
    [KHz8_CheckBox addTarget:self selector:@selector(action8KHzCheckbox)];
    
    [contentNode addSubnode:KHz8_CheckBox];
    
    KHz16_CheckBox = [CheckBoxWithText new];
    [KHz16_CheckBox setTitle:@"16 KHz"];
    [KHz16_CheckBox setChecked:is16KHz];
    [KHz16_CheckBox addTarget:self selector:@selector(action16KHzCheckbox)];
    
    [contentNode addSubnode:KHz16_CheckBox];
    
    applyButton = [ASButtonNode new];
    [applyButton setTitle:@"Áp dụng" withFont:[UIFont systemFontOfSize:16.0] withColor:[UIColor colorWithRed:52.0/255.0 green:168.0/255.0 blue:234.0/255.0 alpha:1.0] forState:ASControlStateNormal];
    [applyButton setCornerRadius:5];
    [applyButton setBorderColor:[UIColor colorWithRed:52.0/255.0 green:168.0/255.0 blue:234.0/255.0 alpha:1.0].CGColor];
    [applyButton setBorderWidth:1.0f];
    [applyButton addTarget:self action:@selector(actionApplyButton) forControlEvents:ASControlNodeEventTouchUpInside];
    [contentNode addSubnode:applyButton];
    
    defaultButton = [ASButtonNode new];
    [defaultButton setTitle:@"Mặc định" withFont:[UIFont systemFontOfSize:16.0] withColor:[UIColor colorWithRed:52.0/255.0 green:168.0/255.0 blue:234.0/255.0 alpha:1.0] forState:ASControlStateNormal];
    [defaultButton setCornerRadius:5];
    [defaultButton setBorderColor:[UIColor colorWithRed:52.0/255.0 green:168.0/255.0 blue:234.0/255.0 alpha:1.0].CGColor];
    [defaultButton setBorderWidth:1.0f];
    [defaultButton addTarget:self action:@selector(actionDefaultButton) forControlEvents:ASControlNodeEventTouchUpInside];
    [contentNode addSubnode:defaultButton];
    
    overlayNode = [ASDisplayNode new];
    overlayNode.hidden = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOverlayNode)];
    [overlayNode.view addGestureRecognizer:gesture];
    
    [contentNode addSubnode:overlayNode];
}

#pragma mark - text style

- (NSDictionary *) sectionStyle {
    UIFont *font = [UIFont boldSystemFontOfSize:16.0];
    
    return @{
             NSFontAttributeName: font,
             NSForegroundColorAttributeName: [UIColor darkGrayColor],
             };
}

#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    overlayNode.hidden = NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    overlayNode.hidden = YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - render data
- (void) initData {
    isRecordAllTime = [GVUserDefaults standardUserDefaults].recordAllTime.length > 0;
    is16KHz = [[GVUserDefaults standardUserDefaults].sampleRate isEqualToString:@"16"];
    isSaveHistory = [GVUserDefaults standardUserDefaults].saveHistory.length > 0;
}
@end
