//
//  DateHelper.h
//  RCalendarPicker
//
//  Created by roycms on 2016/11/16.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject
+  (NSInteger)day:(NSDate *)date;
+  (NSInteger)month:(NSDate *)date;
+  (NSInteger)year:(NSDate *)date;
+  (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
+  (NSInteger)totaldaysInThisMonth:(NSDate *)date;
+  (NSInteger)totaldaysInMonth:(NSDate *)date;
+  (NSDate *)lastMonth:(NSDate *)date;
+ (NSDate*)nextMonth:(NSDate *)date;
+ (NSDate *)dateInYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day weekday:(NSInteger)weekday;
@end
