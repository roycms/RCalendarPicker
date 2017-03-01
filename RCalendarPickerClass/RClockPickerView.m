//
//  RClockPickerView.m
//  RCalendarPicker
//
//  Created by roycms on 2016/11/18.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import "RClockPickerView.h"
#import "ClockHelper.h"
#define kDegreesToRadians(degrees)  ((M_PI * degrees)/ 180)

@interface RClockPickerView()
@property (nonatomic,assign) CGFloat  clockRadius;//表盘 圆圈的半径
@property (nonatomic,assign) CGFloat  clockCalibrationRadius;//表盘刻度 圆圈的半径

@property (nonatomic,strong) UIView   *headerView;//头部 view
@property (nonatomic,strong) UILabel  *hoursLabel;//时 Label
@property (nonatomic,strong) UILabel  *minutesLabel;//分 Label
@property (nonatomic,strong) UILabel  *semicolonLabel;//时 分 的“:”分隔符
@property (nonatomic,strong) UILabel  *morningLabel;//上午
@property (nonatomic,strong) UILabel  *afternoonLabel;//下午

@property (nonatomic,strong) UIView   *clockView;//表盘 view
@property (nonatomic,strong) UIView   *hoursView;//时针 view
@property (nonatomic,strong) UIView   *minutesView;//分针 view

@property (nonatomic,assign) BOOL     selectedDate;// 小时和分钟选中状态 YES 小时  NO 分钟
@property (nonatomic,assign) BOOL     selectedMorningOrafternoon;// 上下午选择状态 YES Morning  NO afternoon

@property (nonatomic,assign) int      selectHours;//当前选择的 小时
@property (nonatomic,assign) int      selectMinutes;//当前选择的 分钟

@property (nonatomic,strong) UIButton *cancelButton;//取消按钮
@property (nonatomic,strong) UIButton *okButton;// 确认按钮

@property (nonatomic,strong) NSArray  *themeArray;//主题颜色数组


@property (nonatomic,strong) UIView   *hoursPointer;//时针
@property (nonatomic,strong) UIView   *minutesPointer;//分针

@property (nonatomic,strong) CAShapeLayer *shapeLayer; //表盘中心的小圆圈

@end
@implementation RClockPickerView

-(void)dealloc{}
#pragma mark - init


/**
 init

 @param frame frame description
 @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _clockRadius            = 140;//表 半径
        _clockCalibrationRadius = 130;//刻度 半径
        
        [self prepareUI];
        [self drawPointer];
        [self drawClockCenterLayer];
        
        [self prepareData];
    }
    return self;
}


/**
 初始化
 
 @param frame frame description
 @param clockRadius 表盘 圆圈的半径
 @param clockCalibrationRadius 表盘刻度 圆圈的半径
 @return return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                  clockRadius:(CGFloat)clockRadius
       clockCalibrationRadius:(CGFloat)clockCalibrationRadius

{
    if (self = [super initWithFrame:frame]) {
        
        _clockRadius            = clockRadius;//表 半径
        _clockCalibrationRadius = clockCalibrationRadius;//刻度 半径

        [self prepareUI];
        [self drawPointer];
        [self drawClockCenterLayer];

        [self prepareData];
    }
    return self;
}

#pragma mark - set


/**
 date 的set 方法

 @param date date description
 */
-(void)setDate:(NSDate *)date{
    _date = date;
    @try {
        NSInteger hours  = [DateHelper hours:date];
        NSInteger minute = [DateHelper minute:date];

        [self updateDefaultUiViewForHours:hours minute:minute];
    } @catch (NSException *exception) {
        NSLog(@"获取当前时间出错");
    } @finally {
        return;
    }
}


/**
 dateString 的set 方法

 @param dateString dateString description
 */
