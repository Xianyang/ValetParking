//
//  HttpClient.m
//  ValetParkinge
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "HttpClient.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const kIPAdress = @"http://147.8.203.207:3001/";
//static NSString * const kIPAdress = @"http://192.168.1.100:3001/";

@interface HttpClient()

@property (strong, nonatomic) NSString *kRegisterURL;
@property (strong, nonatomic) NSString *kLoginURL;
@property (strong, nonatomic) NSString *kResetPasswordURL;

@property (strong, nonatomic) NSString *kGetAllOpeningOrders;
@property (strong, nonatomic) NSString *kCreateOrder;
@property (strong, nonatomic) NSString *kEndAnOrder;

@end

@implementation HttpClient

- (id)init {
    if (self == [super init]) {
        self.kLoginURL = [kIPAdress stringByAppendingString:@"api/account/valet/logon"];
        self.kResetPasswordURL = [kIPAdress stringByAppendingString:@"api/account/valet/set_new_password"];
        
        self.kGetAllOpeningOrders = [kIPAdress stringByAppendingString:@"api/order/get_all_opening_orders"];
        self.kCreateOrder = [kIPAdress stringByAppendingString:@"api/order/add"];
        self.kEndAnOrder = [kIPAdress stringByAppendingString:@"api/order/end_by_valet"];
    }
    
    return self;
}

#pragma mark - Accouns

- (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
               success:(void(^)(ValetModel *valetModel))successBlock
                  fail:(void(^)(NSError *error))failBlock
{
    NSURL *url = [NSURL URLWithString:self.kLoginURL];
    NSDictionary *parameters = @{@"phone": phone,
                                 @"password": password};
    
    AFHTTPSessionManager *manager = [self newManager];
    
    [manager POST:[url absoluteString]
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSError *error = nil;
              // get response from the server successfully
              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                  BOOL isSuccess = [responseObject[@"success"] boolValue];
                  if (isSuccess) {
                      NSError *error;
                      ValetModel *valetModel = [[ValetModel alloc] initWithDictionary:responseObject[@"extras"][@"valetProfileModel"]
                                                                             error:&error];
                      if (error) {
                          failBlock(error);
                      } else {
                          successBlock(valetModel);
                      }
                  } else {
                      // login failed
                      ServerErrorMessage failMessage = (ServerErrorMessage)[responseObject[@"extras"][@"msg"] integerValue];
                      error = [NSError errorWithDomain:NetworkErrorDomain
                                                  code:failMessage
                                              userInfo:nil];
                      failBlock(error);
                  }
              } else {
                  failBlock(nil);
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failBlock(error);
          }];
}

- (void)resetPasswordWithPhone:(NSString *)phone
                      password:(NSString *)password
                       success:(void(^)(ValetModel *valetModel))successBlock
                          fail:(void(^)(NSError *error))failBlock
{
    NSURL *url = [NSURL URLWithString:self.kResetPasswordURL];
    NSDictionary *parameters = @{@"phone": phone,
                                 @"password": password};
    
    AFHTTPSessionManager *manager = [self newManager];
    
    [manager POST:[url absoluteString]
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSError *error = nil;
              // get response from the server successfully
              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                  BOOL isSuccess = [responseObject[@"success"] boolValue];
                  if (isSuccess) {
                      NSError *error;
                      ValetModel *valetModel = [[ValetModel alloc] initWithDictionary:responseObject[@"extras"][@"valetProfileModel"]
                                                                             error:&error];
                      if (error) {
                          failBlock(error);
                      } else {
                          successBlock(valetModel);
                      }
                  } else {
                      // reset failed
                      ServerErrorMessage failMessage = (ServerErrorMessage)[responseObject[@"extras"][@"msg"] integerValue];
                      error = [NSError errorWithDomain:NetworkErrorDomain
                                                  code:failMessage
                                              userInfo:nil];
                      failBlock(error);
                  }
              } else {
                  failBlock(nil);
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failBlock(error);
          }];
}

#pragma mark - Order

