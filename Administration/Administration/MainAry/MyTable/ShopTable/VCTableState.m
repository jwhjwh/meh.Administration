//
//  VCTableState.m
//  Administration
//
//  Created by zhang on 2017/9/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCTableState.h"
#import "VCArtShopTable.h"
#import "VCInsideShopTable.h"
#import "VCBussinessShopTable.h"
#import "VCArtFillWeekTable.h"
#import "VCInsideFillWeekTable.h"
#import "VCBuessFillWeekTable.h"
#import "VCArtFillMonthTable.h"
#import "VCInsideFillMonthTable.h"
#import "VCDrafts.h"
#import "VCSubmited.h"
#import "VCNewPostil.h"
#import "VCUnPassed.h"
@interface VCTableState ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arrayData;
@end

@implementation VCTableState

#pragma -mark custem
-(void)getdate
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryUserNewPostilList",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"DepartmentID":[ShareModel shareModel].departmentID,
                           @"Num":[ShareModel shareModel].num,
                           @"Sort":[ShareModel shareModel].sort
                           };
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            NSString *message = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"message"]];
           
            if (![message isEqualToString:@"0"]) {
                NSString *string = [NSString stringWithFormat:@"新批注（%@）",message];
                [self.array replaceObjectAtIndex:3 withObject:string];
                self.arrayData = [[responseObject valueForKey:@"lists"]mutableCopy];
            }
            [self.tableView reloadData];
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];

}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *roleID = [ShareModel shareModel].roleID;
    
    if (indexPath.row==0) {
        if ([[ShareModel shareModel].sort isEqualToString:@"1"]) {
            if (indexPath.row==0) {
                if ([roleID isEqualToString:@"2"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"10"]) {
                    VCArtShopTable  *vc = [[VCArtShopTable alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([roleID isEqualToString:@"5"]||[roleID isEqualToString:@"8"]||[roleID isEqualToString:@"9"]) {
                    //跳转业务界面
                    VCBussinessShopTable *vc = [[VCBussinessShopTable alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else
                {
                    VCInsideShopTable *vc = [[VCInsideShopTable alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
        if ([[ShareModel shareModel].sort isEqualToString:@"2"]) {
            
            if ([roleID isEqualToString:@"2"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"10"]) {
                VCArtFillWeekTable  *vc = [[VCArtFillWeekTable alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([roleID isEqualToString:@"5"]||[roleID isEqualToString:@"8"]||[roleID isEqualToString:@"9"]) {
                //跳转业务界面
                VCBuessFillWeekTable *vc = [[VCBuessFillWeekTable alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCInsideFillWeekTable *vc = [[VCInsideFillWeekTable alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        if ([[ShareModel shareModel].sort isEqualToString:@"3"]) {
            
            if ([roleID isEqualToString:@"2"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"10"]) {
                VCArtFillMonthTable  *vc = [[VCArtFillMonthTable alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCInsideFillMonthTable *vc = [[VCInsideFillMonthTable alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if (indexPath.row==1)
    {
        //跳转草稿箱
        VCDrafts *vc = [[VCDrafts alloc]init];
        if ([[ShareModel shareModel].sort isEqualToString:@"1"]) {
            vc.stringTitle = @"店报表";
        }else if([[ShareModel shareModel].sort isEqualToString:@"2"])
        {
            vc.stringTitle = @"周报表";
        }else
        {
            vc.stringTitle = @"月报表";
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row==2)
    {
        //跳转已提交
        VCSubmited *vc = [[VCSubmited alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row==3)
    {
        //跳转新批注
        VCNewPostil *vc = [[VCNewPostil alloc]init];
        vc.arrayData = self.arrayData;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        //跳转未通过
        VCUnPassed *vc = [[VCUnPassed alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma -mark custem
-(void)setUI
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(-1, kTopHeight, Scree_width+2, 30)];
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1.0f;
    label.textColor = GetColor(59, 148, 243, 1);
    label.text = [NSString stringWithFormat:@"          %@",[ShareModel shareModel].postionName];
    [self.view addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 3, 24, 24)];
    imageView.image = [UIImage imageNamed:@"zw_ico"];
    [label addSubview:imageView];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight+30, Scree_width, Scree_height)];
    tableView.delegate =self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.array = [NSMutableArray arrayWithObjects:@"填写报表",@"草稿箱",@"已提交",@"新批注",@"未通过", nil];
}

#pragma -mark system
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.arrayData removeAllObjects];
    [self getdate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    
    self.arrayData = [NSMutableArray array];
    
    [self setUI];
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
