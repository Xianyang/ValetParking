//
//  ForgetPasswordViewController.m
//  ValetParking
//
//  Created by WangYili on 7/24/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "LibraryAPI.h"


@interface ForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITextField *userAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.inputView.layer setCornerRadius:3.0];
    
    [self.cancelBtn addTarget:self
                       action:@selector(cancalBtnPressed)
             forControlEvents:UIControlEventTouchUpInside];
    [self.okBtn.layer setCornerRadius:3.0];
    [self addTargetToTextFields:@[self.userAccountTextField, self.verificationCodeTextField, self.userPasswordTextField]];
    
    [self.getVerificationCodeBtn setEnabled:NO];
    [self.getVerificationCodeBtn setTitleColor:[UIColor colorWithRed:241.0/255.0 green:235.0/255.0 blue:227.0/255.0
                                                               alpha:1.0]
                                      forState:UIControlStateNormal];
    
    [self.okBtn addTarget:self action:@selector(okBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.okBtn setDisableStatus];
    
    [self.userAccountTextField becomeFirstResponder];
}

- (void)cancalBtnPressed {
    [self.view endEditing:YES];
    [self.delegate cancelSetNewPassword];
}

- (void)okBtnPressed {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.okBtn setDisableStatus];
    // TODO check verification code firstly
    
    [[LibraryAPI sharedInstance] resetPasswordWithPhone:self.userAccountTextField.text
                                               password:self.userPasswordTextField.text
                                                success:^(UserModel *userModel) {
                                                    [self.okBtn setEnabled:YES];
                                                    [hud hideAnimated:YES];
                                                    [self.delegate resetSucceed:userModel];
                                                }
                                                   fail:^(NSError *error) {
                                                       hud.mode = MBProgressHUDModeText;
                                                       hud.label.text = [[APIMessage sharedInstance] messageToShowWithError:error.code];
                                                       [hud hideAnimated:YES afterDelay:1];
                                                       
                                                       [self.okBtn setEnableStatus];
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
    
    if ([self.userAccountTextField.text isEqualToString:@""] ||
        [self.verificationCodeTextField.text isEqualToString:@""] ||
        [self.userPasswordTextField.text isEqualToString:@""]) {
        [self.okBtn setDisableStatus];
    } else {
        [self.okBtn setEnableStatus];
    }
}

- (void)addTargetToTextFields:(NSArray *)textfields {
    for (UITextField *textfield in textfields) {
        [textfield addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
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
