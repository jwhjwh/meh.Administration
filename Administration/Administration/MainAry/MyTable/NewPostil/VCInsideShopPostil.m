//
//  VCInsideShopDrafts.m
//  Administration
//
//  Created by zhang on 2017/9/26.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCInsideShopPostil.h"
#import "CellEditInfo.h"
#import "CellEditPlan.h"
#import "ViewDatePick.h"
#import "ViewChooseScore.h"
#import "ViewChooseEdit.h"
#import "VCPositil.h"
@interface VCInsideShopPostil ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,ViewDatePickerDelegate,UIAlertViewDelegate,ViewChooseScoreDelegate,ViewChooseEditDelegate>
{
    NSArray *arrayTitle;
    UITableView *tableView1;
    ViewDatePick *myDatePick;
    BOOL isBack;
    ViewChooseScore *myScore;
    NSIndexPath *indexPathGes;
    BOOL isEditing;
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
@property(nonatomic,strong) NSMutableDictionary *dict;
@property(nonatomic,strong) NSArray *arrayPostil;

@end

@implementation VCInsideShopPostil

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
            self.string1 = [self.dict[@"dateLine"] substringToIndex:10];
            self.string2 = self.dict[@"store"];
            self.string3 = self.dict[@"targetDetail"];
            self.string4 = self.dict[@"appraisal"];
            if (![self.dict[@"evaluation"] isKindOfClass:[NSNull class]]) {
                self.string5 = [NSString stringWithFormat:@"%@",self.dict[@"evaluation"]];
            }else
            {
                self.string5 = @"";
            }
            
            self.string6 = self.dict[@"reason"];
            self.string7 = self.dict[@"sentiment"];
            self.string8 = self.dict[@"tomorrowPlan"];
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
    tableView1 = [[UITableView alloc]init];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView1.rowHeight = UITableViewAutomaticDimension;
    tableView1.estimatedRowHeight = 100;
    [tableView1 registerClass:[CellEditPlan class] forCellReuseIdentifier:@"cell"];
    [tableView1 registerClass:[CellEditInfo class] forCellReuseIdentifier:@"cell2"];
    [self.view addSubview:tableView1];
    [tableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(kTopHeight);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self.view addSubview:tableView1];
}

-(void)showDatePicker:(UITapGestureRecognizer *)ges
{
    CGPoint point = [ges locationInView:tableView1];
    indexPathGes = [tableView1 indexPathForRowAtPoint:point];
    myDatePick = [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    myDatePick.delegate = self;
    [self.view addSubview:myDatePick];
}

-(void)showChooseScore:(UITapGestureRecognizer*)ges
{
    myScore  = [[ViewChooseScore alloc]initWithFrame:self.view.frame];
    myScore.delegate = self;
    CGPoint point = [ges locationInView:tableView1];
    NSIndexPath *indexPath = [tableView1 indexPathForRowAtPoint:point];
    indexPathGes  = indexPath;
    if (indexPath.row==5) {
        myScore.label.text = @"状态";
        myScore.arrayContent = @[@"很好",@"好",@"一般",@"差",@"很差"];
    }else
    {
        myScore.label.text = @"自我打分";
        myScore.arrayContent = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    }
    [self.view addSubview:myScore];
    
}


-(void)gotoPositil:(UIButton *)button
{
    CellEditPlan *cell = (CellEditPlan *)[button superview].superview;
    
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
        
       UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(31, 0, 25, 25)];
        [button2 setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button2];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        [self.dict setValue:@"2" forKey:@"canEdit"];
        isEditing = YES;
        [tableView1 reloadData];
    }else
    {
        [chooseEdit removeFromSuperview];
    }
    
}

//删除草稿
-(void)deleteDrafts
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/delReport",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Num":[ShareModel shareModel].num,
                           @"Sort":[ShareModel shareModel].sort,
                           @"code":@"2",
                           @"id":self.tableID,
                           @"Hint":@"3"};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return ;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)submitData:(NSString *)hint
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/insert",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    if (isBack==NO) {
        if (self.string8.length==0||self.string7.length==0||self.string6.length==0||self.string5.length==0||self.string4.length==0||self.string3.length==0||self.string2.length==0||self.string1.length==0) {
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
        [dict setValue:self.string1 forKey:@"DateLine"];
    }else
    {
        [dict setValue:@"" forKey:@"DateLine"];
    }
    
    if (self.string2.length!=0) {
        [dict setValue:self.string2 forKey:@"Store"];
    }else
    {
        [dict setValue:@"" forKey:@"Store"];
    }
    if (self.string3.length!=0) {
        [dict setValue:self.string3 forKey:@"TargetDetail"];
    }else
    {
        [dict setValue:@"" forKey:@"TargetDetail"];
    }
    if (self.string4.length!=0) {
        [dict setValue:self.string4 forKey:@"evaluation"];
    }else
    {
        [dict setValue:@"" forKey:@"evaluation"];
    }
    if (self.string5.length!=0) {
        [dict setValue:self.string5 forKey:@"Appraisal"];
    }else
    {
        [dict setObject:@"" forKey:@"Appraisal"];
    }
    if (self.string6.length!=0) {
        [dict setValue:self.string6 forKey:@"reason"];
    }else
    {
        [dict setValue:@"" forKey:@"reason"];
    }
    if (self.string7.length!=0) {
        [dict setValue:self.string7 forKey:@"Sentiment"];
    }else
    {
        [dict setValue:@"" forKey:@"Sentiment"];
    }
    if (self.string8.length!=0) {
        [dict setValue:self.string8 forKey:@"TomorrowPlan"];
    }else
    {
        [dict setValue:@"" forKey:@"TomorrowPlan"];
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
    [alertView show];
}

