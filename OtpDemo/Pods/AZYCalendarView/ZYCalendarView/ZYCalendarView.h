//
//  ZYCalendarView.h
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYCalendarManager.h"

@class ZYCalendarView;

@interface ZYCalendarView : UIScrollView
@property (nonatomic, strong)NSDate *maxDate;
@property (nonatomic, strong)NSDate *selectedDate;
@property (nonatomic, strong)ZYCalendarManager *manager;
@property (nonatomic, copy)void(^dayViewBlock)(ZYCalendarManager *manager,id);

@end
