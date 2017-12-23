//
//  VCShopInfoManager.m
//  Administration
//
//  Created by zhang on 2017/12/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ManagerShopinfo.h"
#import "VCBossInfoManager.h"
#import "VCCustemInfoM.h"
#import "VCPersonInfoM.h"
#import "VCShopInfoManager.h"
#import "VCManagerAddPermision.h"
@interface ManagerShopinfo ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong)NSArray *array;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation ManagerShopinfo

#pragma -mark custem

-(void)setUI
{
    
    if (![[ShareModel shareModel].roleID isEqualToString:@"2"]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"..." style:UIBarButtonItemStyleDone target:self action:@selector(showAlert)];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除门店",@"谁可以看",@"谁负责", nil];
    alert.tag = 100;
    [alert show];
}

-(void)deleteShop
{
    NSString *urlStr =[NSString stringWithFormat:@"%@stores/delstore.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS valueForKey:@"userid"],@"RoleId":[ShareModel shareModel].roleID,@"Storeid":[ShareModel shareModel].shopID};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
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

#pragma -mark alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        switch (buttonIndex) {
            case 1:
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"数据存在，是否删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 200;
                [alert show];
            }
                break;
            case 2:
            {
                VCManagerAddPermision *vc = [[VCManagerAddPermision alloc]init];
                vc.stringTitle = @"谁可以看";
                vc.stringCode = @"2";
                vc.buttonTitle = @"添加访问人";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                VCManagerAddPermision *vc = [[VCManagerAddPermision alloc]init];
                vc.stringTitle = @"谁负责";
                vc.stringCode = @"1";
                vc.buttonTitle = @"添加负责人";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }

    }else
    {
        if (buttonIndex==1) {
            [self deleteShop];
        }
    }
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.array[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            VCShopInfoManager *vc = [[VCShopInfoManager alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            VCBossInfoManager *vc = [[VCBossInfoManager alloc]init];
            vc.isEdit = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            VCPersonInfoM *vc = [[VCPersonInfoM alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            VCCustemInfoM *vc = [[VCCustemInfoM alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    [ShareModel shareModel].storeName = self.stringTitle;
    [self setUI];
    
    self.array = @[@"门店信息",@"老板信息",@"店员信息",@"顾客信息"];
    
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
