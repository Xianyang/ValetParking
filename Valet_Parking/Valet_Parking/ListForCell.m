//
//  ListForCell.m
//  Valet_Parking
//
//  Created by Chester on 03/11/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "ListForCell.h"

@implementation ListForCell

+ (NSArray *)placeArray {
    return @[@"California Tower", @"iSquare"];
}

+ (NSArray *)coordinatorArray {
    return @[@[@22.280908, @114.155501], @[@22.296935, @114.172049]];
}

+ (NSArray *)carBrandArray {
    return @[@[@"Audi", @"Audi", @"Audi", @"Audi", @"Audi"],
             @[@"BMW"],
             @[@"Casdf", @"Casdf", @"Casdf", @"Casdf", @"Casdf"],
             @[@"Dad", @"Dad", @"Dad", @"Dad", @"Dad", @"Dad", @"Dad", @"Dad", @"Dad", @"Dad"],
             @[@"Volvo"]];
}

@end
