//
//  CarModel.h
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CarModel
@end

@interface CarModel : JSONModel

- (id)initWithPlate:(NSString *)plate brand:(NSString *)brand color:(NSString *)color;
- (BOOL)isSameCar:(CarModel *)car;

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *userIdentifier;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *plate;
@property (strong, nonatomic) NSString *color;

@end
