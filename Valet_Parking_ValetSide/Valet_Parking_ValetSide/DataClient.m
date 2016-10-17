//
//  DataClient.m
//  Valet_Parking
//
//  Created by Chester on 15/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "DataClient.h"
#import <CoreData/CoreData.h>
#import "KeychainItemWrapper.h"

static NSString * const AccountNameInKeychain = @"Valet_Parking_Valet_Login";

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

- (BOOL)saveValetModelToCoreData:(ValetModel *)valetModel {
    NSManagedObject *valetMO = [NSEntityDescription insertNewObjectForEntityForName:@"Valet"
                                                            inManagedObjectContext:self.managedObjectContext];
    [valetMO setValue:valetModel.identifier forKey:@"identifier"];
    [valetMO setValue:valetModel.firstName forKey:@"firstName"];
    [valetMO setValue:valetModel.lastName forKey:@"lastName"];
    [valetMO setValue:valetModel.phone forKey:@"phone"];
    
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

- (void)saveAccountToKeychain:(NSString *)valetAccount password:(NSString *)valetPassword {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:AccountNameInKeychain
                                                                        accessGroup:nil];
    [keychain setObject:valetAccount forKey:(__bridge id)(kSecAttrAccount)];
    [keychain setObject:valetPassword forKey:(__bridge id)(kSecValueData)];
}

- (ValetModel *)getCurrentValetModel {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Valet"];
    NSArray *valetMOs = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:nil] copy];
    
    NSManagedObject *valetMO = [valetMOs lastObject];
    ValetModel *currentValetModel = [[ValetModel alloc]
                                   initWithIdentifier:[valetMO valueForKey:@"identifier"]
                                   firstName:[valetMO valueForKey:@"firstName"]
                                   lastName:[valetMO valueForKey:@"lastName"]
                                   phone:[valetMO valueForKey:@"phone"]];
    return currentValetModel;
}

- (BOOL)deleteValetMO {
    NSLog(@"delete valet mo");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Valet"];
    NSArray *valetMOs = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:nil] copy];
    for (NSManagedObject *valetMO in valetMOs) {
        [self.managedObjectContext deleteObject:valetMO];
    }
    
    return [self saveContext];
}


@end
