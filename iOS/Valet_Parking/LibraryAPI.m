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
#import "UserModel.h"
#import "KeychainItemWrapper.h"

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

- (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
               success:(void(^)(UserModel *userModel))successBlock
                  fail:(void(^)(NSError *error))failBlock
{
    [self.httpClient loginWithPhone:phone
                           password:password
                            success:^(UserModel *userModel) {
                                // save the user's account and password
                                [self.dataClient saveAccountToKeychain:phone password:password];
                                
                                // save the user's profile
                                if ([self.dataClient saveUserModelToCoreData:userModel]) {
                                    NSLog(@"%@ logs in", phone);
                                    successBlock(userModel);
                                } else {
                                    failBlock(nil);
                                }
                            }
                               fail:^(NSError *error) {
                                   failBlock(error);
                               }];
}

- (void)registerWithPhone:(NSString *)phone
                firstName:(NSString *)firstName
                 lastName:(NSString *)lastName
                 password:(NSString *)password
                  success:(void(^)(UserModel *userModel))successBlock
                     fail:(void(^)(NSError *error))failBlock;
{
    // TODO communicate with server
    [self.httpClient registerWithPhone:phone
                             firstName:firstName
                              lastName:lastName
                              password:password
                               success:^(UserModel *userModel) {
                                   // save the user's account and password
                                   [self.dataClient saveAccountToKeychain:phone password:password];
                                   
                                   // save the user's profile
                                   if ([self.dataClient saveUserModelToCoreData:userModel]) {
                                       NSLog(@"%@ logs in", phone);
                                       successBlock(userModel);
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
                       success:(void(^)(UserModel *userModel))successBlock
                          fail:(void(^)(NSError *error))failBlock
{
    [self.httpClient resetPasswordWithPhone:phone
                                   password:password
                                    success:^(UserModel *userModel) {
                                        // save the user's account and password
                                        [self.dataClient saveAccountToKeychain:phone password:password];
                                        
                                        // save the user's profile
                                        if ([self.dataClient saveUserModelToCoreData:userModel]) {
                                            NSLog(@"%@ logs in", phone);
                                            successBlock(userModel);
                                        } else {
                                            failBlock(nil);
                                        }
                                    }
                                       fail:^(NSError *error) {
                                           failBlock(error);
                                       }];
}

- (void)logout {
    // delete user mo
    [self.dataClient deleteUserMO];
    
    // delete car mo
    [self.dataClient deleteAllCarsInCoreData];
    
    // delete key chain
    [self.dataClient saveAccountToKeychain:@"" password:@""];
    
    NSLog(@"user logs out");
}

- (UserModel *)getCurrentUserModel {
    return [self.dataClient getCurrentUserModel];
}

# pragma mark - Cars
// create a car
- (void)addACar:(CarModel *)carModel
        succeed:(void (^)(CarModel *))successBlock
           fail:(void (^)(NSError *))failBlock {
    // Step0 - check redundancy
    if ([self.dataClient checkRedundantCar:carModel]) {
        NSError *error = [NSError errorWithDomain:@"reduplicate car" code:CAR_ALREADY_EXISTS userInfo:nil];
        failBlock(error);
        return;
    }

    id me = self;
    // Step1 - upload this car to server
    [self.httpClient addACarWithCarModel:carModel
                                 success:^(CarModel *carModel) {
                                     // Step2 - get a new car object with identifier and save it locally
                                     if ([[me dataClient] saveCarToCoreData:carModel]) {
                                         successBlock(carModel);
                                     } else {
                                         failBlock(nil);
                                     }
                                     
                                 }
                                    fail:^(NSError *error) {
                                        failBlock(error);
                                    }];
}

// read all cars
- (void)getCarsForUser:(UserModel *)userModel
               success:(void(^)(NSArray *cars))successBlock
                  fail:(void(^)(NSError *error))failBlock
{
    id me = self;
    
    // Step1 - get cars from server
    [self.httpClient getCarsForUser:userModel
                            success:^(NSArray *cars) {
                                // Step2 - save cars locally
                                for (CarModel *carModel in cars) {
                                    [[me dataClient] saveCarToCoreData:carModel];
                                }
                                
                                successBlock(cars);
                            }
                               fail:^(NSError *error) {
                                   failBlock(error);
                               }];
}

// update a car
- (void)updateACar:(CarModel *)oldCarModel
       newCarModel:(CarModel *)newCarModel
           success:(void(^)(CarModel *carModel))successBlock
              fail:(void(^)(NSError *error))failBlock {
    // Step0 - check redundancy
    if ([self.dataClient checkRedundantCar:newCarModel]) {
        NSError *error = [NSError errorWithDomain:@"reduplicate car" code:CAR_ALREADY_EXISTS userInfo:nil];
        failBlock(error);
        return;
    }
    
    id me = self;
    
    // Step 1 - update the car on server
    [self.httpClient updateACar:oldCarModel
                    newCarModel:newCarModel
                        success:^(CarModel *carModel) {
                            // Step 2 - update the car locally
                            if ([[me dataClient] updateCarLocally:oldCarModel newCarModel:newCarModel]) {
                                successBlock(carModel);
                            } else {
                                failBlock(nil);
                            }
                        }
                           fail:^(NSError *error) {
                               failBlock(error);
                           }];
}

// delete a car
- (void)deleteCarWithCarModel:(CarModel *)carModel
                      success:(void(^)(NSString *msg))successBlock
                         fail:(void(^)(NSError *error))failBlock {
    id me = self;
    
    // Step1 -  delete this car from server
    [self.httpClient deleteCarWithCarModel:carModel
                                   success:^(NSString *msg) {
                                       // Step2 - delete this car locally
                                       if ([[me dataClient] deleteCarLocally:carModel]) {
                                           successBlock([@"delete a car successfully, plate is " stringByAppendingString:carModel.plate]);
                                       } else {
                                           failBlock(nil);
                                       }
                                   }
                                      fail:^(NSError *error) {
                                          failBlock(error);
                                      }];
}

// read all car models locally
- (NSArray *)getAllCarModelsInCoreData {
    return [self.dataClient getAllCarModelsInCoreData];
}

// delete all car models locally
- (void)deleteAllCarsInCoreData {
    [self.dataClient deleteAllCarsInCoreData];
}

# pragma mark - QR 
- (UIImage *)qrImageForString:(NSString *)qrString withImageWidth:(CGFloat)width imageHeight:(CGFloat)height
{
    CIImage *qrCIImage = [self qrCIImageForString:qrString];
    CGFloat scaleX = width / qrCIImage.extent.size.width;
    CGFloat scaleY = height / qrCIImage.extent.size.height;
    CIImage *transformedImage = [qrCIImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

- (CIImage *)qrCIImageForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding
                                allowLossyConversion:NO];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}



@end
