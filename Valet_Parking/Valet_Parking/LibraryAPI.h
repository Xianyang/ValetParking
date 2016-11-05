//
//  LibraryAPI.h
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CarModel.h"
#import "UserModel.h"
#import "OrderModel.h"

@interface LibraryAPI : NSObject

+ (LibraryAPI *)sharedInstance;

// Account
- (BOOL)isUserLogin;
- (void)tryLoginWithLocalAccount;
- (void)loginWithPhone;
- (void)registerWithPhone;
- (void)resetPasswordWithPhone;
- (void)logout;
- (UserModel *)getCurrentUserModel;
// cars
- (void)getCarsForUser;
- (void)addACar;
- (void)updateACar;
- (void)deleteCarWithCarModel;
- (void)deleteAllCarsInCoreData;
- (NSArray *)getAllCarModelsInCoreData;
// Orders
- (void)getCurrentOrdersForUser;
- (void)recallACar;
- (void)checkOrderWithParkingPlace;
// qr
- (UIImage *)qrImageForString;
- (UIColor *)themeColor;
// check data & transformation
- (BOOL)isPhoneNumberValid;
- (NSString *)transferOrderDateToYYYYMMDDAndTime;
- (NSString *)transferOrderDateToMMDDAndTime;
- (NSTimeInterval)calculateTimeIntervalSinceTime;

@end
