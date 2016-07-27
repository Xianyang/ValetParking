//
//  ParkNowViewController.m
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "ParkNowViewController.h"
#import "AddCarViewController.h"
#import "LibraryAPI.h"


@interface ParkNowViewController () <AddCarViewControllerDelegate>
@property (strong, nonatomic) NSArray *cars;

@end

@implementation ParkNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Step1 - Check if the user has a car. If not, present add car view
    [self checkCars];
}

- (void)checkCars {
    self.cars = [[LibraryAPI sharedInstance] getAllCars];
    
    if (self.cars.count > 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddCarViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AddCarViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.delegate = self;
        [self.navigationController presentViewController:nav
                                                animated:YES
                                              completion:nil];
    }
}

# pragma mark - AddCarViewControllerDelegate

- (void)cancelAddCar {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishAddCar {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // TODO present the service page
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
