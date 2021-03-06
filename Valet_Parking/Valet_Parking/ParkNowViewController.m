//
//  ParkNowViewController.m
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "ParkNowViewController.h"
#import "AddCarViewController.h"
#import "ParkTicketViewController.h"
#import "PlaceListViewController.h"
#import "EditItemViewController.h"
#import "MyCarsViewController.h"
#import "WelcomeViewController.h"
#import "MapViewController.h"
#import "TwoLabelCell.h"
#import "UserModel.h"
#import "CarModel.h"

static NSString * const TwoLabelCellIdentifier = @"TwoLabelCell";

@interface ParkNowViewController () <AddCarViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, EditItemViewControllerDelegate, MyCarsViewControllerDelegate, WelcomeViewControllerDelegate, MapViewControllerDelegate>
@property (strong, nonatomic) NSArray *cars;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UserModel *userModel;
@property (strong, nonatomic) NSArray *userCars;

@property (strong, nonatomic) NSString *chosenPlace;
@property (strong, nonatomic) CarModel *chosenCar;
@end

@implementation ParkNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back")
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    // Step1 check if logged in
    if (![[LibraryAPI sharedInstance] isUserLogin]) {
        [[LibraryAPI sharedInstance] deleteAllCarsInCoreData];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
        [[LibraryAPI sharedInstance] tryLoginWithLocalAccount:^(UserModel *userModel) {
            [hud hideAnimated:YES];
            [self loginSuccessfully:userModel];
        }
                                                         fail:^(NSError *error) {
                                                             [hud hideAnimated:YES];
                                                             [self popUpWelcomeView];
                                                         }];
    } else {
        [self settingsAfterViewDidLoad];
    }
}

- (void)settingsAfterViewDidLoad {
    // Step1 - Let user chooses its info
    self.userModel = [[LibraryAPI sharedInstance] getCurrentUserModel];
    self.userCars = [[LibraryAPI sharedInstance] getAllCarModelsInCoreData];
    
    // Step2 - Check if the user has a car. If not, present add car view
    [self checkCars];
    
    // TODO set chosen car and place
    self.chosenPlace = [ListForCell placeArray][0];
    if (self.userCars.count) {
        self.chosenCar = [self.userCars lastObject];
    }
    
    [self.tableView reloadData];
}

- (void)checkCars {
    if (self.userCars.count == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddCarViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AddCarViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.delegate = self;
        [self.navigationController presentViewController:nav
                                                animated:YES
                                              completion:nil];
    }
}

- (void)popUpWelcomeView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WelcomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    viewController.delegate = self;
    [self.navigationController presentViewController:viewController
                                            animated:YES
                                          completion:nil];
}


- (void)finishChangeText:(NSString *)newText {
    
}

#pragma mark - MapViewControllerDelegate

- (void)refreshPlace:(NSString *)place {
    self.chosenPlace = place;
    [self.tableView reloadData];
}

#pragma mark - WelcomeViewControllerDelegate

- (void)loginSuccessfully:(UserModel *)userModel
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // get user's car
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    
    [[LibraryAPI sharedInstance] getCarsForUser:userModel
                                        success:^(NSArray *cars) {
                                            NSLog(@"Get %lu cars from server", (unsigned long)[cars count]);
                                            [hud hideAnimated:YES];
                                            [self settingsAfterViewDidLoad];
                                        }
                                           fail:^(NSError *error) {
                                               hud.mode = MBProgressHUDModeText;
                                               hud.label.text = @"fail to fetch cars";
                                               [hud hideAnimated:YES afterDelay:1];
                                           }];
}


# pragma mark - My Car Viewcontroller Delegate
- (void)setChosenCarModel:(CarModel *)aCarModel {
    self.chosenCar = aCarModel;
    [self.tableView reloadData];
}

# pragma mark - UI Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ParkTicketViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ParkTicketViewController"];
        [vc setPlace:self.chosenPlace userModel:self.userModel carModel:self.chosenCar];
        
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 0) {
        /*
        if (indexPath.row == 1) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EditItemViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"EditItemViewController"];
            TwoLabelCell *cell = (TwoLabelCell *)[tableView cellForRowAtIndexPath:indexPath];
            [vc setNavTitle:@"Change Name" oldString:cell.rightLabel.text];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EditItemViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"EditItemViewController"];
            TwoLabelCell *cell = (TwoLabelCell *)[tableView cellForRowAtIndexPath:indexPath];
            [vc setNavTitle:@"Change Phone" oldString:cell.rightLabel.text];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
         */
        if (indexPath.row == 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PlaceListViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PlaceListViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 3) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyCarsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MyCarsViewController"];
            [vc setDelegate:self];
            [vc setEditable:NO chosenCar:self.chosenCar];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section?1:4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TwoLabelCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TwoLabelCellIdentifier];
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    } else {
        UITableViewCell *confirmCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                              reuseIdentifier:nil];
        confirmCell.textLabel.textAlignment = NSTextAlignmentCenter;
        confirmCell.textLabel.text = @"Confirm";
        
        return confirmCell;
    }
}

- (void)configureCell:(TwoLabelCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.leftLabel.text = [ParkNowViewController leftTextForCell][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.rightLabel.text = self.chosenPlace;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 1) {
            cell.rightLabel.text = [[self.userModel.firstName stringByAppendingString:@" "] stringByAppendingString:self.userModel.lastName];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 2) {
            cell.rightLabel.text = self.userModel.phone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 3) {
            if (self.chosenCar != nil) {
                cell.rightLabel.text = self.chosenCar.plate;
            } else {
                cell.rightLabel.text = @"";
            }
        }
    }
}

+ (NSArray *)leftTextForCell {
    return @[@"Place", @"Name", @"Phone", @"Car"];
}

# pragma mark - AddCarViewControllerDelegate

- (void)cancelAddCar {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishAddCar {
    self.userCars = [[LibraryAPI sharedInstance] getAllCarModelsInCoreData];
    if (self.userCars.count) {
        self.chosenCar = [self.userCars lastObject];
    }
    [self.tableView reloadData];
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
