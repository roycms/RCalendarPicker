//
//  RClockPickerView.m
//  RCalendarPicker
//
//  Created by roycms on 2016/11/18.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import "RClockPickerView.h"
#define kDegreesToRadians(degrees)  ((M_PI * degrees)/ 180)

@interface RClockPickerView()

@property (nonatomic)CGPoint centers; //中心点
@property (nonatomic)CGFloat clockRadius;//表 半径
@property (nonatomic)CGFloat clockCalibrationRadius;//刻度 半径
@property (nonatomic)CGFloat hoursLength;//时针 长度
@property (nonatomic)CGFloat minutesLength;//分针长度

@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UILabel *hoursLabel;
@property (nonatomic,strong)UILabel *minutesLabel;
@property (nonatomic,strong)UILabel *semicolonLabel;//时 分 的:分隔符

@property (nonatomic,strong)UILabel *morningLabel;//上午
@property (nonatomic,strong)UILabel *afternoonLabel;//下午

@property (nonatomic,strong)UIView *clockView; //表盘 view
@property (nonatomic,strong)UIView *hoursView; //时针 view
@property (nonatomic,strong)UIView *minutesView; //分针针 view

@property (nonatomic,assign)BOOL selectedDate; // true 小时  false 分钟
@property (nonatomic,assign)BOOL selectedMorningOrafternoon; // true Morning  false afternoon

@property CAShapeLayer *hoursLayer; //时针 Layer
@property CAShapeLayer *minutesLayer; //分针 Layer

@end
@implementation RClockPickerView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _clockRadius = 140;//表 半径
        _clockCalibrationRadius = 130;//刻度 半径
        _hoursLength = 60;//时针 长度
        _minutesLength = 80;//分针长度
        
        [self prepareUI];
        [self drawPointer];
        [self drawClockCenterLayer];
        
        self.selectedDate = YES; //默认选中小时
        self.minutesLabel.alpha = 0.6;
        
        self.selectedMorningOrafternoon = YES;
        self.afternoonLabel.alpha = 0.6;
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                  clockRadius:(CGFloat)clockRadius
       clockCalibrationRadius:(CGFloat)clockCalibrationRadius
                  hoursLength:(CGFloat)hoursLength
                minutesLength:(CGFloat)minutesLength

{
    if (self = [super initWithFrame:frame]) {
        
        _clockRadius = clockRadius; //表 半径
        _clockCalibrationRadius = clockCalibrationRadius; //刻度 半径
        _hoursLength = hoursLength; //时针 长度
        _minutesLength = minutesLength; //分针长度
        
        [self prepareUI];
        [self drawPointer];
        [self drawClockCenterLayer];
        
        self.selectedDate = YES; //默认选中小时
        self.minutesLabel.alpha = 0.6;
        
        self.selectedMorningOrafternoon = YES;
        self.afternoonLabel.alpha = 0.6;
    }
    return self;
}

#pragma mark - set
-(void)setHours:(CGFloat)hours{
    _hours = hours;
    self.hoursLabel.text = [NSString stringWithFormat:@"%d",(int)_hours];
    
    [self.hoursView setTransform:CGAffineTransformMakeRotation([self getAnglesWithHours:hours])];
    
}
-(void)setMinutes:(CGFloat)minutes{
    _minutes = minutes;
    self.minutesLabel.text =[NSString stringWithFormat:@"%d",(int)_minutes];
    [self.minutesView setTransform:CGAffineTransformMakeRotation([self getAnglesWithMinutes:minutes])];
    
    [self.hoursView setTransform:CGAffineTransformMakeRotation([self getAnglesWithHoursAndMinutes:self.hours minutes:minutes])];
}

#pragma mark - prepare
- (void)prepareUI {
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    CGFloat size = self.frame.size.width * 0.82;
    
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.semicolonLabel];
    [self.headerView addSubview:self.hoursLabel];
    [self.headerView addSubview:self.minutesLabel];
    [self.headerView addSubview:self.morningLabel];
    [self.headerView addSubview:self.afternoonLabel];
    
    self.semicolonLabel.text = @":";
    self.hoursLabel.text = @"11";
    self.minutesLabel.text = @"40";
    self.morningLabel.text = @"上午";
    self.afternoonLabel.text = @"下午";
    
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
        make.top.equalTo(self).offset(60);
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
        make.bottom.equalTo(self.minutesLabel.mas_centerY);
        make.left.equalTo(self.minutesLabel.mas_right).offset(5);
    }];
    [self.afternoonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.minutesLabel.mas_centerY);
        make.left.equalTo(self.minutesLabel.mas_right).offset(5);
    }];
    
    [self.hoursView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.clockView);
    }];
    [self.minutesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.clockView);
    }];
}


