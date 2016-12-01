//
//  RCalendarPickerView.m
//  RCalendarPicker
//
//  Created by roycms on 2016/11/16.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import "RCalendarPickerView.h"
#import "RCollectionViewCell.h"

@interface RCalendarPickerView()
@property (nonatomic,strong) NSDate           *date;
@property (nonatomic,strong) UIView           *headerView;// view
@property (nonatomic,strong) UILabel          *weekLabel;// 顶部星期
@property (nonatomic,strong) UILabel          *monthLabel;//月
@property (nonatomic,strong) UILabel          *dayLabel;// 日
@property (nonatomic,strong) UILabel          *yearLabel;// 年
@property (nonatomic,strong) UICollectionView *collectionView;// 日历的collectionView
@property (nonatomic,strong) NSArray          *weekDayArray;// 日历内的星期数据
@property (nonatomic,strong) NSArray          *weekDayTextSupportsArray;// 最顶部选择后的 星期显示数据
@property (nonatomic,strong) UILabel          *groundColourMonthLabel;// 日历 上 浅色的半透明的 很大的月份显示 Label
@property (nonatomic,strong) NSArray          *themeArray;//主体颜色数组
@property (nonatomic,strong) UIButton         *cancelButton;//取消按钮
@property (nonatomic,strong) UIButton         *okButton;//确认按钮

@property (nonatomic,copy) UIColor* (^themeBlock)();
@end

@implementation RCalendarPickerView
#pragma mark - dealloc
-(void)dealloc{}
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
        [self prepareData];
        [self prepareSwipe]; // 添加滑动翻页事件
    }
    return self;
}

#pragma mark - put


/**
 根据时间 更新头部显示

 @param date date description
 */
-(void)updateHeaderViewDate:(NSDate *)date {
    
    self.weekLabel.text = [NSString stringWithFormat:@"%@",self.weekDayTextSupportsArray[(int)[DateHelper weekday:date] - 1]];
    self.dayLabel.text = [NSString stringWithFormat:@"%d",(int)[DateHelper day:date]];
    self.groundColourMonthLabel.text = [NSString stringWithFormat:@"%d",(int)[DateHelper month:date]];
    if (self.isLunarCalendar) {
        self.monthLabel.text = [NSString stringWithFormat:@"%d %@ %@",(int)[DateHelper month:date],[DateHelper getChineseCalendarMonthsWithDate:date],LANGUAGE(@"month")];
        self.yearLabel.text = [NSString stringWithFormat:@"%d %@",(int)[DateHelper year:date],[DateHelper getChineseCalendarYearsWithDate:date]];
    }
    else{
        self.monthLabel.text = [NSString stringWithFormat:@"%d %@",(int)[DateHelper month:date],LANGUAGE(@"month")];
        self.yearLabel.text = [NSString stringWithFormat:@"%d %@",(int)[DateHelper year:date],LANGUAGE(@"Year")];
    }
}


/**
 date 的set方法

 @param date date description
 */
- (void)setDate:(NSDate *)date
{
    _date = date;
    if(self.thisTheme == nil){
        self.thisTheme = self.themeArray[(arc4random() % 8)];
    }
    self.groundColourMonthLabel.text = [NSString stringWithFormat:@"%d",(int)[DateHelper month:date]];
    [self.collectionView reloadData];
}

-(void)setSelectDate:(NSDate *)selectDate{
    _selectDate = selectDate;
    self.date = selectDate;
    [self updateHeaderViewDate:selectDate];
}

/**
 设置主题 的set 方法

 @param thisTheme thisTheme description
 */
-(void)setThisTheme:(UIColor *)thisTheme{
    _thisTheme = thisTheme;

    [self.headerView setBackgroundColor:thisTheme];
    self.themeBlock =^(){
        return thisTheme;
    };
}

/**
 绑定数据

 @param dataSource dataSource description
 */
-(void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
}

/**
 销毁页面方法
 */
-(void)hide {
    [self removeFromSuperview];
}


#pragma mark - Layout UI准备和布局相关


/**
 准备默认数据
 */
