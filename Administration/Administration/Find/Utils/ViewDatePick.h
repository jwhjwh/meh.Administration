//
//  ViewDatePick.h
//  suibian
//
//  Created by zhang on 2017/9/15.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewDatePickerDelegate <NSObject>

@required
-(void)getDate;

@end

@interface ViewDatePick : UIView

@property (nonatomic,weak)UIButton *buttonCancle;
@property (nonatomic,weak)UIButton *buttonSure;
@property (nonatomic,weak)UILabel *labelTime;
@property (nonatomic,weak)UIDatePicker *datePick;
@property (nonatomic)UIDatePickerMode mode;
@property (nonatomic,assign)id<ViewDatePickerDelegate>delegate;

@end
