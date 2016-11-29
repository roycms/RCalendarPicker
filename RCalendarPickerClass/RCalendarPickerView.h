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
#define LANGUAGE(LANValue) NSLocalizedStringFromTable(LANValue,@"RCalendarPickerLanguage", nil)
#define MainScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define MainScreenWidth  ([UIScreen mainScreen].bounds.size.width)

@interface RCalendarPickerView : UIView<UICollectionViewDelegate , UICollectionViewDataSource,UIScrollViewDelegate>

/**
 选中时间
 */

@property (nonatomic,strong) NSDate *selectDate;
/**
 绑定数据的数据源
 */

@property (nonatomic,strong) NSArray *dataSource;
/**
 选择器的主题颜色
 */
@property (nonatomic,assign) UIColor *thisTheme;

/**
 是否开启农历
 */
@property (nonatomic,assign) BOOL isLunarCalendar;

/**
 选择日历时间成功后 complete block
 */
@property (nonatomic,copy) void(^complete)(NSInteger day, NSInteger month, NSInteger year ,NSDate *date);

/**
 取消按钮的block
 */

@property (nonatomic,copy) void(^cancel)();

/**
 关闭 销毁日历
 */
-(void)hide;

@end
