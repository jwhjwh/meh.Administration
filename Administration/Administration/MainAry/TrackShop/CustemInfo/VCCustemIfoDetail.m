//
//  VCPersonInfoDetail.m
//  Administration
//
//  Created by zhang on 2017/12/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCCustemIfoDetail.h"
#import "CellTrack1.h"
#import "VCSpeciality.h"
#import "VCAddBrithday.h"
#import "VCBrithdayDetail.h"
@interface VCCustemIfoDetail ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableDictionary *dictInfo;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,weak)UITableView *tableView;
@end

@implementation VCCustemIfoDetail
#pragma -mark custem
-(void)setUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@stores/selectstore.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Storeid":self.shopID,
                           @"store":@"4",
                           @"StoreCustomerId":self.personID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            NSDictionary *dict = [responseObject valueForKey:@"list"][0];
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    if ([obj isKindOfClass:[NSNumber class]]) {
                        obj = [NSString stringWithFormat:@"%@",obj];
                    }else
                    {
                        obj = @"";
                    }
                }else
                {
                    obj = [NSString stringWithFormat:@"%@",obj];
                }
                [self.dictInfo setObject:obj forKey:key];
            }];
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0f];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)gotoAddBrithay
{
    if ([self.dictInfo[@"remind"]intValue] ==0) {
        VCAddBrithday *vc = [[VCAddBrithday alloc]init];
        vc.dictInfo = self.dictInfo;
        
        
        if ([self.dictInfo[@"solarBirthday"]isKindOfClass:[NSNull class]]&&[self.dictInfo[@"lunarBirthday"]isKindOfClass:[NSNull class]]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无生日" andInterval:1.0];
            return;
        }else
        {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else
    {
        //跳转生日详情
        VCBrithdayDetail *vc = [[VCBrithdayDetail alloc]init];
        vc.remind = [NSString stringWithFormat:@"%@",self.dictInfo[@"remind"]];
        vc.dictInfo = self.dictInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma -mark tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayTitle.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayTitle[section]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTrack1 *cell = [[CellTrack1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellTrack1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textView.userInteractionEnabled = NO;
    cell.textView.scrollEnabled = NO;
    cell.labelTitle.text = self.arrayTitle[indexPath.section][indexPath.row];
    
    if (indexPath.section==2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                cell.textView.text = self.dictInfo[@"name"];
                break;
            case 1:
                cell.textView.text = self.dictInfo[@"age"];
                break;
                
            default:
                break;
        }
    }else if (indexPath.section==1)
    {
        switch (indexPath.row) {
            case 0:
                cell.textView.text = self.dictInfo[@"phone"];
               
                break;
            case 1:
            {
                if ([self.dictInfo[@"flag"] isEqualToString:@"1"]) {
                    cell.textView.text = self.dictInfo[@"lunarBirthday"];
                }else
                {
                    cell.textView.text = self.dictInfo[@"solarBirthday"];
                }
                if ([self.dictInfo[@"flag"]isEqualToString:@"1"]) {
                    cell.textView.text = self.dictInfo[@"lunarBirthday"];
                }else
                {
                    cell.textView.text = self.dictInfo[@"solarBirthday"];
                }
                
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-30, 10, 30, 20)];
                [button setTitle:@"提醒" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(gotoAddBrithay) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
                if (![self.dictInfo[@"remind"]isEqualToString:@"0"]) {
                    [button setTitleColor:GetColor(229, 126, 0, 1) forState:UIControlStateNormal];
                }
        }
                break;
            case 2:
                cell.textView.text = self.dictInfo[@"qcode"];
                break;

            case 3:
                cell.textView.text = self.dictInfo[@"wcode"];
                break;

            case 4:
                cell.textView.text = self.dictInfo[@"hobbies"];
                break;

            case 5:
                cell.textView.text = self.dictInfo[@"personality"];
                break;

            case 6:
                cell.textView.text = self.dictInfo[@"salesBrand"];
                break;

                
            default:
                break;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        VCSpeciality *vc = [[VCSpeciality alloc]init];
        vc.stringTitle = self.arrayTitle[indexPath.section][indexPath.row];
        switch (indexPath.row) {
            case 0:
                vc.content = self.dictInfo[@"customerHealth"];
                break;
            case 1:
                vc.content = self.dictInfo[@"ongoingItem"];
                break;
            case 2:
                vc.content = self.dictInfo[@"heedful"];
                break;
//            case 3:
//                vc.content = self.dictInfo[@""];
//                break;
//            case 4:
//                vc.content = self.dictInfo[@""];
//                break;
//            case 5:
//                vc.content = self.dictInfo[@""];
//                break;
            case 3:
                vc.content = self.dictInfo[@"consumption"];
                break;
                
            default:
                break;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

#pragma -mark system

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"顾客信息";
    self.dictInfo = [NSMutableDictionary dictionary];
    self.arrayTitle = @[@[@"姓名",@"年龄"],@[@"电话",@"生日",@"QQ",@"微信",@"爱好",@"性格",@"所做品牌"],@[@"顾客身体情况简介",@"正在做的项目",@"特殊注意说明",
//                                                                                        @"经营状况",@"常到顾客",@"拓客计划",
                                                                                        @"消费分析"]];
    [self setUI];
    [self getHttpData];
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
