//
//  LibraryAPI.m
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

// error domain 201: reduplicate car

#import "LibraryAPI.h"
#import "HttpClient.h"
#import "DataClient.h"

@interface LibraryAPI()
@property (strong, nonatomic) HttpClient *httpClient;
@property (strong, nonnull) DataClient *dataClient;
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
        self.dataClient = [[DataClient alloc] init];
    }
    
    return self;
}

# pragma mark - Log in and Sign up

- (BOOL)isUserLogin {
    return [self.dataClient isUserLogin];
}

- (void)tryLoginWithLocalAccount:(void (^)(ValetModel *valetModel))successBlock
                            fail:(void (^)(NSError *error))failBlock{
        
    NSString *userAccount = [self.dataClient getAccountInKeychain];
    NSString *userPassword = [self.dataClient getPasswordInKeychain];
    
    if ([userAccount isEqualToString:@""] || [userPassword isEqualToString:@""]) {
        failBlock(nil);
    }
    
    [self loginWithPhone:userAccount
                password:userPassword
                 success:^(ValetModel *valetModel) {
                     successBlock(valetModel);
                 }
                    fail:^(NSError *error) {
                        failBlock(error);
                    }];
}

- (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
               success:(void(^)(ValetModel *valetModel))successBlock
                  fail:(void(^)(NSError *error))failBlock
{
    [self.httpClient loginWithPhone:phone
                           password:password
                            success:^(ValetModel *valetModel) {
                                // save login seesion
                                [self.dataClient setLoginInShareApplication];
                                
                                // save the user's account and password
                                [self.dataClient saveAccountToKeychain:phone password:password];
                                
                                // save the user's profile
                                if ([self.dataClient saveValetModelToCoreData:valetModel]) {
                                    NSLog(@"%@ logs in", phone);
                                    successBlock(valetModel);
                                } else {
                                    failBlock(nil);
                                }
                            }
                               fail:^(NSError *error) {
                                   failBlock(error);
                               }];
}

- (void)resetPasswordWithPhone:(NSString *)phone
                      password:(NSString *)password
                       success:(void(^)(ValetModel *valetModel))successBlock
                          fail:(void(^)(NSError *error))failBlock
{
    [self.httpClient resetPasswordWithPhone:phone
                                   password:password
                                    success:^(ValetModel *valetModel) {
                                        // save login seesion
                                        [self.dataClient setLoginInShareApplication];
                                        
                                        // save the user's account and password
                                        [self.dataClient saveAccountToKeychain:phone password:password];
                                        
                                        // save the user's profile
                                        if ([self.dataClient saveValetModelToCoreData:valetModel]) {
                                            NSLog(@"%@ logs in", phone);
                                            successBlock(valetModel);
                                        } else {
                                            failBlock(nil);
                                        }
                                    }
                                       fail:^(NSError *error) {
                                           failBlock(error);
                                       }];
}

- (void)logout {
    // set log out session
    [self.dataClient setLogoutInShareApplication];
    
    // delete user mo
    [self.dataClient deleteValetMO];
    
    // delete key chain
    [self.dataClient saveAccountToKeychain:@"nil" password:@"nil"];
    
    NSLog(@"valet logs out");
}

- (ValetModel *)getCurrentValetModel {
    return [self.dataClient getCurrentValetModel];
}

#pragma mark - Order

- (void)getAllOpeningOrders:(ValetModel *)valetModel
                    success:(void (^)(NSArray *orders))successBlock
                       fail:(void (^)(NSError *error))failBlock{
    [self.httpClient getAllOpeningOrders:valetModel
                                 success:^(NSArray *orders) {
                                     successBlock(orders);
                                 }
                                    fail:^(NSError *error) {
                                        failBlock(error);
                                    }];
}

- (void)addOrderWithParkingPlace:(NSString *)parkingPlace
                       userPhone:(NSString *)userPhone
                        carPlate:(NSString *)carPlate
                         success:(void (^)(OrderModel *orderModel))successBlock
                            fail:(void (^)(NSError *error))failBlock {
    [self.httpClient addOrderWithParkingPlace:parkingPlace
                                    userPhone:userPhone
                                     carPlate:carPlate
                                      success:^(OrderModel *orderModel) {
                                          successBlock(orderModel);
                                      }
                                         fail:^(NSError *error) {
                                             failBlock(error);
                                         }];
}

- (void)endAnOrder:(OrderModel *)orderModel
           byValet:(ValetModel *)valetModel
           success:(void (^)(OrderModel *order))successBlock
              fail:(void (^)(NSError *error))failBlock{
    [self.httpClient endAnOrder:orderModel
                        byValet:valetModel
                        success:^(OrderModel *order) {
                            successBlock(orderModel);
                        }
                           fail:^(NSError *error) {
                               failBlock(error);
                           }];
}

@end
