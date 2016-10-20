//
//  WelcomeViewController.m
//  ValetParking
//
//  Created by WangYili on 7/24/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "WelcomeViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "MBProgressHUD+ValetShowAlert.h"

@interface WelcomeViewController () <RegisterViewControllerDelegate, ForgetPasswordViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *userAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwBtn;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInputView];
}

- (void)loginBtnPressed {
    [self.loginBtn setDisableStatus];
    
    NSString *userAccount = self.userAccountTextField.text;
    NSString *userPassword = self.userPasswordTextField.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LibraryAPI sharedInstance] loginWithPhone:userAccount
                                       password:userPassword
                                        success:^(UserModel *userModel) {
                                            [hud hideAnimated:YES];
                                            [self.view endEditing:YES];
                                            [self.delegate loginSuccessfully:userModel];
                                        }
                                           fail:^(NSError *error) {
                                               [self.loginBtn setEnableStatus];
                                               [hud showErrorMessage:error];
                                           }];
}

- (void)signupBtnPressed {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterViewController *viewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController presentViewController:viewcontroller animated:YES completion:nil];
}

- (void)setupInputView {
    [self.inputView.layer setCornerRadius:3.0];
    [self.loginBtn.layer setCornerRadius:3.0];
    
    [self.loginBtn addTarget:self
                      action:@selector(loginBtnPressed)
            forControlEvents:UIControlEventTouchUpInside];
    [self.signupBtn addTarget:self
                       action:@selector(signupBtnPressed)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.userAccountTextField addTarget:self
                                  action:@selector(textFieldDidChange:)
                        forControlEvents:UIControlEventEditingChanged];
    [self.userPasswordTextField addTarget:self
                                   action:@selector(textFieldDidChange:)
                         forControlEvents:UIControlEventEditingChanged];
    
    [self.loginBtn setDisableStatus];
    [self.userAccountTextField becomeFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if ([self.userAccountTextField.text isEqualToString:@""] ||
        [self.userPasswordTextField.text isEqualToString:@""]) {
        [self.loginBtn setDisableStatus];
    } else {
        [self.loginBtn setEnableStatus];
    }
}

# pragma mark - RegisterViewControllerDelegate

- (void)registerSucceed:(UserModel *)userModel {
    [self.delegate loginSuccessfully:userModel];
}

- (void)cancelRegister {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - ForgetPasswordViewControllerDelegate

- (void)resetSucceed:(UserModel *)userModel {
    [self.delegate loginSuccessfully:userModel];
}

- (void)cancelSetNewPassword {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SetNewPasswordSegue"]) {
        ForgetPasswordViewController *viewcontroller = segue.destinationViewController;
        viewcontroller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"SignUpSegue"]) {
        RegisterViewController *viewcontroller = segue.destinationViewController;
        viewcontroller.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
