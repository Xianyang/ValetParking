//
//  LibraryAPI.m
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

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

- (NSArray *)transferToCarModel:(NSArray *)cars {
    NSMutableArray *carModels = [[NSMutableArray alloc] init];
    for (NSManagedObject *carObject in cars) {
        CarModel *carModel = [[CarModel alloc] initWithPlate:[carObject valueForKey:@"plate"]
                                                       brand:[carObject valueForKey:@"brand"]
                                                       color:[carObject valueForKey:@"color"]];
        [carModels addObject:carModel];
    }
    
    return [carModels copy];
}

- (NSArray *)getAllCars {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Car"];
    NSArray *cars = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                          error:nil] mutableCopy];
    NSArray *carModels = [self transferToCarModel:cars];
    
    return carModels;
}

- (void)addACar:(CarModel *)carModel succeed:(void (^)(NSString *))successBlock fail:(void (^)(NSError *))failBlock {
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
    
    successBlock(@"add a car successfully");
}

// cars
- (void)saveACar:(CarModel *)carModel {
    // TODO connect to server and save the car to user info
    
    // save the car info locally
    
}



@end
