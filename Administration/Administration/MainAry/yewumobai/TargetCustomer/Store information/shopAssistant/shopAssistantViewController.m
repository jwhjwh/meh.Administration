//
//  shopAssistantViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/28.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "shopAssistantViewController.h"
#import "ZXDChineseString.h"
#import "shopAssModel.h"
#import "AddAssistant.h"
#import "shopAssTableViewCell.h"
#import "AddCustomer.h"
@interface shopAssistantViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *dataArray;
    UITableView * _tableView;
    NSArray *keys;
    NSMutableDictionary *dict;
    NSMutableArray *arr;
    UITableView *table;
}
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property (nonatomic,strong)NSMutableArray *array;
@end

@implementation shopAssistantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    if ([_shopname isEqualToString:@"1"]) {
        
    }else{
        UIButton *rightitem = [UIButton buttonWithType:UIButtonTypeCustom];
        rightitem.frame =CGRectMake(self.view.frame.size.width-30, 0, 28,28);
        [rightitem setBackgroundImage:[UIImage imageNamed:@"fj_ico"] forState:UIControlStateNormal];
        [rightitem addTarget: self action: @selector(rightItemAction) forControlEvents: UIControlEventTouchUpInside];
        UIBarButtonItem *rbuttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightitem];
        self.navigationItem.rightBarButtonItem = rbuttonItem;
    }
    
    
    table = [[UITableView alloc] initWithFrame:self.view.frame];
    table.delegate = self;
    table.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:table];
    [self.view addSubview:table];
    
    [self afnwtworking];
}
-(void)loadData{
    
    NSMutableArray *aaaa = [NSMutableArray array];
    dict=[NSMutableDictionary dictionary];
    for (NSDictionary *dictc in arr) {
        shopAssModel *model=[[shopAssModel alloc]init];
        [model setValuesForKeysWithDictionary:dictc];
        NSString * nameee = [[NSString alloc]init];
       
        
        NSInteger k = [model.flag integerValue];
        NSString *stringInt = [NSString stringWithFormat:@"%ld",k];
        if ([stringInt isEqualToString:@"1"]) {
             nameee = [NSString stringWithFormat:@"%@    %@",model.name,model.phone];
        }else{
           
             nameee = [NSString stringWithFormat:@"%@    %@",model.name,model.phone];
        }
        [dict setObject:model forKey:nameee];
        [aaaa addObject:dict];
    }
    
    for (NSMutableDictionary  *d in aaaa) {
        keys = [d allKeys];
    }
    self.indexArray = [ZXDChineseString IndexArray:keys];
    self.letterResultArr = [ZXDChineseString LetterSortArray:keys];
    
}
-(void)afnwtworking{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectstore.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    if ([self.titleStr isEqualToString:@"顾客信息"]) {
         dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.shopid,@"store":@"4"};
    }else{
         dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.shopid,@"store":@"3"};
    }
   
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
          
                NSArray *array=[responseObject valueForKey:@"list"];
            arr=[NSMutableArray array];
            dict=[NSMutableDictionary dictionary];
            self.array = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                shopAssModel *model=[[shopAssModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [dict setObject:model forKey:model.name];
                [arr addObject:dict];
            }
            for (NSMutableDictionary  *d in arr) {
                keys = [d allKeys];
            }
            self.indexArray = [ZXDChineseString IndexArray:keys];
            self.array = [ZXDChineseString LetterSortArray:keys];
           
            [table reloadData];
               
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
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
            [table addEmptyViewWithImageName:@"" title:@"暂无店员" Size:20.0];
            table.emptyView.hidden = NO;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.indexArray objectAtIndex:section];
}
//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.indexArray count];
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.array objectAtIndex:section] count];
}
//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    shopAssTableViewCell *cell = [[shopAssTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[shopAssTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.modle=[dict objectForKey: _array[indexPath.section][indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld %ld",(long)indexPath.section,(long)indexPath.row);
     shopAssModel *model=[dict objectForKey: _array[indexPath.section][indexPath.row]];
    NSLog(@"----%@",model.AssustantId);
    if ([self.title isEqualToString:@"顾客信息"]) {
        AddCustomer *addvc = [[AddCustomer alloc]init];
        addvc.issend = NO;
        addvc.shopid = self.shopid;
        addvc.strId = self.strId;
        addvc.StoreClerkId = model.AssustantId;
        addvc.shopname = self.shopname;
        [self.navigationController pushViewController:addvc animated:YES];
    }else{
        AddAssistant *addvc = [[AddAssistant alloc]init];
        addvc.issssend = NO;
        addvc.shopid = self.shopid;
        addvc.strId = self.strId;
        addvc.StoreClerkId = model.AssustantId;
        addvc.shopname = self.shopname;
        [self.navigationController pushViewController:addvc animated:YES];
    }
    

}
-(void)rightItemAction{
    if ([self.title isEqualToString:@"顾客信息"]) {
        AddCustomer *addvc = [[AddCustomer alloc]init];
        addvc.issend = YES;
        addvc.shopid = self.shopid;
        
       
        [self.navigationController pushViewController:addvc animated:YES];
    }else{
        AddAssistant *addvc = [[AddAssistant alloc]init];
        addvc.issssend = YES;
        addvc.shopid = self.shopid;
        [self.navigationController pushViewController:addvc animated:YES];
    }
    

}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 50.0f;
    
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
        [table setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([table respondsToSelector:@selector(setLayoutMargins:)])  {
        [table setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
