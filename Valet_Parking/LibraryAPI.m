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
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
    }
    
    successBlock([@"add a car successfully, plate is " stringByAppendingString:carModel.carPlate]);
}

- (void)deleteCar:(CarModel *)carModel succeed:(void (^)(NSString *))successBlock fail:(void (^)(NSError *))failBlock {
    // Step1 - TODO delete this car from server
    
    // Step2 - delete this car locally
    NSArray *carMOs = [self getAllCarMOs];
    for (NSManagedObject *carMO in carMOs) {
        if ([self checkCarMO:carMO andModel:carModel]) {
            [self.managedObjectContext deleteObject:carMO];
        }
    }
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
    }
    
    successBlock([@"delete a car successfully, plate is " stringByAppendingString:carModel.carPlate]);
}

// cars
- (void)saveACar:(CarModel *)carModel {
    // TODO connect to server and save the car to user info
    
    // save the car info locally
    
}



@end
