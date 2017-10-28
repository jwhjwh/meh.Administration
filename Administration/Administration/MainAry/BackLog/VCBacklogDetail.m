//
//  VCBacklogDetail.m
//  Administration
//
//  Created by zhang on 2017/10/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCBacklogDetail.h"
#import "ViewDatePick.h"
#import "ViewChooseBacklog.h"
#import "CellAddBacklog.h"
#import "CellEditInfo.h"
#import "ViewChooseEdit.h"
@interface VCBacklogDetail ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ViewDatePickerDelegate,ViewChooseBacklogDelegate,ViewChooseEditDelegate,UIAlertViewDelegate>
@property (nonatomic,weak)UILabel *label;

@property (nonatomic,weak)UIButton *warnDate;
@property (nonatomic,weak)UIButton *allReady;
@property (nonatomic,weak)UIButton *notReady;
@property (nonatomic,weak)UITableView *tableView;

@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSArray *arrayPlacehold;
@property (nonatomic,strong)NSArray *arrayBackTitle;
@property (nonatomic,strong)NSArray *arrayData;

@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)NSString *string2;
@property (nonatomic,strong)NSString *startTime;
@property (nonatomic,strong)NSString *endTime;
@property (nonatomic,strong)NSString *wornTime;
@property (nonatomic,strong)NSString *backlogState;
@property (nonatomic,strong)NSString *state;
@property (nonatomic,strong)NSDictionary *dictinfo;

@property (nonatomic,assign)NSUInteger buttonTag;

@property (nonatomic,strong)ViewDatePick *myDatePick;
@property (nonatomic,strong)ViewChooseBacklog *chooseBacklog;

@property (nonatomic,strong)ViewChooseEdit *chooseEdit;

@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic) BOOL canEdit;

@end

