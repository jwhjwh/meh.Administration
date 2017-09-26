//
//  ViewArtMonthSummary.m
//  Administration
//
//  Created by zhang on 2017/9/25.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewArtMonthSummary.h"
#import "ViewDatePick.h"

@interface ViewArtMonthSummary ()<ViewDatePickerDelegate,UITextFieldDelegate>
@property (nonatomic,weak)ViewDatePick *myDatePick;
@end

@implementation ViewArtMonthSummary

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
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 420)];
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
    label5.text = @"本月目标完成情况";
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
        make.height.mas_equalTo(300);
    }];
    
    UILabel *labela = [[UILabel alloc]init];
    labela.text = @"品牌任务";
    [viewB addSubview:labela];
    [labela mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(8);
        make.top.mas_equalTo(viewB.mas_top).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelb = [[UILabel alloc]init];
    labelb.text = @"品牌中任务";
    [viewB addSubview: labelb];
    [labelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(8);
        make.top.mas_equalTo(labela.mas_bottom).offset(16);
        make.height.mas_equalTo(21);
    }];
    
    MyTextField *textF1 = [[MyTextField alloc]init];
    textF1.delegate = self;
    [viewB addSubview:textF1];
    [textF1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelb.mas_right);
        make.top.mas_equalTo(labela.mas_bottom).offset(16);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(45);
    }];
    self.textFiled1 = textF1;
    
    UILabel *labelc = [[UILabel alloc]init];
    labelc.text = @"万元";
    [viewB addSubview:labelc];
    [labelc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF1.mas_right);
        make.top.mas_equalTo(labela.mas_bottom).offset(16);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labeld = [[UILabel alloc]init];
    labeld.text = @"实际出货";
    [viewB addSubview:labeld];
    [labeld mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(8);
        make.top.mas_equalTo(labelb.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    MyTextField *textF2 = [[MyTextField alloc]init];
    textF2.delegate =self;
    [viewB addSubview:textF2];
    [textF2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labeld.mas_right);
        make.top.mas_equalTo(labelb.mas_bottom).offset(8);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(21);
    }];
    self.textFiled2 = textF2;
    
    UILabel *labele = [[UILabel alloc]init];
    labele.text = @"万元";
    [viewB addSubview:labele];
    [labele mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF2.mas_right);
        make.top.mas_equalTo(labelb.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelf = [[UILabel alloc]init];
    labelf.text = @"完成比例";
    [viewB addSubview:labelf];
    [labelf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(8);
        make.top.mas_equalTo(labeld.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    MyTextField *textF3 = [[MyTextField alloc]init];
    textF3.delegate = self;
    [viewB addSubview:textF3];
    [textF3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelf.mas_right);
        make.top.mas_equalTo(labeld.mas_bottom).offset(8);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(21);
    }];
    self.textFiled3 = textF3;
    
    UILabel *labeli = [[UILabel alloc]init];
    labeli.text = @"%";
    [viewB addSubview: labeli];
    [labeli mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF3.mas_right);
        make.top.mas_equalTo(labeld.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelh = [[UILabel alloc]init];
    labelh.text = @"个人任务";
    [viewB addSubview:labelh];
    [labelh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(8);
        make.top.mas_equalTo(labeli.mas_bottom).offset(16);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelj = [[UILabel alloc]init];
    labelj.text = @"个人任务";
    [viewB addSubview:labelj];
    [labelj mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(8);
        make.top.mas_equalTo(labelh.mas_bottom).offset(16);
        make.height.mas_equalTo(21);
    }];
    
    MyTextField *textF4 = [[MyTextField alloc]init];
    textF4.delegate = self;
    [viewB addSubview:textF4];
    [textF4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelj.mas_right);
        make.top.mas_equalTo(labelh.mas_bottom).offset(16);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(21);
    }];
    self.textFiled4 = textF4;
    
    UILabel *labelk = [[UILabel alloc]init];
    labelk.text= @"万元";
    [viewB addSubview:labelk];
    [labelk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF4.mas_right);
        make.top.mas_equalTo(labelh.mas_bottom).offset(16);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labell = [[UILabel alloc]init];
    labell.text = @"个人出货";
    [viewB addSubview:labell];
    [labell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(8);
        make.top.mas_equalTo(labelj.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    MyTextField *textF5 = [[MyTextField alloc]init];
    textF5.delegate = self;
    [viewB addSubview:textF5];
    [textF5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labell.mas_right);
        make.top.mas_equalTo(labelj.mas_bottom).offset(8);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(21);
    }];
    self.textFiled5 = textF5;
    
    UILabel *labelm = [[UILabel alloc]init];
    labelm.text = @"万元";
    [viewB addSubview:labelm];
    [labelm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF5.mas_right);
        make.top.mas_equalTo(labelj.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labeln = [[UILabel alloc]init];
    labeln.text = @"完成比例";
    [viewB addSubview:labeln];
    [labeln mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(8);
        make.top.mas_equalTo(labell.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    MyTextField *textF6 = [[MyTextField alloc]init];
    textF6.delegate = self;
    [viewB addSubview:textF6];
    [textF6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labeln.mas_right);
        make.top.mas_equalTo(labell.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(45);
    }];
    self.textFiled6 = textF6;
    
    UILabel *labelo = [[UILabel alloc]init];
    labelo.text=  @"%";
    [viewB addSubview:labelo];
    [labelo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF6.mas_right);
        make.top.mas_equalTo(labell.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelp = [[UILabel alloc]init];
    labelp.text = @"占品牌完成任务";
    [viewB addSubview:labelp];
    [labelp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewB.mas_left).offset(8);
        make.top.mas_equalTo(labeln.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    MyTextField *textF7 = [[MyTextField alloc]init];
    textF7.delegate = self;
    [viewB addSubview:textF7];
    [textF7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelp.mas_right);
        make.top.mas_equalTo(labeln.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(45);
    }];
    self.textFiled7 = textF7;
    
    UILabel *labelq = [[UILabel alloc]init];
    labelq.text = @"%";
    [viewB addSubview:labelq];
    [labelq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textF7.mas_right);
        make.top.mas_equalTo(labeln.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
}

-(void)showDatePicker
{
    ViewDatePick *myDatePick=  [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length>=4) {
        textField.text = [textField.text substringToIndex:3];
    }
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
