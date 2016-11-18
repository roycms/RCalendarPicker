//
//  ViewController.m
//  RCalendarPicker
//
//  Created by roycms on 2016/11/16.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import "ViewController.h"
#import "RCalendarPickerView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:calendarPicker];
    calendarPicker.isZn = YES; //开启农历
    calendarPicker.today = [NSDate date]; //现在时间
    calendarPicker.date = calendarPicker.today; //选择时间
    calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
        NSLog(@"%d-%d-%d", (int)year,(int)month,(int)day);
    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