@implementation VCBacklogDetail

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@matters/SelectMatters.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"Matterstype":self.matterstype,
                           @"id":self.backlogID,
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code=  [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.arrayData = [responseObject valueForKey:@"list"];
            self.dictinfo = self.arrayData[0];
            self.string1 = _dictinfo[@"title"];
            self.string2 = _dictinfo[@"content"];
            
            self.startTime = [_dictinfo[@"starttime"]substringToIndex:10];
            self.wornTime = self.dictinfo[@"remindertime"];
            [self.warnDate setTitle:self.wornTime forState:UIControlStateNormal];
            
            if ([[NSString stringWithFormat:@"%@",_dictinfo[@"red"]] isEqualToString:@"0"]) {
                [self.notReady setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
                [self.notReady setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else
            {
                [self.allReady setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
                [self.allReady setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            if (![self.matterstype isEqualToString:@"1"]) {
                if (![self.dictinfo[@"endtime"]isKindOfClass:[NSNull class]]) {
                    self.endTime = [_dictinfo[@"endtime"]substringToIndex:10];
                }
                
            }
            
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    CGRect frameView;
    
    frameView = CGRectMake(0, kTopHeight, Scree_width, 108);
    
    UIView *viewFooter = [[UIView alloc]initWithFrame:frameView];
    viewFooter.backgroundColor = GetColor(192, 192, 192, 1);
    [self.view addSubview:viewFooter];
    
    UILabel *labelworn = [[UILabel alloc]init];
    labelworn.text = @"  提醒时间";
    labelworn.backgroundColor = [UIColor whiteColor];
    labelworn.textColor = GetColor(102, 103, 104, 1);
    [viewFooter addSubview:labelworn];
    [labelworn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewFooter.mas_left);
        make.top.mas_equalTo(viewFooter.mas_top).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    
    
    UIButton *wornDate = [[UIButton alloc]init];
    wornDate.userInteractionEnabled = NO;
    wornDate.tag = 500;
    wornDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    wornDate.contentEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    [wornDate setBackgroundColor:[UIColor whiteColor]];
    [wornDate setTitle:@"选择提醒时间" forState:UIControlStateNormal];
    [wornDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [wornDate addTarget:self action:@selector(showDatePick:) forControlEvents:UIControlEventTouchUpInside];
    [viewFooter addSubview:wornDate];
    [wornDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelworn.mas_right);
        make.top.mas_equalTo(viewFooter.mas_top).offset(10);
        make.right.mas_equalTo(viewFooter.mas_right);
        make.height.mas_equalTo(44);
    }];
    self.warnDate = wornDate;
    
    
    
    UIButton *notReady = [[UIButton alloc]init];
    notReady.tag = 300;
    [notReady setBackgroundColor:[UIColor whiteColor]];
    [notReady setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    [notReady setTitle:@"未完成" forState:UIControlStateNormal];
    [notReady setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [notReady addTarget:self action:@selector(buttonNotPresss) forControlEvents:UIControlEventTouchUpInside];
    [viewFooter addSubview:notReady];
    [notReady mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewFooter.mas_left);
        make.right.mas_equalTo(viewFooter.mas_centerX);
        make.top.mas_equalTo(labelworn.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
    }];
    self.notReady = notReady;
    
    UIButton *allReady = [[UIButton alloc]init];
    allReady.tag = 400;
    [allReady setBackgroundColor:[UIColor whiteColor]];
    [allReady setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    [allReady setTitle:@"已完成" forState:UIControlStateNormal];
    [allReady setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [allReady addTarget:self action:@selector(buttonAllpress) forControlEvents:UIControlEventTouchUpInside];
    [viewFooter addSubview:allReady];
    [allReady mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewFooter.mas_centerX);
        make.right.mas_equalTo(viewFooter.mas_right);
        make.top.mas_equalTo(labelworn.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
    }];
    self.allReady = allReady;
    
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 50;
    tableView.tableFooterView = viewFooter;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[CellEditInfo class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[CellAddBacklog class] forCellReuseIdentifier:@"cell1"];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView = tableView;
}


-(void)showChooseBacklog:(UITapGestureRecognizer *)ges
{
    CGPoint point = [ges locationInView:self.tableView];
    self.indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    self.chooseBacklog = [[ViewChooseBacklog alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    self.chooseBacklog.arrayTitle = self.arrayBackTitle;
    self.chooseBacklog.delegate = self;
    [self.view.window addSubview:self.chooseBacklog];
}

-(void)saveBacklog
{
    NSString *urlStr =[NSString stringWithFormat:@"%@matters/InsertMatters.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict;
    
    if (self.string1.length==0||self.string2.length==0||self.wornTime.length==0||self.startTime.length==0) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1.0];
        return;
    }
    
    if ([self.matterstype isEqualToString:@"1"]) {
//        if ([self.wornTime compare:self.startTime] == NSOrderedDescending) {
//            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"提醒时间不能大于开始时间" andInterval:1];
//            return;
//        }
        if (self.startTime.length==0) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1.0];
            return;
        }
        dict = @{@"appkey":appKeyStr,
                 @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                 @"CompanyInfoId":compid,
                 @"Starttime":self.startTime,
                 @"Content":self.string2,
                 @"Title":self.string1,
                 @"Remindertime":self.wornTime,
                 @"Matterstype":[NSString stringWithFormat:@"%ld",self.indexPath.row]
                 };
    }else
    {
        if (self.endTime.length==0) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1.0];
            return;
        }
        if ([self.startTime isEqualToString:self.endTime]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"开始时间不能等于结束时间" andInterval:1.0];
            return;
        }
        
        if ([self.wornTime compare:self.startTime]==NSOrderedAscending) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"提醒时间不能小于开始时间" andInterval:1.0];
            return;
        }
        if ([self.wornTime compare:self.endTime]==NSOrderedDescending) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"提醒时间不能大于结束时间" andInterval:1.0];
            return;
        }
        if ([self.startTime compare:self.endTime]==NSOrderedDescending) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"开始时间不能大于结束时间" andInterval:1.0];
            return;
        }
        
        dict = @{@"appkey":appKeyStr,
                 @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                 @"CompanyInfoId":compid,
                 @"Starttime":self.startTime,
                 @"Endtime":self.endTime,
                 @"Content":self.string2,
                 @"Title":self.string1,
                 @"Remindertime":self.wornTime,
                 @"Matterstype":[NSString stringWithFormat:@"%ld",self.indexPath.row]
                 };
    }
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"成功" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"超时请重新登录" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return ;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)deleteBacklog
{
    NSString *urlStr =[NSString stringWithFormat:@"%@matters/DeleteToMatters.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"id":self.backlogID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"1001 "]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"0001 "]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];

}

-(void)changeBacklogSate
{
    NSString *urlStr =[NSString stringWithFormat:@"%@matters/UpdateToMattersRed.action",KURLHeader];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"Matterstype":self.matterstype,
                           @"id":self.backlogID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改成功" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"1001 "]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"0001 "]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];

}

-(void)showEditView
{
    self.chooseEdit = [[ViewChooseEdit alloc]initWithFrame:self.view.frame];
    self.chooseEdit.arrayButton = @[@"编辑",@"删除"];
    self.chooseEdit.delegate = self;
    [self.view.window addSubview:self.chooseEdit];
}
-(void)showDatePick:(UIButton *)button
{
    CellAddBacklog *cell = (CellAddBacklog *)[button superview].superview;
    [self.view endEditing:YES];
    self.indexPath = [self.tableView indexPathForCell:cell];
    self.buttonTag = button.tag;
    self.myDatePick = [[ViewDatePick alloc]initWithFrame:self.view.frame];
    self.myDatePick.delegate = self;
    if (button.tag==500) {
        self.myDatePick.datePick.datePickerMode = UIDatePickerModeDateAndTime;
    }
    [self.view.window addSubview:self.myDatePick];
}

-(void)buttonAllpress
{
    [self.notReady setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    [self.notReady setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [self.allReady setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    [self.allReady setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [self changeBacklogSate];
}

-(void)buttonNotPresss
{
    [self.allReady setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    [self.allReady setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [self.notReady setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    [self.notReady setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
}

-(void)getState
{
    NSIndexPath *indexPath = [self.chooseEdit.tableView indexPathForSelectedRow];
    if (indexPath.row==0) {
        self.canEdit = YES;
        self.warnDate.userInteractionEnabled = YES;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(saveBacklog)];
        [rightitem setTitleTextAttributes:dictionary forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightitem;
        [self.tableView reloadData];
    }else
    {
        [self deleteBacklog];
    }
}

-(void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要删除此项内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma -mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self deleteBacklog];
    }
}


#pragma -mark viewChooseBacklog

-(void)getChoosed
{
    NSIndexPath *indexPath = [self.chooseBacklog.tableView indexPathForSelectedRow];
    CellEditInfo *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    cell.textView.text = self.arrayBackTitle[indexPath.row];
    self.indexPath = indexPath;
    [self.tableView reloadData];
    
}

#pragma viewDatepickDelegate

-(void)getDate
{
    NSDate *date = self.myDatePick.datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringDate = [formatter stringFromDate:date];
    CellAddBacklog *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    if (self.buttonTag==100) {
        [cell.startDate setTitle:stringDate forState:UIControlStateNormal];
        self.startTime = stringDate;
    }else if(self.buttonTag == 200)
    {
        [cell.endDate setTitle:stringDate forState:UIControlStateNormal];
        self.endTime = stringDate;
    }else
    {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        stringDate = [formatter stringFromDate:date];
        [self.warnDate setTitle:stringDate forState:UIControlStateNormal];
        self.wornTime = stringDate;
    }
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        CellAddBacklog *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell==nil) {
            cell = [[CellAddBacklog alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelDate.text = self.arrayTitle[indexPath.row];
        
        [cell.startDate addTarget:self action:@selector(showDatePick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.endDate addTarget:self action:@selector(showDatePick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.matterstype isEqualToString:@"1"]) {
            cell.labelzhi.hidden = YES;
            cell.endDate.hidden = YES;
            cell.endDate.userInteractionEnabled = NO;
            [cell.startDate setTitle:self.startTime forState:UIControlStateNormal];
        }else
        {
            cell.labelzhi.hidden = NO;
            cell.endDate.hidden = NO;
            cell.endDate.userInteractionEnabled = YES;
            [cell.startDate setTitle:self.startTime forState:UIControlStateNormal];
            [cell.endDate setTitle:self.endTime forState:UIControlStateNormal];
        }
        
        return cell;
    }else
    {
        CellEditInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell = [[CellEditInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.userInteractionEnabled = self.canEdit;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.delegate = self;
        cell.textView.placeholder = self.arrayPlacehold[indexPath.row];
        cell.labelTitle.text = self.arrayTitle[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
                cell.textView.text = self.arrayBackTitle[[self.dictinfo[@"matterstype"]intValue]];
                cell.userInteractionEnabled = NO;
                break;
            case 2:
                cell.textView.text = self.string1;
                break;
            case 3:
                cell.textView.text = self.string2;
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
    CellEditInfo *cell = (CellEditInfo *)[textView superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch (indexPath.row) {
        case 2:
            self.string1 = textView.text;
            break;
        case 3:
            self.string2 = textView.text;
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
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma  -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"..." style:(UIBarButtonItemStyleDone) target:self action:@selector(showEditView)];
    [rightitem setTitleTextAttributes:dictionary forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    self.title = @"添加待办事项";
    
    self.canEdit = NO;

    self.navigationItem.rightBarButtonItem = rightitem;
    
    self.arrayTitle = @[@"待办事项",@"日期",@"计划标题",@"详细内容"];
    self.arrayPlacehold = @[@"选择待办事项",@"",@"填写计划标题",@"填写详细内容"];
    self.arrayBackTitle = @[@"待办事项",@"日待办事项",@"周待办事项",@"店家待办事项",@"其他待办事项"];
    self.arrayData = [NSArray array];
    
    self.string1 = @"";
    self.string2 = @"";
    self.startTime = @"";
    self.endTime = @"";
    self.wornTime = @"";
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
