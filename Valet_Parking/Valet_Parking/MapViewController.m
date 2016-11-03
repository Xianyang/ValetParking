//
//  MapViewController.m
//  Valet_Parking
//
//  Created by Chester on 03/11/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "MapViewController.h"
@import GoogleMaps;

@interface MapViewController () {
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
    NSString *_title;
    
    BOOL _firstLocationUpdate;
    GMSMapView *_mapView;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _title;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_latitude
                                                            longitude:_longitude
                                                                 zoom:14];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    _mapView.settings.compassButton = YES;
    _mapView.settings.myLocationButton = YES;
    
    // Listen to the myLocation property of GMSMapView.
    [_mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        _mapView.myLocationEnabled = YES;
    });
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    marker.snippet = _title;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    // marker.icon = [UIImage imageNamed:@"valet-color"];
    marker.map = _mapView;
    
    self.view = _mapView;
}

- (IBAction)confirmBtnClicked:(id)sender {
    NSArray *vcs = [self.navigationController viewControllers];
    [self.delegate refreshPlace:_title];
    [self.navigationController popToViewController:vcs[1] animated:YES];
}


#pragma mark - KVO updates

- (void)dealloc {
    [_mapView removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    /*
    if (!_firstLocationUpdate) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        _firstLocationUpdate = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        _mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
    }*/
}

- (void)setTitle:(NSString *)title
        Latitude:(CLLocationDegrees)latitude
       longitude:(CLLocationDegrees)longitude {
    _title = title;
    _latitude = latitude;
    _longitude = longitude;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
