//
//  RCalendarPickerView.h
//  RCalendarPicker
//
//  Created by roycms on 2016/11/16.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "RRGB.h"
#import "DateHelper.h"

#define MainScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define MainScreenWidth  ([UIScreen mainScreen].bounds.size.width)

@interface RCalendarPickerView : UIView<UICollectionViewDelegate , UICollectionViewDataSource,UIScrollViewDelegate>

/**
 选中时间
 */
@property (nonatomic,strong) NSDate *date;

/**
 今天
 */
@property (nonatomic,strong) NSDate *today;

@property (nonatomic,assign) UIColor *thisTheme;
/**
 是否开启农历
 */
@property (nonatomic,assign) BOOL isZn;

/**
 选择日历时间成功后 complete block
 */
@property (nonatomic,copy) void(^complete)(NSInteger day, NSInteger month, NSInteger year ,NSDate *date);

/**
 关闭 销毁日历
 */
-(void)hide;

@end
