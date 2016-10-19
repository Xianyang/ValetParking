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
- (void)tryLoginWithLocalAccount:(void (^)(UserModel *userModel))successBlock
                            fail:(void (^)(NSError *error))failBlock;

- (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
               success:(void(^)(UserModel *userModel))successBlock
                  fail:(void(^)(NSError *error))failBlock;

- (void)registerWithPhone:(NSString *)phone
                firstName:(NSString *)firstName
                 lastName:(NSString *)lastName
                 password:(NSString *)password
                  success:(void(^)(UserModel *userModel))successBlock
                     fail:(void(^)(NSError *error))failBlock;

- (void)resetPasswordWithPhone:(NSString *)phone
                      password:(NSString *)password
                       success:(void(^)(UserModel *userModel))successBlock
                          fail:(void(^)(NSError *error))failBlock;

- (void)logout;
- (UserModel *)getCurrentUserModel;

// cars
- (void)getCarsForUser:(UserModel *)userModel
               success:(void(^)(NSArray *cars))successBlock
                  fail:(void(^)(NSError *error))failBlock;

- (void)addACar:(CarModel *)carModel
        succeed:(void(^)(CarModel *carModel))successBlock
           fail:(void(^)(NSError *error))failBlock;

- (void)updateACar:(CarModel *)oldCarModel
       newCarModel:(CarModel *)newCarModel
           success:(void(^)(CarModel *carModel))successBlock
              fail:(void(^)(NSError *error))failBlock;

- (void)deleteCarWithCarModel:(CarModel *)carModel
                      success:(void(^)(NSString *msg))successBlock
                         fail:(void(^)(NSError *error))failBlock;

- (void)deleteAllCarsInCoreData;
- (NSArray *)getAllCarModelsInCoreData;

// Orders
- (void)getCurrentOrdersForUser:(UserModel *)userModel
                        success:(void (^)(NSArray *orders))successBlock
                           fail:(void (^)(NSError *error))failBlock;

- (void)recallACar:(OrderModel *)orderModel
           success:(void (^)(OrderModel *orderModel))successBlock
              fail:(void (^)(NSError *error))failBlock;

// qr
- (UIImage *)qrImageForString:(NSString *)qrString withImageWidth:(CGFloat)width imageHeight:(CGFloat)height;

@end
