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
    
    // Step1 check if logged in
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"ValetLogin"
                                                                        accessGroup:nil];
    
    NSString *userPassword = [keychain objectForKey:(__bridge id)(kSecValueData)];
    NSString *userAccount = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    
    if (![userAccount isEqualToString:@""] && ![userPassword isEqualToString:@""]) {
        // TODO user already logged in once
        // [self popUpWelcomeView];
        [[LibraryAPI sharedInstance] loginWithAccount:userAccount
                                             password:userPassword
                                              succeed:^(UserModel *userModel) {
                                                  
                                              }
                                                 fail:^(NSError *error) {
                                                     
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
        } else if (indexPath.row == 1) {
            // book a service
            BookServiceViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"BookServiceViewController"];
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
        return 2;
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
    return @[@"Parking Now", @"Book a Service"];
}

#pragma mark - WelcomeViewControllerDelegate

- (void)loginSuccessfully
{
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO some instruction
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