- (void)getAllOpeningOrders:(ValetModel *)valetModel
                    success:(void (^)(NSArray *orders))successBlock
                       fail:(void (^)(NSError *error))failBlock {
    NSURL *url = [NSURL URLWithString:self.kGetAllOpeningOrders];
    NSDictionary *parameters = @{@"identifier": valetModel.identifier,
                                 @"phone": valetModel.phone,
                                 @"firstName": valetModel.firstName,
                                 @"lastName": valetModel.lastName};
    
    AFHTTPSessionManager *manager = [self newManager];
    
    [manager POST:[url absoluteString]
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSError *error = nil;
              // get response from the server successfully
              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                  BOOL isSuccess = [responseObject[@"success"] boolValue];
                  if (isSuccess) {
                      NSError *error;
                      NSMutableArray *orders = [NSMutableArray new];
                      for (NSDictionary *dic in responseObject[@"extras"][@"orders"]) {
                          OrderModel *orderModel = [[OrderModel alloc] initWithDictionary:dic error:&error];
                          [orders addObject:orderModel];
                      }
                      
                      if (error) {
                          failBlock(error);
                      } else {
                          successBlock(orders);
                      }
                  } else {
                      ServerErrorMessage failMessage = (ServerErrorMessage)[responseObject[@"extras"][@"msg"] integerValue];
                      error = [NSError errorWithDomain:NetworkErrorDomain
                                                  code:failMessage
                                              userInfo:nil];
                      failBlock(error);
                  }
              } else {
                  
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failBlock(error);
          }];


}

- (void)addOrderWithParkingPlace:(NSString *)parkingPlace
                       userPhone:(NSString *)userPhone
                        carPlate:(NSString *)carPlate
                         success:(void (^)(OrderModel *orderModel))successBlock
                            fail:(void (^)(NSError *error))failBlock {
    NSURL *url = [NSURL URLWithString:self.kCreateOrder];
    NSDictionary *parameters = @{@"parkingPlace": parkingPlace,
                                 @"userPhone": userPhone,
                                 @"carPlate":carPlate};
    
    AFHTTPSessionManager *manager = [self newManager];
    
    [manager POST:[url absoluteString]
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSError *error = nil;
              // get response from the server successfully
              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                  BOOL isSuccess = [responseObject[@"success"] boolValue];
                  if (isSuccess) {
                      NSError *error;
                      OrderModel *orderModel = [[OrderModel alloc] initWithDictionary:responseObject[@"extras"][@"orderProfileModel"]
                                                                                error:&error];
                      if (error) {
                          failBlock(error);
                      } else {
                          successBlock(orderModel);
                      }
                  } else {
                      // reset failed
                      ServerErrorMessage failMessage = (ServerErrorMessage)[responseObject[@"extras"][@"msg"] integerValue];
                      error = [NSError errorWithDomain:NetworkErrorDomain
                                                  code:failMessage
                                              userInfo:nil];
                      failBlock(error);
                  }
              } else {
                  failBlock(nil);
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failBlock(error);
          }];
}

- (void)endAnOrder:(OrderModel *)orderModel
           byValet:(ValetModel *)valetModel
           success:(void (^)(OrderModel *order))successBlock
              fail:(void (^)(NSError *error))failBlock {
    NSURL *url = [NSURL URLWithString:self.kEndAnOrder];
    
    NSDictionary *parameters = @{@"_id": orderModel._id,
                                 @"valetPhone": valetModel.phone,
                                 @"parkingPlace": orderModel.parkingPlace,
                                 @"carIdentifier": orderModel.carIdentifier,
                                 @"carPlate":orderModel.carPlate};
    
    AFHTTPSessionManager *manager = [self newManager];
    
    [manager POST:[url absoluteString]
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSError *error = nil;
              // get response from the server successfully
              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                  BOOL isSuccess = [responseObject[@"success"] boolValue];
                  if (isSuccess) {
                      NSError *error;
                      OrderModel *orderModel = [[OrderModel alloc] initWithDictionary:responseObject[@"extras"][@"orderProfileModel"]
                                                                                error:&error];
                      
                      if (error) {
                          failBlock(error);
                      } else {
                          successBlock(orderModel);
                      }
                  } else {
                      ServerErrorMessage failMessage = (ServerErrorMessage)[responseObject[@"extras"][@"msg"] integerValue];
                      error = [NSError errorWithDomain:NetworkErrorDomain
                                                  code:failMessage
                                              userInfo:nil];
                      failBlock(error);
                  }
              } else {
                  failBlock(nil);
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failBlock(error);
          }];

}

#pragma mark - Manager

- (AFHTTPSessionManager *)newManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return manager;
}

@end
