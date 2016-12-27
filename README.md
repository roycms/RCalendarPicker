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
> Pod installation failure  Please have a look at issues2 https://github.com/roycms/RCalendarPicker/issues/2

```
pod 'RCalendarPicker'
---or---
pod 'RCalendarPicker', :git => 'https://github.com/roycms/RCalendarPicker.git'
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
            calendarPicker.selectDate = [NSDate date]; //默认被选中时间
            calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
                NSLog(@"%d-%d-%d", (int)year,(int)month,(int)day);
            };
            [self.view addSubview:calendarPicker];
```

# The lunar calendar
Calendar lunar display forms
```objective-c
RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]init];
calendarPicker.isLunarCalendar = YES; //开启农历

```

# The calendar dataSource

The days in the calendar display when binding event data

![dataSource预览](https://roycms.github.io/RCalendarPicker/RCalendarPicker/Resource/dataSource.png)

```objective-c
RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]init];
calendarPicker.dataSource = self.dataSource;
```

self.dataSource is test data  for json file
```json
[{"date":"2016-12-1","value":1},
{"date":"2016-12-3","value":1},
{"date":"2016-12-7","value":1},
{"date":"2016-12-19","value":1},
{"date":"2016-12-29","value":1}]
```

# calendar Theme
Set the calendar theme colors

```objective-c
RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]init];
calendarPicker.thisTheme =[UIColor blackColor]; //设置主题颜色 缺省情况下随机显示
```

# A clock dial effect
The effect of a similar watches and clocks, can drag pointer to set a time

```objective-c
 RClockPickerView *rClockPickerView = [[RClockPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)
                                                                            clockRadius:140
                                                                 clockCalibrationRadius:130];
            rClockPickerView.date = [NSDate date];
            rClockPickerView.complete = ^(NSInteger hours, NSInteger minutes, NSInteger noon,float clockDate){
                NSLog(@"%d-%d-%d   float clockDate:  -%f", (int)hours,(int)minutes,(int)noon,clockDate);

            };
            [self.view addSubview:rClockPickerView];
```

# calendar + clock  use

To choose the calendar (date) (month) (year) and the vehicle to choose the combination use of the clock

```objective-c
RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
            calendarPicker.selectDate = [NSDate date]; //默认被选中时间
            [self.view addSubview:calendarPicker];

            calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
                NSLog(@"%d-%d-%d", (int)year,(int)month,(int)day);

                RClockPickerView *rClockPickerView = [[RClockPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)
                                                                                clockRadius:140
                                                                     clockCalibrationRadius:130];
                rClockPickerView.date = [NSDate date];
                rClockPickerView.complete = ^(NSInteger hours, NSInteger minutes, NSInteger noon,float clockDate){
                    NSLog(@"%d-%d-%d", (int)hours,(int)minutes,(int)noon);

                    NSDate *selectDate = [DateHelper dateInDate:date Hours:hours minutes:minutes];

                    NSLog(@"selectDate: %@",selectDate);

                };
                [self.view addSubview:rClockPickerView];
            };

```
# pop-up window Gestures conflict bug   
In the current UIView sliding gesture of conflicts between the pop-up window will open bugs can be directly in the new UIViewController   
```objective-c
            UIViewController *viewController = [[UIViewController alloc]init];
            
            RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
            calendarPicker.selectDate = [NSDate date]; //默认被选中时间
            [viewController.view addSubview:calendarPicker];
            calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
                NSLog(@"%d-%d-%d", (int)year,(int)month,(int)day);
                  [self.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:viewController animated:YES];
```

# TODO

* [x] 增加选择年月的切换形式
* [x] 定义日期的可选择范围
* [x] Tests

# You may encounter problems   
>[NSDate 8小时问题-没你想的那么简单！](http://www.jianshu.com/p/df41659b06a9)

