//
//  ClockHelper.m
//  RCalendarPicker
//
//  Created by roycms on 2016/11/23.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import "ClockHelper.h"

@implementation ClockHelper
//三个点A、B、C，计算ㄥABC
+ (CGFloat)getAnglesWithThreePoint:(CGPoint)pointA
                            pointB:(CGPoint)pointB
                            pointC:(CGPoint)pointC
{
    CGFloat x1 = pointA.x - pointB.x;
    CGFloat y1 = pointA.y - pointB.y;
    CGFloat x2 = pointC.x - pointB.x;
    CGFloat y2 = pointC.y - pointB.y;
    CGFloat x = x1 * x2 + y1 * y2;
    CGFloat y = x1 * y2 - x2 * y1;
    CGFloat angle = acos(x/sqrt(x*x+y*y));
    
    //    NSLog(@"angle ---- %f",angle);
    if (pointC.x < pointB.x) {
        //以所得角度最大为π，因工程中AB为竖直方向固定，需要得到顺时针角度，最大2π，故添加如下：
        angle = M_PI*2 - angle;
    }
    return angle;
}

//时间转角度 WithHour 整点
+ (CGFloat)getAnglesWithHours:(CGFloat)hours{
    
    CGFloat angle = (int)hours*((M_PI*2)/12) - ((M_PI*2)/12)/60*((hours-(int)hours)*100);
    return angle;
}
//时间转角度 WithHour 整点+ 分钟偏移
+ (CGFloat)getAnglesWithHoursAndMinutes:(CGFloat)hours minutes:(CGFloat)minutes{
    
    CGFloat angle = (int)hours*((M_PI*2)/12) - ((M_PI*2)/12)/60*((hours-(int)hours)*100) + ((M_PI*2)/12/60)*minutes;
    return angle;
}
//时间转角度 WithMinutes
+ (CGFloat)getAnglesWithMinutes:(CGFloat)minutes{
    
    CGFloat angle = minutes*((M_PI*2)/60);
    return angle;
}
//根据角度换算成 小时时间
+ (CGFloat)getHoursWithAngles:(CGFloat)angle {
    
    CGFloat oneHours = ((M_PI*2)/12);
    return  (int)(angle / oneHours)==0?12:(int)(angle / oneHours);
}

//根据角度换算成 分钟时间
+ (CGFloat)getMinutesWithAngles:(CGFloat)angle {
    
    CGFloat oneMinutes = ((M_PI*2)/60);
    return  (int)(angle / oneMinutes);
}
//默认计算半径 105
+ (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center Angle:(CGFloat)angel {
    
    CGFloat x = 105 * cosf(angel);
    CGFloat y = 105 * sinf(angel);
    return CGPointMake(center.x + x, center.y - y);
}
@end
