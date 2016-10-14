//
//  HttpClient.h
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

static NSString * const NetworkErrorDomain = @"com.luoxianyang";

typedef NS_ENUM(NSInteger, APIMessage){
    ACCOUNT_NOT_FOUND = 1,
    INVALID_PWD = 2,
    DB_ERROR = 3,
    NOT_FOUND = 4,
    ACCOUNT_ALREADY_EXISTS = 5,
    COULD_NOT_CREATE_USER = 6,
    PASSWORD_RESET_EXPIRED = 7,
    PASSWORD_RESET_HASH_MISMATCH = 8,
    PASSWORD_RESET_ACCOUNT_MISMATCH = 9,
    COULD_NOT_RESET_PASSWORD = 10,
    PASSWORD_CONFIRM_MISMATCH = 11,
    COULD_NOT_CREATE_SESSION = 12,
    COULD_NOT_CONNECT_TO_SERVER = 13,
    COULD_NOT_CREATE_CAR = 14,
};

@interface HttpClient : NSObject

- (id)init;

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

@end
