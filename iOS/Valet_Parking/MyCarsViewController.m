//
//  MyCarsViewController.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "MyCarsViewController.h"
#import "AddCarViewController.h"
#import "CarCell.h"
#import "CarModel.h"
#import "LibraryAPI.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSString * const CarCellIdentifier = @"CarCell";

@interface MyCarsViewController () <AddCarViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isEditable;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addCarBtn;
@property (strong, nonatomic) NSArray *cars;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;

@property (strong, nonatomic) CarModel *chosenCarModel;
@end

@implementation MyCarsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.addCarBtn setTarget:self];
    [self.addCarBtn setAction:@selector(addCarbtnPressed)];
    
    [self reloadCars];
    if (self.cars.count == 0) {
        [self presentAddCarView];
    }
    
    // is the bar button item editable
    if (!_isEditable) {
        [self.rightBarButton setEnabled:NO];
        [self.rightBarButton setTintColor:[UIColor clearColor]];
    }
}

- (void)setEditable:(BOOL)editable chosenCar:(CarModel *)aCarModel{
    _isEditable = editable;
    self.chosenCarModel = aCarModel;
}

- (void)presentAddCarView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddCarViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AddCarViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.delegate = self;
    [self.navigationController presentViewController:nav
                                            animated:YES
                                          completion:nil];
}

- (void)reloadCars {
    self.cars = [[LibraryAPI sharedInstance] getAllCarModels];
    
//    if (self.cars.count > 0) {
//        for (CarModel *car in self.cars) {
//            NSLog(@"%@", car.plate);
//        }
//    }
    
    [self.tableView reloadData];
}

- (void)addCarbtnPressed {
    [self presentAddCarView];
}

# pragma mark - AddCarViewControllerDelegate

- (void)cancelAddCar {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.cars.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)finishAddCar {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self reloadCars];
}

# pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isEditable && self.chosenCarModel) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        if (![self.chosenCarModel isSameCar:self.cars[indexPath.row]]) {
            self.chosenCarModel = self.cars[indexPath.row];
            [self.tableView reloadData];
            [self.delegate setChosenCarModel:self.chosenCarModel];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddCarViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AddCarViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.delegate = self;
        [vc enterEditModeWithCar:self.cars[indexPath.row]];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CarCellIdentifier
                                                         forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(CarCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    CarModel *car = self.cars[indexPath.row];
    cell.plateLabel.text = car.plate;
    cell.brandLabel.text = car.brand;
    cell.colorLabel.text = car.color;
    
    if (!_isEditable) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        if ([car isSameCar:self.chosenCarModel]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && _isEditable) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[LibraryAPI sharedInstance] deleteCarWithCarModel:self.cars[indexPath.row]
                                                   success:^(NSString *msg) {
                                                       [hud hideAnimated:YES];
                                                       NSLog(@"%@", msg);
                                                       [self reloadCars];
                                                   }
                                                      fail:^(NSError *error) {
                                                          hud.mode = MBProgressHUDModeText;
                                                          hud.label.text = @"delete failed";
                                                          [hud hideAnimated:YES afterDelay:1];
                                                      }];
    }
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
