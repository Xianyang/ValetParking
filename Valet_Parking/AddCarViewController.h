//
//  AddCarViewController.h
//  ValetParking
//
//  Created by WangYili on 7/25/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"

@protocol AddCarViewControllerDelegate

- (void)cancelAddCar;
- (void)finishAddCar;


@end

@interface AddCarViewController : UIViewController
{
    BOOL _editMode;
    CarModel *_oldCar;
}

@property (assign, nonatomic) id <AddCarViewControllerDelegate> delegate;
- (void)enterEditModeWithCar:(CarModel *)car;

@end
