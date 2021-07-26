//
//  ZYCalendarManager.h
//  Example
//
//  Created by Daniel on 2016/10/30.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTDateHelper.h"

typedef NS_ENUM(NSInteger, ZYCalendarSelectionType) {
    ZYCalendarSelectionTypeSingle = 0,          // 单选
    ZYCalendarSelectionTypeMultiple = 1,        // 多选
    ZYCalendarSelectionTypeRange = 2            // 范围选择
};
static NSString *Identifier = @"WeekView";
@class ZYWeekView;

@interface ZYCalendarManager : NSObject
// 计算日期
@property (nonatomic, strong)JTDateHelper *helper;

@property (nonatomic, strong)NSDateFormatter *titleDateFormatter;
@property (nonatomic, strong)NSDateFormatter *dayDateFormatter;
@property (nonatomic, strong)NSDateFormatter *dateFormatter;

@property (nonatomic, assign)CGFloat dayViewGap;
@property (nonatomic, assign)CGFloat dayViewWidth;
@property (nonatomic, assign)CGFloat dayViewHeight;

// 图片渲染
@property (nonatomic, assign)UIImageRenderingMode imageRenderingMode;

@property (nonatomic, strong)UIColor *selectedBackgroundColor;
@property (nonatomic, strong)UIColor *selectedTextColor;
@property (nonatomic, strong)UIColor *defaultTextColor;
@property (nonatomic, strong)UIColor *disableTextColor;

@property (nonatomic, strong)NSDate *date;

@property (nonatomic, strong)NSMutableArray <NSDate *>*selectedDateArray;

@property (nonatomic, assign)ZYCalendarSelectionType selectionType;

@property (nonatomic, assign)BOOL canSelectPastDays;

@property (nonatomic, assign)BOOL canSelectFutureDays;

// Set '0' to selecting unlimited date ranges
@property (nonatomic, assign)NSUInteger maxDaysAllowedInRange;

@property (nonatomic, assign)NSInteger maxSelectPastMonths;

@property (nonatomic, copy)void(^dayViewBlock)(ZYCalendarManager *manager,id);


- (void)registerWeekViewWithReuseIdentifier:(NSString *)identifier;
- (void)addToReusePoolWithView:(UIView *)view identifier:(NSString *)identifier;
- (ZYWeekView *)dequeueReusableWeekViewWithIdentifier:(NSString *)identifier;
- (void) resetCalendar;
-(void)setSelectedDates:(NSMutableArray <NSDate *>*)selectedDateArray;
@end
