//
//  MyCarsViewController.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "MyCarsViewController.h"
#import "AddCarViewController.h"
#import "LibraryAPI.h"

@interface MyCarsViewController () <AddCarViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addCarBtn;
@property (strong, nonatomic) NSArray *cars;
@end

@implementation MyCarsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.addCarBtn setTarget:self];
    [self.addCarBtn setAction:@selector(addCarbtnPressed)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.cars = [[LibraryAPI sharedInstance] getAllCars];
    
    for (CarModel *car in self.cars) {
        NSLog(@"%@", car.carPlate);
    }
}

- (void)addCarbtnPressed {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddCarViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AddCarViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.delegate = self;
    [self.navigationController presentViewController:nav
                                            animated:YES
                                          completion:nil];
}

# pragma mark - AddCarViewControllerDelegate

- (void)cancelAddCar {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishAddCar {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - UITableView

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
