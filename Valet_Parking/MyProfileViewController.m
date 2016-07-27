//
//  MyProfileViewController.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "MyProfileViewController.h"
#import "UserModel.h"

@interface MyProfileViewController ()
@property (strong, nonatomic) UserModel *userModel;
@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userModel = [[LibraryAPI sharedInstance] getCurrentUserModel];
    NSLog(@"current user is %@, first name %@, last name %@, id %@", self.userModel.phone, self.userModel.firstName, self.userModel.lastName, self.userModel.identifier);
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
