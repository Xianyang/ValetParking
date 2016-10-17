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

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self.getVerificationCodeBtn setEnabled:NO];
    [self.getVerificationCodeBtn setTitleColor:[UIColor colorWithRed:241.0/255.0 green:235.0/255.0 blue:227.0/255.0
                                                               alpha:1.0]
                                      forState:UIControlStateNormal];
    [self.getVerificationCodeBtn addTarget:self
                                    action:@selector(getVC)
                          forControlEvents:UIControlEventTouchUpInside];
    
    [self.userFirstNameTextField becomeFirstResponder];
}

- (void)getVC {
    [self.getVerificationCodeBtn setEnabled:NO];
    [self.getVerificationCodeBtn setTitleColor:[UIColor colorWithRed:241.0/255.0 green:235.0/255.0 blue:227.0/255.0
                                                               alpha:1.0]
                                      forState:UIControlStateNormal];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:self.userAccountTextField.text
                                   zone:@"852"
                       customIdentifier:nil
                                 result:nil];
}



- (void)addTargetToTextFields:(NSArray *)textfields {
    for (UITextField *textfield in textfields) {
        [textfield addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    }
}

- (void)cancalBtnPressed {
    [self.view endEditing:YES];
    [self.delegate cancelRegister];
}

- (void)signupBtnPressed {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.signUpBtn setDisableStatus];
    
    // TODO check verification code firstly
    
    [[LibraryAPI sharedInstance] registerWithPhone:self.userAccountTextField.text
                                         firstName:self.userFirstNameTextField.text
                                          lastName:self.userLastNameTextField.text
                                          password:self.userPasswordTextField.text
                                           success:^(UserModel *userModel) {
                                               [hud hideAnimated:YES];
                                               [self.delegate registerSucceed:userModel];
                                           }
                                              fail:^(NSError *error) {
                                                  hud.mode = MBProgressHUDModeText;
                                                  hud.label.text = [[APIMessage sharedInstance] messageToShowWithError:error.code];
                                                  [hud hideAnimated:YES afterDelay:1];
                                                  
                                                  [self.signUpBtn setEnableStatus];
                                              }];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if ([self.userAccountTextField.text isEqualToString:@""]) {
        [self.getVerificationCodeBtn setEnabled:NO];
        [self.getVerificationCodeBtn setTitleColor:[UIColor colorWithRed:241.0/255.0 green:235.0/255.0 blue:227.0/255.0
                                                                   alpha:1.0]
                                          forState:UIControlStateNormal];
    } else {
        [self.getVerificationCodeBtn setEnabled:YES];
        [self.getVerificationCodeBtn setTitleColor:[UIColor colorWithRed:186.0/255.0 green:138.0/255.0 blue:87.0/255.0
                                                                   alpha:1.0]
                                          forState:UIControlStateNormal];
    }
    
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
