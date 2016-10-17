//
//  OrderModel.h
//  Valet_Parking
//
//  Created by Chester on 17/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OrderModel : JSONModel

- (id)initWithParkingPlace:(NSString *)parkingPlace
            userIdentifier:(NSString *)userIdentifier
             userFirstName:(NSString *)userFirstName
              userLastName:(NSString *)userLastName
                 userPhone:(NSString *)userPhone
             carIdentifier:(NSString *)carIdentifier
                  carPlate:(NSString *)carPlate
                  carBrand:(NSString *)carBrand
                  carColor:(NSString *)carColor;

- (NSDictionary *)createTicketDic;

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *createAt;
@property (strong, nonatomic) NSString <Optional> *userRequestAt;
@property (strong, nonatomic) NSString <Optional> *endAt;


@property (strong, nonatomic) NSString *parkingPlace;

@property (strong, nonatomic) NSString *userIdentifier;
@property (strong, nonatomic) NSString *userFirstName;
@property (strong, nonatomic) NSString *userLastName;
@property (strong, nonatomic) NSString *userPhone;

@property (strong, nonatomic) NSString *carIdentifier;
@property (strong, nonatomic) NSString *carPlate;
@property (strong, nonatomic) NSString *carBrand;
@property (strong, nonatomic) NSString *carColor;


@end
