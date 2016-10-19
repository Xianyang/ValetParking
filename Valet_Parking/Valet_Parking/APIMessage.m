//
//  APIMessage.m
//  Valet_Parking
//
//  Created by Chester on 14/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "APIMessage.h"

@implementation APIMessage

+ (APIMessage *)sharedInstance
{
    // 1
    static APIMessage *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[APIMessage alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

- (NSString *)messageToShowWithError:(NSInteger)errorMessage {
    NSString *messageToShow = @"fail";
    switch (errorMessage) {
        case ACCOUNT_NOT_FOUND:
            messageToShow = @"account not found";
            break;
        case INVALID_PWD:
            messageToShow = @"invalid password";
            break;
        case ACCOUNT_ALREADY_EXISTS:
            messageToShow = @"account already exist";
            break;
        case COULD_NOT_CREATE_CAR:
            messageToShow = @"could not add a car";
            break;
        case COULD_NOT_FIND_CAR:
            messageToShow = @"could not find this car";
            break;
        case CAR_ALREADY_EXISTS:
            messageToShow = @"you already have this car";
            break;
        case ORDER_ALREADY_EXISTS:
            messageToShow = @"you already recall this car";
            break;
        case COULD_NOT_UPDATE_ORDER:
            messageToShow = @"fail to update order";
            break;
        default:
            break;
    }
    
    return messageToShow;
}

@end
