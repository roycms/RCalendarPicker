//
//  ClockHelper.h
//  RCalendarPicker
//
//  Created by roycms on 2016/11/23.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ClockHelper : NSObject

/**
 三个点A、B、C，计算ㄥABC

 @param pointA A CGPoint
 @param pointB B CGPoint
 @param pointC C CGPoint
 @return ㄥABC Angles
 */
+ (CGFloat)getAnglesWithThreePoint:(CGPoint)pointA
                            pointB:(CGPoint)pointB
                            pointC:(CGPoint)pointC;

/**
 时间转角度 WithHour 整点

 @param hours hours description
 @return return value description
 */
+ (CGFloat)getAnglesWithHours:(CGFloat)hours;

/**
 时间转角度 WithHour 整点+ 分钟偏移

 @param hours hours description
 @param minutes minutes description
 @return return value description
 */
+ (CGFloat)getAnglesWithHoursAndMinutes:(CGFloat)hours minutes:(CGFloat)minutes;

/**
 时间转角度 WithMinutes

 @param minutes minutes description
 @return return value description
 */
+ (CGFloat)getAnglesWithMinutes:(CGFloat)minutes;

/**
 根据角度换算成 小时时间

 @param angle angle description
 @return return value description
 */
+ (CGFloat)getHoursWithAngles:(CGFloat)angle;

/**
 根据角度换算成 分钟时间

 @param angle angle description
 @return return value description
 */
+ (CGFloat)getMinutesWithAngles:(CGFloat)angle;


/**
 根据点和角度 获取转动后的 点位置

 @param center center description
 @param angel angel description
 @return return value description
 */
+ (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center Angle:(CGFloat)angel;

/**
 返回 float 形式的 时间   格式例  12.05

 @param hours hours description
 @param minutes minutes description
 @return return value description
 */
+ (float)getFloatDate:(CGFloat)hours minutes:(CGFloat)minutes;


/**
 判断一个点是否在 一个view内

 @param point 点
 @param view view
 @return return value description
 */
+ (BOOL)isPointInViewFor:(CGPoint)point view:(UIView *)view;
@end
