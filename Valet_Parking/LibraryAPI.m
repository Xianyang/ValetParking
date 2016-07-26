//
//  LibraryAPI.m
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "LibraryAPI.h"
#import "HttpClient.h"
#import "UserModel.h"

@interface LibraryAPI()

@property (strong, nonatomic) HttpClient *httpClient;
@property (strong, nonatomic) UserModel *userModel;

@end

@implementation LibraryAPI

+ (LibraryAPI *)sharedInstance
{
    // 1
    static LibraryAPI *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        self.httpClient = [[HttpClient alloc] init];
        self.userModel = [[UserModel alloc] init];
    }
    
    return self;
}

// cars
- (void)saveACar:(CarModel *)carModel {
    // TODO connect to server and save the car to user info
    
    // save the car info locally
    
}



@end