-(void)setDateString:(NSString *)dateString{
    _dateString = dateString;
    
    @try {
        dateString       = [dateString stringByReplacingOccurrencesOfString:@":" withString:@"."];
        dateString       = [dateString stringByReplacingOccurrencesOfString:@"：" withString:@"."];
        double date      = [dateString doubleValue];

        NSInteger hours  = (int)date;

        NSInteger minute = (int)((date - hours)*100);

        [self updateDefaultUiViewForHours:hours minute:minute];
    } @catch (NSException *exception) {
        NSLog(@"dateString 格式不正确 例子： 12.01 或者 12:01");
    } @finally {
        return;
    }
}


/**
 设置主题的 set 方法

 @param thisTheme thisTheme description
 */
-(void)setThisTheme:(UIColor *)thisTheme{
    _thisTheme                      = thisTheme;
    self.headerView.backgroundColor = thisTheme;

    [self.hoursPointer setBackgroundColor:thisTheme];
    [self.minutesPointer setBackgroundColor:thisTheme];
    self.shapeLayer.strokeColor   = thisTheme.CGColor;
}


/**
 根据 时 分 更新默认的数据

 @param hours 小时
 @param minute 分钟
 */
-(void)updateDefaultUiViewForHours:(NSInteger)hours minute:(NSInteger)minute{
    _selectHours           = (int)hours;
    _selectMinutes         = (int)minute;

    if(_selectHours > 12){
        [self afternoonSelectedAction];
    }
    else{
        [self morningSelectedAction]; //上午
    }

    self.hoursLabel.text   = [NSString stringWithFormat:@"%d",(int)hours];
    NSString *minutesStr;
    if(minute<10){
    minutesStr             = [NSString stringWithFormat:@"0%d",(int)minute];
    }else{
    minutesStr             = [NSString stringWithFormat:@"%d",(int)minute];
    }
    self.minutesLabel.text = minutesStr;
    [self.minutesView setTransform:CGAffineTransformMakeRotation([ClockHelper getAnglesWithMinutes:minute])];
    [self.hoursView setTransform:CGAffineTransformMakeRotation([ClockHelper getAnglesWithHoursAndMinutes:_selectHours minutes:minute])];
}

#pragma mark - prepare


/**
 准备初始数据
 */
- (void)prepareData{
    self.selectedDate               = YES;//默认选中小时
    self.minutesLabel.alpha         = 0.5;
    self.selectedMorningOrafternoon = YES;//上午
    self.afternoonLabel.alpha       = 0.5;
    self.morningLabel.alpha         = 1;

    self.semicolonLabel.text        = @":";
    self.morningLabel.text          = LANGUAGE(@"AM");


    self.afternoonLabel.text        = LANGUAGE(@"PM");

    self.themeArray                 = @[RGB16(0X1abc9c),
                        RGB16(0X27ae60),
                        RGB16(0X2980b9),
                        RGB16(0X2c3e50),
                        RGB16(0Xf39c12),
                        RGB16(0Xc0392b),
                        RGB16(0X7f8c8d),
                        RGB16(0X8e44ad)];
    if(self.thisTheme == nil){
        self.thisTheme = self.themeArray[(arc4random() % 8)];
    }

}


/**
 准备界面UI
 */
