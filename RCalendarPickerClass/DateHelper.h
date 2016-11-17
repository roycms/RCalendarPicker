//
//  DateHelper.h
//  RCalendarPicker
//
//  Created by roycms on 2016/11/16.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

/**
 返回 day

 @param date nsdate
 @return 返回 day
 */
+  (NSInteger)day:(NSDate *)date;

/**
 返回 月

 @param date nsdate
 @return 返回 month
 */
+  (NSInteger)month:(NSDate *)date;

/**
 返回 year

 @param date nsdate
 @return 返回 year
 */
+  (NSInteger)year:(NSDate *)date;

/**
 Description

 @param date date description
 @return return value description
 */
+  (NSInteger)weekday:(NSDate *)date;
/**
 Description

 @param date date description
 @return return value description
 */
+  (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;

/**
 Description

 @param date date description
 @return return value description
 */
+  (NSInteger)totaldaysInThisMonth:(NSDate *)date;

/**
 Description

 @param date date description
 @return return value description
 */
+  (NSInteger)totaldaysInMonth:(NSDate *)date;

/**
 lastMonth

 @param date lastMonth
 @return lastMonth
 */
+  (NSDate *)lastMonth:(NSDate *)date;

/**
 nextMonth
 
 @param date date description
 @return nextMonth
 */
+ (NSDate*)nextMonth:(NSDate *)date;


/**
 根据年月日 返回 NSDate
 
 @param year 年
 @param month 月
 @param day 日
 @return 返回 NSDate
 */
+ (NSDate *)dateInYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
@end
