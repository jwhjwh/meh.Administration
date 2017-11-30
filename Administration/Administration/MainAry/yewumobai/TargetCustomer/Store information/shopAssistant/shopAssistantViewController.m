//
//  shopAssistantViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/28.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "shopAssistantViewController.h"
#import "ZXDChineseString.h"
#import "Brandmodle.h"
#import "brandTableViewCell.h"
#import "AddAssistant.h"

@interface shopAssistantViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *dataArray;
 
    UITableView * _tableView;
   
    NSArray *keys;
    NSArray *key;
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
    self.title = @"店员信息";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIButton *rightitem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightitem.frame =CGRectMake(self.view.frame.size.width-30, 0, 28,28);
    [rightitem setBackgroundImage:[UIImage imageNamed:@"fj_ico"] forState:UIControlStateNormal];
    [rightitem addTarget: self action: @selector(rightItemAction) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *rbuttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightitem];
    self.navigationItem.rightBarButtonItem = rbuttonItem;
    
    //[self loadData];
    
    //根据Person对象的 name 属性 按中文 对 Person数组 排序
  
//
//    self.indexArray = [ZXDChineseString IndexArray:dataArray];
//    self.letterResultArr = [ZXDChineseString LetterSortArray:dataArray];
    
    table = [[UITableView alloc] initWithFrame:self.view.frame];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [self afnwtworking];
}
-(void)loadData{
    NSArray *stringsToSort=[NSArray arrayWithObjects:
                            @"李白",@"张三",
                            @"重庆",@"重量",
                            @"调节",@"调用",
                            @"小白",@"小明",@"千珏",
                            @"黄家驹", @"鼠标",@"hello",@"多美丽",@"肯德基",@"##",
                            nil];
    
    //模拟网络请求接收到的数组对象 Person数组
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
  
    
     arr=[NSMutableArray array];
     dict=[NSMutableDictionary dictionary];
     
     for (NSDictionary *dic in stringsToSort) {
         Brandmodle *model=[[Brandmodle alloc]init];
         [model setValuesForKeysWithDictionary:dic];
         [dict setObject:model forKey:model.finsk];
     [arr addObject:dict];
     }
     for (NSMutableDictionary  *d in arr) {
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
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.shopid,@"store":@"3"};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            
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
    return [[self.letterResultArr objectAtIndex:section] count];
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
    brandTableViewCell *cell = [[brandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[brandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.modle=[dict objectForKey: _array[indexPath.section][indexPath.row]];
    return cell;
}
-(void)rightItemAction{
    AddAssistant *addvc = [[AddAssistant alloc]init];
    addvc.issssend = YES;
    [self.navigationController pushViewController:addvc animated:YES];

}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
