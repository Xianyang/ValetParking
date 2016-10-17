//
//  WelcomeViewController.m
//  ValetParking
//
//  Created by WangYili on 7/24/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "WelcomeViewController.h"
#import "KeychainItemWrapper.h"
#import "ForgetPasswordViewController.h"
#import "UIButton+Status.h"
#import "LibraryAPI.h"
#import "APIMessage.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface WelcomeViewController () <ForgetPasswordViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *userAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwBtn;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.inputView.layer setCornerRadius:3.0];
    [self.loginBtn.layer setCornerRadius:3.0];
    
    [self.loginBtn addTarget:self
                      action:@selector(loginBtnPressed)
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

- (void)loginBtnPressed {
    NSString *userAccount = self.userAccountTextField.text;
    NSString *userPassword = self.userPasswordTextField.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.loginBtn setDisableStatus];
    [[LibraryAPI sharedInstance] loginWithPhone:userAccount
                                       password:userPassword
                                        success:^(ValetModel *valetModel) {
                                            [hud hideAnimated:YES];
                                            [self.view endEditing:YES];
                                            [self.delegate loginSuccessfully:valetModel];
                                        }
                                           fail:^(NSError *error) {
                                               [self.loginBtn setEnableStatus];
                                               hud.mode = MBProgressHUDModeText;
                                               hud.label.text = [[APIMessage sharedInstance] messageToShowWithError:error.code];
                                               [hud hideAnimated:YES afterDelay:1];
                                           }];
}

# pragma mark - ForgetPasswordViewControllerDelegate

- (void)cancelSetNewPassword {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetSucceed:(ValetModel *)valetModel {
    [self.delegate loginSuccessfully:valetModel];
}

# pragma mark -

- (void)textFieldDidChange:(UITextField *)textField {
    if ([self.userAccountTextField.text isEqualToString:@""] ||
        [self.userPasswordTextField.text isEqualToString:@""]) {
        [self.loginBtn setDisableStatus];
    } else {
        [self.loginBtn setEnableStatus];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SetNewPasswordSegue"]) {
        ForgetPasswordViewController *viewcontroller = segue.destinationViewController;
        viewcontroller.delegate = self;
    }
}


@end
