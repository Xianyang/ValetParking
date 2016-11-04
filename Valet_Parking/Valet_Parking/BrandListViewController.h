//
//  BrandListViewController.h
//  Valet_Parking
//
//  Created by Chester on 03/11/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

@protocol BrandListViewControllerDelegate

- (void)refreshBrand:(NSString *)brand;

@end

#import <UIKit/UIKit.h>

@interface BrandListViewController : UIViewController

@property (assign, nonatomic) id <BrandListViewControllerDelegate> delegate;

@end
