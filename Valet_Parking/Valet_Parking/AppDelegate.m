//
//  AppDelegate.m
//  Valet_Parking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "AppDelegate.h"
#import <SMS_SDK/SMSSDK.h>
@import GoogleMaps;
@import GooglePlaces;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [SMSSDK registerApp:@"f3fc6baa9ac4"
             withSecret:@"7f3dedcb36d92deebcb373af921d635a"];
    
//    [SMSSDK registerApp:@"158a3305baeaa"
//             withSecret:@"a905df802b5e5f23c4bf5707055ee030"];
    [GMSServices provideAPIKey:@"AIzaSyA0NPAaiCykYkF1h8Cvpa2hRtxKbmiHQwg"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyA0NPAaiCykYkF1h8Cvpa2hRtxKbmiHQwg"];
    
    [self createItemsWithIcons];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0]
                                              forKey:@"is_ValetParking_User_login"];
    
    // determine whether we've launched from a shortcut item or not
    UIApplicationShortcutItem *item = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    if (item) {
        NSLog(@"We've launched from shortcut item: %@", item.localizedTitle);
    } else {
        NSLog(@"We've launched properly.");
    }
    
    // have we launched Deep Link Level 1
    if ([item.type isEqualToString:@"com.luoxianyang.parkingNow"]) {
        [self launchParkingNow];
    }
    
    // have we launched Deep Link Level 2
    if ([item.type isEqualToString:@"com.luoxianyang.currentOrders"]) {
        [self launchCurrentOrder];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

# pragma mark - Springboard Shortcut Items (dynamic)

- (void)createItemsWithIcons {
    
    // icons with my own images
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"valet"];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"order"];
    
    // create several (dynamic) shortcut items
    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"com.luoxianyang.parkingNow" localizedTitle:@"Parking Now" localizedSubtitle:nil icon:icon1 userInfo:nil];
    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"com.luoxianyang.currentOrders" localizedTitle:@"Current Orders" localizedSubtitle:nil icon:icon2 userInfo:nil];
    
    // add all items to an array
    NSArray *items = @[item1, item2];
    
    // add this array to the potentially existing static UIApplicationShortcutItems
    NSArray *existingItems = [UIApplication sharedApplication].shortcutItems;
    if (!existingItems.count) {
        NSArray *updatedItems = [existingItems arrayByAddingObjectsFromArray:items];
        [UIApplication sharedApplication].shortcutItems = updatedItems;
    }
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    // react to shortcut item selections
    NSLog(@"A shortcut item was pressed. It was %@.", shortcutItem.localizedTitle);
    
    // have we launched Deep Link Level 1
    if ([shortcutItem.type isEqualToString:@"com.luoxianyang.parkingNow"]) {
        [self launchParkingNow];
    }
    
    // have we launched Deep Link Level 2
    if ([shortcutItem.type isEqualToString:@"com.luoxianyang.currentOrders"]) {
        [self launchCurrentOrder];
    }
}

- (void)launchParkingNow {
    // grab our storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // instantiate our tabbar controller
    UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTab"];
    
    // instantiate our navigation controller
    UINavigationController *controller = tabBarController.viewControllers[0];
    
    // instantiate second view controller
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ParkNowViewController"];
    
    // now push both controllers onto the stack
    [controller pushViewController:vc animated:NO];
    
    // make the nav controller visible
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
}

- (void)launchCurrentOrder {
    // grab our storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // instantiate our tabbar controller
    UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTab"];
    
    // instantiate our navigation controller
    UINavigationController *controller = tabBarController.viewControllers[0];
    
    // instantiate second view controller
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CurrentOrderViewController"];
    
    // now push both controllers onto the stack
    [controller pushViewController:vc animated:NO];
    
    // make the nav controller visible
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.luoxianyang.testcoredata" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Valet_Parking" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"testcoredata.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
