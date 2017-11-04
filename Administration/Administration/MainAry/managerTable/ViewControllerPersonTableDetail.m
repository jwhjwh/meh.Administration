//
//  ViewControllerPersonTableDetail.m
//  Administration
//
//  Created by zhang on 2017/8/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerPersonTableDetail.h"
#import "CellTabelDetail.h"
#import "ViewControllerPostil.h"
#import "ZXYAlertView.h"
#import "CellInfo.h"
@interface ViewControllerPersonTableDetail ()<UITableViewDelegate,UITableViewDataSource,ZXYAlertViewDelegate,UIAlertViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSDictionary *dictContent;
@property (nonatomic,strong)UIAlertView *alertView;
@property (nonatomic,strong)NSArray *arrayKey;
@property (nonatomic,strong)NSString *power;
@end

@implementation ViewControllerPersonTableDetail
#pragma -mark custem
-(void)getData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryReportInfo",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"DepartmentID":self.departmentId,
                           @"remark":self.remark,
                           @"id":self.tableId
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *stringCode = [responseObject valueForKey:@"status"];
        if ([stringCode isEqualToString:@"0000"]) {
            self.dictContent = responseObject[@"tableInfo"];
            if (self.dictContent!=nil) {
                
                NSString *stringKey = [responseObject valueForKey:@"name"];
                self.arrayKey = [stringKey componentsSeparatedByString:@","];
                self.power = [responseObject valueForKey:@"power"];
               [self.tableView reloadData];
            }
            return ;
        }
        if ([stringCode isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return;
        }
        if ([stringCode isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
            return;
        }
        if ([stringCode isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据为空" andInterval:1];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)checkTable:(UIButton *)button
{
    ZXYAlertView *alt = [ZXYAlertView alertViewDefault];
    alt.title = @"审核";
    alt.buttonArray = @[@"通过",@"不通过"];
    [alt.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    alt.delegate = self;
    [alt show];
}

-(void)editContent:(UIButton *)button
{
    CellTabelDetail *cell = (CellTabelDetail *)[[button superview] superview];
    
    ViewControllerPostil *vc = [[ViewControllerPostil alloc]init];
    vc.stringName = cell.textView.text;
    
    NSMutableArray *array = [[self.dictContent allKeys]mutableCopy];
    if ([array containsObject:@"store"]) {
        [array removeObject:@"store"];
    }
    
    for (NSString *key in array) {
        if (![self.dictContent[key] isEqual:[NSNull class]]) {
            if ([cell.textView.text isEqualToString:[NSString stringWithFormat:@"%@",self.dictContent[key]]]) {
                vc.theKey = key;
                break;
            } 
        }
        
    }
    vc.departmentID = self.departmentId;
    vc.remark = self.remark;
    vc.tableID = self.dictContent[@"id"];
    vc.tableID = self.tableId;
    vc.num = self.num;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)initView
{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
   // tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [tableView registerClass:[CellTabelDetail class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[CellInfo class] forCellReuseIdentifier:@"cell2"];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView = tableView;
    
}

#pragma -mark alertView
-(void)alertView:(ZXYAlertView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        self.alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否将次内容审核为通过？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.alertView.tag = 200;
        [self.alertView show];
        
    }else
    {
        self.alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否将次内容审核为不通过？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.alertView.tag = 300;
        [self.alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/updateReportState",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict;
    
    if (buttonIndex==1) {
        if (alertView.tag == 200) {
            dict = @{@"appkey":appKeyStr,
                     @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                     @"CompanyInfoId":compid,
                     @"RoleId":[ShareModel shareModel].roleID,
                     @"DepartmentID":self.departmentId,
                     @"Num":self.num,
                     @"Sort":[ShareModel shareModel].sort,
                     @"State":@"1",
                     @"code":@"2",
                     @"id":self.dictContent[@"id"]};
        }else
        {
            dict = @{@"appkey":appKeyStr,
                     @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                     @"CompanyInfoId":compid,
                     @"RoleId":[ShareModel shareModel].roleID,
                     @"DepartmentID":self.departmentId,
                     @"Num":self.num,
                     @"Sort":[ShareModel shareModel].sort,
                     @"State":@"2",
                     @"code":@"2",
                     @"id":self.dictContent[@"id"]};
        }
        
        [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
            NSString *string = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
            if ([string isEqualToString:@"0000"]) {
                [self.navigationController popViewControllerAnimated: YES];
                return ;
            }
            if ([string isEqualToString:@"4444"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
                return ;
            }
            if ([string isEqualToString:@"1001"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
                return ;
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
        
        
        
        
    }
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.postionName containsString:@"美导"]||[self.postionName containsString:@"市场"]) {
        if (indexPath.row<3) {
            CellInfo *cell = [[CellInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            if (cell==nil) {
                cell = [[CellInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelTitle.text = self.arrayTitle[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    cell.labelInfo.text = [self.dictContent[@"dateLine"]substringToIndex:10];
                    break;
                case 1:
                    cell.labelInfo.text = self.postionName;
                    break;
                case 2:
                    cell.labelInfo.text = self.dictContent[@"name"];
                    break;
                    
                default:
                    break;
            }
             return cell;
        }else
        {
            CellTabelDetail *cell = [[CellTabelDetail alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            if (cell==nil) {
                cell = [[CellTabelDetail alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.power.length!=0) {
                if ([self.power containsString:[ShareModel shareModel].roleID]) {
                    cell.button.hidden = NO;
                    cell.button.userInteractionEnabled = YES;
                }else
                {
                    cell.button.hidden = YES;
                    cell.button.userInteractionEnabled = NO;;
                }
            }
            
            switch (indexPath.row) {
                    
                case 3:
                    cell.textView.text = self.dictContent[@"store"];
                    cell.button.hidden = YES;
                    cell.button.userInteractionEnabled = NO;
                    break;
                case 4:
                    if (self.dictContent[@"aim"]) {
                       cell.textView.text = self.dictContent[@"aim"];
                    }
                    else
                    {
                        cell.textView.text = @"  ";
                    }
                    
                    if ([self.arrayKey containsObject:@"aim"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        cell.button.hidden = NO;
                    }
                    break;
                case 5:
                    if (self.dictContent[@"achievement"]) {
                        cell.textView.text = self.dictContent[@"achievement"];
                    }
                    else
                    {
                        cell.textView.text = @"  ";
                    }
                   if ([self.arrayKey containsObject:@"achievement"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                       cell.button.hidden = NO;
                    }
                    break;
                case 6:
                    if (self.dictContent[@"shipment"]) {
                        cell.textView.text = self.dictContent[@"shipment"];
                    }
                    else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"shipment"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        cell.button.hidden = NO;
                    }
                    break;
                case 7:
                    if (self.dictContent[@"question"]) {
                        cell.textView.text = self.dictContent[@"question"];
                    }
                    else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"question"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        cell.button.hidden = NO;
                    }
                    break;
                case 8:
                    if (self.dictContent[@"solution"]) {
                        cell.textView.text = self.dictContent[@"solution"];
                    }
                    else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"solution"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        cell.button.hidden = NO;
                    }
                    break;
                case 9:
                    if (self.dictContent[@"apperception"]) {
                        cell.textView.text = self.dictContent[@"apperception"];
                    }
                    else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"apperception"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        cell.button.hidden = NO;
                    }
                    break;
                case 10:
                    if (self.dictContent[@"morgenPlan"]) {
                        cell.textView.text = self.dictContent[@"morgenPlan"];
                    }
                    else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"morgenPlan"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        cell.button.hidden = NO;
                    }
                    break;
                case 11:
                    if (self.dictContent[@"morgenAim"]) {
                        cell.textView.text = self.dictContent[@"morgenAim"];
                    }
                    else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"morgenAim"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        cell.button.hidden = NO;
                    }
                    break;
                case 12:
                    if (self.dictContent[@"summery"]) {
                        cell.textView.text = self.dictContent[@"summery"];
                    }
                    else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"summery"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        cell.button.hidden = NO;
                    }
                    break;
                default:
                    break;
            }
            [cell.button addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
            cell.labelTitle.text = self.arrayTitle[indexPath.row];
            return cell;
        }
       
    }
   else if([self.postionName containsString:@"业务"])
   {
       if (indexPath.row<4) {
           CellInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
           if (cell==nil) {
               cell = [[CellInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
           }
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
           cell.labelTitle.text = self.arrayTitle[indexPath.row];
           switch (indexPath.row) {
               case 0:
                   cell.labelInfo.text = [self.dictContent[@"dates"] substringToIndex:15];
                   break;
               case 1:
                   cell.labelInfo.text = self.dictContent[@"worship"];
                   break;
               case 2:
                   cell.labelInfo.text = self.postionName;
                   break;
               case 3:
                   cell.labelInfo.text = self.dictContent[@"name"];
                   break;
               default:
                   break;
           }
           return cell;
       }else
       {
           CellTabelDetail *cell = [[CellTabelDetail alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
           if (cell==nil) {
               cell = [[CellTabelDetail alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
           }
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
           [cell.button addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
           cell.labelTitle.text = self.arrayTitle[indexPath.row];
           
           if (self.power.length!=0) {
               if ([self.power containsString:[ShareModel shareModel].roleID]) {
                   cell.button.hidden = NO;
                   cell.button.userInteractionEnabled = YES;
               }else
               {
                   cell.button.hidden = YES;
                   cell.button.userInteractionEnabled = NO;;
               }
           }
           
           switch (indexPath.row) {
               case 4:
                   if (self.dictContent[@"theTargetJob"]) {
                       cell.textView.text = self.dictContent[@"theTargetJob"];
                   }
                   else
                   {
                       cell.textView.text = @"  ";
                   }
                   if ([self.arrayKey containsObject:@"theTargetJob"]) {
                       [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                   }
                   break;
               case 5:
                   if (self.dictContent[@"appraisal"]) {
                       cell.textView.text = self.dictContent[@"appraisal"];
                   }
                   else
                   {
                       cell.textView.text = @"  ";
                   }
                   if ([self.arrayKey containsObject:@"appraisal"]) {
                       [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                       cell.button.hidden = NO;
                   }
                   break;
               case 6:
                   if (self.dictContent[@"evaluation"]) {
                       cell.textView.text = [NSString stringWithFormat:@"%@",self.dictContent[@"evaluation"]];
                   }
                   else
                   {
                       cell.textView.text = @"  ";
                   }
                   
                   if ([self.arrayKey containsObject:@"evaluation"]) {
                       [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                       cell.button.hidden = NO;
                   }
                   break;
               case 7:
                   if (self.dictContent[@"reason"]) {
                       cell.textView.text = self.dictContent[@"reason"];
                   }
                   else
                   {
                       cell.textView.text = @"  ";
                   }
                   if ([self.arrayKey containsObject:@"reason"]) {
                       [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                   }
                   break;
               case 8:
                   if (self.dictContent[@"feelingToShare"]) {
                       cell.textView.text = self.dictContent[@"feelingToShare"];
                   }
                   else
                   {
                       cell.textView.text = @"  ";
                   }
                   if ([self.arrayKey containsObject:@"feelingToShare"]) {
                       [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                       cell.button.hidden = NO;
                   }
                   break;
               case 9:
                   if (self.dictContent[@"plans"]) {
                       cell.textView.text = self.dictContent[@"plans"];
                   }
                   else
                   {
                       cell.textView.text = @"  ";
                   }
                   if ([self.arrayKey containsObject:@"plans"]) {
                       [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                       cell.button.hidden = NO;
                   }
                   break;
               default:
                   break;
           }
           return cell;
       }
   }else
   {
       if (indexPath.row<4) {
           CellInfo *cell = [[CellInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
           if (cell==nil) {
               cell = [[CellInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
           }
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
           cell.labelTitle.text = self.arrayTitle[indexPath.row];
           switch (indexPath.row) {
               case 0:
                   cell.labelInfo.text = [self.dictContent[@"dates"] substringToIndex:16];
                   break;
               case 1:
                   cell.labelInfo.text = self.dictContent[@"store"];
                   break;
               case 2:
                   cell.labelInfo.text = self.postionName;
                   break;
               case 3:
                   cell.labelInfo.text = self.dictContent[@"name"];
                   break;
               default:
                   break;
           }
           return cell;
       }else
       {
           CellTabelDetail *cell = [[CellTabelDetail alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
           if (cell==nil) {
               cell = [[CellTabelDetail alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
           }
           
           if (self.power.length!=0) {
               if ([self.power containsString:[ShareModel shareModel].roleID]) {
                   cell.button.hidden = NO;
                   cell.button.userInteractionEnabled = YES;
               }else
               {
                   cell.button.hidden = YES;
                   cell.button.userInteractionEnabled = NO;;
               }
           }
           
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
           [cell.button addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
           cell.labelTitle.text = self.arrayTitle[indexPath.row];
           switch (indexPath.row) {
               case 4:
                   if (self.dictContent[@"targetDetail"]) {
                       cell.textView.text = self.dictContent[@"targetDetail"];
                   }
                   else
                   {
                       cell.textView.text = @"  ";
                   }
                   if ([self.arrayKey containsObject:@"targetDetail"]) {
                       [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                       cell.button.hidden = NO;
                   }
                   break;
               case 5:
                   if (self.dictContent[@"appraisal"]) {
                       cell.textView.text = self.dictContent[@"appraisal"];
                   }
                   else
                   {
                       cell.textView.text = @"  ";
                   }
                   if ([self.arrayKey containsObject:@"appraisal"]) {
                       [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                       cell.button.hidden = NO;
                   }
                   break;
               case 6:
                   if (self.dictContent[@"evaluation"]) {
                       cell.textView.text = [NSString stringWithFormat:@"%@",self.dictContent[@"evaluation"]];
                   }
                   else
                   {
                       cell.textView.text = @"  ";
                   }
                   
                   if ([self.arrayKey containsObject:@"evaluation"]) {
                       [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                       cell.button.hidden = NO;
                   }
                   break;
               case 7:
                   if (self.dictContent[@"reason"]) {
                       cell.textView.text = self.dictContent[@"reason"];
                   }
                   else
                   {
                       cell.textView.text = @"  ";
                   }
                   if ([self.arrayKey containsObject:@"reason"]) {
                       [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                       cell.button.hidden = NO;
                   }
                   break;
               case 8:
                   if (self.dictContent[@"sentiment"]) {
                       cell.textView.text = self.dictContent[@"sentiment"];
                   }
                   else
                   {
                       cell.textView.text = @"  ";
                   }
                   if ([self.arrayKey containsObject:@"sentiment"]) {
                       [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                       cell.button.hidden = NO;
                   }
                   break;
               case 9:
                   if (self.dictContent[@"tomorrowPlan"]) {
                       cell.textView.text = self.dictContent[@"tomorrowPlan"];
                   }
                   else
                   {
                       cell.textView.text = @"  ";
                   }
                   if ([self.arrayKey containsObject:@"tomorrowPlan"]) {
                       [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                       cell.button.hidden = NO;
                   }
                   break;
               default:
                   break;
           }
           return cell;
       }
   }
}



#pragma -mark system
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    [self initView];
    
    if ([self.postionName containsString:@"美导"]||[self.postionName containsString:@"市场"]) {
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"地区店名老板",@"目标",@"业绩",@"出货",@"发现问题",@"解决方案",@"感悟分享",@"明日计划",@"明日目标",@"总结"];
    }else if([self.postionName containsString:@"业务"])
    {
    self.arrayTitle = @[@"日期",@"陌拜地址",@"职位",@"姓名",@"今日目标及工作详细内容",@"自我状态评估",@"自我打分",@"原因",@"感悟分享及心得",@"明日计划安排"];
    }else
    {
        self.arrayTitle = @[@"日期",@"服务店家",@"职位",@"姓名",@"今日目标及工作详细内容",@"自我状态评估",@"自我打分",@"原因",@"感悟分享及心得",@"明日计划安排"];
    }
    self.dictContent = [NSDictionary dictionary];
    self.arrayKey = [NSArray array];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"审核" style:(UIBarButtonItemStyleDone) target:self action:@selector(checkTable:)];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    if ([self.state isEqualToString:@"0"]) {
      self.navigationItem.rightBarButtonItem = rightitem;
    }
    
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
