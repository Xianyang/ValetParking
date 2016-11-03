//
//  MBProgressHUD+ValetShowAlert.m
//  Valet_Parking
//
//  Created by Chester on 20/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "MBProgressHUD+ValetShowAlert.h"
#import "APIMessage.h"

@implementation MBProgressHUD (ValetShowAlert)

- (void)showErrorMessage:(NSError *)error {
    self.mode = MBProgressHUDModeText;
    self.label.text = [[APIMessage sharedInstance] messageToShowWithError:error.code];
    [self hideAnimated:YES afterDelay:2];
}

@end
