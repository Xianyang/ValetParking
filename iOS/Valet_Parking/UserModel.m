//
//  UserModel.m
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (id)initWithIdentifier:(NSString *)identifier firstName:(NSString *)firstName lastName:(NSString *)lastName phone:(NSString *)phone
{
    if (self = [super init]) {
        self.identifier = identifier;
        self.firstName = firstName;
        self.lastName = lastName;
        self.phone = phone;
    }
    
    return self;
}

@end
