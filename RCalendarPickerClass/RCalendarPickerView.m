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
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *weekLabel;
@property (nonatomic,strong) UILabel *monthLabel;
@property (nonatomic,strong) UILabel *dayLabel;
@property (nonatomic,strong) UILabel *yearLabel;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *weekDayArray;
@property (nonatomic,strong) NSArray *weekDayTextSupportsArray;
@property (nonatomic,strong) UILabel *groundColourMonthLabel;
@property (nonatomic,strong)NSArray *themeArray;
@property (nonatomic,strong)NSDate *selectDate;
@property (nonatomic,assign)UIColor *thisTheme;
@end

@implementation RCalendarPickerView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
        [self prepareData];
        [self prepareSwipe]; // 添加滑动翻页事件
    }
    return self;
}

#pragma mark - pu t

-(void)updateHeaderViewDate:(NSDate *)date {
    
    self.weekLabel.text = [NSString stringWithFormat:@"%@",self.weekDayTextSupportsArray[(int)[DateHelper weekday:date] - 1]];
    self.dayLabel.text = [NSString stringWithFormat:@"%d",(int)[DateHelper day:date]];
    self.groundColourMonthLabel.text = [NSString stringWithFormat:@"%d",(int)[DateHelper month:date]];
    
    if (self.isZn) {
        self.monthLabel.text = [NSString stringWithFormat:@"%d月 %@",(int)[DateHelper month:date],[DateHelper getChineseCalendarMonthsWithDate:date]];
        self.yearLabel.text = [NSString stringWithFormat:@"%d %@",(int)[DateHelper year:date],[DateHelper getChineseCalendarYearsWithDate:date]];
    }
    else{
        self.monthLabel.text = [NSString stringWithFormat:@"%d月",(int)[DateHelper month:date]];
        self.yearLabel.text = [NSString stringWithFormat:@"%d",(int)[DateHelper year:date]];
    }
}
-(void)setToday:(NSDate *)today{
    
    _today = today;
    [self updateHeaderViewDate:today];
}
- (void)setDate:(NSDate *)date
{
    _date = date;
    self.thisTheme = self.themeArray[(arc4random() % 8)];
    [self.headerView setBackgroundColor:self.thisTheme];
    self.groundColourMonthLabel.text = [NSString stringWithFormat:@"%d",(int)[DateHelper month:date]];
    [self.collectionView reloadData];
}

-(void)hide {
    [self removeFromSuperview];
}
#pragma mark - Layout UI准备和布局相关

-(void)prepareData{
    
    self.weekDayTextSupportsArray = @[@"Sunday",
                                      @"Monday",
                                      @"Tuesday",
                                      @"Wednesday",
                                      @"Thursday",
                                      @"Friday",
                                      @"Saturday"];
    self.weekDayArray = @[@"日",
                          @"一",
                          @"二",
                          @"三",
                          @"四",
                          @"五",
                          @"六"];
    
    self.themeArray = @[RGB16(0X1abc9c),
                        RGB16(0X27ae60),
                        RGB16(0X2980b9),
                        RGB16(0X2c3e50),
                        RGB16(0Xf39c12),
                        RGB16(0Xc0392b),
                        RGB16(0X7f8c8d),
                        RGB16(0X8e44ad)];
}

- (void)prepareUI{
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    [self addSubview:self.headerView];
    [self addSubview:self.collectionView];
    [self addSubview:self.groundColourMonthLabel];
    
    
    [self.headerView addSubview:self.weekLabel];
    [self.headerView addSubview:self.monthLabel];
    [self.headerView addSubview:self.dayLabel];
    [self.headerView addSubview:self.yearLabel];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(60);
        make.centerX.equalTo(self);
        make.width.offset(self.frame.size.width * 0.82);
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
        make.bottom.equalTo(self.headerView).offset(-15);
    }];
    [self.groundColourMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(5);
        make.centerX.equalTo(self);
        make.width.height.equalTo(self.collectionView);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.centerX.equalTo(self);
        make.width.height.offset(self.frame.size.width * 0.82);
    }];
    
};

#pragma -mark click
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
- (void)previouseAction {
    [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        self.date = [DateHelper lastMonth:_date];
    } completion:nil];
}

- (void)nexAction {
    [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        self.date = [DateHelper nextMonth:_date];
    } completion:nil];
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
    cell.bgViewColor = self.thisTheme;
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
            
            if (self.isZn) {
                 cell.znDay = [DateHelper getChineseCalendarDaysWithDate:date];
            }
            cell.dayLabelTextColor = RGB16(0x5d5d5d);
            //this month 当前月 当前天
            BOOL isThisMonth = [DateHelper month:_date] == [DateHelper month:[NSDate date]];
            if (day == [DateHelper day:_date] && isThisMonth) {
                cell.isToDay = YES;
                cell.dayLabelTextColor = RGB16(0xffffff);
            }
            //选择的天
            if(self.selectDate != nil && day == [DateHelper day:self.selectDate] && [DateHelper month:self.date] == [DateHelper month:self.selectDate])
            {
                cell.isSelected = YES;
            }
//            if ([_today isEqualToDate:_date]) {
//            } else if ([_today compare:_date] == NSOrderedAscending) {
//                cell.dayLabelTextColor = RGB16(0x5d5d5d);
//            }
        }
    }
    return cell;
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
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    NSInteger firstWeekday = [DateHelper firstWeekdayInThisMonth:_date];
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    day = i - firstWeekday + 1;
    
    NSDate *date = [DateHelper dateInYear:[comp year] month:[comp month] day:day];
    self.selectDate = date;
    [self updateHeaderViewDate:date];
    [self.collectionView reloadData];
    if (self.complete) {
        self.complete(day, [comp month], [comp year] ,date);
    }
    // [self hide]; //选择后是否关闭日历
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

@end
