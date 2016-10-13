//
//  HttpClient.m
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "HttpClient.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const kRegisterURL = @"http://192.168.1.102:3001/api/account/register";
static NSString * const kLoginURL = @"http://192.168.1.102:3001/api/account/logon";

@implementation HttpClient

- (void)registerWithPhone:(NSString *)phone
                firstName:(NSString *)firstName
                 lastName:(NSString *)lastName
                 password:(NSString *)password
                  success:(void(^)(UserModel *userModel))successBlock
                     fail:(void(^)(NSError *error))failBlock;
{
    NSURL *url = [NSURL URLWithString:kRegisterURL];
    
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
    NSURL *url = [NSURL URLWithString:kLoginURL];
    NSDictionary *parameters = @{@"phone": phone,
                                 @"password": password};
    
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
                      // login failed
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

@end
