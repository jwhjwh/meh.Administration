//
//  TransferGroupViewController.m
//  Administration
//
//  Created by zhang on 2017/7/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TransferGroupViewController.h"
#import "CellGroup.h"
@interface TransferGroupViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSDictionary *dictInfo;
@end

@implementation TransferGroupViewController
#pragma --mark mark custom
-(void)transferGroup
{
    NSString *urlStr =[NSString stringWithFormat:@"%@group/updateGroupInformation.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *userid = [USER_DEFAULTS objectForKey:@"userid"];
    
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":userid,@"Userid":self.dictInfo[@"userId"],@"groupNumber":self.groupInfo[@"groupNumber"],@"groupinformationId":self.dictInfo[@"groupinformationId"],@"uuid":self.dictInfo[@"uuid"]};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *stringCode = [responseObject valueForKey:@"status"];
        if ([stringCode isEqualToString:@"0000"]) {
            [self back];
            return ;
        }
        if ([stringCode isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"token超时请重新登录" andInterval:1];
            return ;
        }
        if ([stringCode isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1];
            return ;
        }
        if ([stringCode isEqualToString:@"1111"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1];
            return ;
        }
        if ([stringCode isEqualToString:@"0003"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"权限不足" andInterval:1];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)back
{
    UIViewController * viewControllerWithdraw = nil;
    for (UIViewController * viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:NSClassFromString(@"ChatViewController")])
        {
            viewControllerWithdraw = viewController;
            [self.navigationController popToViewController:viewControllerWithdraw animated:YES];
            break;
        }
    }

    
}
#pragma -mark mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrList[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellGroup *cell = [self.tableview dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellGroup alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.labelDivision.hidden = YES;
    cell.locationButton.hidden = YES;
    NSDictionary *dict = self.arrList[indexPath.section][indexPath.row];
    cell.nameLabel.text = dict[@"name"];
    cell.TelLabel.text = dict[@"account"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",KURLHeader,dict[@"img"]];
    [cell.TXImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"banben100"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.dictInfo = self.arrList[indexPath.section][indexPath.row];
    UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要将此群转让？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alt show];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.arrTitle[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
}

#pragma --mark mark UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self transferGroup];
    }
}

#pragma -mark mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"转让该群";
    
    self.tableview  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:NSClassFromString(@"CellGroup") forCellReuseIdentifier:@"cell"];
    
    [self.arrList removeObjectAtIndex:0];
    [self.arrTitle removeObjectAtIndex:0];
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
