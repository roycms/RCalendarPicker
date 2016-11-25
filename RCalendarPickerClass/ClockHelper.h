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
@end
