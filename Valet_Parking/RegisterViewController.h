//
//  RegisterViewController.h
//  ValetParking
//
//  Created by WangYili on 7/24/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterViewControllerDelegate

- (void)cancelRegister;

@end

@interface RegisterViewController : UIViewController
@property (assign, nonatomic) id <RegisterViewControllerDelegate> delegate;


@end
