//
//  ViewBuessWeekTable.m
//  Administration
//
//  Created by zhang on 2017/9/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewBuessWeekTable.h"
#import "ViewDatePick.h"

@interface ViewBuessWeekTable ()<UITextFieldDelegate,ViewDatePickerDelegate>
@property (nonatomic,weak)ViewDatePick *myDatePick;
@property (nonatomic,assign)NSUInteger buttonTAag;
@end


@implementation ViewBuessWeekTable

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length>=4) {
        textField.text = [textField.text substringToIndex:3];
    }
    return YES;
}

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
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 180)];
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
    [startDate setTitle:@"选择日期" forState:UIControlStateNormal];
    startDate.titleLabel.textAlignment = NSTextAlignmentLeft;
    startDate.tag = 100;
    [startDate addTarget:self action:@selector(showDatePicker2:) forControlEvents:UIControlEventTouchUpInside];
    [startDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [startDate setBackgroundColor:[UIColor whiteColor]];
    [viewT addSubview:startDate];
    [startDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right);
        make.top.mas_equalTo(viewT.mas_top);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(120);
    }];
    self.startDate = startDate;
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"至";
    label2.backgroundColor = [UIColor whiteColor];
    [viewT addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(startDate.mas_right);
        make.top.mas_equalTo(viewT.mas_top);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(30);
    }];
    
    UIButton *endDate = [[UIButton alloc]init];
    [endDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [endDate setTitle:@"选择日期" forState:UIControlStateNormal];
    [endDate setBackgroundColor:[UIColor whiteColor]];
    [endDate addTarget:self action:@selector(showDatePicker2:) forControlEvents:UIControlEventTouchUpInside];
    endDate.tag = 200;
    [viewT addSubview:endDate];
    [endDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label2.mas_right);
        make.right.mas_equalTo(viewT.mas_right);
        make.top.mas_equalTo(viewT.mas_top);
        make.height.mas_equalTo(35);
    }];
    self.endDate = endDate;
    
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
    
    UILabel *labelPlan = [[UILabel alloc]init];
    labelPlan.text = @"本周任务计划";
    [headerView addSubview:labelPlan];
    [labelPlan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).offset(10);
        make.top.mas_equalTo(viewT.mas_bottom).offset(8);
        make.right.mas_equalTo(headerView.mas_right);
        make.height.mas_equalTo(21);
    }];
    
    UIView *viewB = [[UIView alloc]init];
    viewB.layer.borderColor = GetColor(192, 192, 1921, 1).CGColor;
    viewB.layer.borderWidth = 1.0f;
    [headerView addSubview:viewB];
    [viewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).offset(10);
        make.right.mas_equalTo(headerView.mas_right).offset(-10);
        make.top.mas_equalTo(labelPlan.mas_bottom).offset(8);
        make.height.mas_equalTo(52);
    }];
    
    UILabel *labeljihua = [[UILabel alloc]init];
    labeljihua.text = @"计划陌拜";
    labeljihua.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labeljihua];
    [labeljihua mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textF1 = [[MyTextField alloc]init];
    textF1.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:textF1];
    [textF1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labeljihua.mas_right);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiled1 = textF1;
    
    UILabel *labeldou = [[UILabel alloc]init];
    labeldou.font = [UIFont systemFontOfSize:12];
    labeldou.text = @"家店，回访";
    [viewB addSubview:labeldou];
    [labeldou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF1.mas_right);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textF2 = [[MyTextField alloc]init];
    textF2.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:textF2];
    [textF2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labeldou.mas_right);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiled2 = textF2;
    
    UILabel *labelwan = [[UILabel alloc]init];
    labelwan.text = @"家意向店";
    labelwan.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelwan];
    [labelwan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF2.mas_right);
        make.top.mas_equalTo(viewB.top).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelyuji = [[UILabel alloc]init];
    labelyuji.text = @"预计达成合作";
    labelyuji.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelyuji];
    [labelyuji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labeljihua.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textF3 = [[MyTextField alloc]init];
    textF3.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:textF3];
    [textF3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelyuji.mas_right);
        make.top.mas_equalTo(labeljihua.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiled3 = textF3;
    
    UILabel *labeldou1 = [[UILabel alloc]init];
    labeldou1.text = @"家，预计回款";
    labeldou1.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labeldou1];
    [labeldou1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF3.mas_right);
        make.top.mas_equalTo(labeljihua.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textF4 = [[MyTextField alloc]init];
    textF4.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:textF4];
    [textF4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labeldou1.mas_right);
        make.top.mas_equalTo(labeljihua.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiled4 = textF4;
    
    UILabel *labelyuan = [[UILabel alloc]init];
    labelyuan.text = @"万元";
    labelyuan.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelyuan];
    [labelyuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF4.mas_right);
        make.top.mas_equalTo(labeljihua.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
}

-(void)showDatePicker2:(UIButton *)button
{
    self.buttonTAag = button.tag;
    ViewDatePick *myDatePick = [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    myDatePick.delegate = self;
    [self.window addSubview:myDatePick];
    self.myDatePick = myDatePick;
}

-(void)getDate
{
    NSDate *date = self.myDatePick.datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringDate = [formatter stringFromDate:date];
    
    if (self.buttonTAag==100) {
        [self.startDate setTitle:stringDate forState:UIControlStateNormal];
        [self.startDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    }else
    {
        [self.endDate setTitle:stringDate forState:UIControlStateNormal];
        [self.endDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
