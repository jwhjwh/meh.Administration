//
//  VCArtShopDrfts.m
//  Administration
//
//  Created by zhang on 2017/9/26.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCArtShopSubmited.h"
#import "CellEditPlan.h"
#import "ViewChooseEdit.h"
#import "VCPositil.h"
@interface VCArtShopSubmited ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,ViewDatePickerDelegate,UIAlertViewDelegate,ViewChooseEditDelegate>

{
    UIButton *button;
    NSArray *arrayTitle;
    UITableView *tableView1;
    ViewDatePick *myDatePick;
    BOOL isBack;
    BOOL isEditing;
    BOOL isSave;
    ViewChooseEdit *chooseEdit;
}
@property(nonatomic,strong) NSString *string1;
@property(nonatomic,strong) NSString *string2;
@property(nonatomic,strong) NSString *string3;
@property(nonatomic,strong) NSString *string4;
@property(nonatomic,strong) NSString *string5;
@property(nonatomic,strong) NSString *string6;
@property(nonatomic,strong) NSString *string7;
@property(nonatomic,strong) NSString *string8;
@property(nonatomic,strong) NSString *string9;
@property(nonatomic,strong) NSString *summary;
@property(nonatomic,strong) NSMutableDictionary *dict;
@property(nonatomic,strong) NSArray * arrayPostil;
@end

@implementation VCArtShopSubmited

#pragma -mark custem
-(void)getHttpData
    {
        NSString *urlStr =[NSString stringWithFormat:@"%@report/queryReportInfo",KURLHeader];
        NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
        NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
        NSDictionary *dict = @{@"appkey":appKeyStr,
                               @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                               @"CompanyInfoId":compid,
                               @"RoleId":[ShareModel shareModel].roleID,
                               @"DepartmentID":[ShareModel shareModel].departmentID,
                               @"remark":self.remark,
                               @"id":self.tableID};
        [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
            NSString *code = [responseObject valueForKey:@"status"];
            if ([code isEqualToString:@"0000"]) {
                self.dict = [[responseObject valueForKey:@"tableInfo"]mutableCopy];
                NSString *string = [self.dict[@"dateLine"] substringToIndex:10];
                [button setTitle:string forState:UIControlStateNormal];
                self.string1 = self.dict[@"store"];
                self.string2 = self.dict[@"aim"];
                self.string3 = self.dict[@"achievement"];
                self.string4 = self.dict[@"shipment"];
                self.string5 = self.dict[@"question"];
                self.string6 = self.dict[@"solution"];
                self.string7 = self.dict[@"apperception"];
                self.string8 = self.dict[@"morgenPlan"];
                self.string9 = self.dict[@"morgenAim"];
                self.summary = self.dict[@"summery"];
                [self.dict setValue:@"1" forKey:@"canEdit"];
                
                if ([[responseObject valueForKey:@"owner"] length]!=0) {
                    if (![[responseObject valueForKey:@"owner"] isEqualToString:@""]) {
                        NSString *string = [responseObject valueForKey:@"owner"];
                        self.arrayPostil = [string componentsSeparatedByString:@","];
                    }
                    
                }
                
                [tableView1 reloadData];
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
    
}

-(void)setUI
{
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = GetColor(188, 189, 190, 1);
    [self.view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.right.mas_equalTo (self.view.mas_right).offset(1);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.mas_equalTo(66);
    }];
    
    UILabel *labelDate = [[UILabel alloc]init];
    labelDate.text = @"  日期";
    labelDate.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:labelDate];
    [labelDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view1.mas_left);
        make.top.mas_equalTo(view1.mas_top);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(50);
    }];
    
    button = [[UIButton alloc]init];
    button.userInteractionEnabled = NO;
    [button setTitle:@"选择日期" forState:UIControlStateNormal];
    [button setTitleColor:GetColor(188, 189, 190, 1) forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button setBackgroundColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelDate.mas_right);
        make.top.mas_equalTo(view1.mas_top);
        make.right.mas_equalTo(view1.mas_right);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelPistion = [[UILabel alloc]init];
    labelPistion.text = @"  职位";
    labelPistion.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:labelPistion];
    [labelPistion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view1.mas_left);
        make.top.mas_equalTo(labelDate.mas_bottom).offset(1);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(50);
    }];
    
    UILabel *labelPistionName = [[UILabel alloc]init];
    labelPistionName.text = [NSString stringWithFormat:@"  %@",[ShareModel shareModel].postionName];
    labelPistionName.backgroundColor = [UIColor whiteColor];
    labelPistionName.textColor= GetColor(188, 189, 190, 1);
    [view1 addSubview:labelPistionName];
    [labelPistionName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelPistion.mas_right);
        make.top.mas_equalTo(button.mas_bottom).offset(1);
        make.right.mas_equalTo(view1.mas_right);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelName = [[UILabel alloc]init];
    labelName.text = @"  姓名";
    labelName.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view1.mas_left);
        make.top.mas_equalTo(labelPistion.mas_bottom).offset(1);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(50);
    }];
    
    UILabel *labelName2 = [[UILabel alloc]init];
    labelName2.text = [NSString stringWithFormat:@"  %@",[USER_DEFAULTS valueForKey:@"name"]];
    labelName2.textColor = GetColor(188, 189, 190, 1);
    labelName2.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:labelName2];
    [labelName2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelName.mas_right);
        make.top.mas_equalTo(labelPistionName.mas_bottom).offset(1);
        make.right.mas_equalTo(view1.mas_right);
        make.height.mas_equalTo(21);
    }];
    
    tableView1 = [[UITableView alloc]init];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView1.rowHeight = UITableViewAutomaticDimension;
    tableView1.estimatedRowHeight = 100;
    [tableView1 registerClass:[CellEditPlan class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView1];
    [tableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view1.mas_bottom).offset(1);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self.view addSubview:tableView1];
    
}

