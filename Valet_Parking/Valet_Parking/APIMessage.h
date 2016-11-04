//
//  APIMessage.h
//  Valet_Parking
//
//  Created by Chester on 14/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ServerErrorMessage){
    ACCOUNT_NOT_FOUND = 1,
    INVALID_PWD = 2,
    DB_ERROR = 3,
    VALET_NOT_FOUND = 4,
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
    COULD_NOT_FIND_CAR = 15,
    ORDER_ALREADY_EXISTS = 16,
    ORDER_ALREADY_RECALLED = 17,
    COULD_NOT_UPDATE_ORDER = 18,
    COULD_NOT_FIND_ORDER = 19,
};

typedef NS_ENUM(NSInteger, LocalErrorMessage){
    CAR_ALREADY_EXISTS = 201,
    VERIFY_CODE_FAIL = 202,
};

@interface APIMessage : NSObject

+ (APIMessage *)sharedInstance;
- (NSString *)messageToShowWithError:(NSInteger)errorMessage;

@end
