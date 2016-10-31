//
//  MyOrdersViewController.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "TwoLabelCell.h"
#import "OrderModel.h"

static NSString * const TwoLabelCellIdentifier = @"TwoLabelCell";

@interface MyOrdersViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *orders;
@end

@implementation MyOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadOrders];
}

- (void)loadOrders {
    [self.orders removeAllObjects];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LibraryAPI sharedInstance] getCurrentOrdersForUser:[[LibraryAPI sharedInstance] getCurrentUserModel]
                                                 success:^(NSArray *orders) {
                                                     if (orders.count) {
                                                         [hud hideAnimated:YES];
                                                         
                                                         self.orders = [[[orders reverseObjectEnumerator] allObjects] mutableCopy];
                                                         [self.tableView reloadData];
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
    hud.label.text = @"You do not have any orders";
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TwoLabelCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TwoLabelCellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(TwoLabelCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    OrderModel *order = self.orders[indexPath.row];
    cell.leftLabel.text = [[order.carPlate stringByAppendingString:@" "] stringByAppendingString:order.carBrand];
    
//    cell.rightLabel.text = order.createAt;
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EE MMM d yyyy HH:mm:ss 'GMT'ZZZZ '(CST)'"];
    NSDate *date = [dateFormat dateFromString:order.createAt];
    [dateFormat setDateFormat:@"MM/d/yyyy HH:mm"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    
    cell.rightLabel.text = dateString;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)orders {
    if (!_orders) {
        _orders = [[NSMutableArray alloc] init];
    }
    
    return _orders;
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
