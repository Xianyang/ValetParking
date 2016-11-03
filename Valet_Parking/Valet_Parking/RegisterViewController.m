//
//  RegisterViewController.m
//  ValetParking
//
//  Created by WangYili on 7/24/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "RegisterViewController.h"
#import "LibraryAPI.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDKCountryAndAreaCode.h>
#import <SMS_SDK/Extend/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/Extend/SMSSDK+ExtexdMethods.h>
#import <MOBFoundation/MOBFoundation.h>


@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *userFirstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userLastNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITextField *userAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *termsBtn;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger countDownTime;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInputView];
    self.getVerificationCodeBtn.titleLabel.text = @"aaa";
}


#pragma mark - Verification Code

- (void)changeTextByTimer {
    if (self.countDownTime > 1) {
        self.countDownTime -= 1;
        NSString *timeString = [[NSString stringWithFormat:@"%ld", (long)self.countDownTime] stringByAppendingString:@"s"];
        [self.getVerificationCodeBtn setTitle:timeString forState:UIControlStateDisabled];
    } else {
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.getVerificationCodeBtn setTitle:@"Verification Code" forState:UIControlStateNormal];
        [self.getVerificationCodeBtn setVerificationButtonReadyStatus];
    }
}

- (void)getVC {
    // check the phone number
    if (![[LibraryAPI sharedInstance] isPhoneNumberValid:self.userAccountTextField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"Please input an valid number in HK";
        [hud hideAnimated:YES afterDelay:1.5];
        
        return;
    }
    
    self.countDownTime = 11;
    [self.timer setFireDate:[NSDate date]];
    [self.getVerificationCodeBtn setVerificationButtonCountingStatus];

    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:self.userAccountTextField.text
                                   zone:@"852"
                       customIdentifier:nil
                                 result:nil];
}


- (void)cancalBtnPressed {
    [self.view endEditing:YES];
    [self.delegate cancelRegister];
}

- (void)signupBtnPressed {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.signUpBtn setDisableStatus];
    
    // TODO check verification code firstly
    
    [SMSSDK commitVerificationCode:self.verificationCodeTextField.text
                       phoneNumber:self.userAccountTextField.text
                              zone:@"852"
                            result:^(NSError *error) {
                                if (!error) {
                                    // verify successfully
                                    [[LibraryAPI sharedInstance] registerWithPhone:self.userAccountTextField.text
                                                                         firstName:self.userFirstNameTextField.text
                                                                          lastName:self.userLastNameTextField.text
                                                                          password:self.userPasswordTextField.text
                                                                           success:^(UserModel *userModel) {
                                                                               [hud hideAnimated:YES];
                                                                               [self.delegate registerSucceed:userModel];
                                                                           }
                                                                              fail:^(NSError *error) {
                                                                                  [hud showErrorMessage:error];
                                                                                  [self.signUpBtn setEnableStatus];
                                                                              }];

                                } else {
                                    NSError *error = [NSError errorWithDomain:@"error"
                                                                         code:VERIFY_CODE_FAIL
                                                                     userInfo:nil];
                                    [hud showErrorMessage:error];
                                }
                            }];
}

- (void)setupInputView {
    [self.inputView.layer setCornerRadius:3.0];
    
    [self.cancelBtn addTarget:self
                       action:@selector(cancalBtnPressed)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.signUpBtn setDisableStatus];
    
    // sign up button
    [self.signUpBtn.layer setCornerRadius:3.0];
    [self.signUpBtn addTarget:self
                       action:@selector(signupBtnPressed)
             forControlEvents:UIControlEventTouchUpInside];
    
    // set target of text field
    [self addTargetToTextFields:@[self.userFirstNameTextField, self.userLastNameTextField,
                                  self.userAccountTextField, self.verificationCodeTextField, self.userPasswordTextField]];
    
    // set verficate button
    [self.getVerificationCodeBtn setVerificationButtonReadyStatus];
    [self.getVerificationCodeBtn addTarget:self
                                    action:@selector(getVC)
                          forControlEvents:UIControlEventTouchUpInside];
    
    [self.userFirstNameTextField becomeFirstResponder];
}

- (void)addTargetToTextFields:(NSArray *)textfields {
    for (UITextField *textfield in textfields) {
        [textfield addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
//    if ([self.userAccountTextField.text isEqualToString:@""]) {
//        [self.getVerificationCodeBtn setDisableStatus];
//    } else {
//        [self.getVerificationCodeBtn setEnableStatus];
//        [self.getVerificationCodeBtn setTitleColor:[[LibraryAPI sharedInstance] themeColor]
//                                          forState:UIControlStateNormal];
//    }
    
    if ([self.userFirstNameTextField.text isEqualToString:@""] ||
        [self.userLastNameTextField.text isEqualToString:@""] ||
        [self.userAccountTextField.text isEqualToString:@""] ||
        [self.verificationCodeTextField.text isEqualToString:@""] ||
        [self.userPasswordTextField.text isEqualToString:@""]) {
        [self.signUpBtn setDisableStatus];
    } else {
        [self.signUpBtn setEnableStatus];
    }
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(changeTextByTimer)
                                                userInfo:nil
                                                 repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    
    return _timer;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
