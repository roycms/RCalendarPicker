//
//  RCalendarPickerView.h
//  RCalendarPicker
//
//  Created by roycms on 2016/11/16.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "RRGB.h"
#import "DateHelper.h"
#define MainScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define MainScreenWidth  ([UIScreen mainScreen].bounds.size.width)

@interface RCalendarPickerView : UIView<UICollectionViewDelegate , UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSDate *today;
@property (nonatomic,copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);

@end
