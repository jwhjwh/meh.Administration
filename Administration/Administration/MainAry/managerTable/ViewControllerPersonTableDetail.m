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
            [self.tableView reloadData];
            return ;
        }
        if ([stringCode isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return;
        }
        if ([stringCode isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"token请求超时" andInterval:1];
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ViewControllerPostil *vc = [[ViewControllerPostil alloc]init];
    vc.stringName = cell.labelContent.attributedText;
    vc.tableID = self.tableId;
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
                     @"Num":self.remark,
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
                     @"Num":self.remark,
                     @"Sort":[ShareModel shareModel].sort,
                     @"State":@"2",
                     @"code":@"2",
                     @"id":self.dictContent[@"id"]};
        }
        
        [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
            NSString *string = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
            if ([string isEqualToString:@"0000"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"成功" andInterval:1];
                return ;
            }
            if ([string isEqualToString:@"4444"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
                return ;
            }
            if ([string isEqualToString:@"1001"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"token请求超时" andInterval:1];
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
    if ([self.postionName containsString:@"美导"]) {
        if (indexPath.row<3) {
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            CellInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (cell==nil) {
                cell = [[CellInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            }
            cell.labelTitle.text = self.arrayTitle[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    cell.labelInfo.text = self.dictContent[@"dateLine"];
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
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            CellTabelDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell==nil) {
                cell = [[CellTabelDetail alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            
            switch (indexPath.row) {
                case 3:
                    cell.labelContent.text = self.dictContent[@"store"];
                    break;
                case 4:
                    cell.labelContent.text = self.dictContent[@"aim"];
                    break;
                case 5:
                    cell.labelContent.text = self.dictContent[@"achievement"];
                    break;
                case 6:
                    cell.labelContent.text = self.dictContent[@"shipment"];
                    break;
                case 7:
                    cell.labelContent.text = self.dictContent[@"question"];
                    break;
                case 8:
                    cell.labelContent.text = self.dictContent[@"solution"];
                    break;
                case 9:
                    cell.labelContent.text = self.dictContent[@"apperception"];
                    break;
                case 10:
                    cell.labelContent.text = self.dictContent[@"morgenPlan"];
                    break;
                case 11:
                    cell.labelContent.text = self.dictContent[@"morgenAim"];
                    break;
                case 12:
                    cell.labelContent.text = self.dictContent[@"summery"];
                    break;
                default:
                    break;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.button addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
            cell.labelTitle.text = self.arrayTitle[indexPath.row];
            return cell;
        }
       
    }
   else
   {
       if (indexPath.row<4) {
           tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
           CellInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
           if (cell==nil) {
               cell = [[CellInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
           }
           cell.labelTitle.text = self.arrayTitle[indexPath.row];
           switch (indexPath.row) {
               case 0:
                   cell.labelInfo.text = self.dictContent[@"dateLine"];
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
           CellTabelDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
           if (cell==nil) {
               cell = [[CellTabelDetail alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
           }
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
           [cell.button addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
           cell.labelTitle.text = self.arrayTitle[indexPath.row];
           switch (indexPath.row) {
               case 4:
                   cell.labelContent.text = self.dictContent[@"theTargetJob"];
                   break;
               case 5:
                   cell.labelContent.text = self.dictContent[@"appraisal"];
                   break;
               case 6:
                   cell.labelContent.text = self.dictContent[@"evaluation"];
                   break;
               case 7:
                   cell.labelContent.text = self.dictContent[@"reason"];
                   break;
               case 8:
                   cell.labelContent.text = self.dictContent[@"feelingToShare"];
                   break;
               case 9:
                   cell.labelContent.text = self.dictContent[@"plans"];
                   break;
               default:
                   break;
           }
           return cell;
       }
   }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CellTabelDetail *cell = [tableView cellForRowAtIndexPath:indexPath];
//    CGSize size = [cell.labelContent.text boundingRectWithSize:CGSizeMake(Scree_width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//    
//    return size.height+27;
//}

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
    
    if ([self.postionName containsString:@"美导"]) {
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"地区店名老板",@"目标",@"业绩",@"出货",@"发现问题",@"解决方案",@"感悟分享",@"明日计划",@"明日目标",@"总结"];
    }else
    {
    self.arrayTitle = @[@"日期",@"陌拜地址",@"职位",@"姓名",@"今日目标及工作详细内容",@"自我状态评估",@"自我打分",@"原因",@"感悟分享及心得",@"明日计划安排"];
    }
    self.dictContent = [NSDictionary dictionary];

    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"审核" style:(UIBarButtonItemStyleDone) target:self action:@selector(checkTable:)];
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
