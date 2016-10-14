//
//  AddCarViewController.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "AddCarViewController.h"
#import "CarModel.h"
#import "LibraryAPI.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface AddCarViewController ()
@property (strong, nonatomic) NSString *userPhone;
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
    
    self.userPhone = [[[LibraryAPI sharedInstance] getCurrentUserModel] phone];
    
    if (_editMode) {
        self.navigationItem.title = @"Edit";
        self.plateTextField.text = _oldCar.plate;
        self.brandTextField.text = _oldCar.brand;
        self.colorTextField.text = _oldCar.color;
    }
}

- (void)enterEditModeWithCar:(CarModel *)car {
    _editMode = YES;
    _oldCar = car;
}

- (void)cancelAddCar {
    // TODO add a alert
    [self.view endEditing:YES];
    [self.delegate cancelAddCar];
}

- (void)finishAddCar {
    CarModel *newCar = [[CarModel alloc] initWithIdentifier:@""
                                                  userPhone:self.userPhone
                                                      plate:self.plateTextField.text
                                                      brand:self.brandTextField.text
                                                      color:self.colorTextField.text];
    
//    CarModel *newCar = [[CarModel alloc] initWithPlate:self.plateTextField.text
//                                                 brand:self.brandTextField.text
//                                                 color:self.colorTextField.text];
    
    void (^deleteCar)(CarModel *) = ^(CarModel *oldCar)
    {
        [[LibraryAPI sharedInstance] deleteCar:_oldCar
                                       succeed:^(NSString *message) {
                                           NSLog(@"%@", message);
                                       }
                                          fail:^(NSError *error) {
                                              
                                          }];
    };
    
    __block BOOL addSuccessfully = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LibraryAPI sharedInstance] addACar:newCar
                                 succeed:^(CarModel *carModel) {
                                     addSuccessfully = YES;
                                     [self.view endEditing:YES];
                                     
                                     if (_editMode) {
                                         deleteCar(_oldCar);
                                     }
                                     
                                     [hud hideAnimated:YES];
                                     [self.delegate finishAddCar];
                                 }
                                    fail:^(NSError *error) {
                                        NSLog(@"%@", error);
                                        // TODO if same car, alert user
                                        if (error.code == 201 && _editMode == NO) {
                                            // user add a car that already exist
                                            hud.mode = MBProgressHUDModeText;
                                            hud.label.text = @"You have already added this car";
                                            [hud hideAnimated:YES afterDelay:1];
                                        } else {
                                            hud.mode = MBProgressHUDModeText;
                                            hud.label.text = @"fail";
                                            [hud hideAnimated:YES afterDelay:1];
                                        }
                                    }];
    
    
//    if (_editMode && addSuccessfully) {
//        [[LibraryAPI sharedInstance] deleteCar:_oldCar
//                                       succeed:^(NSString *message) {
//                                           NSLog(@"%@", message);
//                                           
//                                       }
//                                          fail:^(NSError *error) {
//                                              
//                                          }];
//    }
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
