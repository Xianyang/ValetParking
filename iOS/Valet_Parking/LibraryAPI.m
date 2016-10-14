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
#import "UserModel.h"
#import "KeychainItemWrapper.h"

@interface LibraryAPI()

@property (strong, nonatomic) HttpClient *httpClient;
@property (strong, nonatomic) UserModel *userModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
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
        self.managedObjectContext = [self createManagementObjectContect];
    }
    
    return self;
}

// for core data
- (NSManagedObjectContext *)createManagementObjectContect {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (NSManagedObjectContext *)getManagedObjectContext {
    return self.managedObjectContext;
}

- (void)saveContext {
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
    }
}

# pragma mark - Log in and Sign up

- (UserModel *)getFakeUserModel {
    return [[UserModel alloc] initWithIdentifier:@"0001"
                                       firstName:@"xianyang"
                                        lastName:@"luo"
                                           phone:@"51709669"];
}

- (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
               success:(void(^)(UserModel *userModel))successBlock
                  fail:(void(^)(NSError *error))failBlock
{
    [self.httpClient loginWithPhone:phone
                           password:password
                            success:^(UserModel *userModel) {
                                // save the user's profile
                                [self saveUserModelToCoreData:userModel];
                                
                                // save the user's account and password
                                [self saveAccountToKeychain:phone password:password];
                                NSLog(@"%@ logs in", phone);
                                successBlock(userModel);
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
                                   // save the user's profile
                                   [self saveUserModelToCoreData:userModel];
                                   
                                   // save the user's account and password
                                   [self saveAccountToKeychain:phone password:password];
                                   NSLog(@"%@ signs up", phone);
                                   successBlock(userModel);
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
                                        // save the user's profile
                                        [self saveUserModelToCoreData:userModel];
                                        
                                        // save the user's account and password
                                        [self saveAccountToKeychain:phone password:password];
                                        NSLog(@"%@ logs in", phone);
                                        successBlock(userModel);
                                    }
                                       fail:^(NSError *error) {
                                           failBlock(error);
                                       }];
}

- (void)saveUserModelToCoreData:(UserModel *)userModel {
    NSManagedObject *userMO = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                            inManagedObjectContext:self.managedObjectContext];
    [userMO setValue:userModel.identifier forKey:@"identifier"];
    [userMO setValue:userModel.firstName forKey:@"firstName"];
    [userMO setValue:userModel.lastName forKey:@"lastName"];
    [userMO setValue:userModel.phone forKey:@"phone"];
    
    [self saveContext];
}

- (void)saveAccountToKeychain:(NSString *)userAccount password:(NSString *)userPassword {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"ValetLogin"
                                                                        accessGroup:nil];
    [keychain setObject:userAccount forKey:(__bridge id)(kSecAttrAccount)];
    [keychain setObject:userPassword forKey:(__bridge id)(kSecValueData)];
}

- (void)logout {
    // delete user mo
    NSLog(@"delete user mo");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray *userMOs = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:nil] copy];
    for (NSManagedObject *userMO in userMOs) {
        [self.managedObjectContext deleteObject:userMO];
    }
    
    [self saveContext];
    
    // delete car mo
    [self deleteAllCarsInCoreData];
    
    // delete key chain
    [self saveAccountToKeychain:@"" password:@""];
    
    NSLog(@"user logs out");
}

- (void)deleteAllCarsInCoreData {
    NSLog(@"delete car mo");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Car"];
    NSArray *carMOs = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                error:nil] copy];
    for (NSManagedObject *carMO in carMOs) {
        [self.managedObjectContext deleteObject:carMO];
    }
    
    [self saveContext];
}

- (UserModel *)getCurrentUserModel {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray *userMOs = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:nil] copy];
    
    NSManagedObject *userMO = [userMOs lastObject];
    UserModel *currentUserModel = [[UserModel alloc]
                                   initWithIdentifier:[userMO valueForKey:@"identifier"]
                                   firstName:[userMO valueForKey:@"firstName"]
                                   lastName:[userMO valueForKey:@"lastName"]
                                   phone:[userMO valueForKey:@"phone"]];
    return currentUserModel;
}


