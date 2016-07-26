//
//  AddCarViewController.h
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCarViewControllerDelegate

- (void)cancelAddCar;
- (void)finishAddCar;



@end

@interface AddCarViewController : UIViewController

@property (assign, nonatomic) id <AddCarViewControllerDelegate> delegate;

@end
