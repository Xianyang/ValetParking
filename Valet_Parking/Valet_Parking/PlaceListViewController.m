//
//  PlaceListViewController.m
//  Valet_Parking
//
//  Created by Chester on 03/11/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "PlaceListViewController.h"
#import "MapViewController.h"

@interface PlaceListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PlaceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back")
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
}



#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    NSNumber *latitude = [ListForCell coordinatorArray][indexPath.row][0];
    NSNumber *longitude = [ListForCell coordinatorArray][indexPath.row][1];
    
    [vc setDelegate:self.navigationController.viewControllers[1]];
    
    [vc setTitle:[ListForCell placeArray][indexPath.row]
        Latitude:[latitude doubleValue]
       longitude:[longitude doubleValue]];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ListForCell placeArray] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"car_list_cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"car_list_cell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [ListForCell placeArray][indexPath.row];
    
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
