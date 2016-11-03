//
//  MapViewController.h
//  Valet_Parking
//
//  Created by Chester on 03/11/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol MapViewControllerDelegate

- (void)refreshPlace:(NSString *)place;

@end

@interface MapViewController : UIViewController

@property (assign, nonatomic) id <MapViewControllerDelegate> delegate;

- (void)setTitle:(NSString *)title
        Latitude:(CLLocationDegrees)latitude
       longitude:(CLLocationDegrees)longitude;

@end
