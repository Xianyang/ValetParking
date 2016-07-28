//
//  ParkTicketViewController.h
//  Valet_Parking
//
//  Created by WangYili on 7/28/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "CarModel.h"

@interface ParkTicketViewController : UIViewController

- (void)setPlace:(NSString *)place userModel:(UserModel *)user carModel:(CarModel *)car;

@end
