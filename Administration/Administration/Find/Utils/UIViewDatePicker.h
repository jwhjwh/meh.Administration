//
//  UIViewDatePicker.h
//  testCalender
//
//  Created by zhang on 2017/11/23.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDJDatePickerView.h"
#import "CalendarHeader.h"

@protocol UIViewDatePickerDelegate <NSObject>

@required
-(void)getChooseDate;

@end
typedef void  (^BAELOCKckkkk)(NSString *content,NSString *oldcontent,NSString *flag);
@interface UIViewDatePicker : UIView<IDJDatePickerViewDelegate>

@property (nonatomic,assign)id<UIViewDatePickerDelegate>delegate;

@property (nonatomic,strong)NSString *stringChinese;
@property (nonatomic,strong)NSString *stringGregorian;
@property (nonatomic,strong)NSString *flagggg;

@property (nonatomic,copy)BAELOCKckkkk blcokStrrrr;

@end
