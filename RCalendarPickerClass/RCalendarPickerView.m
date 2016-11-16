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
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UILabel *weekLabel;
@property (nonatomic,strong)UILabel *monthLabel;
@property (nonatomic,strong)UILabel *dayLabel;
@property (nonatomic,strong)UILabel *yearLabel;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *weekDayArray;
@property (nonatomic,strong) NSArray *weekDayTextSupportsArray;
@end

@implementation RCalendarPickerView

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        [self prepareUI];
        [self prepareData];
    }
    return self;
}
-(void)prepareData{
    self.weekDayTextSupportsArray = @[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    self.weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
}
-(void)setToday:(NSDate *)today{
    _today = today;
    self.weekLabel.text = [NSString stringWithFormat:@"%@",self.weekDayTextSupportsArray[(int)[DateHelper firstWeekdayInThisMonth:today]+1]];
    self.monthLabel.text = [NSString stringWithFormat:@"%d月",(int)[DateHelper month:today]];
    self.dayLabel.text = [NSString stringWithFormat:@"%d",(int)[DateHelper day:today]];
    self.yearLabel.text = [NSString stringWithFormat:@"%d",(int)[DateHelper year:today]];
}
#pragma mark - Layout UI准备和布局相关
- (void)prepareUI{
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    [self addSubview:self.headerView];
    [self addSubview:self.collectionView];
    
    [self.headerView addSubview:self.weekLabel];
    [self.headerView addSubview:self.monthLabel];
    [self.headerView addSubview:self.dayLabel];
    [self.headerView addSubview:self.yearLabel];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(60);
        make.centerX.equalTo(self);
        make.width.offset(MainScreenWidth * 0.82);
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
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.centerX.equalTo(self);
        make.width.height.offset(MainScreenWidth * 0.82);
    }];
    
};

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
    if (indexPath.section == 0) {
        
        cell.day = self.weekDayArray[indexPath.row];
        cell.dayLabelTextColor = RGB16(0x15cc9c);
    } else {
        NSInteger daysInThisMonth = [DateHelper totaldaysInMonth:_date];
        NSInteger firstWeekday = [DateHelper firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i < firstWeekday) {
            cell.day = @"";
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            cell.day = @"";
        }else{
            day = i - firstWeekday + 1;
            cell.day = [NSString stringWithFormat:@"%i",(int)day];
            cell.dayLabelTextColor = RGB16(0x6f6f6f);
            //this month
            if ([_today isEqualToDate:_date]) {
                if (day == [DateHelper day:_date]) {
                    cell.isSelected = YES;
                    cell.dayLabelTextColor = RGB16(0x4898eb);
                } else if (day > [DateHelper day:_date]) {
                    cell.dayLabelTextColor = RGB16(0xcbcbcb);
                }
            } else if ([_today compare:_date] == NSOrderedAscending) {
                cell.dayLabelTextColor = RGB16(0xcbcbcb);
            }
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
            //this month
            //            if ([_today isEqualToDate:_date]) {
            //                if (day <= [DateHelper day:_date]) {
            //                    return YES;
            //                }
            //            } else if ([_today compare:_date] == NSOrderedDescending) {
            //                return YES;
            //            }
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
    if (self.calendarBlock) {
        self.calendarBlock(day, [comp month], [comp year]);
    }
}


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

-(UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        CGFloat size = MainScreenWidth * 0.82;
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
