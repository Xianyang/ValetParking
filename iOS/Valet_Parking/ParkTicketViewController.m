//
//  ParkTicketViewController.m
//  Valet_Parking
//
//  Created by WangYili on 7/28/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "ParkTicketViewController.h"

@interface ParkTicketViewController ()

@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) UserModel *user;
@property (strong, nonatomic) CarModel *car;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;

@end

@implementation ParkTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *stringToEncode = [[[[self.place stringByAppendingString:@"--"] stringByAppendingString:self.user.phone] stringByAppendingString:@"--"] stringByAppendingString:self.car.carPlate];
//    UIImage *qrImage = [[LibraryAPI sharedInstance] qrImageForString:stringToEncode
//                                                      withImageWidth:self.qrImageView.frame.size.width
//                                                         imageHeight:self.qrImageView.frame.size.height];
    UIImage *qrImage = [[LibraryAPI sharedInstance] qrImageForString:stringToEncode
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
