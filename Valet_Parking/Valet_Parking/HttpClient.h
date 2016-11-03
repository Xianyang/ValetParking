//
//  HttpClient.h
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "CarModel.h"
#import "OrderModel.h"
#import "APIMessage.h"

static NSString * const NetworkErrorDomain = @"com.luoxianyang";

@interface HttpClient : NSObject

- (id)init;

// account
- (void)registerWithPhone:(NSString *)phone
                firstName:(NSString *)firstName
                 lastName:(NSString *)lastName
                 password:(NSString *)password
                  success:(void(^)(UserModel *userModel))successBlock
                     fail:(void(^)(NSError *error))failBlock;

- (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
               success:(void(^)(UserModel *userModel))successBlock
                  fail:(void(^)(NSError *error))failBlock;

- (void)resetPasswordWithPhone:(NSString *)phone
                      password:(NSString *)password
                       success:(void(^)(UserModel *userModel))successBlock
                          fail:(void(^)(NSError *error))failBlock;

// car
- (void)getCarsForUser:(UserModel *)userModel
               success:(void(^)(NSArray *cars))successBlock
                  fail:(void(^)(NSError *error))failBlock;

- (void)addACarWithCarModel:(CarModel *)carModel
                    success:(void(^)(CarModel *carModel))successBlock
                       fail:(void(^)(NSError *error))failBlock;

- (void)updateACar:(CarModel *)oldCarModel
       newCarModel:(CarModel *)newCarModel
           success:(void(^)(CarModel *carModel))successBlock
              fail:(void(^)(NSError *error))failBlock;

- (void)deleteCarWithCarModel:(CarModel *)carModel
                      success:(void(^)(NSString *msg))successBlock
                         fail:(void(^)(NSError *error))failBlock;

// orders
- (void)getCurrentOrdersForUser:(UserModel *)userModel
                        success:(void (^)(NSArray *orders))successBlock
                           fail:(void (^)(NSError *error))failBlock;

- (void)recallACar:(OrderModel *)orderModel
           success:(void (^)(OrderModel *orderModel))successBlock
              fail:(void (^)(NSError *error))failBlock;

- (void)checkOrderWithParkingPlace:(NSString *)parkingPlace
                         userPhone:(NSString *)userPhone
                          carPlate:(NSString *)carPlate
                           success:(void (^)(OrderModel *orderModel))successBlock
                              fail:(void (^)(NSError *error))failBlock;

@end
