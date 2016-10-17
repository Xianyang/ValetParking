//
//  OrderModel.h
//  Valet_Parking
//
//  Created by Chester on 17/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OrderModel : JSONModel

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *createAt;
@property (strong, nonatomic) NSString <Optional> *endAt;
@property (strong, nonatomic) NSString *parkingPlace;

@property (strong, nonatomic) NSString *userIdentifier;
@property (strong, nonatomic) NSString *userFirstName;
@property (strong, nonatomic) NSString *userLastName;
@property (strong, nonatomic) NSString *userPhone;
@property (strong, nonatomic) NSString *carIdentifier;
@property (strong, nonatomic) NSString *carPlate;


@end
