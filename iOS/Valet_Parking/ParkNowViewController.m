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
#import "EditItemViewController.h"
#import "MyCarsViewController.h"
#import "TwoLabelCell.h"
#import "UserModel.h"
#import "CarModel.h"

static NSString * const TwoLabelCellIdentifier = @"TwoLabelCell";

@interface ParkNowViewController () <AddCarViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, EditItemViewControllerDelegate, MyCarsViewControllerDelegate>
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
    
    // Step1 - Let user chooses its info
    self.userModel = [[LibraryAPI sharedInstance] getCurrentUserModel];
    self.userCars = [[LibraryAPI sharedInstance] getAllCarModels];
    
    // Step2 - Check if the user has a car. If not, present add car view
    [self checkCars];
    
    // TODO set chosen car and place
    self.chosenPlace = @"California Tower";
    if (self.userCars.count) {
        self.chosenCar = [self.userCars lastObject];
    }
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

- (void)finishChangeText:(NSString *)newText {
    
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
        if (indexPath.row == 3) {
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
    return 44.0f;
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
        } else if (indexPath.row == 1) {
            cell.rightLabel.text = [[self.userModel.firstName stringByAppendingString:@" "] stringByAppendingString:self.userModel.lastName];
        } else if (indexPath.row == 2) {
            cell.rightLabel.text = self.userModel.phone;
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
    self.userCars = [[LibraryAPI sharedInstance] getAllCarModels];
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
