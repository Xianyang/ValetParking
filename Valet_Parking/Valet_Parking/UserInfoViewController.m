//
//  UserInfoViewController.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserModel.h"
#import "ImageTextCell.h"
#import "ValetServiceViewController.h"
#import "MyProfileViewController.h"
#import "MyOrdersViewController.h"
#import "MyCarsViewController.h"
#import "SettingViewController.h"
#import "WelcomeViewController.h"
#import "LibraryAPI.h"

static NSString * const SimpleTableViewCellIdentifier = @"SimpleTableViewCellIdentifier";
static NSString * const ImageTextCellIdentifier = @"ImageTextCell";

@interface UserInfoViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"]
                                                  forBarMetrics:UIBarMetricsDefault];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)popUpWelcomeView {
    UINavigationController *nav = self.tabBarController.viewControllers[0];
    ValetServiceViewController *vc = (ValetServiceViewController *)nav.topViewController;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WelcomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    viewController.delegate = (id)vc;
    [self.navigationController presentViewController:viewController
                                            animated:YES
                                          completion:nil];
}


# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MyProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            MyOrdersViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MyOrdersViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            MyCarsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MyCarsViewController"];
            [vc setEditable:YES chosenCar:nil];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 3) {
            SettingViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 1) {
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
//        [[LibraryAPI sharedInstance] logout];
//        [self popUpWelcomeView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section?1:4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        ImageTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ImageTextCellIdentifier
//                                                                  forIndexPath:indexPath];
//        [self configureImageCell:cell atIndexPath:indexPath];
//        
//        return cell;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableViewCellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"CellForService"];
        }
        
        cell.textLabel.text = [UserInfoViewController textForTableView][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[UserInfoViewController imageNameForTableView][indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else {
        UITableViewCell *logoutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                             reuseIdentifier:nil];
        logoutCell.textLabel.text = @"Log Out";
        logoutCell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return logoutCell;
    }
    
}

- (void)configureImageCell:(ImageTextCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.cellTitle.text = [UserInfoViewController textForTableView][indexPath.row];
    cell.cellImage.image = [UIImage imageNamed:[UserInfoViewController imageNameForTableView][indexPath.row]];
    // [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

+ (NSArray *)textForTableView {
    return @[@"My Profile", @"Historical Orders", @"My Cars", @"Settings"];
}

+ (NSArray *)imageNameForTableView {
    return @[@"user-color", @"order-color", @"car-color", @"setting-color"];
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
