//
//  ViewBack.m
//  testDatePick
//
//  Created by zhang on 2017/8/22.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "ViewBack.h"

@interface ViewBack()
@property (nonatomic,weak)UIView *viewB;
@property (nonatomic,weak)UILabel *labelTime;
@property (nonatomic,weak)UIDatePicker *dataPick;
@property (nonatomic,weak)UIButton *buttonCancle;
@property (nonatomic,weak)UIButton *buttonSure;
@end
@implementation ViewBack


-(instancetype)initWithFrame:(CGRect)frame
{
    self=  [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    UIView *viewB = [[UIView alloc]initWithFrame:CGRectMake(0,0, 300, 262)];
    viewB.backgroundColor = GetColor(126, 127, 128, 1);
//    viewB.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    viewB.layer.borderWidth = 1.0f;
    viewB.center = self.center;
    [self addSubview:viewB];
    self.viewB = viewB;
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, viewB.frame.size.width, 30)];
    labelTitle.textColor = [UIColor lightGrayColor];
    labelTitle.backgroundColor = [UIColor whiteColor];
    [viewB addSubview:labelTitle];
    self.labelTitle = labelTitle;
    
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 31, viewB.frame.size.width, 30)];
    labelTime.backgroundColor = [UIColor whiteColor];
    labelTime.textAlignment = UITextAlignmentCenter;
    NSDate *theDate = self.dataPick.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    self.labelTime.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:theDate]];
    [viewB addSubview:labelTime];
    self.labelTime = labelTime;
    
    UIDatePicker *datePick = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 62, viewB.frame.size.width, 158)];
    datePick.backgroundColor = [UIColor whiteColor];
    datePick.datePickerMode = UIDatePickerModeDate;
    [datePick addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    [viewB addSubview:datePick];
    self.dataPick = datePick;
    
    UIButton *buttonCancle = [[UIButton alloc]initWithFrame:CGRectMake(0, 221, viewB.frame.size.width/2, 40)];
    [buttonCancle setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCancle setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonCancle setBackgroundColor:[UIColor whiteColor]];
    [buttonCancle addTarget:self action:@selector(cacleButton) forControlEvents:UIControlEventTouchUpInside];
    [viewB addSubview:buttonCancle];
    self.buttonCancle = buttonCancle;
    
    UIButton *buttonSure = [[UIButton alloc]initWithFrame:CGRectMake(viewB.frame.size.width/2+1, 221, viewB.frame.size.width/2, 40)];
    [buttonSure setTitle:@"确定" forState:UIControlStateNormal];
    [buttonSure setBackgroundColor:[UIColor whiteColor]];
    [buttonSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonSure addTarget:self action:@selector(surebutton) forControlEvents:UIControlEventTouchUpInside];
    [viewB addSubview:buttonSure];
    self.buttonSure = buttonSure;
}

- (void)dateChanged
{
    NSDate *theDate = self.dataPick.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    self.labelTime.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:theDate]];
}

-(void)surebutton
{
    NSDate *theDate = self.dataPick.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    self.startDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:theDate]];
    [self removeFromSuperview];
    
}

-(void)cacleButton
{

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
