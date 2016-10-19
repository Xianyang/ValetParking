//
//  ValetServiceViewController.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "ValetServiceViewController.h"
#import "WelcomeViewController.h"
#import "ParkNowViewController.h"
#import "CurrentOrderViewController.h"


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
    
    [self setNavigationBar];
    
    // Step0 delete all cars in local database
    [[LibraryAPI sharedInstance] deleteAllCarsInCoreData];
    
    // Step1 check if logged in
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LibraryAPI sharedInstance] tryLoginWithLocalAccount:^(UserModel *userModel) {
        [hud hideAnimated:YES];
        [self loginSuccessfully:userModel];
    }
                                                     fail:^(NSError *error) {
                                                         [hud hideAnimated:YES];
                                                         [self popUpWelcomeView];
                                                     }];
    
    [self.tableView reloadData];
}

- (void)setNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"]
                                                  forBarMetrics:UIBarMetricsDefault];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (indexPath.section == 0) {
        // park now
        ParkNowViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ParkNowViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
        // current orders view controller
        CurrentOrderViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CurrentOrderViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // if there is orders, then show the second section
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"CellForService"];
    }
    
    cell.textLabel.text = [ValetServiceViewController textForTableView][indexPath.section];
    
    return cell;
}

+ (NSArray *)textForTableView {
    return @[@"Parking Now", @"Current Orders"];
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
