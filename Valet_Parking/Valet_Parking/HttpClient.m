//
//  HttpClient.m
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "HttpClient.h"
#import <AFNetworking/AFNetworking.h>

//static NSString * const kIPAdress = @"http://147.8.232.248:3001/";
static NSString * const kIPAdress = @"http://192.168.1.108:3001/";

@interface HttpClient()

@property (strong, nonatomic) NSString *kRegisterURL;
@property (strong, nonatomic) NSString *kLoginURL;
@property (strong, nonatomic) NSString *kResetPasswordURL;

@property (strong, nonatomic) NSString *kAddCarURL;
@property (strong, nonatomic) NSString *kGetCarURL;
@property (strong, nonatomic) NSString *kDeleteCarURL;
@property (strong, nonatomic) NSString *kUpdateCarURL;

@property (strong, nonatomic) NSString *kGetOrderURL;
@property (strong, nonatomic) NSString *kRecallCarURL;
@end

@implementation HttpClient

- (id)init {
    if (self == [super init]) {
        self.kRegisterURL = [kIPAdress stringByAppendingString:@"api/account/user/register"];
        self.kLoginURL = [kIPAdress stringByAppendingString:@"api/account/user/logon"];
        self.kResetPasswordURL = [kIPAdress stringByAppendingString:@"api/account/user/set_new_password"];
        self.kAddCarURL = [kIPAdress stringByAppendingString:@"api/car/add"];
        self.kGetCarURL = [kIPAdress stringByAppendingString:@"api/car/get_cars_for_user"];
        self.kUpdateCarURL = [kIPAdress stringByAppendingString:@"api/car/update"];
        self.kDeleteCarURL = [kIPAdress stringByAppendingString:@"api/car/delete"];
        self.kGetOrderURL = [kIPAdress stringByAppendingString:@"api/order/get_orders_for_user"];
        self.kRecallCarURL = [kIPAdress stringByAppendingString:@"api/order/recall_by_user"];
    }
    
    return self;
}

#pragma mark - Account

