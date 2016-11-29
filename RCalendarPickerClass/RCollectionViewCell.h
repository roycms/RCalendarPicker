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

/**
 日
 */
@property (nonatomic,strong)NSString *day;

/**
 农历 日
 */
@property (nonatomic,strong)NSString *znDay;

/**
 是否选中
 */
@property (nonatomic, assign)BOOL isSelected;
/**
 该天是否有绑定数据
 */
@property (nonatomic, assign)BOOL isDataSource;


/**
 是否是今天
 */
@property (nonatomic, assign)BOOL isToDay;

/**
  day uicolor
 */
@property (nonatomic, assign)UIColor *dayLabelTextColor;

/**
 日期方格的背景颜色
 */
@property (nonatomic, assign)UIColor *bgViewColor;
@end
