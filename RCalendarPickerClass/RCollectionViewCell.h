//
//  RCollectionViewCell.h
//  RCalendarPicker
//
//  Created by roycms on 2016/11/16.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "RRGB.h"

@interface RCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)NSString *day;
@property (nonatomic, assign)BOOL isSelected;
@property (nonatomic, assign)UIColor *dayLabelTextColor;
@end
