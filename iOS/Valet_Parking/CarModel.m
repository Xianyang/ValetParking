//
//  CarModel.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel

- (id)initWithIdentifier:(NSString *)identifier
               userPhone:(NSString *)userPhone
                   plate:(NSString *)plate
                   brand:(NSString *)brand
                   color:(NSString *)color
{
    if (self = [super init]) {
        self.identifier = identifier;
        self.userPhone = userPhone;
        self.plate = plate;
        self.brand = brand;
        self.color = color;
    }
    
    return self;
}

//- (id)initWithPlate:(NSString *)plate brand:(NSString *)brand color:(NSString *)color {
//    if (self = [super init]) {
//        self.identifier = @"default";
//        self.userPhone = @"default";
//        self.plate = plate;
//        self.brand = brand;
//        self.color = color;
//    }
//    
//    return self;
//}

- (BOOL)isSameCar:(CarModel *)car {
    if ([self.plate isEqualToString:car.plate] &&
        [self.brand isEqualToString:car.brand] &&
        [self.color isEqualToString:car.color]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isSamePlate:(CarModel *)car {
    return [self.plate isEqualToString:car.plate]?YES:NO;
}

@end
