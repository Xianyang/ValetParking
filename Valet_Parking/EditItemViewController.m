//
//  EditItemViewController.m
//  Valet_Parking
//
//  Created by WangYili on 7/29/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "EditItemViewController.h"

@interface EditItemViewController ()
{
    NSString *_oldString;
}
@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation EditItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textField becomeFirstResponder];
    self.textField.text = _oldString;
}
- (IBAction)doneBtnPressed:(id)sender {
    [self.view endEditing:YES];
    [self.delegate finishChangeText:self.textField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavTitle:(NSString *)title oldString:(NSString *)oldString {
    self.title = title;
    _oldString = oldString;
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
