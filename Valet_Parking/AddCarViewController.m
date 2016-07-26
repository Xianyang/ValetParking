//
//  AddCarViewController.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "AddCarViewController.h"

@interface AddCarViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelAddCarBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishAddCarBtn;
@property (weak, nonatomic) IBOutlet UITextField *plateTextField;
@property (weak, nonatomic) IBOutlet UITextField *brandTextField;
@property (weak, nonatomic) IBOutlet UITextField *colorTextField;

@end

@implementation AddCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"]
                                                  forBarMetrics:UIBarMetricsDefault];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    
    [self.cancelAddCarBtn setTarget:self];
    [self.finishAddCarBtn setTarget:self];
    [self.cancelAddCarBtn setAction:@selector(cancelAddCar)];
    [self.finishAddCarBtn setAction:@selector(finishAddCar)];
    
    [self.plateTextField becomeFirstResponder];
}

- (void)cancelAddCar {
    [self.delegate cancelAddCar];
}

- (void)finishAddCar {
    [self.delegate finishAddCar];
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
