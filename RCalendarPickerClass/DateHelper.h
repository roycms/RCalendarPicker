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
 hours

 @param date date description
 @return return value description
 */
+  (NSInteger)hours:(NSDate *)date;

/**
 minute

 @param date date description
 @return return value description
 */
+  (NSInteger)minute:(NSDate *)date;
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

/**
 Description

 @param date date description
 @param hours hours description
 @param minutes minutes description
 @return return value description
 */
+ (NSDate *)dateInDate:(NSDate *)date Hours:(NSInteger)hours minutes:(NSInteger)minutes;
+ (NSDate *)dateInDate:(NSDate *)date Hours:(NSInteger)hours minutes:(NSInteger)minutes second:(NSInteger)second;
/**
 返回农历的月

 @param date date description
 @return return value description
 */
+ (NSString*)getChineseCalendarMonthsWithDate:(NSDate *)date;

/**
 返回农历的天

 @param date date description
 @return return value description
 */
+ (NSString*)getChineseCalendarDaysWithDate:(NSDate *)date;

/**
 返回农历的年

 @param date date description
 @return return value description
 */
+ (NSString*)getChineseCalendarYearsWithDate:(NSDate *)date;

/**
 返回农历的全部  例子 甲子 十一月 初三

 @param date date description
 @return return value description
 */
+ (NSString*)getChineseCalendarWithDate:(NSDate *)date;

/**
 根据字符串返回 nsdate
 str⏬                                    dateFormat⏬
 
 Tue May 31 18:20:45 +0800 2011  --->>>>  EEE MMM dd HH:mm:ss ZZZZ yyyy
 12/23/2015 12点08:03秒           --->>>>  MM/dd/yyyy HH点mm:ss秒
 2015-12-26 12:08:03             --->>>>  yyyy-MM-dd HH:mm:ss
 2015-12-26                      --->>>>  yyyy-MM-dd
 
 @param str str description
 @param dateFormat dateFormat description
 @return return value description
 */
+ (NSDate *)getDateForString:(NSString *)str dateFormat:(NSString *)dateFormat;
@end
