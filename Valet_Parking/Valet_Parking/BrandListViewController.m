//
//  BrandListViewController.m
//  Valet_Parking
//
//  Created by Chester on 03/11/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "BrandListViewController.h"

@interface BrandListViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation BrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate refreshBrand:[ListForCell carBrandArray][indexPath.section][indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *titles = [NSMutableArray new];
    for (NSArray *array in [ListForCell carBrandArray]) {
        [titles addObject:[array[0] substringToIndex:1]];
    }
    return titles;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *aBrand = [ListForCell carBrandArray][section][0];
    NSString *firstLetter = [aBrand substringToIndex:1];
    return firstLetter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ListForCell carBrandArray][section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[ListForCell carBrandArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"car_list_cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"car_list_cell"];
    }
    
    NSString *carBrand = [ListForCell carBrandArray][indexPath.section][indexPath.row];
    cell.textLabel.text = carBrand;
    cell.imageView.image = [UIImage imageNamed:[@"Logo_" stringByAppendingString:carBrand]];
//    cell.imageView.image = [UIImage imageNamed:@"Logo_Acura1"];
//    [cell.imageView setFrame:CGRectMake(cell.imageView.frame.origin.x
//                                        , cell.imageView.frame.origin.y
//                                        , 5.0f, 5.0f)];
    
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
