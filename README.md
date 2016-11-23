
# RCalendarPicker

RCalendarPicker 日历控件 ，日历选择控件，日历，日期选择

# Preview

![预览1](https://roycms.github.io/RCalendarPicker/RCalendarPicker/Resource/calendar.jpg)
![预览2](https://roycms.github.io/RCalendarPicker/RCalendarPicker/Resource/clock.jpg)


# Use

note: MainScreenWidth = 360  MainScreenHeight = 960
```
 RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
            calendarPicker.today = [NSDate date]; //现在时间
            calendarPicker.date = calendarPicker.today; //选择时间
            calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
                NSLog(@"%d-%d-%d", (int)year,(int)month,(int)day);
            };
            [self.view addSubview:calendarPicker];
```

农历
```
RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
            calendarPicker.isZn = YES; //开启农历
            calendarPicker.today = [NSDate date]; //现在时间
            calendarPicker.date = calendarPicker.today; //选择时间
            calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
                NSLog(@"%d-%d-%d", (int)year,(int)month,(int)day);
            };
            [self.view addSubview:calendarPicker];
```

钟表
```
 RClockPickerView *rClockPickerView = [[RClockPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)
                                                                            clockRadius:140
                                                                 clockCalibrationRadius:130];
            rClockPickerView.date = [NSDate date];
            rClockPickerView.complete = ^(NSInteger hours, NSInteger minutes, NSInteger noon){
                NSLog(@"%d-%d-%d", (int)hours,(int)minutes,(int)noon);
                
            };
            [self.view addSubview:rClockPickerView];
```

日期+钟表
```
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

* 增加年月日时分秒联动选择成功后返回nsdate
* 增加上下午的判断和参数处理
* 增加主题定义
* 增加国际化语言支持
* 增加选择年月的切换形式

