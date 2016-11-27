![logo](https://roycms.github.io/RCalendarPicker/logo.png) 
# RCalendarPicker

RCalendarPicker Calendar calendar control, select control, calendar, date selection, the clock selection control. 日历控件 ，日历选择控件，日历，日期选择，时钟选择控件

[![CocoaPods](https://img.shields.io/badge/pod-0.0.1-red.svg)](http://cocoapods.org/?q=RCalendarPicker)
[![Packagist](https://img.shields.io/packagist/l/doctrine/orm.svg?maxAge=2592000?style=flat-square)](https://github.com/roycms/RCalendarPicker/blob/master/LICENSE)
[![email](https://img.shields.io/badge/%20email%20-%20roycms%40qq.com%20-yellowgreen.svg)](mailto:roycms@qq.com)
[![doc](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-DOC-orange.svg)](https://github.com/roycms/)


# Preview

![预览1](https://roycms.github.io/RCalendarPicker/RCalendarPicker/Resource/calendar.jpg) 
![预览1](https://roycms.github.io/RCalendarPicker/RCalendarPicker/Resource/clock.jpg) 
# cocoapods

```
pod 'RCalendarPicker'
```
# Run 

```
cd myfinder
git clone https://github.com/roycms/RCalendarPicker.git
cd RCalendarPicker
run pod install 
xcode open RCalendarPicker.xcworkspace
```

# Use Introduce file

Introduce the head file
```objective-c
#import "RCalendarPickerView.h" // The calendar 
#import "RClockPickerView.h" // A clock dial effect
#import "DateHelper.h" // Time processing with the help of the class
```

# calendar 

default: MainScreenWidth = 360  MainScreenHeight = 960
```objective-c
 RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
            calendarPicker.today = [NSDate date]; //现在时间
            calendarPicker.date = calendarPicker.today; //选择时间
            calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
                NSLog(@"%d-%d-%d", (int)year,(int)month,(int)day);
            };
            [self.view addSubview:calendarPicker];
```

# The lunar calendar
```objective-c
RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]init];
calendarPicker.isLunarCalendar = YES; //开启农历

```

# A clock dial effect
```objective-c
 RClockPickerView *rClockPickerView = [[RClockPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)
                                                                            clockRadius:140
                                                                 clockCalibrationRadius:130];
            rClockPickerView.date = [NSDate date];
            rClockPickerView.complete = ^(NSInteger hours, NSInteger minutes, NSInteger noon){
                NSLog(@"%d-%d-%d", (int)hours,(int)minutes,(int)noon);
                
            };
            [self.view addSubview:rClockPickerView];
```

# calendar + clock  use
```objective-c
RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
            calendarPicker.today = [NSDate date]; //现在时间
            calendarPicker.date = calendarPicker.today; //选择时间
            [self.view addSubview:calendarPicker];
            
            calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
                NSLog(@"%d-%d-%d", (int)year,(int)month,(int)day);
                
                RClockPickerView *rClockPickerView = [[RClockPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)
                                                                                clockRadius:140
                                                                     clockCalibrationRadius:130];
                rClockPickerView.date = [NSDate date];
                rClockPickerView.complete = ^(NSInteger hours, NSInteger minutes, NSInteger noon){
                    NSLog(@"%d-%d-%d", (int)hours,(int)minutes,(int)noon);
                    
                    NSDate *selectDate = [DateHelper dateInDate:date Hours:hours>12?hours%12:hours minutes:minutes];
                    
                    NSLog(@"selectDate: %@",selectDate);
                    
                };
                [self.view addSubview:rClockPickerView];
            };

```

# TODO

* 增加选择年月的切换形式

