//
//  ViewBuessWeekSummary.m
//  Administration
//
//  Created by zhang on 2017/9/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewBuessWeekSummary.h"

#import "ViewDatePick.h"

@interface ViewBuessWeekSummary ()<UITextFieldDelegate,ViewDatePickerDelegate>
@property (nonatomic,weak)ViewDatePick *myDatePick;
@property (nonatomic,assign)NSUInteger buttonTAag;
@end

@implementation ViewBuessWeekSummary

   
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
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 250)];
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
    [startDate addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
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
    [endDate addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
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
    labelPlan.text = @"本周完成计划情况";
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
        make.height.mas_equalTo(130);
    }];
    
    UILabel *labela = [[UILabel alloc]init];
    labela.font =   [UIFont systemFontOfSize:13];
    labela.text = @"原计划陌拜";
    [viewB addSubview:labela];
    [labela mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
          [UIFont systemFontOfSize:21];
    }];
    
    MyTextField *textF1 = [[MyTextField alloc]init];
    textF1.font =   [UIFont systemFontOfSize:13];
    textF1.delegate = self;
    [viewB addSubview:textF1];
    [textF1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labela.mas_right);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
        make.width.mas_equalTo(45);
          [UIFont systemFontOfSize:21];
    }];
    self.textFiled1 = textF1;
    
    UILabel *labelb = [[UILabel alloc]init];
    labelb.text = @"家店，实际陌拜";
    labelb.font =   [UIFont systemFontOfSize:13];
    [viewB addSubview:labelb];
    [labelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF1.mas_right);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
          [UIFont systemFontOfSize:21];
    }];
    
    MyTextField *textF2 = [[MyTextField alloc]init];
    textF2.font =   [UIFont systemFontOfSize:13];
    textF2.delegate = self;
    [viewB addSubview:textF2];
    [textF2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelb.mas_right);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
        make.width.mas_equalTo(45);
          [UIFont systemFontOfSize:21];
    }];
    self.textFiled2 = textF2;
    
    UILabel *labelc = [[UILabel alloc]init];
    labelc.text = @"家";
    labelc.font =   [UIFont systemFontOfSize:13];
    [viewB addSubview:labelc];
    [labelc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF2.mas_right);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
          [UIFont systemFontOfSize:21];
    }];
    
    UILabel *labeld = [[UILabel alloc]init];
    labeld.text = @"其中专业美容院";
    labeld.font =   [UIFont systemFontOfSize:13];
    [viewB addSubview:labeld];
    [labeld mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labela.mas_bottom).offset(8);
          [UIFont systemFontOfSize:21];
    }];
    MyTextField *textF3 = [[MyTextField alloc]init];
    textF3.font =   [UIFont systemFontOfSize:13];
    textF3.delegate = self;
    [viewB addSubview:textF3];
    [textF3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labeld.mas_right);
        make.top.mas_equalTo(labela.mas_bottom).offset(8);
        make.width.mas_equalTo(45);
          [UIFont systemFontOfSize:21];
    }];
    self.textFiled3 = textF3;
    
    UILabel *labele = [[UILabel alloc]init];
    labele.text = @"家，前店后院";
    labele.font =   [UIFont systemFontOfSize:13];
    [viewB addSubview:labele];
    [labele mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF3.mas_right);
        make.top.mas_equalTo(labela.mas_bottom).offset(8);
          [UIFont systemFontOfSize:21];
    }];
    
    MyTextField *textF4 = [[MyTextField alloc]init];
    textF4.font =   [UIFont systemFontOfSize:13];
    textF4.delegate = self;
    [viewB addSubview:textF4];
    [textF4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labele.mas_right);
        make.top.mas_equalTo(labela.mas_bottom).offset(8);
          [UIFont systemFontOfSize:21];
        make.width.mas_equalTo(45);
    }];
    self.textFiled4 = textF4;
    
    UILabel *labelf =[[UILabel alloc]init];
    labelf.text = @"家";
    labelf.font =   [UIFont systemFontOfSize:13];
    [viewB addSubview:labelf];
    [labelf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF4.mas_right);
        make.top.mas_equalTo(labela.mas_bottom).offset(8);
          [UIFont systemFontOfSize:21];
    }];
    
    UILabel *labelg = [[UILabel alloc]init];
    labelg.text = @"确定意向";
    labelg.font =   [UIFont systemFontOfSize:13];
    [viewB addSubview:labelg];
    [labelg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labeld.mas_bottom).offset(8);
          [UIFont systemFontOfSize:21];
    }];
    
    MyTextField *textF5 = [[MyTextField alloc]init];
    textF5.font =   [UIFont systemFontOfSize:13];
    textF5.delegate = self;
    [viewB addSubview:textF5];
    [textF5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelg.mas_right);
        make.top.mas_equalTo(labeld.mas_bottom).offset(8);
        make.width.mas_equalTo(45);
          [UIFont systemFontOfSize:21];
    }];
    self.textFiled5 = textF5;
    
    UILabel *labelh = [[UILabel alloc]init];
    labelh.text = @"家，实际达成合作";
    labelh.font =   [UIFont systemFontOfSize:13];
    [viewB addSubview:labelh];
    [labelh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF5.mas_right);
        make.top.mas_equalTo(labeld.mas_bottom).offset(8);
          [UIFont systemFontOfSize:21];
    }];
    
    MyTextField *textF6 = [[MyTextField alloc]init];
    textF6.font =   [UIFont systemFontOfSize:13];
    textF6.delegate = self;
    [viewB addSubview:textF6];
    [textF6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelh.mas_right);
        make.top.mas_equalTo(labeld.mas_bottom).offset(8);
        make.width.mas_equalTo(45);
          [UIFont systemFontOfSize:21];
    }];
    self.textFiled6 = textF6;
    
    UILabel *jk= [[UILabel alloc]init];
    jk.font =   [UIFont systemFontOfSize:13];
    jk.text = @"家";
    [viewB addSubview:jk];
    [jk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF6.mas_right);
        make.top.mas_equalTo(labeld.mas_bottom).offset(8);
          [UIFont systemFontOfSize:21];
    }];
    
    UILabel *labeli = [[UILabel alloc]init];
    labeli.text = @"实际回款";
    labeli.font =   [UIFont systemFontOfSize:13];
    [viewB addSubview:labeli];
    [labeli mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelg.mas_bottom).offset(8);
          [UIFont systemFontOfSize:21];
    }];
    
    MyTextField *textF7 = [[MyTextField alloc]init];
    textF7.font =   [UIFont systemFontOfSize:13];
    textF7.delegate = self;
    [viewB addSubview:textF7];
    [textF7  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labeli.mas_right);
        make.top.mas_equalTo(labelg.mas_bottom).offset(8);
        make.width.mas_equalTo(45);
          [UIFont systemFontOfSize:21];
    }];
    self.textFiled7 = textF7;
    
    UILabel *labelj = [[UILabel alloc]init];
    labelj.text = @"万";
    labelj.font =   [UIFont systemFontOfSize:13];
    [viewB addSubview:labelj];
    [labelj mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF7.mas_right);
        make.top.mas_equalTo(labelg.mas_bottom).offset(8);
          [UIFont systemFontOfSize:21];
    }];
    
}

-(void)showDatePicker:(UIButton *)button
{
    [self endEditing:YES];
    self.buttonTAag = button.tag;
    ViewDatePick *myDatePick = [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    myDatePick.delegate = self;
    [self addSubview:myDatePick];
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
