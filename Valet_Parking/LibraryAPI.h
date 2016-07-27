//
//  LibraryAPI.h
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CarModel.h"

@interface LibraryAPI : NSObject

+ (LibraryAPI *)sharedInstance;

- (NSManagedObjectContext *)getManagedObjectContext;


// cars
- (void)addACar:(CarModel *)carModel succeed:(void(^)(NSString *message))successBlock fail:(void(^)(NSError *error))failBlock;
- (CarModel *)getACar:(NSString *)carNO;
- (NSArray *)getAllCars;

@end