- (void)prepareUI {
    
    if(self.frame.size.width == 0){
    self.frame   = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    }

    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    CGFloat size = self.frame.size.width * 0.82;

    CGFloat topSize = (self.frame.size.height - (120+60+size))/2;
    
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.semicolonLabel];
    [self.headerView addSubview:self.hoursLabel];
    [self.headerView addSubview:self.minutesLabel];
    [self.headerView addSubview:self.morningLabel];
    [self.headerView addSubview:self.afternoonLabel];
    
    [self addSubview:self.cancelButton];
    [self addSubview:self.okButton];
    
    [self addSubview:self.clockView];
    [self.clockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.centerX.equalTo(self);
        make.width.height.offset(size);
    }];
    [self drawClockLayer];
    
    [self.clockView addSubview:self.hoursView];
    [self.clockView addSubview:self.minutesView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(topSize);
        make.centerX.equalTo(self);
        make.width.offset(size);
        make.height.offset(120);
    }];
    
    [self.semicolonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView).offset(-30);
        make.centerY.equalTo(self.headerView);
        make.width.offset(20);
    }];
    [self.hoursLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.semicolonLabel);
        make.right.equalTo(self.semicolonLabel.mas_left);
    }];
    [self.minutesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.semicolonLabel);
        make.left.equalTo(self.semicolonLabel.mas_right);
    }];
    [self.morningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.minutesLabel.mas_centerY).offset(-1.5);
        make.left.equalTo(self.minutesLabel.mas_right).offset(5);
    }];
    [self.afternoonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.minutesLabel.mas_centerY).offset(1.5);
        make.left.equalTo(self.minutesLabel.mas_right).offset(5);
    }];
    
    [self.hoursView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.clockView);
    }];
    [self.minutesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.clockView);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clockView.mas_bottom);
        make.right.equalTo(self.clockView.mas_centerX);
        make.left.equalTo(self.clockView);
        make.height.offset(60);
    }];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clockView.mas_bottom);
        make.left.equalTo(self.clockView.mas_centerX);
        make.right.equalTo(self.clockView);
        make.height.offset(60);
    }];
}

#pragma mark - draw

/**
 绘制 时针和分针

 */
-(void)drawPointer{
    
    self.hoursPointer = [[UIView alloc]init];
    self.minutesPointer = [[UIView alloc]init];
    
    self.hoursView.userInteractionEnabled = YES;
    self.minutesView.userInteractionEnabled = YES;
    self.hoursPointer.userInteractionEnabled = YES;
    self.minutesPointer.userInteractionEnabled = YES;
    self.hoursPointer.layer.shouldRasterize = YES;
    self.minutesPointer.layer.shouldRasterize = YES;
    
    UITapGestureRecognizer *minutesTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(minutesSelectedAction)];
    [self.minutesPointer addGestureRecognizer:minutesTapGesture];
    
    UITapGestureRecognizer *hoursTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hoursSelectedAction)];
    [self.hoursPointer addGestureRecognizer:hoursTapGesture];
    
    self.hoursPointer.alpha = 0.8;
    self.minutesPointer.alpha = 0.5;
    [self.hoursPointer setBackgroundColor:RGB16(0xff4081)];
    [self.minutesPointer setBackgroundColor:RGB16(0xff4081)];
    [self.hoursView addSubview:self.hoursPointer];
    [self.minutesView addSubview:self.minutesPointer];
    
    [self.hoursPointer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(2.6);
        make.height.offset(self.frame.size.width * 0.24);
        make.top.equalTo(self.hoursView).offset(85);
        make.centerX.equalTo(self.hoursView);
    }];
    
    [self.minutesPointer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(1.6);
        make.height.offset(self.frame.size.width * 0.35);
        make.top.equalTo(self.minutesView).offset(58);
        make.centerX.equalTo(self.minutesView);
    }];
}


/**
 画表盘中心的圆点 小圆圈
 */
-(void)drawClockCenterLayer{
    
    UIBezierPath *cicrle        = [UIBezierPath bezierPathWithArcCenter:self.clockView.center
                                                              radius:4
                                                          startAngle:0
                                                            endAngle:2*M_PI
                                                           clockwise:YES];
    self.shapeLayer             = [CAShapeLayer layer];
    self.shapeLayer.lineWidth   = 0.8f;
    self.shapeLayer.fillColor   = RGB16(0Xf5f5f5).CGColor;
    self.shapeLayer.strokeColor = RGB16(0xff4081).CGColor;
    self.shapeLayer.path        = cicrle.CGPath;

    [self.clockView.layer addSublayer:self.shapeLayer];
}

/**
 画表盘和刻度
 */
