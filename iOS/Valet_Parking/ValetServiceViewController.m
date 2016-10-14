//
//  ValetServiceViewController.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "ValetServiceViewController.h"
#import "KeychainItemWrapper.h"
#import "WelcomeViewController.h"
#import "ParkNowViewController.h"
#import "BookServiceViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSString * const SimpleTableViewCellIdentifier = @"SimpleTableViewCellIdentifier";

@interface ValetServiceViewController () <WelcomeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ValetServiceViewController
{
    NSInteger _numOfUserOrder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[LibraryAPI sharedInstance] deleteCarsInCoreDate];
    // Step1 check if logged in
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"ValetLogin"
                                                                        accessGroup:nil];
    
    NSString *userPassword = [keychain objectForKey:(__bridge id)(kSecValueData)];
    NSString *userAccount = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    
    // user already logged in once, use saved user name and password to login
    if (![userAccount isEqualToString:@""] && ![userPassword isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[LibraryAPI sharedInstance] loginWithPhone:userAccount
                                           password:userPassword
                                            success:^(UserModel *userModel) {
                                                [hud hideAnimated:YES];
                                                [self loginSuccessfully:userModel];
                                            }
                                               fail:^(NSError *error) {
                                                   [hud hideAnimated:YES];
                                                   [self popUpWelcomeView];
                                               }];
    } else {
        [self popUpWelcomeView];
    }
    
    [self setNavigationBar];
    [self setParas];
    
    [self.tableView reloadData];
    [self getUserOrders];
}

- (void)setNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"]
                                                  forBarMetrics:UIBarMetricsDefault];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)setParas {
    _numOfUserOrder = 0;
}

# pragma mark - Orders
- (void)getUserOrders {
    // TODO use user's info to get its orders. If there is a order, then refresh the tabel view
}

- (void)popUpWelcomeView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WelcomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    viewController.delegate = self;
    [self.navigationController presentViewController:viewController
                                            animated:YES
                                          completion:nil];
}

# pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (indexPath.row == 0) {
            // park now
            ParkNowViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ParkNowViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 1) {
        // service view controller
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // if there is orders, then show the second section
    return _numOfUserOrder?2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return _numOfUserOrder;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"CellForService"];
    }
    
    cell.textLabel.text = [ValetServiceViewController textForFirstSection][indexPath.row];
    
    return cell;
}

+ (NSArray *)textForFirstSection {
    return @[@"Parking Now"];
}

#pragma mark - WelcomeViewControllerDelegate

- (void)loginSuccessfully:(UserModel *)userModel
{
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO some instruction
    
    // get user's car
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[LibraryAPI sharedInstance] getCarsForUser:userModel
                                        success:^(NSArray *cars) {
                                            NSLog(@"Get %lu cars from server", (unsigned long)[cars count]);
                                            [hud hideAnimated:YES];
                                        }
                                           fail:^(NSError *error) {
                                               hud.mode = MBProgressHUDModeText;
                                               hud.label.text = @"fail to fetch cars";
                                               [hud hideAnimated:YES afterDelay:1];
                                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
