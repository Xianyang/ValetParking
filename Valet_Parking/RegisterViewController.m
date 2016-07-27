//
//  RegisterViewController.m
//  ValetParking
//
//  Created by WangYili on 7/24/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "RegisterViewController.h"
#import "LibraryAPI.h"

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
    [self.signUpBtn.layer setCornerRadius:3.0];
    [self.signUpBtn addTarget:self
                       action:@selector(signupBtnPressed)
             forControlEvents:UIControlEventTouchUpInside];
    [self.userAccountTextField addTarget:self
                                  action:@selector(textFieldDidChange:)
                        forControlEvents:UIControlEventEditingChanged];
    [self.getVerificationCodeBtn setEnabled:NO];
    [self.getVerificationCodeBtn setTitleColor:[UIColor colorWithRed:241.0/255.0 green:235.0/255.0 blue:227.0/255.0
                                                               alpha:1.0]
                                      forState:UIControlStateNormal];
    
    [self.userFirstNameTextField becomeFirstResponder];

}

- (void)cancalBtnPressed {
    [self.delegate cancelRegister];
}

- (void)signupBtnPressed {
    [[LibraryAPI sharedInstance] signUpWithPhone:self.userAccountTextField.text
                                       firstName:self.userFirstNameTextField.text
                                        lastName:self.userLastNameTextField.text
                                        password:self.userPasswordTextField.text
                                         succeed:^(NSString *userIdentifier) {
                                             // TODO dismiss this page and log in
                                             [self.delegate registerSucceed];
                                         }
                                            fail:^(NSError *error) {
                                                
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
