//
//  ColorListViewController.h
//  Valet_Parking
//
//  Created by Chester on 03/11/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorListViewControllerDelegate

- (void)refreshColor:(NSString *)color;

@end

@interface ColorListViewController : UIViewController

@property (assign, nonatomic) id <ColorListViewControllerDelegate> delegate;

@end
