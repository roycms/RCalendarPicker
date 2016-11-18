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
@property (nonatomic,strong)NSString *znDay;
@property (nonatomic, assign)BOOL isSelected;
@property (nonatomic, assign)BOOL isToDay;
@property (nonatomic, assign)UIColor *dayLabelTextColor;
@property (nonatomic, assign)UIColor *bgViewColor;
@end
