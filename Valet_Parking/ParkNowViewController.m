//
//  ParkNowViewController.m
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "ParkNowViewController.h"

@interface ParkNowViewController ()

@end

@implementation ParkNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Step1 - Check if the user has a car. If not, present add car view
    [self checkCars];
}

- (void)checkCars {
    
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
