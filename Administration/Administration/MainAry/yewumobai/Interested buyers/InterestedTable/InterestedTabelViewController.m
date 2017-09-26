//
//  InterestedTabelViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/9/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "InterestedTabelViewController.h"
#import "InterestedModel.h"
#import "SelectAlert.h"
#import "inftionTableViewCell.h"
#import "FillTableViewCell.h"
@interface InterestedTabelViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *infonTableview;
    BOOL isof;
}
@property (nonatomic,retain)NSArray *arr;
@property (strong,nonatomic) NSMutableArray *InterNameAry;
@property (nonatomic,strong) UITextField *textField;

@end

@implementation InterestedTabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意向客户表";
    isof = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"···" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    _InterNameAry = [[NSMutableArray alloc]init];
    _arr=@[@"日期",@"洽谈人",@"地区",@"店名",@"店铺地址",@"负责人",@"手机",@"微信",@"主要经营品牌",@"店面评估档次分类",@"意向选择",@"店面情况简介",@"店家情况综合分析"];
    infonTableview= [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    [infonTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];

    [ZXDNetworking setExtraCellLineHidden:infonTableview];
    [self selectworsh];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect labelRect2 = CGRectMake(120, 1, self.view.bounds.size.width-170, 48);
     if(indexPath.row<8){
         inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
         if (cell ==nil)
         {
             cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
             
         }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.userInteractionEnabled = isof;
         if (isof ==YES) {
             if (indexPath.section == 0) {
                 UIImageView *SiginImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-30, 10, 30, 30)];
                 SiginImage.image = [UIImage imageNamed:@"qd_ico"];
                 [cell addSubview:SiginImage];
                 UILabel *SiginLabel = [[UILabel alloc]initWithFrame:CGRectMake(((self.view.frame.size.width/2)-30)+30, 10, 50, 30)];
                 SiginLabel.text = @"签到";
                 [cell addSubview:SiginLabel];
                 cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
             }else{
                 cell.mingLabel.text = _arr[indexPath.section][indexPath.row];
                 if (indexPath.row == 2) {
                     cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
                     cell.userInteractionEnabled = isof;
                     
                 }
             }
         }else{
             cell.mingLabel.text = _arr[indexPath.row];
             cell.mingLabel.textColor = [UIColor blackColor];
             if (indexPath.row == 2) {
                 cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
                 cell.userInteractionEnabled = isof;
                 
             }
         }
         return cell;
     }else
     {
         FillTableViewCell *cell = [[FillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FillTableCell"];
         if (cell == nil) {
             cell = [[FillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FillTableCell"];
         }
         if (!(indexPath.row==9)) {
             cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
         }
         if (indexPath.row == 9) {
             if (_InterNameAry.count>0) {
                
                 cell.userInteractionEnabled = isof;
             }
             //
         }
         cell.mingLabel.text=_arr[indexPath.row];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         
         return cell;
         
     }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemAction:(UIBarButtonItem*)sender{
    if (isof == NO) {
        NSArray *zwlbAry = [[NSArray alloc]init];
        zwlbAry = @[@"编辑意向客户",@"升级为目标客户",@"确定合作",@"分享给同事",@"删除"];
        [SelectAlert showWithTitle:nil titles:zwlbAry selectIndex:^(NSInteger selectIndex) {
            if (selectIndex == 0) {
                isof = YES;
               
                _arr=@[@[@""],@[@"日期",@"洽谈人",@"地区",@"店名",@"店铺地址",@"负责人",@"手机",@"微信",@"主要经营品牌",@"店面评估档次分类",@"意向选择",@"店面情况简介",@"店家情况综合分析"]];
                [infonTableview reloadData];
            }
        } selectValue:^(NSString *selectValue) {
            
        } showCloseButton:NO];
    }else{
        NSArray *zwlbAry = [[NSArray alloc]init];
        zwlbAry = @[@"提交到上级",@"提交到品牌部"];
        [SelectAlert showWithTitle:nil titles:zwlbAry selectIndex:^(NSInteger selectIndex) {
            if (selectIndex == 0) {
                isof = NO;
                _arr=@[@"日期",@"洽谈人",@"地区",@"店名",@"店铺地址",@"负责人",@"手机",@"微信",@"主要经营品牌",@"店面评估档次分类",@"意向选择",@"店面情况简介",@"店家情况综合分析"];
                [infonTableview reloadData];
            }
        } selectValue:^(NSString *selectValue) {
            
        } showCloseButton:NO];
        
    }
}
-(void)selectworsh{
//数据请求
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectIntended.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"IntendedId":self.intentionId,@"RoleId":self.strId};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *arry=[responseObject valueForKey:@"list"];
            _InterNameAry = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arry) {
                InterestedModel *model=[[InterestedModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_InterNameAry addObject:model];
            }
            [infonTableview reloadData];
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isof ==NO) {
        return _arr.count;
    }else{
      return [_arr[section]count];
    }
    
        

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    if (isof ==NO) {
        return 1;
    }else{
        return 2;
    }
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([infonTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [infonTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([infonTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [infonTableview setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
@end
