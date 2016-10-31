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
#import "LibraryAPI.h"
#import "APIMessage.h"
#import <MBProgressHUD/MBProgressHUD.h>

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

- (IBAction)callCustomer:(id)sender {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@", self.order.userPhone]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}

#pragma mark UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section && self.order.userRequestAt) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[LibraryAPI sharedInstance] endAnOrder:self.order
                                        byValet:[[LibraryAPI sharedInstance] getCurrentValetModel]
                                        success:^(OrderModel *order) {
                                            [hud hideAnimated:YES];
                                            [self.navigationController popViewControllerAnimated:YES];
                                            [self.delegate endOrderSuccessfully];
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
        
        if (self.order.userRequestAt) {
            cell.textLabel.text = @"End this Order";
            cell.textLabel.textColor = [UIColor redColor];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        } else {
            cell.textLabel.text = @"In the parking lot";
            cell.textLabel.textColor = [UIColor greenColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    } else {
        TwoLabelCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TwoLabelCellIdentifier];
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    
}

- (void)configureCell:(TwoLabelCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.leftLabel.text = [CarStatusViewController titleArray][indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row == 0) {
        cell.rightLabel.text = self.order.carPlate;
    } else if (indexPath.row == 1) {
        cell.rightLabel.text = self.order.carBrand;
    } else if (indexPath.row == 2) {
        cell.rightLabel.text = self.order.carColor;
    } else if (indexPath.row == 3) {
        cell.rightLabel.text = [self.order.userFirstName stringByAppendingString:self.order.userLastName];
    } else {
        cell.rightLabel.text = self.order.userPhone;
    }
    
    
}

+ (NSArray *)titleArray {
    return @[@"Plate", @"Brand", @"Color", @"User Name", @"Use Phone"];
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
