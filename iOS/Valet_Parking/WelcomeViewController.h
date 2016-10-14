//
//  WelcomeViewController.h
//  ValetParking
//
//  Created by WangYili on 7/24/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WelcomeViewControllerDelegate

- (void)loginSuccessfully;

@end

@interface WelcomeViewController : UIViewController

@property (assign, nonatomic) id <WelcomeViewControllerDelegate> delegate;

@end
