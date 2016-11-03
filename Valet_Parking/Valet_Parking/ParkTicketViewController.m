//
//  ParkTicketViewController.m
//  Valet_Parking
//
//  Created by WangYili on 7/28/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "ParkTicketViewController.h"
#import "OrderModel.h"

@interface ParkTicketViewController ()

@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) UserModel *user;
@property (strong, nonatomic) CarModel *car;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;

@end

@implementation ParkTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back")
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
//    NSError *err;
//    NSDictionary *dic = @{@"a":@"b"};
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&err];
//    NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    NSError *err2;
//    NSData *data = [myString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *res;
//    res = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:0 error:&err2];
    
    OrderModel *order = [[OrderModel alloc] initWithParkingPlace:self.place
                                                  userIdentifier:self.user.identifier
                                                   userFirstName:self.user.firstName
                                                    userLastName:self.user.lastName
                                                       userPhone:self.user.phone
                                                   carIdentifier:self.car._id
                                                        carPlate:self.car.plate
                                                        carBrand:self.car.brand
                                                        carColor:self.car.color];

    NSDictionary *parkingTicketDic = [order createTicketDic];
    NSError *error;
    NSData *parkingTicketData = [NSJSONSerialization dataWithJSONObject:parkingTicketDic
                                                                options:0
                                                                  error:&error];
    
    NSString *parkingTicketString = [[NSString alloc] initWithData:parkingTicketData encoding:NSUTF8StringEncoding];
    UIImage *qrImage = [[LibraryAPI sharedInstance] qrImageForString:parkingTicketString
                                                      withImageWidth:150.0f
                                                         imageHeight:150.0f];
    
    [self.qrImageView setImage:qrImage];
}

- (void)setPlace:(NSString *)place userModel:(UserModel *)user carModel:(CarModel *)car {
    self.place = place;
    self.user = user;
    self.car = car;
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
