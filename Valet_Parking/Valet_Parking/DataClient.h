//
//  DataClient.h
//  Valet_Parking
//
//  Created by Chester on 15/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "CarModel.h"

@interface DataClient : NSObject

- (id)init;

// Account
- (BOOL)isUserLogin;
- (void)setLogoutInShareApplication;
- (void)setLoginInShareApplication;
- (NSString *)getAccountInKeychain;
- (NSString *)getPasswordInKeychain;
- (BOOL)saveUserModelToCoreData:(UserModel *)userModel;
- (void)saveAccountToKeychain:(NSString *)userAccount password:(NSString *)userPassword;
- (UserModel *)getCurrentUserModel;
- (BOOL)deleteUserMO;

// Car
- (BOOL)checkRedundantCar:(CarModel *)carModel;

- (BOOL)saveCarToCoreData:(CarModel *)carModel;
- (BOOL)updateCarLocally:(CarModel *)oldCarModel newCarModel:(CarModel *)newCarModel;
- (BOOL)deleteCarLocally:(CarModel *)carModel;

- (NSArray *)getAllCarModelsInCoreData;
- (BOOL)deleteAllCarsInCoreData;

@end
