//
//  UserInfoViewController.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserModel.h"
#import "UserInfoCell.h"
#import "MyProfileViewController.h"
#import "MyOrdersViewController.h"
#import "MyCarsViewController.h"
#import "WelcomeViewController.h"
#import "LibraryAPI.h"

static NSString * const UserInfoCellIdentifier = @"UserInfoCell";

@interface UserInfoViewController () <UITableViewDelegate, UITableViewDataSource, WelcomeViewControllerDelegate>
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WelcomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    viewController.delegate = self;
    [self.navigationController presentViewController:viewController
                                            animated:YES
                                          completion:nil];
}

- (void)loginSuccessfully {
    [self.tabBarController setSelectedIndex:0];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return section?1:3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:UserInfoCellIdentifier
                                                                  forIndexPath:indexPath];
        [self configureImageCell:cell atIndexPath:indexPath];
        
        return cell;
    } else {
        UITableViewCell *logoutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                             reuseIdentifier:nil];
        logoutCell.textLabel.text = @"Log Out";
        logoutCell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return logoutCell;
    }
    
}

- (void)configureImageCell:(UserInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.cellTitle.text = [UserInfoViewController titleForCell][indexPath.row];
    // [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

+ (NSArray *)titleForCell {
    return @[@"My Profile", @"My Orders", @"My Cars"];
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
