//
//  AddOrderViewController.m
//  Valet_Parking_ValetSide
//
//  Created by Chester on 19/10/2016.
//  Copyright © 2016 Chester. All rights reserved.
//

#import "AddOrderViewController.h"

@interface AddOrderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AddOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        // TODO start adding order
    } else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        
        cell.textLabel.text = @"Confirm";
        return cell;
    } else {
        return [self configureCell:indexPath];
    }
}

- (UITableViewCell *)configureCell:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    
    return cell;
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
