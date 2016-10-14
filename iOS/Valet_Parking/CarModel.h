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

- (id)initWithIdentifier:(NSString *)identifier userPhone:(NSString *)userPhone plate:(NSString *)plate brand:(NSString *)brand color:(NSString *)color;
// - (id)initWithPlate:(NSString *)plate brand:(NSString *)brand color:(NSString *)color;
- (BOOL)isSameCar:(CarModel *)car;
- (BOOL)isSamePlate:(CarModel *)car;

@property (strong, nonatomic) NSString <Optional> *identifier;
@property (strong, nonatomic) NSString *userPhone;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *plate;
@property (strong, nonatomic) NSString *color;

@end
