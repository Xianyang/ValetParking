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

- (void)loginWithAccount:(NSString *)account password:(NSString *)password succeed:(void (^)(UserModel *))successBlock fail:(void (^)(NSError *))failBlock {
    // TODO communicate with server
    
    // temp code: if log in successfully, then do the following
    UserModel *returnUserModelFromServer = [self getFakeUserModel]; // will change to get from server
    [self saveUserModelToCoreData:returnUserModelFromServer];
    [self saveAccountToKeychain:account password:password];
    
    
    NSLog(@"%@ logs in", account);
    successBlock(returnUserModelFromServer);
}

- (void)signUpWithPhone:(NSString *)phone firstName:(NSString *)firstName lastName:(NSString *)lastName password:(NSString *)password succeed:(void (^)(NSString *))successBlock fail:(void (^)(NSError *))failBlock {
    // TODO communicate with server
    
    // temp code: if sign in succussfully, save user info locally
    NSString *returnIDFromServer = @"0001";
    UserModel *userModel = [[UserModel alloc] initWithIdentifier:returnIDFromServer
                                                       firstName:firstName
                                                        lastName:lastName
                                                           phone:phone];
    
    [self saveUserModelToCoreData:userModel];
    [self saveAccountToKeychain:phone password:password];

    NSLog(@"%@ signs up", phone);
    successBlock(returnIDFromServer);
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
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray *userMOs = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:nil] copy];
    for (NSManagedObject *userMO in userMOs) {
        [self.managedObjectContext deleteObject:userMO];
    }
    
    [self saveContext];
    
    // delete key chain
    [self saveAccountToKeychain:@"" password:@""];
    
    NSLog(@"user logs out");
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

- (NSArray *)transferToCarModel:(NSArray *)carMOs {
    NSMutableArray *carModels = [[NSMutableArray alloc] init];
    for (NSManagedObject *carMO in carMOs) {
        CarModel *carModel = [[CarModel alloc] initWithPlate:[carMO valueForKey:@"plate"]
                                                       brand:[carMO valueForKey:@"brand"]
                                                       color:[carMO valueForKey:@"color"]];
        [carModels addObject:carModel];
    }
    
    return [carModels copy];
}

- (NSArray *)getAllCarModels {
    NSArray *carMOs = [self getAllCarMOs];
    NSArray *carModels = [self transferToCarModel:carMOs];
    
    return carModels;
}

- (NSArray *)getAllCarMOs {
    // NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Car"];
    
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

- (BOOL)checkCarMO:(NSManagedObject *)carMO andModel:(CarModel *)carModel {
    if ([[carMO valueForKey:@"plate"] isEqualToString:carModel.carPlate] &&
        [[carMO valueForKey:@"brand"] isEqualToString:carModel.carBrand] &&
        [[carMO valueForKey:@"color"] isEqualToString:carModel.carColor]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)addACar:(CarModel *)carModel succeed:(void (^)(NSString *))successBlock fail:(void (^)(NSError *))failBlock {
    // Step0 - check redundancy
    NSArray *carModels = [self getAllCarModels];
    for (CarModel *savedCarModel in carModels) {
        if ([carModel isSameCar:savedCarModel]) {
            NSError *error = [NSError errorWithDomain:@"reduplicate car" code:201 userInfo:nil];
            failBlock(error);
            return;
        }
    }
    
    // Step1 - TODO upload this car to server
    
    // Step2 - create a new car object and save it locally
    NSManagedObject *newCar = [NSEntityDescription insertNewObjectForEntityForName:@"Car"
                                                            inManagedObjectContext:self.managedObjectContext];
    [newCar setValue:carModel.carPlate forKey:@"plate"];
    [newCar setValue:carModel.carBrand forKey:@"brand"];
    [newCar setValue:carModel.carColor forKey:@"color"];
    
    [self saveContext];
    
    successBlock([@"add a car successfully, plate is " stringByAppendingString:carModel.carPlate]);
}

- (void)deleteCar:(CarModel *)carModel succeed:(void (^)(NSString *))successBlock fail:(void (^)(NSError *))failBlock {
    // Step1 - TODO delete this car from server
    
    // Step2 - delete this car locally
    NSArray *carMOs = [self getAllCarMOs];
    for (NSManagedObject *carMO in carMOs) {
        if ([self checkCarMO:carMO andModel:carModel]) {
            [self.managedObjectContext deleteObject:carMO];
            [self saveContext];
            
            successBlock([@"delete a car successfully, plate is " stringByAppendingString:carModel.carPlate]);
            return;
        }
    }
    
    NSLog(@"delete fail, car not find");
}

// cars
- (void)saveACar:(CarModel *)carModel {
    // TODO connect to server and save the car to user info
    
    // save the car info locally
    
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
    NSData *stringData = [qrString dataUsingEncoding:NSISOLatin1StringEncoding
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
