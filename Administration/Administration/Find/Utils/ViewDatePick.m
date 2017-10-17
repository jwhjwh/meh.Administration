//
//  ViewDatePick.m
//  suibian
//
//  Created by zhang on 2017/9/15.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "ViewDatePick.h"
#import "Masonry.h"
@implementation ViewDatePick

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    self.backgroundColor = [UIColor colorWithRed:126.0f/255.0f green:127/255.0f blue:128/255.0f alpha:0.5];
    self.userInteractionEnabled = YES;
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(260);
        make.width.mas_equalTo(300);
    }];
    
    
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:17];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    label.text = [formatter stringFromDate:date];
    
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
        make.left.mas_equalTo(view.mas_left);
        make.right.mas_equalTo(view.mas_right);
        make.height.mas_equalTo(34);
    }];
    self.labelTime = label;
    
    UIButton *buttonSure = [[UIButton alloc]init];
    [buttonSure setTitle:@"确定" forState:UIControlStateNormal];
    [buttonSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonSure setBackgroundColor:[UIColor whiteColor]];
    [buttonSure addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonSure];
    
    [buttonSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view.mas_right);
        make.bottom.mas_equalTo(view.mas_bottom);
        make.left.mas_equalTo(view.mas_centerX).offset(0.5);
        make.height.mas_equalTo(40);
    }];
    self.buttonSure = buttonSure;
    
    
    UIButton *buttonCancle = [[UIButton alloc]init];
    [buttonCancle setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCancle setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonCancle setBackgroundColor:[UIColor whiteColor]];
    [buttonCancle addTarget:self action:@selector(cancleButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonCancle];
    
    [buttonCancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left);
        make.bottom.mas_equalTo(view.mas_bottom);
        make.right.mas_equalTo(view.mas_centerX).offset(-0.5);
        make.height.mas_equalTo(40);
    }];
    
    self.buttonCancle = buttonCancle;
   
    UIDatePicker *datepicker = [[UIDatePicker alloc]init];
    [datepicker setBackgroundColor:[UIColor whiteColor]];
    if (self.mode==UIDatePickerModeDateAndTime) {
        datepicker.datePickerMode = UIDatePickerModeDateAndTime;
    }else
    {
    datepicker.datePickerMode = UIDatePickerModeDate;
    }
    [datepicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:datepicker];
    [datepicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(1);
        make.left.mas_equalTo(view.mas_left);
        make.right.mas_equalTo(view.mas_right);
        make.bottom.mas_equalTo(buttonSure.mas_top).offset(-1);
    }];
    self.datePick = datepicker;
}

//监听时间选择器值的变化

-(void)dateChange:(UIDatePicker *)datepick
{
    NSDate *date = [datepick date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.labelTime.text = [formatter stringFromDate:date];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

-(void)cancleButton
{
    [self removeFromSuperview];
}

-(void)sureButton
{
    if ([self.delegate respondsToSelector:@selector(getDate)]) {
        [self.delegate getDate];
    }
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
