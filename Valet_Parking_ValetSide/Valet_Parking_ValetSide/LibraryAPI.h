//
//  LibraryAPI.h
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CarModel.h"
#import "ValetModel.h"

@interface LibraryAPI : NSObject

+ (LibraryAPI *)sharedInstance;

// Account
- (void)tryLoginWithLocalAccount:(void (^)(ValetModel *valetModel))successBlock
                            fail:(void (^)(NSError *error))failBlock;

- (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
               success:(void(^)(ValetModel *valetModel))successBlock
                  fail:(void(^)(NSError *error))failBlock;

- (void)resetPasswordWithPhone:(NSString *)phone
                      password:(NSString *)password
                       success:(void(^)(ValetModel *valetModel))successBlock
                          fail:(void(^)(NSError *error))failBlock;

- (void)logout;
- (ValetModel *)getCurrentValetModel;

@end