-(void)gotoPositil:(UIButton *)button1
{
    CellEditPlan *cell = (CellEditPlan *)[button1 superview].superview;
    
    VCPositil *vc = [[VCPositil alloc]init];
    for (NSString *key in [self.dict allKeys]) {
        if (![self.dict[key] isKindOfClass:[NSNull class]]) {
            if ([cell.textView.text isEqualToString:self.dict[key]]) {
                vc.field = key;
                break;
            }
        }
        
    }
    
    vc.remark = self.remark;
    vc.reportID = self.dict[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)showDatePicker
{
    myDatePick = [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    myDatePick.delegate = self;
    [self.view addSubview:myDatePick];
}

-(void)showChooseEdit
{
    chooseEdit  = [[ViewChooseEdit alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    chooseEdit.delegate = self;
    chooseEdit.arrayButton = @[@"编辑",@"取消"];
    [self.view addSubview:chooseEdit];
}


-(void)getState
{
    NSIndexPath *indexPath = [chooseEdit.tableView indexPathForSelectedRow];
    if (indexPath.row==0) {
        
//        UIToolbar*tools=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 100, 39)];
//        //解决出现的那条线
//        tools.clipsToBounds = YES;
//        //解决tools背景颜色的问题
//        [tools setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//        [tools setShadowImage:[UIImage new]forToolbarPosition:UIToolbarPositionAny];
//        //添加两个button
//        NSMutableArray*buttons=[[NSMutableArray alloc]initWithCapacity:2];
//        
//        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
//        [button1 setImage:[UIImage imageNamed:@"bc_ico01"] forState:UIControlStateNormal];
//        [button1 addTarget:self action:@selector(showSave) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(31, 0, 25, 25)];
//        [button2 setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
//        [button2 addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
//        UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
//        
//        [buttons addObject:item1];
//        [buttons addObject:item2];
//        [tools setItems:buttons animated:NO];
//        UIBarButtonItem *btn=[[UIBarButtonItem  alloc]initWithCustomView:tools];
//        self.navigationItem.rightBarButtonItem=btn;
//        button.userInteractionEnabled = YES;
        
        [self.dict setValue:@"2" forKey:@"canEdit"];
        
        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(31, 0, 25, 25)];
                [button2 setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
                [button2 addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button2];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        isEditing = YES;
        [tableView1 reloadData];
    }else
    {
        [chooseEdit removeFromSuperview];
    }
    
}


-(void)submitData:(NSString *)hint
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/insert",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    if (isBack==NO) {
        if (self.string9.length==0||self.string8.length==0||self.string7.length==0||self.string6.length==0||self.string5.length==0||self.string4.length==0||self.string3.length==0||self.string2.length==0||self.string1.length==0||self.summary.length==0||[button.titleLabel.text isEqualToString:@"选择日期"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
            return;
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:appKeyStr forKey:@"appkey"];
    [dict setValue:[USER_DEFAULTS valueForKey:@"userid"] forKey:@"usersid"];
    [dict setValue:compid forKey:@"CompanyInfoId"];
    [dict setValue:[ShareModel shareModel].roleID forKey:@"RoleId"];
    [dict setValue:[ShareModel shareModel].departmentID forKey:@"DepartmentID"];
    [dict setValue:[ShareModel shareModel].num forKey:@"Num"];
    [dict setValue:@"1" forKey:@"Sort"];
    [dict setValue:@"2" forKey:@"code"];
    if (self.string1.length!=0) {
        [dict setValue:self.string1 forKey:@"Store"];
    }else
    {
        [dict setValue:@"" forKey:@"Store"];
    }
    
    if (self.string2.length!=0) {
        [dict setValue:self.string2 forKey:@"Aim"];
    }else
    {
        [dict setValue:@"" forKey:@"Aim"];
    }
    if (self.string3.length!=0) {
        [dict setValue:self.string3 forKey:@"Achievement"];
    }else
    {
        [dict setValue:@"" forKey:@"Achievement"];
    }
    if (self.string4.length!=0) {
        [dict setValue:self.string4 forKey:@"Shipment"];
    }else
    {
        [dict setValue:@"" forKey:@"Shipment"];
    }
    if (self.string5.length!=0) {
        [dict setValue:self.string5 forKey:@"Question"];
    }else
    {
        [dict setValue:@"" forKey:@"Question"];
    }
    if (self.string6.length!=0) {
        [dict setValue:self.string6 forKey:@"Solution"];
    }else
    {
        [dict setValue:@"" forKey:@"Solution"];
    }
    if (self.string7.length!=0) {
        [dict setValue:self.string7 forKey:@"Apperception"];
    }else
    {
        [dict setValue:@"" forKey:@"Apperception"];
    }
    if (self.string8.length!=0) {
        [dict setValue:self.string8 forKey:@"MorgenPlan"];
    }else
    {
        [dict setValue:@"" forKey:@"MorgenPlan"];
    }
    if (self.string9.length!=0) {
        [dict setValue:self.string9 forKey:@"MorgenAim"];
    }else
    {
        [dict setValue:@"" forKey:@"MorgenAim"];
    }
    if (self.summary.length!=0) {
        [dict setValue:self.summary forKey:@"Summery"];
    }else
    {
        [dict setValue:@"" forKey:@"Summery"];
    }
    if ([button.titleLabel.text isEqualToString:@"选择日期"]) {
        [dict setValue:@"" forKey:@"DateLine"];
    }
    else
    {
        [dict setValue:button.titleLabel.text forKey:@"DateLine"];
    }
    
    [dict setValue:hint forKey:@"Hint"];
    [dict setValue:[USER_DEFAULTS valueForKey:@"name"] forKey:@"Name"];
    
    [ZXDNetworking POST:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view];
}
-(void)showSave
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要保存此项内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 300;
    isSave = YES;
    [alertView show];
}

-(void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要提交此项内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    isSave = NO;
    [alertView show];
}

-(void)back
{
    if (isEditing==YES) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"离开后编辑的内容将要消失" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"存到草稿箱",@"确定" ,nil];
        alertView.tag = 200;
        [alertView show];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma -mark alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex ==1) {
            [self submitData:@"1"];
        }
    }else if(alertView.tag==200)
    {
        if (buttonIndex==1) {
            isBack = YES;
            [self submitData:@"3"];
            
        }if (buttonIndex ==2) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma -mark viewDatePickDelegate
-(void)getDate
{
    NSDate *date = myDatePick.datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringDate = [formatter stringFromDate:date];
    [button setTitle:stringDate forState:UIControlStateNormal];
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellEditPlan *cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell.buttonPostil addTarget:self action:@selector(gotoPositil:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.LabelTitle.text = arrayTitle[indexPath.row];
    cell.textView.delegate = self;
    if ([self.dict[@"canEdit"]isEqualToString:@"1"]) {
        cell.textView.userInteractionEnabled = NO;
    }else
    {
        cell.textView.userInteractionEnabled = YES;
    }
    switch (indexPath.row) {
        case 0:
            if (self.string1.length!=0) {
                cell.textView.text = self.string1;
            }else
            {
                cell.textView.placeholder = @"填写地区店名老板";
            }
            break;
        case 1:
            if (self.string2.length!=0) {
                cell.textView.text = self.string2;
            }else
            {
                cell.textView.placeholder = @"填写目标";
            }
            
            for (NSString *string in self.arrayPostil) {
                if ([string containsString:@"aim"]) {
                    cell.buttonPostil.hidden = NO;
                    cell.labelNumber.hidden = NO;
                    cell.buttonPostil.userInteractionEnabled  =YES;
                    NSRange rang = [string rangeOfString:@"aim"];
                    cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    break;
                }
            }
            
            break;
        case 2:
            if (self.string3.length!=0) {
                cell.textView.text = self.string3;
            }else
            {
                cell.textView.placeholder = @"填写业绩";
            }
            for (NSString *string in self.arrayPostil) {
                if ([string containsString:@"achievement"]) {
                    cell.buttonPostil.hidden = NO;
                    cell.labelNumber.hidden = NO;
                    cell.buttonPostil.userInteractionEnabled  =YES;
                    NSRange rang = [string rangeOfString:@"achievement"];
                    cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                }
            }
            break;
        case 3:
            if (self.string4.length!=0) {
                cell.textView.text = self.string4;
            }else
            {
                cell.textView.placeholder = @"填写出货";
            }
            
            for (NSString *string in self.arrayPostil) {
                if ([string containsString:@"shipment"]) {
                    cell.buttonPostil.hidden = NO;
                    cell.labelNumber.hidden = NO;
                    cell.buttonPostil.userInteractionEnabled  =YES;
                    NSRange rang = [string rangeOfString:@"shipment"];
                    cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                }
            }
            break;
        case 4:
            if (self.string5.length!=0) {
                cell.textView.text = self.string5;
            }else
            {
                cell.textView.placeholder = @"填写发现的问题";
            }
            
            for (NSString *string in self.arrayPostil) {
                if ([string containsString:@"question"]) {
                    cell.buttonPostil.hidden = NO;
                    cell.labelNumber.hidden = NO;
                    cell.buttonPostil.userInteractionEnabled  =YES;
                    NSRange rang = [string rangeOfString:@"question"];
                    cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                }
            }
            
            break;
        case 5:
            if (self.string6.length!=0) {
                cell.textView.text = self.string6;
            }else
            {
                cell.textView.placeholder = @"填写解决的方案";
            }
            
            for (NSString *string in self.arrayPostil) {
                if ([string containsString:@"solution"]) {
                    cell.buttonPostil.hidden = NO;
                    cell.labelNumber.hidden = NO;
                    cell.buttonPostil.userInteractionEnabled  =YES;
                    NSRange rang = [string rangeOfString:@"solution"];
                    cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                }
            }
            
            break;
        case 6:
            if (self.string7.length!=0) {
                cell.textView.text = self.string7;
            }else
            {
                cell.textView.placeholder = @"填写感悟分享";
            }
            
            for (NSString *string in self.arrayPostil) {
                if ([string containsString:@"apperception"]) {
                    cell.buttonPostil.hidden = NO;
                    cell.labelNumber.hidden = NO;
                    cell.buttonPostil.userInteractionEnabled  =YES;
                    NSRange rang = [string rangeOfString:@"apperception"];
                    cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                }
            }
            break;
        case 7:
            if (self.string8.length!=0) {
                cell.textView.text =self.string8;
            }else
            {
                cell.textView.placeholder = @"填写明日计划";
            }
            
            for (NSString *string in self.arrayPostil) {
                if ([string containsString:@"morgenPlan"]) {
                    cell.buttonPostil.hidden = NO;
                    cell.labelNumber.hidden = NO;
                    cell.buttonPostil.userInteractionEnabled  =YES;
                    NSRange rang = [string rangeOfString:@"morgenPlan"];
                    cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                }
            }
            break;
        case 8:
            
            if (self.string9.length!=0) {
                cell.textView.text = self.string9;
            }else
            {
                cell.textView.placeholder = @"填写明日目标";
            }
            
            for (NSString *string in self.arrayPostil) {
                if ([string containsString:@"morgenAim"]) {
                    cell.buttonPostil.hidden = NO;
                    cell.labelNumber.hidden = NO;
                    cell.buttonPostil.userInteractionEnabled  =YES;
                    NSRange rang = [string rangeOfString:@"morgenAim"];
                    cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                }
            }
            break;
        case 9:
            if (self.summary.length!=0) {
                cell.textView.text = self.summary;
            }else
            {
                cell.textView.placeholder = @"填写总结";
            }
            
            for (NSString *string in self.arrayPostil) {
                if ([string containsString:@"summery"]) {
                    cell.buttonPostil.hidden = NO;
                    cell.labelNumber.hidden = NO;
                    cell.buttonPostil.userInteractionEnabled  =YES;
                    NSRange rang = [string rangeOfString:@"summery"];
                    cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                }
            }
            
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma -mark textView
-(void)textViewDidChange:(UITextView *)textView
{
    CellEditPlan *cell = (CellEditPlan *)[textView superview].superview;
    NSIndexPath *indexPath = [tableView1 indexPathForCell:cell];
    switch (indexPath.row) {
        case 0:
            self.string1 = textView.text;
            break;
        case 1:
            self.string2 = textView.text;
            break;
        case 2:
            self.string3 = textView.text;
            break;
        case 3:
            self.string4 = textView.text;
            break;
        case 4:
            self.string5 = textView.text;
            break;
        case 5:
            self.string6 = textView.text;
            break;
        case 6:
            self.string7 = textView.text;
            break;
        case 7:
            self.string8 = textView.text;
            break;
        case 8:
            self.string9 = textView.text;
            break;
        case 9:
            self.summary = textView.text;
            break;
            
        default:
            break;
    }
    
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }
    cell.textView.frame = CGRectMake(frame.origin.x, frame.origin.y,cell.contentView.frame.size.width, size.height);
    
    [tableView1 beginUpdates];
    [tableView1 endUpdates];
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=  @"店报表";
    [self setUI];
    arrayTitle = @[@"地区店名老板",@"目标",@"业绩",@"出货",@"发现问题",@"解决方案",@"感悟分享",@"明日计划",@"明日目标",@"总结"];
    
    self.dict = [NSMutableDictionary dictionary];
    self.arrayPostil = [NSArray array];
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"..." style:(UIBarButtonItemStyleDone) target:self action:@selector(showChooseEdit)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