-(void)drawClockLayer{
    
    [self layoutIfNeeded];
    self.clockView.layer.frame = self.clockView.bounds;
    //画表盘
    UIBezierPath *cicrle       = [UIBezierPath bezierPathWithArcCenter:self.clockView.center
                                                              radius:self.clockRadius
                                                          startAngle:0
                                                            endAngle:2*M_PI
                                                           clockwise:YES];
    CAShapeLayer *shapeLayer   = [CAShapeLayer layer];
    shapeLayer.lineWidth       = 2.f;
    shapeLayer.fillColor       = RGB16(0Xf5f5f5).CGColor;
    shapeLayer.strokeColor     = RGB16(0Xf5f5f5).CGColor;
    shapeLayer.path            = cicrle.CGPath;

    [self.clockView.layer addSublayer:shapeLayer];
    
    //画刻度
    CGFloat perAngle = (M_PI*2) / 60;
    for (int i = 0; i< 60; i++) {
        
        CGFloat startAngel             = (perAngle * i);
        CGFloat endAngel               = startAngel + perAngle/8;

        UIBezierPath *tickPath         = [UIBezierPath bezierPathWithArcCenter:self.clockView.center
                                                                radius:self.clockCalibrationRadius
                                                            startAngle:startAngel
                                                              endAngle:endAngel
                                                             clockwise:YES];

        UIBezierPath *clockValtickPath = [UIBezierPath bezierPathWithArcCenter:self.clockView.center
                                                                        radius:self.clockCalibrationRadius-18
                                                                    startAngle:startAngel
                                                                      endAngle:endAngel
                                                                     clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        if (i % 5 == 0) {
            perLayer.strokeColor     = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.26].CGColor;
            perLayer.lineWidth       = 10.f;

            //画刻度值
            CGPoint point            = [ClockHelper calculateTextPositonWithArcCenter:self.clockView.center Angle:startAngel];
            UILabel *clockLabel =[[UILabel alloc] initWithFrame:CGRectMake(point.x - 5, point.y - 5, 25, 25)];
            int clockVal             = i/5 +3;
            clockLabel.text          = [NSString stringWithFormat:@"%d",clockVal>12?clockVal%12:clockVal];
            clockLabel.textColor     = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.18];
            clockLabel.font          = [UIFont systemFontOfSize:20];
            clockLabel.textAlignment = NSTextAlignmentCenter;
            clockLabel.center        = clockValtickPath.currentPoint;
            [self.clockView addSubview:clockLabel];
            
            
        }else{
            perLayer.strokeColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.10].CGColor;
            perLayer.lineWidth   = 5;
            
        }
        perLayer.path = tickPath.CGPath;
        [self.clockView.layer addSublayer:perLayer];
    }
    
}

#pragma -mark 触摸回调