- (void)registerWithPhone:(NSString *)phone
                firstName:(NSString *)firstName
                 lastName:(NSString *)lastName
                 password:(NSString *)password
                  success:(void(^)(UserModel *userModel))successBlock
                     fail:(void(^)(NSError *error))failBlock;
{
    NSURL *url = [NSURL URLWithString:self.kRegisterURL];
    
    NSDictionary *parameters = @{@"phone": phone,
                                 @"firstName": firstName,
                                 @"lastName": lastName,
                                 @"password": password,
                                 @"passwordConfirm": password};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
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
                      UserModel *userModel = [[UserModel alloc] initWithDictionary:responseObject[@"extras"][@"userProfileModel"]
                                                                             error:&error];
                      if (error) {
                          failBlock(error);
                      } else {
                          successBlock(userModel);
                      }
                  } else {
                      // register failed
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

- (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
               success:(void(^)(UserModel *userModel))successBlock
                  fail:(void(^)(NSError *error))failBlock
{
    NSURL *url = [NSURL URLWithString:self.kLoginURL];
    NSDictionary *parameters = @{@"phone": phone,
                                 @"password": password};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:5];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
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
                      UserModel *userModel = [[UserModel alloc] initWithDictionary:responseObject[@"extras"][@"userProfileModel"]
                                                                             error:&error];
                      if (error) {
                          failBlock(error);
                      } else {
                          successBlock(userModel);
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
                       success:(void(^)(UserModel *userModel))successBlock
                          fail:(void(^)(NSError *error))failBlock
{
    NSURL *url = [NSURL URLWithString:self.kResetPasswordURL];
    NSDictionary *parameters = @{@"phone": phone,
                                 @"password": password};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:5];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
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
                      UserModel *userModel = [[UserModel alloc] initWithDictionary:responseObject[@"extras"][@"userProfileModel"]
                                                                             error:&error];
                      if (error) {
                          failBlock(error);
                      } else {
                          successBlock(userModel);
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

#pragma mark - Car

- (void)getCarsForUser:(UserModel *)userModel
               success:(void(^)(NSArray *cars))successBlock
                  fail:(void(^)(NSError *error))failBlock
{
    NSURL *url = [NSURL URLWithString:self.kGetCarURL];
    
    NSDictionary *parameters = @{@"identifier": userModel.identifier,
                                 @"phone": userModel.phone,
                                 @"firstName": userModel.firstName,
                                 @"lastName": userModel.lastName};
    
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
                      NSMutableArray *cars = [NSMutableArray new];
                      for (NSDictionary *dic in responseObject[@"extras"][@"cars"]) {
                          CarModel *carModel = [[CarModel alloc] initWithDictionary:dic error:&error];
                          [cars addObject:carModel];
                      }
                      
                      if (error) {
                          failBlock(error);
                      } else {
                          successBlock(cars);
                      }
                  } else {
                      // register failed
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

- (void)addACarWithCarModel:(CarModel *)carModel
                    success:(void(^)(CarModel *carModel))successBlock
                       fail:(void(^)(NSError *error))failBlock
{
    NSURL *url = [NSURL URLWithString:self.kAddCarURL];
    
    NSDictionary *parameters = @{@"userPhone": carModel.userPhone,
                                 @"plate": carModel.plate,
                                 @"brand": carModel.brand,
                                 @"color": carModel.color};
    
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
                      CarModel *carModel = [[CarModel alloc] initWithDictionary:responseObject[@"extras"][@"carProfileModel"]
                                                                             error:&error];
                      if (error) {
                          failBlock(error);
                      } else {
                          successBlock(carModel);
                      }
                  } else {
                      // register failed
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

- (void)updateACar:(CarModel *)oldCarModel
       newCarModel:(CarModel *)newCarModel
           success:(void(^)(CarModel *carModel))successBlock
              fail:(void(^)(NSError *error))failBlock
{
    NSURL *url = [NSURL URLWithString:self.kUpdateCarURL];
    
    NSDictionary *parameters = @{@"_id": oldCarModel._id,
                                 @"userPhone": newCarModel.userPhone,
                                 @"plate": newCarModel.plate,
                                 @"brand": newCarModel.brand,
                                 @"color": newCarModel.color};
    
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
                      CarModel *carModel = [[CarModel alloc] initWithDictionary:responseObject[@"extras"][@"carProfileModel"]
                                                                          error:&error];
                      if (error) {
                          failBlock(error);
                      } else {
                          successBlock(carModel);
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

- (void)deleteCarWithCarModel:(CarModel *)carModel
                      success:(void(^)(NSString *msg))successBlock
                         fail:(void(^)(NSError *error))failBlock
{
    NSURL *url = [NSURL URLWithString:self.kDeleteCarURL];
    
    NSDictionary *parameters = @{@"_id": carModel._id,
                                 @"userPhone": carModel.userPhone,
                                 @"plate": carModel.plate,
                                 @"brand": carModel.brand,
                                 @"color": carModel.color};
    
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
                      successBlock(responseObject[@"extras"][@"msg"]);
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

# pragma mark - Orders

- (void)getCurrentOrdersForUser:(UserModel *)userModel
                        success:(void (^)(NSArray *orders))successBlock
                           fail:(void (^)(NSError *error))failBlock {
    NSURL *url = [NSURL URLWithString:self.kGetOrderURL];
    
    NSDictionary *parameters = @{@"identifier": userModel.identifier,
                                 @"phone": userModel.phone,
                                 @"firstName": userModel.firstName,
                                 @"lastName": userModel.lastName};
    
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
                  failBlock(nil);
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failBlock(error);
          }];

}

- (void)recallACar:(OrderModel *)orderModel
           success:(void (^)(OrderModel *orderModel))successBlock
              fail:(void (^)(NSError *error))failBlock {
    NSURL *url = [NSURL URLWithString:self.kRecallCarURL];
    
    NSDictionary *parameters = @{@"_id": orderModel._id,
                                 @"userPhone": orderModel.userPhone,
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

- (AFHTTPSessionManager *)newManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return manager;
}

@end
