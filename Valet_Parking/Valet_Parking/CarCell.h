//
//  CarCell.h
//  Valet_Parking
//
//  Created by WangYili on 7/27/16.
//  Copyright © 2016 xianyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *plateLabel;

@end
