//
//  UserModel.h
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CarModel.h"

@interface UserModel : JSONModel

@property (strong, nonatomic) NSString *userNo;
@property (strong, nonatomic) NSString *userFirstName;
@property (strong, nonatomic) NSString *userLastName;
@property (strong, nonatomic) NSString *userNickName;
@property (strong, nonatomic) NSString *userPhone;
@property (strong, nonatomic) NSArray <CarModel> *userCars;


@end