//绘制 时针和分针
-(void)drawPointer{
    
    UIView *hoursPointer = [[UIView alloc]init];
    UIView *minutesPointer = [[UIView alloc]init];
    
    self.hoursView.userInteractionEnabled = YES;
    self.minutesView.userInteractionEnabled = YES;
    hoursPointer.userInteractionEnabled = YES;
    minutesPointer.userInteractionEnabled = YES;
    hoursPointer.layer.shouldRasterize = YES;
    minutesPointer.layer.shouldRasterize = YES;
    
    UITapGestureRecognizer *minutesTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(minutesSelectedAction)];
    [minutesPointer addGestureRecognizer:minutesTapGesture];
    
    UITapGestureRecognizer *hoursTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hoursSelectedAction)];
    [hoursPointer addGestureRecognizer:hoursTapGesture];
    
    hoursPointer.alpha = 0.8;
    minutesPointer.alpha = 0.5;
    [hoursPointer setBackgroundColor:RGB16(0xff4081)];
    [minutesPointer setBackgroundColor:RGB16(0xff4081)];
    [self.hoursView addSubview:hoursPointer];
    [self.minutesView addSubview:minutesPointer];
    
    [hoursPointer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(2.6);
        make.height.offset(self.frame.size.width * 0.26);
        make.top.equalTo(self.hoursView).offset(80);
        make.centerX.equalTo(self.hoursView);
    }];
    
    [minutesPointer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(1.6);
        make.height.offset(self.frame.size.width * 0.35);
        make.top.equalTo(self.minutesView).offset(50);
        make.centerX.equalTo(self.minutesView);
    }];
}

//画表盘中心的圆点
-(void)drawClockCenterLayer{
    
    UIBezierPath *cicrle     = [UIBezierPath bezierPathWithArcCenter:self.clockView.center
                                                              radius:4
                                                          startAngle:0
                                                            endAngle:2*M_PI
                                                           clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth     = 0.8f;
    shapeLayer.fillColor     = RGB16(0Xf5f5f5).CGColor;
    shapeLayer.strokeColor   = RGB16(0xff4081).CGColor;
    shapeLayer.path          = cicrle.CGPath;
    
    [self.clockView.layer addSublayer:shapeLayer];
}

//画表盘和刻度
-(void)drawClockLayer{
    
    [self layoutIfNeeded];
    self.clockView.layer.frame = self.clockView.bounds;
    _centers = self.clockView.center;
    //画表盘
    UIBezierPath *cicrle     = [UIBezierPath bezierPathWithArcCenter:_centers
                                                              radius:self.clockRadius
                                                          startAngle:0
                                                            endAngle:2*M_PI
                                                           clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth     = 2.f;
    shapeLayer.fillColor     = RGB16(0Xf5f5f5).CGColor;
    shapeLayer.strokeColor   = RGB16(0Xf5f5f5).CGColor;
    shapeLayer.path          = cicrle.CGPath;
    
    [self.clockView.layer addSublayer:shapeLayer];
    
    //画刻度
    CGFloat perAngle = (M_PI*2) / 60;
    for (int i = 0; i< 60; i++) {
        
        CGFloat startAngel = (perAngle * i);
        CGFloat endAngel   = startAngel + perAngle/8;
        
        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:_centers
                                                                radius:self.clockCalibrationRadius
                                                            startAngle:startAngel
                                                              endAngle:endAngel
                                                             clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        if (i % 5 == 0) {
            perLayer.strokeColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.30].CGColor;
            perLayer.lineWidth   = 10.f;
            
        }else{
            perLayer.strokeColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.12].CGColor;
            perLayer.lineWidth   = 5;
            
        }
        
        perLayer.path = tickPath.CGPath;
        [self.clockView.layer addSublayer:perLayer];
    }
}


