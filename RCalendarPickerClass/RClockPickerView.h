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

@interface RClockPickerView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                  clockRadius:(CGFloat)clockRadius
       clockCalibrationRadius:(CGFloat)clockCalibrationRadius;

@property (nonatomic,assign)NSDate *date;
@property (nonatomic,strong)NSString *dateString;
@property (nonatomic,assign) UIColor *thisTheme;
/**
 选择时间成功后 complete block
 */
@property (nonatomic,copy) void(^complete)(NSInteger hours, NSInteger minutes, NSInteger noon);

@property (nonatomic,copy) void(^cancel)();
/**
 关闭 销毁
 */
-(void)hide;
@end
