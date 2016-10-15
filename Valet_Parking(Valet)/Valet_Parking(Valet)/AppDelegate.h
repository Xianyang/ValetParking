//
//  AppDelegate.h
//  Valet_Parking(Valet)
//
//  Created by Chester on 15/10/2016.
//  Copyright © 2016 Chester. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

