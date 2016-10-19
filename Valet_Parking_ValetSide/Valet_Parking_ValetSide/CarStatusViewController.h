//
//  CarStatusViewController.h
//  Valet_Parking
//
//  Created by Chester on 19/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@protocol CarStatusViewControllerDelegate

@optional
- (void)recallSuccessfully;
- (void)endOrderSuccessfully;

@end

@interface CarStatusViewController : UIViewController

@property (assign, nonatomic) id <CarStatusViewControllerDelegate> delegate;

- (void)setAnOrder:(OrderModel *)order;

@end
