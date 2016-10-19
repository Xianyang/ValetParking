//
//  HttpClient.h
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValetModel.h"
#import "CarModel.h"
#import "OrderModel.h"
#import "APIMessage.h"

static NSString * const NetworkErrorDomain = @"com.luoxianyang";

@interface HttpClient : NSObject

- (id)init;

// account

- (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
               success:(void(^)(ValetModel *valetModel))successBlock
                  fail:(void(^)(NSError *error))failBlock;

- (void)resetPasswordWithPhone:(NSString *)phone
                      password:(NSString *)password
                       success:(void(^)(ValetModel *valetModel))successBlock
                          fail:(void(^)(NSError *error))failBlock;

// order
- (void)addOrderWithParkingPlace:(NSString *)parkingPlace
                       userPhone:(NSString *)userPhone
                        carPlate:(NSString *)carPlate
                         success:(void (^)(OrderModel *orderModel))successBlock
                            fail:(void (^)(NSError *error))failBlock;

- (void)getAllOpeningOrders:(ValetModel *)valetModel
                    success:(void (^)(NSArray *orders))successBlock
                       fail:(void (^)(NSError *error))failBlock;

@end
