//
//  CarStatusViewController.m
//  Valet_Parking
//
//  Created by Chester on 19/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "CarStatusViewController.h"
#import "TwoLabelCell.h"
#import "OrderModel.h"

static NSString * const TwoLabelCellIdentifier = @"TwoLabelCell";

@interface CarStatusViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) OrderModel *order;
@end

@implementation CarStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setAnOrder:(OrderModel *)order {
    self.order = order;
}

#pragma mark UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section && !self.order.userRequestAt) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
        [[LibraryAPI sharedInstance] recallACar:self.order
                                        success:^(OrderModel *orderModel) {
                                            [hud hideAnimated:YES];
                                            [self.navigationController popViewControllerAnimated:YES];
                                            [self.delegate recallSuccessfully];
                                        }
                                           fail:^(NSError *error) {
                                               hud.mode = MBProgressHUDModeText;
                                               hud.label.text = [[APIMessage sharedInstance] messageToShowWithError:error.code];
                                               [hud hideAnimated:YES afterDelay:1];
                                           }];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section?1:5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"section1"];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = self.order.userRequestAt?@"The car is on its way back":@"Get your car back";
        cell.textLabel.textColor = [UIColor greenColor];
        
        return cell;
    } else {
        TwoLabelCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TwoLabelCellIdentifier];
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    
}

- (void)configureCell:(TwoLabelCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftLabel.text = [CarStatusViewController titleArray][indexPath.row];
    
    if (indexPath.row == 0) {
        cell.rightLabel.text = self.order.carPlate;
    } else if (indexPath.row == 1) {
        cell.rightLabel.text = self.order.carBrand;
    } else if (indexPath.row == 2) {
        cell.rightLabel.text = self.order.carColor;
    } else if (indexPath.row == 3) {
        cell.rightLabel.text = [[LibraryAPI sharedInstance] transferOrderDateToMMDDAndTime:self.order.createAt];
    } else if (indexPath.row == 4) {
        NSTimeInterval timeInterval = [[LibraryAPI sharedInstance] calculateTimeIntervalSinceTime:self.order.createAt];
        int hour = timeInterval / 3600;
        int minute = (timeInterval - hour * 3600) / 60;
        NSString *timeString = [NSString stringWithFormat:@"%d h %d m", hour, minute];
        cell.rightLabel.text = timeString;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
}

+ (NSArray *)titleArray {
    return @[@"Plate", @"Brand", @"Color", @"Start Time", @"Parking Time"];
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