//触摸时开始移动时调用(移动时会持续调用)
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint curP = [touch locationInView:self];
    CGPoint preP = [touch previousLocationInView:self];
    
    NSLog(@"curP====%@",NSStringFromCGPoint(curP));
    NSLog(@"preP====%@",NSStringFromCGPoint(preP));
    
    double angle = [self getAnglesWithThreePoint:self.headerView.center pointB:self.clockView.center pointC:curP];
    
    if (self.selectedDate) {
        [self.hoursView setTransform:CGAffineTransformMakeRotation(angle)];
        self.hoursLabel.text =[NSString stringWithFormat:@"%d",(int)[self getHoursWithAngles:angle]] ;
    }
    else{
        [self.minutesView setTransform:CGAffineTransformMakeRotation(angle)];
        self.minutesLabel.text =[NSString stringWithFormat:@"%d",(int)[self getMinutesWithAngles:angle]] ;
    }
}


//三个点A、B、C，计算ㄥABC
- (CGFloat)getAnglesWithThreePoint:(CGPoint)pointA
                            pointB:(CGPoint)pointB
                            pointC:(CGPoint)pointC
{
    CGFloat x1 = pointA.x - pointB.x;
    CGFloat y1 = pointA.y - pointB.y;
    CGFloat x2 = pointC.x - pointB.x;
    CGFloat y2 = pointC.y - pointB.y;
    CGFloat x = x1 * x2 + y1 * y2;
    CGFloat y = x1 * y2 - x2 * y1;
    CGFloat angle = acos(x/sqrt(x*x+y*y));
    
    NSLog(@"angle ---- %f",angle);
    
    if (pointC.x < self.clockView.center.x) {
        //以所得角度最大为π，因工程中AB为竖直方向固定，需要得到顺时针角度，最大2π，故添加如下：
        angle = M_PI*2 - angle;
    }
    return angle;
}

//时间转角度 WithHour 整点
-(CGFloat)getAnglesWithHours:(CGFloat)hours{
    
    CGFloat angle = (int)hours*((M_PI*2)/12) - ((M_PI*2)/12)/60*((hours-(int)hours)*100);
    return angle;
}
//时间转角度 WithHour 整点+ 分钟偏移
-(CGFloat)getAnglesWithHoursAndMinutes:(CGFloat)hours minutes:(CGFloat)minutes{
    
    CGFloat angle = (int)hours*((M_PI*2)/12) - ((M_PI*2)/12)/60*((hours-(int)hours)*100) + ((M_PI*2)/12/60)*minutes;
    return angle;
}
//时间转角度 WithMinutes
-(CGFloat)getAnglesWithMinutes:(CGFloat)minutes{
    
    CGFloat angle = minutes*((M_PI*2)/60);
    return angle;
}
//根据角度换算成 小时时间
-(CGFloat)getHoursWithAngles:(CGFloat)angle {
    CGFloat oneHours = ((M_PI*2)/12);
    
    return  (int)(angle / oneHours)==0?12:(int)(angle / oneHours);
}

//根据角度换算成 分钟时间
-(CGFloat)getMinutesWithAngles:(CGFloat)angle {
    CGFloat oneMinutes = ((M_PI*2)/60);
    
    return  (int)(angle / oneMinutes);
}


//事件
-(void)hoursSelectedAction{
    self.selectedDate = YES;
    self.minutesLabel.alpha = 0.6;
    self.hoursLabel.alpha = 1;
}
-(void)minutesSelectedAction{
    self.selectedDate = NO;
    self.minutesLabel.alpha = 1;
    self.hoursLabel.alpha = 0.6;
}

-(void)morningSelectedAction{
    self.selectedMorningOrafternoon = YES;
    self.afternoonLabel.alpha = 0.6;
    self.morningLabel.alpha = 1;
    
}
-(void)afternoonSelectedAction{
    self.selectedMorningOrafternoon = NO;
    self.afternoonLabel.alpha = 1;
    self.morningLabel.alpha = 0.6;
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
        [_morningLabel setFont:[UIFont boldSystemFontOfSize:18]];
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
        [_afternoonLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_afternoonLabel setTextAlignment:NSTextAlignmentCenter];
        _afternoonLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(afternoonSelectedAction)];
        [_afternoonLabel addGestureRecognizer:tapGesture];
    }
    return _afternoonLabel;
}

@end
