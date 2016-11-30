//
//  RClockPickerView.h
//  RCalendarPicker
//
//  Created by roycms on 2016/11/18.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRGB.h"
#import "Masonry.h"
#import "DateHelper.h"

#define LANGUAGE(LANValue) NSLocalizedStringFromTable(LANValue,@"RCalendarPickerLanguage", nil)
#define MainScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define MainScreenWidth  ([UIScreen mainScreen].bounds.size.width)

@interface RClockPickerView : UIView

/**
 初始化

 @param frame frame description
 @param clockRadius 表盘 圆圈的半径
 @param clockCalibrationRadius 表盘刻度 圆圈的半径
 @return return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                  clockRadius:(CGFloat)clockRadius
       clockCalibrationRadius:(CGFloat)clockCalibrationRadius;


/**
 设置当前钟表指针指向的时间 默认不设置是当前的时间
 */
@property (nonatomic,assign)NSDate *date;

/**
 设置当前钟表指针指向的时间和上面的date一样只是格式不一样，两者重复设置后设置生效， 格式 12:01  或者 12.01
 */
@property (nonatomic,strong)NSString *dateString;

/**
 主题 颜色
 */
@property (nonatomic,assign) UIColor *thisTheme;

/**
 选择时间成功后 complete block
 */
@property (nonatomic,copy) void(^complete)(NSInteger hours, NSInteger minutes, NSInteger noon, float date);

/**
 取消按钮的block
 */
@property (nonatomic,copy) void(^cancel)();

/**
 关闭 销毁
 */
-(void)hide;
@end
