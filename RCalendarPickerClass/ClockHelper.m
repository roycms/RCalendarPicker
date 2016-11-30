//
//  ClockHelper.m
//  RCalendarPicker
//
//  Created by roycms on 2016/11/23.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import "ClockHelper.h"

@implementation ClockHelper

+ (CGFloat)getAnglesWithThreePoint:(CGPoint)pointA
                            pointB:(CGPoint)pointB
                            pointC:(CGPoint)pointC {
    CGFloat x1    = pointA.x - pointB.x;
    CGFloat y1    = pointA.y - pointB.y;
    CGFloat x2    = pointC.x - pointB.x;
    CGFloat y2    = pointC.y - pointB.y;
    CGFloat x     = x1 * x2 + y1 * y2;
    CGFloat y     = x1 * y2 - x2 * y1;
    CGFloat angle = acos(x/sqrt(x*x+y*y));
    
    if (pointC.x < pointB.x) {
        //以所得角度最大为π，因工程中AB为竖直方向固定，需要得到顺时针角度，最大2π，故添加如下：
        angle = M_PI*2 - angle;
    }
    return angle;
}

+ (CGFloat)getAnglesWithHours:(CGFloat)hours{
    
    CGFloat angle = (int)hours*((M_PI*2)/12) - ((M_PI*2)/12)/60*((hours-(int)hours)*100);
    return angle;
}

+ (CGFloat)getAnglesWithHoursAndMinutes:(CGFloat)hours minutes:(CGFloat)minutes{
    
    CGFloat angle = (int)hours*((M_PI*2)/12) - ((M_PI*2)/12)/60*((hours-(int)hours)*100) + ((M_PI*2)/12/60)*minutes;
    return angle;
}

+ (CGFloat)getAnglesWithMinutes:(CGFloat)minutes{
    
    CGFloat angle = minutes*((M_PI*2)/60);
    return angle;
}

+ (CGFloat)getHoursWithAngles:(CGFloat)angle {
    
    CGFloat oneHours = ((M_PI*2)/12);
    return  (int)(angle / oneHours)==0?12:(int)(angle / oneHours);
}

+ (CGFloat)getMinutesWithAngles:(CGFloat)angle {
    
    CGFloat oneMinutes = ((M_PI*2)/60);
    return  (int)(angle / oneMinutes);
}

+ (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center Angle:(CGFloat)angel {
    
    CGFloat x = 105 * cosf(angel);
    CGFloat y = 105 * sinf(angel);
    return CGPointMake(center.x + x, center.y - y);
}

+ (float)getFloatDate:(CGFloat)hours minutes:(CGFloat)minutes{
    NSString *date;
    if(minutes < 10){
        date = [NSString stringWithFormat:@"%d.0%d",(int)hours,(int)minutes];
    }else{
        date = [NSString stringWithFormat:@"%d.%d",(int)hours,(int)minutes];
    }
    return fabsf([date floatValue]);
}

+ (BOOL)isPointInViewFor:(CGPoint)point view:(UIView *)view {
    CGFloat x     = view.frame.origin.x;
    CGFloat y     = view.frame.origin.y;
    CGFloat width = view.frame.size.width;
    CGFloat height = view.frame.size.height;
    
    if((point.x > x && point.x<(x+width))&& (point.y > y && point.y<(y+height)))
    {
        return YES;
    }
    else{
        
        return NO;
    }
}
@end