/**
 触摸结束回调

 @param touches touches description
 @param event event description
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {}

/**
 触摸时开始移动时调用(移动时会持续调用)

 @param touches touches description
 @param event event description
 */
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint curP   = [touch locationInView:self];
    //    CGPoint preP = [touch previousLocationInView:self];
    //    NSLog(@"curP====%@",NSStringFromCGPoint(curP));
    //    NSLog(@"preP====%@",NSStringFromCGPoint(preP));
    double angle = [ClockHelper getAnglesWithThreePoint:self.headerView.center pointB:self.clockView.center pointC:curP];
    
    //拖动不再表盘区域内时 不做调整 直接 return
    if(![ClockHelper isPointInViewFor:curP view:self.clockView])
    {
        return;
    }
    if (self.selectedDate) {
        CGFloat hours    = [ClockHelper getHoursWithAngles:angle];
        self.selectHours = hours;
        [self.hoursView setTransform:CGAffineTransformMakeRotation(angle)];
        
        if(self.selectedMorningOrafternoon){
            self.hoursLabel.text = [NSString stringWithFormat:@"%d",(int)hours == 12?0:(int)hours] ;
        }
        else{
            self.hoursLabel.text = [NSString stringWithFormat:@"%d",((int)hours+12)==24?12:((int)hours+12)] ;
        }
        //设置分针 跟随转动
        double minutesAngle = angle - [ClockHelper getAnglesWithHours:(int)hours == 12?0:(int)hours];
        int minutes         = (int)[ClockHelper getMinutesWithAngles:(minutesAngle)*12];
        [self.minutesView setTransform:CGAffineTransformMakeRotation(minutesAngle*12)];
        NSString *minutesStr;
        if(minutes<10){
            minutesStr = [NSString stringWithFormat:@"0%d",(int)minutes];
        }else{
            minutesStr = [NSString stringWithFormat:@"%d",(int)minutes];
        }
        if(minutes >= 60)
        {
            minutesStr = @"00";
        }
        self.selectMinutes = minutes;
        self.minutesLabel.text = minutesStr;
        
    }
    else{
        int minutes        = (int)[ClockHelper getMinutesWithAngles:angle];
        self.selectMinutes = minutes;
        [self.minutesView setTransform:CGAffineTransformMakeRotation(angle)];
        NSString *minutesStr;
        if(minutes < 10){
            minutesStr = [NSString stringWithFormat:@"0%d",(int)minutes];
        }else{
            minutesStr = [NSString stringWithFormat:@"%d",(int)minutes];
        }
        if(minutes >= 60)
        {
            minutesStr = @"00";
        }
        self.minutesLabel.text = minutesStr;

        //设置时针的偏移 矫正
        [self.hoursView setTransform:CGAffineTransformMakeRotation([ClockHelper getAnglesWithHoursAndMinutes:self.selectHours minutes:minutes])];
    }
}


#pragma -mark 事件

/**
 选择 时按钮状态 的事件
 */
-(void)hoursSelectedAction{
    self.selectedDate = YES;
    self.minutesLabel.alpha = 0.5;
    self.hoursLabel.alpha = 1;
}

/**
 选择 分按钮状态 的事件
 */
-(void)minutesSelectedAction{
    self.selectedDate = NO;
    self.minutesLabel.alpha = 1;
    self.hoursLabel.alpha = 0.5;
}

/**
 选择 上午按钮状态 的事件
 */
-(void)morningSelectedAction{
    self.selectedMorningOrafternoon = YES;
    self.afternoonLabel.alpha = 0.5;
    self.morningLabel.alpha = 1;
    
}

/**
 选择 下午按钮状态 的事件
 */
-(void)afternoonSelectedAction{
    self.selectedMorningOrafternoon = NO;
    self.afternoonLabel.alpha = 1;
    self.morningLabel.alpha = 0.5;
}

/**
 点击确认按钮的事件
 */
-(void)okButtonAction{
    
    if (self.complete) {
        if(self.selectedMorningOrafternoon){
            self.complete(self.selectHours==12?0:self.selectHours,self.selectMinutes>60?0:self.selectMinutes,0,[ClockHelper getFloatDate:self.selectHours minutes:self.selectMinutes>60?0:self.selectMinutes]);
        }
        else{
            int hours;
            if(self.selectHours>12){
                hours = self.selectHours==24?12:self.selectHours;
            }
            else{
                hours = (self.selectHours + 12)==24?12:(self.selectHours + 12);
            }
            
            self.complete(hours,self.selectMinutes>60?0:self.selectMinutes,1,[ClockHelper getFloatDate:hours minutes:self.selectMinutes>60?0:self.selectMinutes]);
        }
    }
    [self hide];
}

/**
 点击取消按钮的事件
 */
-(void)cancelButtonAction{
    
    if (self.cancel) {
        self.cancel();
    }
    [self hide];
}

/**
 销毁 self 的方法
 */
-(void)hide {
    [self removeFromSuperview];
}


