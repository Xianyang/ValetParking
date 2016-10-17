//
//  OrderModel.m
//  Valet_Parking
//
//  Created by Chester on 17/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

- (id)initWithParkingPlace:(NSString *)parkingPlace
            userIdentifier:(NSString *)userIdentifier
             userFirstName:(NSString *)userFirstName
              userLastName:(NSString *)userLastName
                 userPhone:(NSString *)userPhone
             carIdentifier:(NSString *)carIdentifier
                  carPlate:(NSString *)carPlate
                  carBrand:(NSString *)carBrand
                  carColor:(NSString *)carColor {
    if (self == [super init]) {
        self.identifier = @"";
        self.createAt = @"";
        self.userRequestAt = @"";
        self.endAt = @"";
        self.parkingPlace = parkingPlace;
        self.userIdentifier = userIdentifier;
        self.userFirstName = userFirstName;
        self.userLastName = userLastName;
        self.userPhone = userPhone;
        self.carIdentifier = carIdentifier;
        self.carPlate = carPlate;
        self.carBrand = carBrand;
        self.carColor = carColor;
    }
    
    return self;
}

- (NSDictionary *)createTicketDic {
    return @{@"parkingPlace":self.parkingPlace,
             @"userPhone":self.userPhone,
             @"carPlate":self.carPlate};
}

@end
