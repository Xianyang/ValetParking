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
#import "UserModel.h"

@interface LibraryAPI : NSObject

+ (LibraryAPI *)sharedInstance;

- (NSManagedObjectContext *)getManagedObjectContext;

// log in and sign up
- (void)loginWithAccount:(NSString *)account password:(NSString *)password succeed:(void(^)(UserModel *userModel))successBlock fail:(void(^)(NSError *error))failBlock;
- (void)signUpWithPhone:(NSString *)phone firstName:(NSString *)firstName lastName:(NSString *)lastName password:(NSString *)password succeed:(void(^)(NSString *userIdentifier))successBlock fail:(void(^)(NSError *error))failBlock;
- (void)logout;
- (UserModel *)getCurrentUserModel;

// cars
- (void)addACar:(CarModel *)carModel succeed:(void(^)(NSString *message))successBlock fail:(void(^)(NSError *error))failBlock;
- (void)deleteCar:(CarModel *)carModel succeed:(void(^)(NSString *message))successBlock fail:(void(^)(NSError *error))failBlock;
- (CarModel *)getACar:(NSString *)carNO;
- (NSArray *)getAllCarModels;

// qr
- (UIImage *)qrImageForString:(NSString *)qrString withImageWidth:(CGFloat)width imageHeight:(CGFloat)height;

@end
