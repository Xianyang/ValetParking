//
//  CurrentOrderViewController.m
//  Valet_Parking
//
//  Created by Chester on 19/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "CurrentOrderViewController.h"

@interface CurrentOrderViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSUInteger _numberOfOrder;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CurrentOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _numberOfOrder = 0;
    
    // TODO get orders from server
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _numberOfOrder;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // TODO return the car
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"orderCell"];
    }
    
    cell.textLabel.text = @"order";
    
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
