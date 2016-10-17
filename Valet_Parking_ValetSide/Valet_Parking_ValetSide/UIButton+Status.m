//
//  UIButton+Status.m
//  Valet_Parking
//
//  Created by Chester on 14/10/2016.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import "UIButton+Status.h"

@implementation UIButton (Status)

- (void)setEnableStatus {
    [self setEnabled:YES];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setDisableStatus {
    [self setEnabled:NO];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
}

@end