-(void)prepareData{
    
    self.weekDayTextSupportsArray = @[LANGUAGE(@"Sunday"),
                                      LANGUAGE(@"Monday"),
                                      LANGUAGE(@"Tuesday"),
                                      LANGUAGE(@"Wednesday"),
                                      LANGUAGE(@"Thursday"),
                                      LANGUAGE(@"Friday"),
                                      LANGUAGE(@"Saturday")];
    self.weekDayArray = @[LANGUAGE(@"Sun"),
                          LANGUAGE(@"Mon"),
                          LANGUAGE(@"Tues"),
                          LANGUAGE(@"Wed"),
                          LANGUAGE(@"Thur"),
                          LANGUAGE(@"Fri"),
                          LANGUAGE(@"Sat")];
    
    self.themeArray = @[RGB16(0X1abc9c),
                        RGB16(0X27ae60),
                        RGB16(0X2980b9),
                        RGB16(0X2c3e50),
                        RGB16(0Xf39c12),
                        RGB16(0Xc0392b),
                        RGB16(0X7f8c8d),
                        RGB16(0X8e44ad)];
    
}


/**
 准备界面UI
 */
- (void)prepareUI{
    
    if(self.frame.size.width == 0){
        self.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    }
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    CGFloat width = self.frame.size.width * 0.82;
    CGFloat topSize = (self.frame.size.height - (235+60+width))/2;
    
    [self addSubview:self.headerView];
    [self addSubview:self.collectionView];
    [self addSubview:self.groundColourMonthLabel];
    
    
    [self.headerView addSubview:self.weekLabel];
    [self.headerView addSubview:self.monthLabel];
    [self.headerView addSubview:self.dayLabel];
    [self.headerView addSubview:self.yearLabel];
    
    [self addSubview:self.cancelButton];
    [self addSubview:self.okButton];

    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(topSize);
        make.centerX.equalTo(self);
        make.width.offset(width);
        make.height.offset(235);
    }];
    
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView);
        make.centerX.equalTo(self.headerView);
        make.width.equalTo(self.headerView);
        make.height.offset(35);
    }];
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weekLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.headerView);
        make.width.equalTo(self.headerView);
    }];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.monthLabel.mas_bottom).offset(-5);
        make.centerX.equalTo(self.headerView);
        make.width.equalTo(self.headerView);
    }];
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dayLabel.mas_bottom).offset(-10);
        make.centerX.equalTo(self.headerView);
        make.width.equalTo(self.headerView);
        make.bottom.equalTo(self.headerView).offset(-10);
    }];
    [self.groundColourMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(5);
        make.centerX.equalTo(self);
        make.width.height.equalTo(self.collectionView);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.centerX.equalTo(self);
        make.width.height.offset(width);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.right.equalTo(self.collectionView.mas_centerX);
        make.left.equalTo(self.collectionView);
        make.height.offset(60);
    }];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.equalTo(self.collectionView.mas_centerX);
        make.right.equalTo(self.collectionView);
        make.height.offset(60);
    }];

};

#pragma -mark click


/**
 添加 左右滑动 翻页
 */
- (void)prepareSwipe
{
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nexAction)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previouseAction)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
}

#pragma -mark click


/**
 上翻页 事件
 */
- (void)previouseAction {
    [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        self.date = [DateHelper lastMonth:_date];
    } completion:nil];
}

/**
 下翻页 事件方法
 */
- (void)nexAction {
    [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        self.date = [DateHelper nextMonth:_date];
    } completion:nil];
}


/**
 确认按钮的点击事件
 */
-(void)okButtonAction{
    if (self.complete) {
        if(!_selectDate){
            NSLog(@"没有选择日期！默认当前系统时间");
            self.complete([DateHelper day:[NSDate date]], [DateHelper month:[NSDate date]], [DateHelper year:[NSDate date]] ,[NSDate date]);
            
        }else{
        self.complete([DateHelper day:_selectDate], [DateHelper month:_selectDate], [DateHelper year:_selectDate] ,_selectDate);
           
        }
    }
    [self hide];
}


/**
 取消按钮的点击事件
 */
-(void)cancelButtonAction{
    if(!self.cancel){
        NSLog(@"cancel block is nil");
    }else{
        self.cancel();
    }
   [self hide];
}


