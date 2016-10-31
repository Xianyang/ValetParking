//
//  UserInfoViewController.m
//  Valet_Parking_ValetSide
//
//  Created by Chester on 17/10/2016.
//  Copyright © 2016 Chester. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ValetModel.h"
#import "LibraryAPI.h"
#import "WelcomeViewController.h"
#import "OrderViewController.h"

@interface UserInfoViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ValetModel *valetModel;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    
    self.valetModel = [[LibraryAPI sharedInstance] getCurrentValetModel];
    
    [self.tableView reloadData];
}

- (void)popUpWelcomeView {
    // stop timer first
    UINavigationController *nav = self.tabBarController.viewControllers[0];
    OrderViewController *vc = (OrderViewController *)nav.topViewController;
    [vc stopTimer];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WelcomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    viewController.delegate = (id)vc;
    [self.navigationController presentViewController:viewController
                                            animated:YES
                                          completion:nil];
}

- (void)loginSuccessfully:(ValetModel *)valetModel
{
    [self.tabBarController setSelectedIndex:0];
    UINavigationController *nav = self.tabBarController.viewControllers[0];
    OrderViewController *vc = (OrderViewController *)nav.topViewController;
    [vc loadOrders];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section) {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@""
                                            message:@"Logout wil delete data. You can log in to use our service"
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"Log Out"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [[LibraryAPI sharedInstance] logout];
                                                                 [self popUpWelcomeView];
                                                             }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                             }];
        [alert addAction:logoutAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserInfo"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = [self.valetModel.firstName stringByAppendingString:self.valetModel.lastName];
    } else {
        cell.textLabel.text = @"Log Out";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    
    return cell;
}

#pragma mark - View

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
