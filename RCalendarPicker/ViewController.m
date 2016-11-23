//
//  ViewController.m
//  RCalendarPicker
//
//  Created by roycms on 2016/11/16.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import "ViewController.h"
#import "RCalendarPickerView.h"
#import "RClockPickerView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
//    [self.view addSubview:calendarPicker];
//    calendarPicker.isZn = YES; //开启农历
//    calendarPicker.today = [NSDate date]; //现在时间
//    calendarPicker.date = calendarPicker.today; //选择时间
//    calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
//        NSLog(@"%d-%d-%d", (int)year,(int)month,(int)day);
//    };
    
    
    

    
    /**
         _centers = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
         _clockRadius = 150;//表 半径
         _clockCalibrationRadius = 140;//刻度 半径
         _hoursLength = 60;//时针 长度
         _minutesLength = 80;//分针长度
     
     //简单的用法 默认值
     RClockPickerView *rClockPickerView = [[RClockPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
     */
    RClockPickerView *rClockPickerView = [[RClockPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)
                                                                    clockRadius:140
                                                         clockCalibrationRadius:130];
    rClockPickerView.date = [NSDate date];
    [self.view addSubview:rClockPickerView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