# pragma mark - Cars
// create a car
- (void)addACar:(CarModel *)carModel succeed:(void (^)(CarModel *))successBlock fail:(void (^)(NSError *))failBlock {
    // Step0 - check redundancy
    NSArray *carModels = [self getAllCarModels];
    for (CarModel *savedCarModel in carModels) {
        if ([carModel isSamePlate:savedCarModel]) {
            NSError *error = [NSError errorWithDomain:@"reduplicate car" code:201 userInfo:nil];
            failBlock(error);
            return;
        }
    }
    
    id me = self;
    // Step1 - upload this car to server
    [self.httpClient addACarWithCarModel:carModel
                                 success:^(CarModel *carModel) {
                                     // Step2 - get a new car object with identifier and save it locally
                                     [me saveCarToCoreData:carModel];
                                     successBlock(carModel);
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
                                    [me saveCarToCoreData:carModel];
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
    id me = self;
    
    // Step 1 - update the car on server
    [self.httpClient updateACar:oldCarModel
                    newCarModel:newCarModel
                        success:^(CarModel *carModel) {
                            // Step 2 - update the car locally
                            if ([me updateCarLocally:oldCarModel newCarModel:newCarModel]) {
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
                                       if ([me deleteCarLocally:carModel]) {
                                           successBlock([@"delete a car successfully, plate is " stringByAppendingString:carModel.plate]);
                                       }
                                   }
                                      fail:^(NSError *error) {
                                          failBlock(error);
                                      }];
}

// create a car locally
- (void)saveCarToCoreData:(CarModel *)carModel{
    NSManagedObject *newCar = [NSEntityDescription insertNewObjectForEntityForName:@"Car"
                                                            inManagedObjectContext:self.managedObjectContext];
    
    [newCar setValue:carModel._id forKey:@"identifier"];
    [newCar setValue:carModel.userPhone forKey:@"userPhone"];
    [newCar setValue:carModel.plate forKey:@"plate"];
    [newCar setValue:carModel.brand forKey:@"brand"];
    [newCar setValue:carModel.color forKey:@"color"];
    
    [self saveContext];
}

- (BOOL)updateCarLocally:(CarModel *)oldCarModel newCarModel:(CarModel *)newCarModel {
    NSManagedObject *carMO = [self getCarMOWithIdentifier:oldCarModel._id];
    if (carMO) {
        [carMO setValue:newCarModel.plate forKey:@"plate"];
        [carMO setValue:newCarModel.brand forKey:@"brand"];
        [carMO setValue:newCarModel.color forKey:@"color"];
        
        [self saveContext];
        return YES;
    } else {
        return NO;
    }
}

// delete a car locally
- (BOOL)deleteCarLocally:(CarModel *)carModel {
    NSManagedObject *carMO = [self getCarMOWithIdentifier:carModel._id];
    if (carMO) {
        [self.managedObjectContext deleteObject:carMO];
        [self saveContext];
        
        return YES;
    } else {
        return NO;
    }
}

- (NSManagedObject *)getCarMOWithIdentifier:(NSString *)identifier {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Car"
                                              inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *carMOs = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                error:&error] mutableCopy];
    
    if (!error) {
        NSManagedObject *carMO = [carMOs objectAtIndex:0];
        return carMO;
    } else {
        return nil;
    }

}

// read all car models locally
- (NSArray *)getAllCarModels {
    NSArray *carMOs = [self getAllCarMOs];
    NSArray *carModels = [self transferToCarModel:carMOs];
    
    return carModels;
}

- (NSArray *)getAllCarMOs {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Car"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"plate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *cars = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                              error:nil] mutableCopy];
    if (cars == nil) {
        // error
    }
    
    return cars;
}

- (NSArray *)transferToCarModel:(NSArray *)carMOs {
    NSMutableArray *carModels = [[NSMutableArray alloc] init];
    for (NSManagedObject *carMO in carMOs) {
        CarModel *carModel = [[CarModel alloc] initWithIdentifier:[carMO valueForKey:@"identifier"]
                                                        userPhone:[carMO valueForKey:@"userPhone"]
                                                            plate:[carMO valueForKey:@"plate"]
                                                            brand:[carMO valueForKey:@"brand"]
                                                            color:[carMO valueForKey:@"color"]];
        [carModels addObject:carModel];
    }
    
    return [carModels copy];
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
