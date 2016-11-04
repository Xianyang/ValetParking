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
    return @[@[@"Acura",
               @"Alfa-romeo",
               @"Aston-martin",
               @"Audi"],
             @[@"Bentley",
               @"BMW",
               @"Bugatti",
               @"Buick"],
             @[@"Cadillac",
               @"Chevrolet",
               @"Chrysler",
               @"Citroen"],
             @[@"Dodge"],
             @[@"Ferrari",
               @"Fiat",
               @"Ford"],
             @[@"Geely",
               @"General-Motors",
               @"GMC"],
             @[@"Honda",
               @"Hyundai"],
             @[@"Infiniti"],
             @[@"Jaguar-cars",
               @"Jeep"],
             @[@"Kia-Motors",
               @"Koenigsegg"],
             @[@"Lamborghini",
               @"Land-rover",
               @"Lexus"],
             @[@"Maserati",
               @"Mazda",
               @"Mclaren",
               @"Mercedes-Benz",
               @"Mini-Car", 
               @"Mitsubishi-Motors"],
             @[@"Nissan"],
             @[@"Pagani",
               @"Peugeot",
               @"Porsche"],
             @[@"RAM",
               @"Renault",
               @"Rolls-Royce"],
             @[@"Saab",
               @"Subaru",
               @"Suzuki"],
             @[@"TATA-Motors",
               @"Tesla-Motors",
               @"Toyota"],
             @[@"Volvo"],
             @[@"Wolksvagen"]];
}

+ (NSArray *)carColorArray {
    return @[@"Black", @"White", @"Grey", @"Red", @"Sivler", @"Blue", @"Brown", @"Yellow", @"Other"];
}

+ (NSArray *)carColorValueArray {
    return @[@[@0.0, @0.0, @0.0, @1.0], // black
             @[@1.0, @1.0, @1.0, @1.0], // white
             @[@0.5, @0.5, @0.5, @1.0], // grey
             @[@1.0, @0.0, @0.0, @1.0], // red
             @[@0.753, @0.753, @0.753, @1.0], // sivler
             @[@0.0, @0.0, @1.0, @1.0], // blue
             @[@0.6, @0.4, @0.2, @1.0], // brown
             @[@1.0, @1.0, @0.0, @1.0], // yellow
             @[@1.0, @1.0, @1.0, @1.0], // other
             ];
}

//@property(class, nonatomic, readonly) UIColor *blackColor;      // 0.0 white
//@property(class, nonatomic, readonly) UIColor *darkGrayColor;   // 0.333 white
//@property(class, nonatomic, readonly) UIColor *lightGrayColor;  // 0.667 white
//@property(class, nonatomic, readonly) UIColor *whiteColor;      // 1.0 white
//@property(class, nonatomic, readonly) UIColor *grayColor;       // 0.5 white
//@property(class, nonatomic, readonly) UIColor *redColor;        // 1.0, 0.0, 0.0 RGB
//@property(class, nonatomic, readonly) UIColor *greenColor;      // 0.0, 1.0, 0.0 RGB
//@property(class, nonatomic, readonly) UIColor *blueColor;       // 0.0, 0.0, 1.0 RGB
//@property(class, nonatomic, readonly) UIColor *cyanColor;       // 0.0, 1.0, 1.0 RGB
//@property(class, nonatomic, readonly) UIColor *yellowColor;     // 1.0, 1.0, 0.0 RGB
//@property(class, nonatomic, readonly) UIColor *magentaColor;    // 1.0, 0.0, 1.0 RGB
//@property(class, nonatomic, readonly) UIColor *orangeColor;     // 1.0, 0.5, 0.0 RGB
//@property(class, nonatomic, readonly) UIColor *purpleColor;     // 0.5, 0.0, 0.5 RGB
//@property(class, nonatomic, readonly) UIColor *brownColor;      // 0.6, 0.4, 0.2 RGB
//@property(class, nonatomic, readonly) UIColor *clearColor;      // 0.0 white, 0.0 alpha

@end
