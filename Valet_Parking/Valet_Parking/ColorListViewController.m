//
//  ColorListViewController.m
//  Valet_Parking
//
//  Created by Chester on 03/11/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "ColorListViewController.h"

@interface ColorListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ColorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate refreshColor:[ListForCell carColorArray][indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ListForCell carColorArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"color_list_cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"color_list_cell"];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"empty"];
    NSArray *colorValue = [ListForCell carColorValueArray][indexPath.row];
    cell.imageView.backgroundColor = [UIColor colorWithRed:[colorValue[0] doubleValue]
                                                     green:[colorValue[1] doubleValue]
                                                      blue:[colorValue[2] doubleValue]
                                                     alpha:[colorValue[3] doubleValue]];
    cell.imageView.layer.cornerRadius = 10;
    cell.imageView.layer.borderColor = [[UIColor blackColor] CGColor];
    cell.imageView.layer.borderWidth = 1.0f;
    cell.textLabel.text = [ListForCell carColorArray][indexPath.row];
    
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
