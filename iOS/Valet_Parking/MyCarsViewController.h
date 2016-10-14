//
//  MyCarsViewController.h
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"

@protocol MyCarsViewControllerDelegate

@optional
- (void)setChosenCarModel:(CarModel *)aCarModel;

@end

@interface MyCarsViewController : UIViewController

@property (assign, nonatomic) id <MyCarsViewControllerDelegate> delegate;

- (void)setEditable:(BOOL)editable chosenCar:(CarModel *)aCarModel;

@end
