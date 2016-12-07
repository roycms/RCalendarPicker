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
#import "DateHelper.h"

@interface ViewController ()
@property(nonatomic,strong)NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self UI];
    [self buttonUI];
    
    
    // 读取 date.json 数据
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"date" ofType:@"json"];
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    self.dataSource = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
    
}

-(void)UI{
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"bg.jpg"];
    UIImageView *logoImageView = [[UIImageView alloc]init];
    logoImageView.image = [UIImage imageNamed:@"logo.png"];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    UILabel *label =[[UILabel alloc]init];
    label.text =@"RCalendarPicker 时间选择控件";
    [label setFont:[UIFont systemFontOfSize:22.0]];
    [label setTextColor:RGB16(0x3d3d3d)];
    
    UILabel *githubLabel =[[UILabel alloc]init];
    githubLabel.text =@"https://github.com/roycms";
    [githubLabel setFont:[UIFont systemFontOfSize:11]];
    [githubLabel setTextColor:RGB16(0x3d3d3d)];
    
    [self.view addSubview:imageView];
    [imageView addSubview:effectView];
    [self.view addSubview:logoImageView];
    [self.view addSubview:label];
    [self.view addSubview:githubLabel];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageView);
    }];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.centerX.equalTo(self.view);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [githubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.centerX.equalTo(self.view);
    }];
}
-(void)buttonUI{
    NSArray *arry = @[@"年月日选择",@"农历日期",@"时分秒选择",@"组合选择器"];
    for (int i=0;i<arry.count;i++) {
        UIButton *bt = [[UIButton alloc]init];
        [bt setBackgroundColor:RGB16(0xf8f8f8)];
        [bt.layer setBorderWidth:1];
        bt.alpha = 0.6;
        [bt setTitleColor:RGB16(0x3d3d3d) forState:UIControlStateNormal];
        [bt.layer setBorderColor:RGB16(0xebebeb).CGColor];
        bt.tag = i;
        [bt setTitle:arry[i] forState:UIControlStateNormal];
        [self.view addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(230+i*50);
            make.centerX.equalTo(self.view);
            make.width.offset(230);
        }];
        [bt addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)btClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {
            
            RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
            
            calendarPicker.selectDate = [DateHelper lastMonth:[NSDate date]];
            calendarPicker.dataSource = self.dataSource;
//            calendarPicker.thisTheme =[UIColor blackColor];
            calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
                NSLog(@"%d-%d-%d", (int)year,(int)month,(int)day);
            };
            [self.view addSubview:calendarPicker];
            
        }
            break;
        case 1:
        {
            
            RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
            calendarPicker.isLunarCalendar = YES; //开启农历
            calendarPicker.selectDate = [NSDate date]; //选择时间
            calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
                NSLog(@"%d-%d-%d", (int)year,(int)month,(int)day);
            };
            [self.view addSubview:calendarPicker];
            
        }
            break;
        case 2:
        {
            RClockPickerView *rClockPickerView = [[RClockPickerView alloc]init];
            rClockPickerView.date = [NSDate date];
//            rClockPickerView.thisTheme =[UIColor blackColor];
//            rClockPickerView.dateString =@"13:50";
            rClockPickerView.complete = ^(NSInteger hours, NSInteger minutes, NSInteger noon ,float date){
                NSLog(@"%d-%d-%d -%f", (int)hours,(int)minutes,(int)noon,date);
                
            };
            [self.view addSubview:rClockPickerView];
            
        }
            break;
        case 3:
        {
            RCalendarPickerView *calendarPicker = [[RCalendarPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
            calendarPicker.selectDate = [NSDate date]; //选择时间
            [self.view addSubview:calendarPicker];
            
            calendarPicker.complete = ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
                NSLog(@"北京时间： %d-%d-%d", (int)year,(int)month,(int)day);
                
                RClockPickerView *rClockPickerView = [[RClockPickerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)
                                                                                clockRadius:140
                                                                     clockCalibrationRadius:130];
                rClockPickerView.date = [NSDate date];
                rClockPickerView.complete = ^(NSInteger hours, NSInteger minutes, NSInteger noon,float clockDate){
                    NSLog(@"北京时间： %d-%d-%d", (int)hours,(int)minutes,(int)noon);
                    NSDate *selectDate = [DateHelper dateInDate:date Hours:hours minutes:minutes];
                    NSLog(@"selectDate 格林尼治时间 +0 : %@",selectDate);
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    NSString *dateStr = [dateFormatter stringFromDate:selectDate];
                    NSLog(@"selectDate  北京时间 +8  : %@",dateStr);
                    
                };
                [self.view addSubview:rClockPickerView];
            };
            
        }
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
