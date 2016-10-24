//
//  CurrentOrderViewController.m
//  Valet_Parking
//
//  Created by Chester on 19/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "CurrentOrderViewController.h"
#import "CarStatusViewController.h"
#import "WelcomeViewController.h"
#import "OrderModel.h"
#import "TwoLabelCell.h"

static NSString * const TwoLabelCellIdentifier = @"TwoLabelCell";

@interface CurrentOrderViewController () <UITableViewDelegate, UITableViewDataSource, CarStatusViewControllerDelegate, WelcomeViewControllerDelegate>
{
//    NSUInteger _numberOfOrder;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *orders;

@end

@implementation CurrentOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[LibraryAPI sharedInstance] isUserLogin]) {
        [[LibraryAPI sharedInstance] deleteAllCarsInCoreData];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[LibraryAPI sharedInstance] tryLoginWithLocalAccount:^(UserModel *userModel) {
            [hud hideAnimated:YES];
            [self loginSuccessfully:userModel];
        }
                                                         fail:^(NSError *error) {
                                                             [hud hideAnimated:YES];
                                                             [self popUpWelcomeView];
                                                         }];
    } else {
        [self loadOrders];
    }
}

- (void)popUpWelcomeView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WelcomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    viewController.delegate = self;
    [self.navigationController presentViewController:viewController
                                            animated:YES
                                          completion:nil];
}

- (void)loadOrders {
    [self.orders removeAllObjects];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LibraryAPI sharedInstance] getCurrentOrdersForUser:[[LibraryAPI sharedInstance] getCurrentUserModel]
                                                 success:^(NSArray *orders) {
                                                     if (orders.count) {
                                                         [hud hideAnimated:YES];
                                                         for (OrderModel *order in orders) {
                                                             if (!order.endAt) {
                                                                 [self.orders addObject:order];
                                                             }
                                                         }
                                                         
                                                         if (self.orders.count) {
                                                             [self.tableView reloadData];
                                                         } else {
                                                             [self noCurrentOrder:hud];
                                                         }
                                                     } else {
                                                         [self noCurrentOrder:hud];
                                                     }
                                                 }
                                                    fail:^(NSError *error) {
                                                        hud.mode = MBProgressHUDModeText;
                                                        hud.label.text = [[APIMessage sharedInstance] messageToShowWithError:error.code];
                                                        [hud hideAnimated:YES afterDelay:1];
                                                        
                                                    }];
}

- (void)noCurrentOrder:(MBProgressHUD *)hud {
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"You do not have unfinished orders";
}

- (void)recallSuccessfully {
    [self loadOrders];
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
                                            [self loadOrders];
                                        }
                                           fail:^(NSError *error) {
                                               hud.mode = MBProgressHUDModeText;
                                               hud.label.text = @"fail to fetch cars";
                                               [hud hideAnimated:YES afterDelay:1];
                                           }];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CarStatusViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"CarStatusViewController"];
    vc.delegate = self;
    [vc setAnOrder:self.orders[indexPath.row]];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TwoLabelCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TwoLabelCellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(TwoLabelCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    OrderModel *order = self.orders[indexPath.row];
    cell.leftLabel.text = order.carPlate;
    
    if (order.userRequestAt) {
        cell.rightLabel.text = @"returning with Valet";
    } else {
        cell.rightLabel.text = @"in parking lot";
    }
}

- (NSMutableArray *)orders {
    if (!_orders) {
        _orders = [[NSMutableArray alloc] init];
    }
    
    return _orders;
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
