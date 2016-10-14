//
//  EditItemViewController.h
//  Valet_Parking
//
//  Created by WangYili on 7/29/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditItemViewControllerDelegate

- (void)finishChangeText:(NSString *)newText;

@end

@interface EditItemViewController : UIViewController

@property (assign, nonatomic) id <EditItemViewControllerDelegate> delegate;
- (void)setNavTitle:(NSString *)title oldString:(NSString *)oldString;

@end
