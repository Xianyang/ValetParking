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

@property (strong, nonatomic) NSString *carNo;
@property (strong, nonatomic) NSString *carBrand;
@property (strong, nonatomic) NSString *carPlate;
@property (strong, nonatomic) NSString *carColor;

@end
