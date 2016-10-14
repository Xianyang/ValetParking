//
//  HttpClient.m
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "HttpClient.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const kIPAdress = @"http://147.8.234.140";

@interface HttpClient()

@property (strong, nonatomic) NSString *kRegisterURL;
@property (strong, nonatomic) NSString *kLoginURL;
@property (strong, nonatomic) NSString *kResetPasswordURL;
@property (strong, nonatomic) NSString *kAddCarURL;

@end

@implementation HttpClient

- (id)init {
    if (self == [super init]) {
        self.kRegisterURL = [kIPAdress stringByAppendingString:@":3001/api/account/register"];
        self.kLoginURL = [kIPAdress stringByAppendingString:@":3001/api/account/logon"];
        self.kResetPasswordURL = [kIPAdress stringByAppendingString:@":3001/api/account/set_new_password"];
        self.kAddCarURL = [kIPAdress stringByAppendingString:@":3001/api/car/add"];
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
                      APIMessage failMessage = (APIMessage)[responseObject[@"extras"][@"msg"] integerValue];
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
                      APIMessage failMessage = (APIMessage)[responseObject[@"extras"][@"msg"] integerValue];
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
                      APIMessage failMessage = (APIMessage)[responseObject[@"extras"][@"msg"] integerValue];
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
                      APIMessage failMessage = (APIMessage)[responseObject[@"extras"][@"msg"] integerValue];
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

- (AFHTTPSessionManager *)newManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return manager;
}

@end
