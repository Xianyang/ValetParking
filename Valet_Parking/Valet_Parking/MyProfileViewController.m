//
//  MyProfileViewController.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "MyProfileViewController.h"
#import "UserModel.h"
#import "TwoLabelCell.h"

static NSString * const TwoLabelCellIdentifier = @"TwoLabelCell";

@interface MyProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UserModel *userModel;
@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userModel = [[LibraryAPI sharedInstance] getCurrentUserModel];
    NSLog(@"current user is %@, first name %@, last name %@, id %@", self.userModel.phone, self.userModel.firstName, self.userModel.lastName, self.userModel.identifier);
}

# pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TwoLabelCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TwoLabelCellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(TwoLabelCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.leftLabel.text = [MyProfileViewController leftTextForCell][indexPath.row];
    
    if (indexPath.row == 0) {
        cell.rightLabel.text = [[self.userModel.firstName stringByAppendingString:@" "] stringByAppendingString:self.userModel.lastName];
    } else if (indexPath.row == 1) {
        cell.rightLabel.text = self.userModel.phone;
    }
}

+ (NSArray *)leftTextForCell {
    return @[@"Name", @"Phone"];
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
