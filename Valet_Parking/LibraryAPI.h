//
//  LibraryAPI.h
//  ValetParking
//
//  Created by WangYili on 7/26/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarModel.h"

@interface LibraryAPI : NSObject

+ (LibraryAPI *)sharedInstance;


// cars
- (void)saveACar:(CarModel *)carModel;
- (CarModel *)getACar:(NSString *)carNO;
- (NSArray *)getAllCars;

@end
