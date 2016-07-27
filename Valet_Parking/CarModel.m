//
//  CarModel.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel

- (id)initWithPlate:(NSString *)plate brand:(NSString *)brand color:(NSString *)color {
    if (self = [super init]) {
        self.carNo = @"default";
        self.carPlate = plate;
        self.carBrand = brand;
        self.carColor = color;
    }
    
    return self;
}

@end
