//
//  ViewArtMonthPlan.m
//  Administration
//
//  Created by zhang on 2017/9/25.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewArtMonthPlan.h"
#import "ViewDatePick.h"

@interface ViewArtMonthPlan ()<ViewDatePickerDelegate,UITextFieldDelegate>
@property (nonatomic,weak)ViewDatePick *myDatePick;
@end

@implementation ViewArtMonthPlan

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
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 200)];
    [self addSubview:headerView];
    
    UIView *viewT = [[UIView alloc]init];
    viewT.backgroundColor = GetColor(192, 192, 192, 1);
    [headerView addSubview:viewT];
    [viewT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left);
        make.top.mas_equalTo(headerView.mas_top);
        make.right.mas_equalTo(headerView.mas_right);
        make.height.mas_equalTo(108);
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"  日期";
    label1.backgroundColor = [UIColor whiteColor];
    [viewT addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewT.mas_left);
        make.top.mas_equalTo(viewT.mas_top);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(70);
    }];
    
    UIButton *startDate = [[UIButton alloc]init];
    startDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    startDate.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [startDate setTitle:@"选择日期" forState:UIControlStateNormal];
    startDate.titleLabel.textAlignment = NSTextAlignmentLeft;
    startDate.tag = 100;
    [startDate addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [startDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [startDate setBackgroundColor:[UIColor whiteColor]];
    [viewT addSubview:startDate];
    [startDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right);
        make.top.mas_equalTo(viewT.mas_top);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(viewT.mas_right);
    }];
    self.buttonDate = startDate;
    
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"  职位";
    label3.backgroundColor = [UIColor whiteColor];
    [viewT addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewT.mas_left);
        make.top.mas_equalTo(label1.mas_bottom).offset(1);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(70);
    }];
    
    UILabel *labelPostion = [[UILabel alloc]init];
    labelPostion.text = [ShareModel shareModel].postionName;
    labelPostion.backgroundColor = [UIColor whiteColor];
    [viewT addSubview:labelPostion];
    [labelPostion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label3.mas_right);
        make.top.mas_equalTo(startDate.mas_bottom).offset(1);
        make.right.mas_equalTo(viewT.mas_right);
        make.height.mas_equalTo(35);
    }];
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.backgroundColor = [UIColor whiteColor];
    label4.text = @"  姓名";
    [viewT addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewT.mas_left);
        make.top.mas_equalTo(label3.mas_bottom).offset(1);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(70);
    }];
    
    UILabel *labelName = [[UILabel alloc]init];
    labelName.text = [USER_DEFAULTS valueForKey:@"name"];
    labelName.backgroundColor = [UIColor whiteColor];
    [viewT addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label4.mas_right);
        make.top.mas_equalTo(labelPostion.mas_bottom).offset(1);
        make.right.mas_equalTo(viewT.mas_right);
        make.height.mas_equalTo(35);
    }];
    
    UILabel *label5 = [[UILabel alloc]init];
    label5.text = @"本月任务";
    [headerView addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).offset(10);
        make.top.mas_equalTo(viewT.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    UIView *viewB = [[UIView alloc]init];
    viewB.layer.borderColor = GetColor(192, 192, 192, 1).CGColor;
    viewB.layer.borderWidth = 1.0f;
    [headerView addSubview:viewB];
    [viewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).offset(10);
        make.top.mas_equalTo(label5.mas_bottom).offset(8);
        make.right.mas_equalTo(headerView.mas_right).offset(-10);
        make.height.mas_equalTo(66);
    }];
    
    UILabel *labelP = [[UILabel alloc]init];
    labelP.text = @"品牌任务：计划";
    [viewB addSubview:labelP];
    [labelP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    MyTextField *textF1 = [[MyTextField alloc]init];
    textF1.delegate = self;
    [viewB addSubview:textF1];
    [textF1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelP.mas_right);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(21);
    }];
    self.textFiled1 = textF1;
    
    UILabel *labelwan = [[UILabel alloc]init];
    labelwan.text = @"万，冲刺";
    [viewB addSubview:labelwan];
    [labelwan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF1.mas_right);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    MyTextField *textF2 = [[MyTextField alloc]init];
    textF2.delegate = self;
    [viewB addSubview:textF2];
    [textF2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelwan.mas_right);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(45);
    }];
    self.textFiled2 = textF2;
    
    UILabel *labelj = [[UILabel alloc]init];
    labelj.text = @"万";
    [viewB addSubview:labelj];
    [labelj mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF2.mas_right);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelPer = [[UILabel alloc]init];
    labelPer.text = @"个人任务：计划";
    [viewB addSubview: labelPer];
    [labelPer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelP.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    MyTextField *textF3 = [[MyTextField alloc]init];
    textF3.delegate = self;
    [viewB addSubview:textF3];
    [textF3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelPer.mas_right);
        make.top.mas_equalTo(labelP.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(45);
    }];
    self.textFiled3 = textF3;
    
    UILabel *labelkj =[[UILabel alloc]init];
    labelkj.text = @"万，冲刺";
    [viewB addSubview:labelkj];
    [labelkj mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF3.mas_right);
        make.top.mas_equalTo(labelP.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    MyTextField *textF4 = [[MyTextField alloc]init];
    textF4.delegate = self;
    [viewB addSubview:textF4];
    [textF4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelkj.mas_right);
        make.top.mas_equalTo(labelP.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(45);
    }];
    self.textFiled4 = textF4;
    
    UILabel *labeldd = [[UILabel alloc]init];
    labeldd.text = @"万";
    [viewB addSubview:labeldd];
    [labeldd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF4.mas_right);
        make.top.mas_equalTo(labelP.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
}

-(void)showDatePicker
{
    ViewDatePick *myDatePick=  [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    [self endEditing:YES];
    myDatePick.delegate = self;
    [self.window addSubview:myDatePick];
    self.myDatePick = myDatePick;
}

-(void)getDate
{
    NSDate *date = self.myDatePick.datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringDate = [[formatter stringFromDate:date] substringToIndex:7];
    [self.buttonDate setTitle:stringDate forState:UIControlStateNormal];
}


@end
