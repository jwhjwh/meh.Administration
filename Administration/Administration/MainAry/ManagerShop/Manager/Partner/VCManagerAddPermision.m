//
//  VCManagerAddPermision.m
//  Administration
//
//  Created by zhang on 2017/12/21.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCManagerAddPermision.h"
#import "VCManagerAddPermision.h"
#import "VCManagerChoosePostion.h"
#import "CellChargeManager.h"
#import "VCManagerChoosePerson.h"
@interface VCManagerAddPermision ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,strong)NSIndexPath *indexPath;
@end

@implementation VCManagerAddPermision

#pragma -mark custem
-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@stores/selectStoreUsersid.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{
                         @"appkey":appKeyStr,
                         @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                         @"Storeid":[ShareModel shareModel].shopID,
                         @"CompanyInfoId":compid,
                         @"DepartmentId":[ShareModel shareModel].departmentID,
                         @"RoleId":[ShareModel shareModel].roleID,
                         @"code":self.stringCode
                         };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.arrayData = [[responseObject valueForKey:@"list"]mutableCopy];
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"0003"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无权限" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"5000"]) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 21)];
            label.text = @"请添加访问人";
            label.textColor = GetColor(192, 192, 192, 1);
            label.center = self.view.center;
            [self.view addSubview:label];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)showAlertView:(UIButton *)button
{
    CellChargeManager *cell = (CellChargeManager *)[button superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.indexPath = indexPath;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除人员" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)setUI
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, kTopHeight, Scree_width, 44)];
    button.adjustsImageWhenHighlighted = NO;
    [button setTitle:self.buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoChoosePostion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, kTopHeight+44, Scree_width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45+kTopHeight, Scree_width, Scree_height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CellChargeManager class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)gotoChoosePostion
{
    if ([self.stringCode isEqualToString:@"2"]) {
        VCManagerChoosePostion *vc = [[VCManagerChoosePostion alloc]init];
        vc.stringCode = self.stringCode;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        VCManagerChoosePerson *vc = [[VCManagerChoosePerson alloc]init];
        vc.stringTitle = @"谁负责";
        vc.stringCode = self.stringCode;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)deletePerson:(NSIndexPath *)indexPath
{
   
    NSDictionary *dictinfo = self.arrayData[indexPath.row];
    
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *urlStr = [NSString stringWithFormat:@"%@stores/deleteStoreusersid.action",KURLHeader];
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];
    [dictJson setValue:[NSString stringWithFormat:@"%@",dictinfo[@"roleId"]] forKey:@"RoleId"];
    [dictJson setValue:[NSString stringWithFormat:@"%@",dictinfo[@"usersid"]] forKey:@"usersid"];
    [array addObject:dictJson];
   
    NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Storeid":[ShareModel shareModel].shopID,
                           @"CompanyInfoId":compid,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"UR":string,
                           @"code":self.stringCode,
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除成功" andInterval:1.0];
            [self.arrayData removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"0003"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无权限" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    CellChargeManager *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CellChargeManager alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dict = self.arrayData[indexPath.row];
    cell.labelLine.hidden = NO;
    cell.buttonDel.hidden = NO;
    cell.buttonDel.userInteractionEnabled = YES;
    [cell.buttonDel addTarget:self action:@selector(showAlertView:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma -mark alertViewDelagate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self deletePerson:self.indexPath];
    }
}


#pragma -mark system
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.arrayData removeAllObjects];
    [self getHttpData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    self.title = self.stringTitle;
    self.arrayData = [NSMutableArray array];
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
