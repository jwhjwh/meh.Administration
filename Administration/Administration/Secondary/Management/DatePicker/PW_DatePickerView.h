//
//  PW_DatePickerView.h
//  ThreeDimensional
//
//  Created by 东方视界 on 16/12/26.
//  Copyright © 2016年 DFSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    
    // 开始日期
    DateTypeOfStart = 0,
    
    // 结束日期
    DateTypeOfEnd,
    
}DateType;
@class PW_DatePickerView;

@protocol PW_DatePickerViewDelegate <NSObject>
-(void) pickerView:(PW_DatePickerView *)pickerView didSelectDateString:(NSString *)dateString type:(DateType)type;
@end


@interface PW_DatePickerView : UIView

@property (nonatomic,weak) id<PW_DatePickerViewDelegate>delegate;

@property (nonatomic,strong) UIView *screenView;
@property (nonatomic, assign) DateType type;
- (instancetype)initDatePickerWithDefaultDate:(NSDate *)date
                            andDatePickerMode:(UIDatePickerMode )mode;

/**
 移除PickerView
 */
- (void)remove;

/**
 显示PickerView
 */
- (void)show;
@end
