//
//  ForgetPasswordViewController.h
//  ValetParking
//
//  Created by WangYili on 7/24/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValetModel.h"

@protocol ForgetPasswordViewControllerDelegate

- (void)cancelSetNewPassword;
- (void)resetSucceed:(ValetModel *)valetModel;

@end

@interface ForgetPasswordViewController : UIViewController

@property (assign, nonatomic) id <ForgetPasswordViewControllerDelegate> delegate;

@end
