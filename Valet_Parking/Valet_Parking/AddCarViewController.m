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

@interface AddCarViewController ()
@property (strong, nonatomic) NSString *userPhone;
@property (weak, nonatomic) IBOutlet UIView *backView;
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
    
    self.userPhone = [[[LibraryAPI sharedInstance] getCurrentUserModel] phone];
    
    if (_editMode) {
        self.navigationItem.title = @"Edit";
        // self.plateTextField.text = _oldCar.plate;
        [self.plateTextField setHidden:YES];
        UILabel *label = [[UILabel alloc] initWithFrame:self.plateTextField.frame];
        label.text = _oldCar.plate;
        label.font = [UIFont fontWithName:@"System" size:13];
        label.textColor = [UIColor lightGrayColor];
        [self.backView addSubview:label];
        
        self.brandTextField.text = _oldCar.brand;
        self.colorTextField.text = _oldCar.color;
        
        [self.brandTextField becomeFirstResponder];
    } else {
        [self.plateTextField becomeFirstResponder];
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
    
    [self.finishAddCarBtn setEnabled:NO];
    if (_editMode) {
        // user wants to edit this car
        newCar._id = _oldCar._id;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[LibraryAPI sharedInstance] updateACar:_oldCar
                                    newCarModel:newCar
                                        success:^(CarModel *carModel) {
                                            [self.view endEditing:YES];
                                            [hud hideAnimated:YES];
                                            [self.delegate finishAddCar];
                                        }
                                           fail:^(NSError *error) {
                                               [self.finishAddCarBtn setEnabled:YES];
                                               hud.mode = MBProgressHUDModeText;
                                               hud.label.text = [[APIMessage sharedInstance] messageToShowWithError:error.code];
                                               [hud hideAnimated:YES afterDelay:1];
                                           }];
        
    } else {
        // user wants to add a new car
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[LibraryAPI sharedInstance] addACar:newCar
                                     succeed:^(CarModel *carModel) {
                                         [self.view endEditing:YES];
                                         [hud hideAnimated:YES];
                                         [self.delegate finishAddCar];
                                     }
                                        fail:^(NSError *error) {
                                            [self.finishAddCarBtn setEnabled:YES];
                                            hud.mode = MBProgressHUDModeText;
                                            hud.label.text = [[APIMessage sharedInstance] messageToShowWithError:error.code];
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
