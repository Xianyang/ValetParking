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

- (id)initWithIdentifier:(NSString *)identifier firstName:(NSString *)firstName lastName:(NSString *)lastName phone:(NSString *)phone;

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phone;



@end
