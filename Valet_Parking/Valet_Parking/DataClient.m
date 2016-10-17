//
//  DataClient.m
//  Valet_Parking
//
//  Created by Chester on 15/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "DataClient.h"
#import "KeychainItemWrapper.h"

static NSString * const AccountNameInKeychain = @"Valet_Parking_User_Login";

@interface DataClient()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation DataClient

- (id)init {
    if (self == [super init]) {
        self.managedObjectContext = [self createManagementObjectContect];
    }
    
    return self;
}

#pragma mark - Management Object

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

- (BOOL)saveContext {
    NSError *error = nil;
//    if (![self.managedObjectContext save:&error]) {
//        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
//    }
    
    // if no error, then return NO. if error, return error
    return [self.managedObjectContext save:&error];
}

#pragma mark - Account

- (BOOL)saveUserModelToCoreData:(UserModel *)userModel {
    NSManagedObject *userMO = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                            inManagedObjectContext:self.managedObjectContext];
    [userMO setValue:userModel.identifier forKey:@"identifier"];
    [userMO setValue:userModel.firstName forKey:@"firstName"];
    [userMO setValue:userModel.lastName forKey:@"lastName"];
    [userMO setValue:userModel.phone forKey:@"phone"];
    
    return [self saveContext];
}

- (NSString *)getAccountInKeychain {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:AccountNameInKeychain
                                                                        accessGroup:nil];
    return [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
}

- (NSString *)getPasswordInKeychain {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:AccountNameInKeychain
                                                                        accessGroup:nil];
    return [keychain objectForKey:(__bridge id)(kSecValueData)];

}

- (void)saveAccountToKeychain:(NSString *)userAccount password:(NSString *)userPassword {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:AccountNameInKeychain
                                                                        accessGroup:nil];
    [keychain setObject:userAccount forKey:(__bridge id)(kSecAttrAccount)];
    [keychain setObject:userPassword forKey:(__bridge id)(kSecValueData)];
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

- (BOOL)deleteUserMO {
    NSLog(@"delete user mo");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray *userMOs = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:nil] copy];
    for (NSManagedObject *userMO in userMOs) {
        [self.managedObjectContext deleteObject:userMO];
    }
    
    return [self saveContext];
}

#pragma mark - Car

- (BOOL)deleteAllCarsInCoreData {
    NSLog(@"delete car mo");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Car"];
    NSArray *carMOs = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                error:nil] copy];
    for (NSManagedObject *carMO in carMOs) {
        [self.managedObjectContext deleteObject:carMO];
    }
    
    return [self saveContext];
}

// create a car locally
- (BOOL)saveCarToCoreData:(CarModel *)carModel{
    NSManagedObject *newCar = [NSEntityDescription insertNewObjectForEntityForName:@"Car"
                                                            inManagedObjectContext:self.managedObjectContext];
    
    [newCar setValue:carModel._id forKey:@"identifier"];
    [newCar setValue:carModel.userPhone forKey:@"userPhone"];
    [newCar setValue:carModel.plate forKey:@"plate"];
    [newCar setValue:carModel.brand forKey:@"brand"];
    [newCar setValue:carModel.color forKey:@"color"];
    
    return [self saveContext];
}

// update a car locally
- (BOOL)updateCarLocally:(CarModel *)oldCarModel newCarModel:(CarModel *)newCarModel {
    NSManagedObject *carMO = [self getCarMOWithIdentifier:oldCarModel._id];
    if (carMO) {
        [carMO setValue:newCarModel.plate forKey:@"plate"];
        [carMO setValue:newCarModel.brand forKey:@"brand"];
        [carMO setValue:newCarModel.color forKey:@"color"];
        
        return [self saveContext];
    } else {
        return NO;
    }
}

// delete a car locally
- (BOOL)deleteCarLocally:(CarModel *)carModel {
    NSManagedObject *carMO = [self getCarMOWithIdentifier:carModel._id];
    if (carMO) {
        [self.managedObjectContext deleteObject:carMO];
        return [self saveContext];
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
- (BOOL)checkRedundantCar:(CarModel *)carModel {
    NSArray *carModels = [self getAllCarModelsInCoreData];
    for (CarModel *savedCarModel in carModels) {
        if ([carModel isSamePlate:savedCarModel]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *)getAllCarModelsInCoreData {
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


@end
