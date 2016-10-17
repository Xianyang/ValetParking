//
//  OrderViewController.m
//  Valet_Parking_ValetSide
//
//  Created by Chester on 17/10/2016.
//  Copyright © 2016 Chester. All rights reserved.
//

#import "OrderViewController.h"
#import "WelcomeViewController.h"
#import "LibraryAPI.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface OrderViewController () <WelcomeViewControllerDelegate>

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    
    // Step1 check if logged in
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LibraryAPI sharedInstance] tryLoginWithLocalAccount:^(ValetModel *valetModel) {
        [hud hideAnimated:YES];
        [self loginSuccessfully:valetModel];
    }
                                                     fail:^(NSError *error) {
                                                         [hud hideAnimated:YES];
                                                         [self popUpWelcomeView];
                                                     }];
}

#pragma mark - WelcomeViewControllerDelegate

- (void)loginSuccessfully:(ValetModel *)valetModel
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // TODO get all orders
    
}

#pragma mark - View

- (void)popUpWelcomeView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WelcomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    viewController.delegate = self;
    [self.navigationController presentViewController:viewController
                                            animated:YES
                                          completion:nil];
}

- (void)setNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"]
                                                  forBarMetrics:UIBarMetricsDefault];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
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
