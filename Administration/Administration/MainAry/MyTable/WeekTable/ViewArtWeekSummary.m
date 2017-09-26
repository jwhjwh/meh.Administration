//
//  ViewArtWeekSummary.m
//  Administration
//
//  Created by zhang on 2017/9/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewArtWeekSummary.h"

@interface ViewArtWeekSummary ()<UITextFieldDelegate,ViewDatePickerDelegate>
@property (nonatomic,weak)ViewDatePick *myDatePick;
@property (nonatomic,assign)NSUInteger buttonTAag;
@end

@implementation ViewArtWeekSummary

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
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 600)];
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
    startDate.userInteractionEnabled = self.userIner;
    [startDate addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [startDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [startDate setBackgroundColor:[UIColor whiteColor]];
    [viewT addSubview:startDate];
    [startDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right);
        make.top.mas_equalTo(viewT.mas_top);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(100);
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
    endDate.userInteractionEnabled = self.userIner;
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
    labelPlan.text = @"本周任务总结";
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
        make.height.mas_equalTo(400);
    }];
    
    UILabel *labelBrand = [[UILabel alloc]init];
    labelBrand.text = @"品牌任务";
    [viewB addSubview:labelBrand];
    [labelBrand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(viewB.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *label5 = [[UILabel alloc]init];
    label5.text = @"本周任务";
    label5.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelBrand.mas_bottom).offset(16);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textFiled1 = [[MyTextField alloc]init];
    textFiled1.userInteractionEnabled = self.userIner;
    textFiled1.font = [UIFont systemFontOfSize:12];
    textFiled1.textAlignment = NSTextAlignmentCenter;
    textFiled1.delegate = self;
    [viewB addSubview:textFiled1];
    [textFiled1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label5.mas_right);
        make.top.mas_equalTo(labelBrand.mas_bottom).offset(16);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiled1=  textFiled1;
    
    UILabel *label6 = [[UILabel alloc]init];
    label6.text = @"万元";
    label6.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textFiled1.mas_right);
        make.top.mas_equalTo(labelBrand.mas_bottom).offset(16);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelA = [[UILabel alloc]init];
    labelA.text = @"本周原预计回款";
    labelA.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelA];
    [labelA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(label5.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textField2 = [[MyTextField alloc]init];
    textField2.delegate = self;
    textField2.userInteractionEnabled = self.userIner;
    textField2.font  =[UIFont systemFontOfSize:12];
    textField2.textAlignment = NSTextAlignmentCenter;
    [viewB addSubview:textField2];
    [textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelA.mas_right);
        make.top.mas_equalTo(label5.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiled2 = textField2;
    
    UILabel *label7 = [[UILabel alloc]init];
    label7.text = @"万元";
    label7.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:label7];
    [label7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textField2.mas_right);
        make.top.mas_equalTo(label5.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelB = [[UILabel alloc]init];
    labelB.text = @"实际回款";
    labelB.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelB];
    [labelB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelA.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textField3 = [[MyTextField alloc]init];
    textField3.delegate = self;
    textField3.userInteractionEnabled = self.userIner;
    textField3.font  =[UIFont systemFontOfSize:12];
    textField3.textAlignment = NSTextAlignmentCenter;
    [viewB addSubview:textField3];
    [textField3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelB.mas_right);
        make.top.mas_equalTo(labelA.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiled3 = textField3;
    
    UILabel *label8 = [[UILabel alloc]init];
    label8.text = @"万";
    label8.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:label8];
    [label8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textField3.mas_right);
        make.top.mas_equalTo(labelA.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelC = [[UILabel alloc]init];
    labelC.text = @"原预计出货";
    labelC.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelC];
    [labelC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelB.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textField4 = [[MyTextField alloc]init];
    textField4.delegate = self;
    textField4.userInteractionEnabled = self.userIner;
    textField4.font  =[UIFont systemFontOfSize:12];
    textField4.textAlignment = NSTextAlignmentCenter;
    [viewB addSubview:textField4];
    [textField4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelC.mas_right);
        make.top.mas_equalTo(labelB.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiled4 = textField4;
    
    UILabel *label9 = [[UILabel alloc]init];
    label9.text = @"万";
    label9.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:label9];
    [label9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textField4.mas_right);
        make.top.mas_equalTo(labelB.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelD = [[UILabel alloc]init];
    labelD.text = @"实际出货";
    labelD.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelD];
    [labelD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelC.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textField5 = [[MyTextField alloc]init];
    textField5.delegate = self;
    textField5.userInteractionEnabled = self.userIner;
    textField5.font  =[UIFont systemFontOfSize:12];
    textField5.textAlignment = NSTextAlignmentCenter;
    [viewB addSubview:textField5];
    [textField5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelD.mas_right);
        make.top.mas_equalTo(labelC.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiled5 = textField5;
    
    UILabel *labela = [[UILabel alloc]init];
    labela.text = @"万元";
    labela.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labela];
    [labela mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textField5.mas_right);
        make.top.mas_equalTo(textField4.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelleiji = [[UILabel alloc]init];
    labelleiji.text = @"现累计出货";
    labelleiji.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelleiji];
    [labelleiji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelD.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textField6 = [[MyTextField alloc]init];
    textField6.font = [UIFont systemFontOfSize:12];
    textField6.delegate =self;
    textField6.userInteractionEnabled = self.userIner;
    [viewB addSubview:textField6];
    [textField6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelleiji.mas_right);
        make.top.mas_equalTo(labelD.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiled6 = textField6;
    
    UILabel *labelwan = [[UILabel alloc]init];
    labelwan.text = @"万元";
    labelwan.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelwan];
    [labelwan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textField6.mas_right);
        make.top.mas_equalTo(labelD.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelkehu = [[UILabel alloc]init];
    labelkehu.text = @"客户账面余额：";
    labelkehu.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelkehu];
    [labelkehu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelleiji.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelzhouchu = [[UILabel alloc]init];
    labelzhouchu.text = @"周初约计";
    labelzhouchu.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelzhouchu];
    [labelzhouchu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelkehu.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textField7 = [[MyTextField alloc]init];
    textField7.font = [UIFont systemFontOfSize:12];
    textField7.delegate = self;
    textField7.userInteractionEnabled = self.userIner;
    [viewB addSubview:textField7];
    [textField7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelzhouchu.mas_right);
        make.top.mas_equalTo(labelkehu.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiled7 = textField7;
    
    UILabel *labeldou = [[UILabel alloc]init];
    labeldou.text = @"万元，周末";
    labeldou.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labeldou];
    [labeldou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textField7.mas_right);
        make.top.mas_equalTo(labelkehu.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textField8 = [[MyTextField alloc]init];
    textField8.font = [UIFont systemFontOfSize:12];
    textField8.delegate = self;
    textField8.userInteractionEnabled = self.userIner;
    [viewB addSubview:textField8];
    [textField8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labeldou.mas_right);
        make.top.mas_equalTo(labelkehu.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiled8 = textField8;
    
    UILabel *labelyuan = [[UILabel alloc]init];
    labelyuan.text = @"万元";
    labelyuan.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelyuan];
    [labelyuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textField8.mas_right);
        make.top.mas_equalTo(labelkehu.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelPerson = [[UILabel alloc]init];
    labelPerson.text = @"个人任务";
    [viewB addSubview:labelPerson];
    [labelPerson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelzhouchu.mas_bottom).offset(16);
        make.height.mas_equalTo(14);
    }];
    
    UILabel *labelE = [[UILabel alloc]init];
    labelE.text = @"本周任务";
    labelE.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelE];
    [labelE mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelPerson.mas_bottom).offset(16);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textField9 = [[MyTextField alloc]init];
    textField9.delegate = self;
    textField9.userInteractionEnabled = self.userIner;
    textField9.font  =[UIFont systemFontOfSize:12];
    textField9.textAlignment = NSTextAlignmentCenter;
    [viewB addSubview:textField9];
    [textField9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelE.mas_right);
        make.top.mas_equalTo(labelPerson.mas_bottom).offset(16);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiled9 = textField9;
    
    UILabel *labelb = [[UILabel alloc]init];
    labelb.text = @"万";
    labelb.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelb];
    [labelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textField9.mas_right);
        make.top.mas_equalTo(labelPerson.mas_bottom).offset(16);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelF = [[UILabel alloc]init];
    labelF.text = @"本周原预计回款";
    labelF.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelF];
    [labelF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelE.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textFieldA = [[MyTextField alloc]init];
    textFieldA.delegate = self;
    textFieldA.userInteractionEnabled = self.userIner;
    textFieldA.font  =[UIFont systemFontOfSize:12];
    textFieldA.textAlignment = NSTextAlignmentCenter;
    [viewB addSubview:textFieldA];
    [textFieldA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelF.mas_right);
        make.top.mas_equalTo(labelE.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiledA = textFieldA;
    
    UILabel *labelc = [[UILabel alloc]init];
    labelc.text = @"万";
    labelc.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelc];
    [labelc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textFieldA.mas_right);
        make.top.mas_equalTo(labelE.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelG = [[UILabel alloc]init];
    labelG.text = @"实际回款";
    labelG.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelG];
    [labelG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelF.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textFieldB = [[MyTextField alloc]init];
    textFieldB.delegate = self;
    textFieldB.userInteractionEnabled = self.userIner;
    textFieldB.font  =[UIFont systemFontOfSize:12];
    textFieldB.textAlignment = NSTextAlignmentCenter;
    [viewB addSubview:textFieldB];
    [textFieldB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelG.mas_right);
        make.top.mas_equalTo(labelF.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiledB = textFieldB;
    
    UILabel *labeld = [[UILabel alloc]init];
    labeld.text = @"万";
    labeld.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labeld];
    [labeld mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textFieldB.mas_right);
        make.top.mas_equalTo(labelF.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelH = [[UILabel alloc]init];
    labelH.text = @"原预计出货";
    labelH.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelH];
    [labelH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelG.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textFieldC = [[MyTextField alloc]init];
    textFieldC.delegate = self;
    textFieldC.userInteractionEnabled = self.userIner;
    textFieldC.font  =[UIFont systemFontOfSize:12];
    textFieldC.textAlignment = NSTextAlignmentCenter;
    [viewB addSubview:textFieldC];
    [textFieldC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelH.mas_right);
        make.top.mas_equalTo(labelG.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiledC = textFieldC;
    
    UILabel *labele = [[UILabel alloc]init];
    labele.text = @"万";
    labele.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labele];
    [labele mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textField9.mas_right);
        make.top.mas_equalTo(labelG.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelI = [[UILabel alloc]init];
    labelI.text = @"实际出货";
    labelI.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelI];
    [labelI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelH.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textFieldD = [[MyTextField alloc]init];
    textFieldD.delegate = self;
    textFieldD.userInteractionEnabled = self.userIner;
    textFieldD.font  =[UIFont systemFontOfSize:12];
    textFieldD.textAlignment = NSTextAlignmentCenter;
    [viewB addSubview:textFieldD];
    [textFieldD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelI.mas_right);
        make.top.mas_equalTo(labelH.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiledD = textFieldD;
    
    UILabel *labelf = [[UILabel alloc]init];
    labelf.text = @"万";
    labelf.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelf];
    [labelf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textFieldD.mas_right);
        make.top.mas_equalTo(labelH.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelGleiji =[[UILabel alloc]init];
    labelGleiji.font = [UIFont systemFontOfSize:12];
    labelGleiji.text = @"现累计出货";
    [viewB addSubview:labelGleiji];
    [labelGleiji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labelI.mas_bottom).offset(8);
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textFieldE = [[MyTextField alloc]init];
    textFieldE.font = [UIFont systemFontOfSize:12];
    textFieldE.delegate =self;
    textFieldE.userInteractionEnabled = self.userIner;
    [viewB addSubview:textFieldE];
    [textFieldE mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelGleiji.mas_right);
        make.top.mas_equalTo(labelI.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiledE = textFieldE;
    
    UILabel *labelqkjk = [[UILabel alloc]init];
    labelqkjk.text = @"万元";
    labelqkjk.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelqkjk];
    [labelqkjk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textFieldE.mas_right);
        make.top.mas_equalTo(labelH.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelyue = [[UILabel alloc]init];
    labelyue.text = @"客户账面余额：";
    labelyue.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelyue];
    [labelyue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelGleiji.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labeldd = [[UILabel alloc]init];
    labeldd.text = @"周初约计";
    labeldd.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labeldd];
    [labeldd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(5);
        make.top.mas_equalTo(labelyue.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textFieldF = [[MyTextField alloc]init];
    textFieldF.font = [UIFont systemFontOfSize:12];
    textFieldF.delegate =self;
    textFieldF.userInteractionEnabled = self.userIner;
    [viewB addSubview:textFieldF];
    [textFieldF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labeldd.mas_right);
        make.top.mas_equalTo(labelyue.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    
    UILabel *labelkd = [[UILabel alloc]init];
    labelkd.text = @"万元，周末";
    labelkd.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelkd];
    [labelkd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textFieldF.mas_right);
        make.top.mas_equalTo(labelyue.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    MyTextField *textFieldG = [[MyTextField alloc]init];
    textFieldG.font = [UIFont systemFontOfSize:12];
    textFieldG.delegate = self;
    textFieldG.userInteractionEnabled = self.userIner;
    [viewB addSubview:textFieldG];
    [textFieldG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelkd.mas_right);
        make.top.mas_equalTo(labelyue.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(45);
    }];
    self.textFiledF = textFieldF;
    
    UILabel *labelkj = [[UILabel alloc]init];
    labelkj.text = @"万元";
    labelkj.font = [UIFont systemFontOfSize:12];
    [viewB addSubview:labelkj];
    [labelkj mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textFieldG.mas_right);
        make.top.mas_equalTo(labelyue.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
}

-(void)showDatePicker:(UIButton *)button
{
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
