//
//  brandViewController.m
//  Administration
//
//  Created by zhang on 2017/3/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "brandViewController.h"
#import "AddBrandViewController.h"
#import "BrandSeachController.h"
#import "EditbrandController.h"
#import "brandTableViewCell.h"
#import "LGUIView.h"
#import "Brandmodle.h"
#import "ZXDChineseString.h"
@interface brandViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    LGUIView * lgView;
    UITableView * _tableView;
    int page;
    int totalPage;//总页数
    NSArray *keys;
    NSArray *key;
    NSMutableDictionary *dict;
    NSMutableArray *arr;
}
@property (nonatomic,strong)NSMutableArray *indexArray;
@property (nonatomic,strong)NSMutableArray *array;
@property (strong,nonatomic) UIButton *sousuoBtn;
@end
@implementation brandViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.title=@"经营品牌";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(butLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIButton *bton = [UIButton buttonWithType:UIButtonTypeCustom];
    bton.frame =CGRectMake(0, 0, 28,28);
    [bton setBackgroundImage:[UIImage imageNamed:@"fj_ico"] forState:UIControlStateNormal];
    [bton addTarget: self action: @selector(buttonrightItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *btonItem=[[UIBarButtonItem alloc]initWithCustomView:bton];
    self.navigationItem.rightBarButtonItem=btonItem;

    _sousuoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *imageBtn = [UIImage imageNamed:@"ss_ico01"];
    [_sousuoBtn setBackgroundImage:imageBtn forState:UIControlStateNormal];
    _sousuoBtn.frame=CGRectMake(10, 70, Scree_width-20, 40);
    _sousuoBtn.layer.masksToBounds = YES;
    _sousuoBtn.layer.cornerRadius = 8.0;
    [_sousuoBtn addTarget:self action:@selector(Touchsearch)forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_sousuoBtn];
    [self creatTableView];
   
}

-(void)creatTableView
{    _tableView.showsVerticalScrollIndicator = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120,Scree_width - 40, Scree_height - 120) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
   
    [self.view addSubview:_tableView];
     [ZXDNetworking setExtraCellLineHidden:_tableView];
  
    [self getNetworkData];
   
}
-(void)creatLGView
{
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < 26; i ++)
    {
        unichar ch = 65 + i;
        NSString * str = [NSString stringWithUTF8String:(char *)&ch];
        [arr addObject:str];
    }
    
    lgView = [[LGUIView alloc]initWithFrame:CGRectMake(Scree_width - 40, 100, 40, Scree_height - 140) indexArray:_indexArray];
    [self.view addSubview:lgView];
    
    [lgView selectIndexBlock:^(NSInteger section)
     {
        
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] animated:NO  scrollPosition:UITableViewScrollPositionTop];
        
     }];
}

-(void)buttonrightItem{
    AddBrandViewController *addBrandVC=[[AddBrandViewController alloc]init];
    addBrandVC.blcokStr=^(UIImage *goodPicture,NSString*String,NSString*strid){
         Brandmodle *model=[[Brandmodle alloc]init];
        NSData *data = UIImageJPEGRepresentation(goodPicture, 1.0f);
        model.brandLogo = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        model.finsk=String;
        model.ID=strid;
        [dict setObject:model forKey:model.finsk];
        [arr addObject:dict];
        
        for (NSMutableDictionary  *d in arr) {
            key = [d allKeys];
        }
     
        self.array = [NSMutableArray array];
        self.indexArray = [ZXDChineseString IndexArray:key];
        self.array = [ZXDChineseString LetterSortArray:key];
        [_tableView reloadData];
    };
    [self.navigationController pushViewController:addBrandVC animated:YES];
}
-(void)butLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString * str = [NSString stringWithFormat:@"%@",_indexArray[section]];
    return str;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _indexArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array[section]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    brandTableViewCell *cell = [[brandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[brandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.modle=[dict objectForKey: _array[indexPath.section][indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Brandmodle *model=[dict objectForKey: _array[indexPath.section][indexPath.row]];
  
}
-(void)getNetworkData{
   
    NSString *uStr =[NSString stringWithFormat:@"%@brand/querybrand.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"]};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        
    
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"brandlist"];
             arr=[NSMutableArray array];
             dict=[NSMutableDictionary dictionary];
             self.array = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                Brandmodle *model=[[Brandmodle alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [dict setObject:model forKey:model.finsk];
                [arr addObject:dict];
            }
            for (NSMutableDictionary  *d in arr) {
                keys = [d allKeys];
            }
            self.indexArray = [ZXDChineseString IndexArray:keys];
            self.array = [ZXDChineseString LetterSortArray:keys];
            if (self.array.count==0) {
                [_tableView addEmptyViewWithImageName:@"" title:@"暂无经营品牌信息，添加几条吧～～" Size:20.0];
                _tableView.emptyView.hidden = NO;
            }
            [_tableView reloadData];
            [self creatLGView];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到更多品牌信息" andInterval:1.0];
            [_tableView addEmptyViewWithImageName:@"" title:@"暂无经营品牌信息，添加几条吧～～" Size:20.0];
            _tableView.emptyView.hidden = NO;
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
        
    }failure:^(NSError *error) {
        
    }view:self.view MBPro:YES];
    
}
-(void)Touchsearch{
    BrandSeachController *brandVC =[[BrandSeachController alloc]init];
    [self.navigationController pushViewController:brandVC animated:YES];
}
@end
