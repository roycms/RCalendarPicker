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
    
    RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]init];
    
    [self.view addSubview:calendarPicker];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year){
        
        NSLog(@"%i-%i-%i", (int)year,(int)month,(int)day);
    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
