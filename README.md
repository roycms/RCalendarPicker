
# RCalendarPicker

RCalendarPicker 日历控件 ，日历选择控件，日历，日期选择

# Preview

![预览](https://roycms.github.io/RCalendarPicker/RCalendarPicker/Resource/Preview.gif)

# Use

note: MainScreenWidth = 360  MainScreenHeight = 960
```
    RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:calendarPicker];
    calendarPicker.isZn = YES; //开启农历
    calendarPicker.today = [NSDate date]; //现在时间
    calendarPicker.date = calendarPicker.today; //选择时间
    calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
        NSLog(@"%d-%d-%d", (int)year,(int)month,(int)day);
    };
```