#pragma -mark 懒加载
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        [_headerView setBackgroundColor:RGB16(0xff4081)];
    }
    return _headerView;
}
-(UIView *)clockView{
    if (!_clockView) {
        _clockView = [[UIView alloc]init];
        [_clockView setBackgroundColor:RGB16(0xffffff)];
    }
    return _clockView;
}

-(UIView *)hoursView{
    if (!_hoursView) {
        _hoursView = [[UIView alloc]init];
    }
    return _hoursView;
}
-(UIView *)minutesView{
    if (!_minutesView) {
        _minutesView = [[UIView alloc]init];
    }
    return _minutesView;
}

-(UILabel *)hoursLabel{
    if (!_hoursLabel) {
        _hoursLabel = [[UILabel alloc]init];
        [_hoursLabel setFont:[UIFont boldSystemFontOfSize:70]];
        [_hoursLabel setTextColor:RGB16(0xffffff)];
        [_hoursLabel setTextAlignment:NSTextAlignmentCenter];
        _hoursLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hoursSelectedAction)];
        [_hoursLabel addGestureRecognizer:tapGesture];
    }
    return _hoursLabel;
}
-(UILabel *)minutesLabel{
    if (!_minutesLabel) {
        _minutesLabel = [[UILabel alloc]init];
        [_minutesLabel setTextColor:RGB16(0xffffff)];
        [_minutesLabel setFont:[UIFont boldSystemFontOfSize:70]];
        [_minutesLabel setTextAlignment:NSTextAlignmentCenter];
        _minutesLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(minutesSelectedAction)];
        [_minutesLabel addGestureRecognizer:tapGesture];
    }
    return _minutesLabel;
}
-(UILabel *)semicolonLabel{
    if (!_semicolonLabel) {
        _semicolonLabel = [[UILabel alloc]init];
        [_semicolonLabel setTextColor:RGB16(0xffffff)];
        [_semicolonLabel setFont:[UIFont boldSystemFontOfSize:70]];
        [_semicolonLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _semicolonLabel;
}
-(UILabel *)morningLabel{
    if (!_morningLabel) {
        _morningLabel = [[UILabel alloc]init];
        [_morningLabel setTextColor:RGB16(0xffffff)];
        [_morningLabel setFont:[UIFont boldSystemFontOfSize:22]];
        [_morningLabel setTextAlignment:NSTextAlignmentCenter];
        _morningLabel.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(morningSelectedAction)];
        [_morningLabel addGestureRecognizer:tapGesture];
    }
    return _morningLabel;
}
-(UILabel *)afternoonLabel{
    if (!_afternoonLabel) {
        _afternoonLabel = [[UILabel alloc]init];
        [_afternoonLabel setTextColor:RGB16(0xffffff)];
        [_afternoonLabel setFont:[UIFont boldSystemFontOfSize:22]];
        [_afternoonLabel setTextAlignment:NSTextAlignmentCenter];
        _afternoonLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(afternoonSelectedAction)];
        [_afternoonLabel addGestureRecognizer:tapGesture];
    }
    return _afternoonLabel;
}

-(UIButton *)cancelButton {
    if(!_cancelButton){
        _cancelButton =[[UIButton alloc]init];
        [_cancelButton setTitle:LANGUAGE(@"Cancel") forState:UIControlStateNormal];
        [_cancelButton setTitleColor:RGB16(0x898989) forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelButtonAction)];
        [_cancelButton addGestureRecognizer:tapGesture];
    }
    return _cancelButton;
}
-(UIButton *)okButton {
    if(!_okButton){
        _okButton =[[UIButton alloc]init];
        [_okButton setTitle:LANGUAGE(@"OK") forState:UIControlStateNormal];
        [_okButton setTitleColor:RGB16(0x898989) forState:UIControlStateNormal];
        [_okButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_okButton setBackgroundColor:[UIColor whiteColor]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(okButtonAction)];
        [_okButton addGestureRecognizer:tapGesture];
        
    }
    return _okButton;
}

@end