-(void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要提交此项内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
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
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
    {
        if (buttonIndex==1) {
            [self submitData:@"3"];
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
    
    CellEditInfo *cell = [tableView1 cellForRowAtIndexPath:indexPathGes];
    cell.textView.text = stringDate;
    self.string1 = stringDate;
}

#pragma -mark viewChooseScoreDelegate
-(void)getIndexPath
{
    CellEditInfo *cell = [tableView1 cellForRowAtIndexPath:indexPathGes];
    NSIndexPath *indexPath = [myScore.tableView indexPathForSelectedRow];
    cell.textView.text = myScore.arrayContent[indexPath.row];
    if (indexPath.row==5) {
        self.string5 = myScore.arrayContent[indexPath.row];
    }else
    {
        self.string4 = myScore.arrayContent[indexPath.row];
    }
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<4) {
        CellEditInfo *cell = [[CellEditInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        if (cell==nil) {
            cell = [[CellEditInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelTitle.text = arrayTitle[indexPath.row];
        if ([self.dict[@"canEdit"]isEqualToString:@"1"]) {
            cell.textView.userInteractionEnabled = NO;;
        }else
        {
            cell.textView.userInteractionEnabled = YES;;
        }
        
        switch (indexPath.row) {
            case 0:
            {
                cell.textView.text = self.string1;
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePicker:)];
                [cell.textView addGestureRecognizer:tap];
            }
                
                break;
            case 1:
                cell.textView.delegate = self;
                cell.textView.text = self.string2;
                
                break;
            case 2:
                cell.textView.editable = NO;
                cell.textView.text = [ShareModel shareModel].postionName;
                break;
            case 3:
                cell.textView.editable = NO;
                cell.textView.text = [USER_DEFAULTS valueForKey:@"name"];
                break;
                
            default:
                break;
        }
        return cell;
        
    }else
    {
        CellEditPlan *cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (cell==nil) {
            cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell.buttonPostil addTarget:self action:@selector(gotoPositil:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.LabelTitle.text = arrayTitle[indexPath.row];
        cell.textView.delegate =self;
        if ([self.dict[@"canEdit"]isEqualToString:@"1"]) {
            cell.textView.userInteractionEnabled = NO;;
        }
        
        switch (indexPath.row) {
              
            case 4:
                
                if (self.string3) {
                    cell.textView.text = self.string3;
                }else
                {
                    cell.textView.placeholder = @"今日目标及工作详细内容";
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"targetDetail"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"targetDetail"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
            case 5:
            {
                cell.textView.editable =  NO;
                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showChooseScore:)];
                [cell.textView addGestureRecognizer:ges];
                if (self.string4) {
                    cell.textView.text = self.string4;
                }else
                {
                    cell.textView.placeholder = @"自我状态评估";
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"appraisal"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"appraisal"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
            }
                break;
                
            case 6:
            {
                cell.textView.editable = NO;
                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showChooseScore:)];
                [cell.textView addGestureRecognizer:ges];
                if (self.string5) {
                    cell.textView.text = self.string5;
                }else
                {
                    cell.textView.placeholder = @"自我打分";
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"evaluation"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"evaluation"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
            }
                break;
            case 7:
                cell.textView.delegate = self;
                if (self.string6) {
                    cell.textView.text =self.string6;
                }else
                {
                    cell.textView.placeholder = @"原因";
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"reason"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"reason"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
            case 8:
                cell.textView.delegate = self;
                if (self.string7) {
                    cell.textView.text =self.string7;
                }else
                {
                    cell.textView.placeholder = @"感悟分享及心得";
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"sentiment"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"sentiment"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
            case 9:
                cell.textView.delegate = self;
                if (self.string8) {
                    cell.textView.text =self.string8;
                }else
                {
                    cell.textView.placeholder = @"明日计划安排";
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"tomorrowPlan"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"tomorrowPlan"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
                
            default:
                break;
        }
        
        return cell;
    }
}

#pragma -mark textView
-(void)textViewDidChange:(UITextView *)textView
{
    CellEditPlan *cell = (CellEditPlan *)[textView superview].superview;
    NSIndexPath *indexPath = [tableView1 indexPathForCell:cell];
    switch (indexPath.row) {
            
        case 1:
            self.string2 = textView.text;
            break;
            
        case 4:
            self.string3 = textView.text;
            break;
        case 7:
            self.string6 = textView.text;
            break;
        case 8:
            self.string7 = textView.text;
            break;
        case 9:
            self.string8 = textView.text;
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
    [super viewWillAppear: YES];
    [self getHttpData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"填写店报表";
    arrayTitle = @[@"日期",@"服务店家",@"职位",@"姓名",@"今日目标及工作详细内容",@"自我状态评估",@"自我打分",@"原因",@"感悟分享及心得",@"明日计划安排"];
    [self setUI];
    isBack = NO;
    isEditing = NO;
    
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
