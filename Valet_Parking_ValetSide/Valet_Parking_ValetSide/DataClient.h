//
//  DataClient.h
//  Valet_Parking
//
//  Created by Chester on 15/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValetModel.h"
#import "CarModel.h"

@interface DataClient : NSObject

- (id)init;

// Account
- (BOOL)isUserLogin;
- (void)setLogoutInShareApplication;
- (void)setLoginInShareApplication;

- (NSString *)getAccountInKeychain;
- (NSString *)getPasswordInKeychain;
- (BOOL)saveValetModelToCoreData:(ValetModel *)valetModel;
- (void)saveAccountToKeychain:(NSString *)valetAccount password:(NSString *)valetPassword;
- (ValetModel *)getCurrentValetModel;
- (BOOL)deleteValetMO;

// Order

@end