#pragma -mark collectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.weekDayArray.count;
    } else {
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RCollectionViewCell" forIndexPath:indexPath];
    cell.isSelected = NO;
    cell.isToDay = NO;
    cell.isDataSource = NO;
    cell.bgViewColor = _themeBlock();
    if (indexPath.section == 0) {
        cell.day = self.weekDayArray[indexPath.row];
        cell.dayLabelTextColor = RGB16(0x6f6f6f);
        cell.znDay = nil;
        
    } else {
        NSInteger daysInThisMonth = [DateHelper totaldaysInMonth:_date];
        NSInteger firstWeekday = [DateHelper firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i < firstWeekday) {
            cell.day = nil;
            cell.znDay = nil;
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            cell.day = nil;
            cell.znDay = nil;
            
        }else{
            day = i - firstWeekday + 1;
            cell.day = [NSString stringWithFormat:@"%i",(int)day];
            
            NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_date];
            NSDate *date = [DateHelper dateInYear:[comp year] month:[comp month] day:day];
            
            if (self.isLunarCalendar) {
                 cell.znDay = [DateHelper getChineseCalendarDaysWithDate:date];
            }
            cell.dayLabelTextColor = RGB16(0x5d5d5d);
            //this month 当前月 当前天
            BOOL isThisMonth = [DateHelper month:_date] == [DateHelper month:[NSDate date]];
            BOOL isThisYear = [DateHelper year:_date] == [DateHelper year:[NSDate date]];
            if (day == [DateHelper day:[NSDate date]] && isThisMonth && isThisYear) {
                cell.isToDay = YES;
                cell.dayLabelTextColor = RGB16(0xffffff);
            }
            //选择的天
            if(_selectDate != nil && day == [DateHelper day:_selectDate] && [DateHelper month:_date] == [DateHelper month:_selectDate]&& [DateHelper year:_date] == [DateHelper year:_selectDate])
            {
                cell.isSelected = YES;
            }
            
            //绑定数据
            cell.isDataSource = [self isDataSourceObj:date];
            
        }
    }
    return cell;
}

/**
 数据源内是否包含当前的天的 数据标记

 @param date date description
 @return return value description
 */
-(BOOL)isDataSourceObj:(NSDate *)date {
    
    BOOL returnVal = NO;
    for (NSDictionary *dataSourceObj in self.dataSource) {
        
     NSDate *dataSourceDate = [DateHelper getDateForString:dataSourceObj[@"date"] dateFormat:@"yyyy-MM-dd"];
        if ([DateHelper year:date] == [DateHelper year:dataSourceDate] &&
            [DateHelper month:date] == [DateHelper month:dataSourceDate] &&
            [DateHelper day:date] == [DateHelper day:dataSourceDate]
            ) {
            returnVal = YES;
        }
    }
    
    return returnVal;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSInteger daysInThisMonth = [DateHelper totaldaysInMonth:_date];
        NSInteger firstWeekday = [DateHelper firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i >= firstWeekday && i <= firstWeekday + daysInThisMonth - 1) {
            day = i - firstWeekday + 1;
            return YES;
        }
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_date];
    NSInteger firstWeekday = [DateHelper firstWeekdayInThisMonth:_date];
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    day = i - firstWeekday + 1;
    
    NSDate *date = [DateHelper dateInYear:[comp year] month:[comp month] day:day];
    self.selectDate = date;
    [self.collectionView reloadData];
}

#pragma -mark 懒加载

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        [_headerView setBackgroundColor:RGB16(0x295DC0)];
    }
    return _headerView;
}
-(UILabel *)weekLabel{
    if (!_weekLabel) {
        _weekLabel = [[UILabel alloc]init];
        [_weekLabel setTextColor:RGB16(0xffffff)];
        [_weekLabel setTextAlignment:NSTextAlignmentCenter];
        [_weekLabel setBackgroundColor:[UIColor blackColor]];
        _weekLabel.alpha = 0.15;
    }
    return _weekLabel;
}
-(UILabel *)monthLabel{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc]init];
        [_monthLabel setTextColor:RGB16(0xffffff)];
        [_monthLabel setFont:[UIFont systemFontOfSize:26]];
        [_monthLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _monthLabel;
}
-(UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc]init];
        [_dayLabel setFont:[UIFont boldSystemFontOfSize:130]];
        [_dayLabel setTextColor:RGB16(0xffffff)];
        [_dayLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _dayLabel;
}
-(UILabel *)yearLabel{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc]init];
        [_yearLabel setTextColor:RGB16(0xffffff)];
        [_yearLabel setFont:[UIFont systemFontOfSize:32]];
        _yearLabel.alpha = 0.5;
        [_yearLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _yearLabel;
}

-(UILabel *)groundColourMonthLabel{
    if (!_groundColourMonthLabel) {
        _groundColourMonthLabel = [[UILabel alloc]init];
        [_groundColourMonthLabel setFont:[UIFont boldSystemFontOfSize:230]];
        [_groundColourMonthLabel setTextColor:RGB16(0x000000)];
        _groundColourMonthLabel.alpha = 0.05;
        [_groundColourMonthLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _groundColourMonthLabel;
}

-(UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        CGFloat size = self.frame.size.width * 0.82;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(size/7, size/7);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        _collectionView.delegate = self;
        _collectionView.dataSource  = self;
        [_collectionView registerClass:[RCollectionViewCell class] forCellWithReuseIdentifier:@"RCollectionViewCell"];
        
    }
    return _collectionView;
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
