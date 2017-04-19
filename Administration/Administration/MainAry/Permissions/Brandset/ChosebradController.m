//
//  ChosebradController.m
//  Administration
//
//  Created by zhang on 2017/4/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ChosebradController.h"
#import "ChooseTableViewCell.h"
#import "Brandmodle.h"
@interface ChosebradController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *keys;
    NSArray *key;
    NSMutableDictionary *dict;
    NSMutableArray *arr;
}
@property (nonatomic,strong)NSMutableArray *indexArray;
@property (nonatomic,strong)UITableView *branTableView;
/** 数据源 */
@property (nonatomic ,strong)NSMutableArray *gameArrs;
@property (nonatomic,strong)NSIndexPath *index;
@end

@implementation ChosebradController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"所选品牌";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    self.branTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
 
    self.branTableView.delegate = self;
    self.branTableView.dataSource = self;
    self.branTableView.tableFooterView = [[UIView alloc] init];
    self.branTableView.backgroundColor = [UIColor whiteColor];
    self.branTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.branTableView];
    /*=========================至关重要============================*/
    self.branTableView.allowsMultipleSelectionDuringEditing = YES;
    self.branTableView.editing =YES;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,Scree_height-49,Scree_width,1)];
    view.backgroundColor = [UIColor RGBview];
    [self.view addSubview:view];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor whiteColor];
    button.frame=CGRectMake(0,Scree_height-48,Scree_width,48);
    [button setTitle:@"确认" forState:UIControlStateNormal];
    [button setTitleColor:GetColor(7, 138, 249, 1) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(allDelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self getNetworkData];
   
}
-(void)allDelBtn{
    NSMutableArray *deleteArrarys = [NSMutableArray array];
   
    for (NSIndexPath *indexPath in _branTableView.indexPathsForSelectedRows) {
        [deleteArrarys addObject:self.gameArrs[indexPath.row]];
    }
 
    self.blockArr(deleteArrarys);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.gameArrs.count;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifi = @"gameCell";
    ChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    
    if (!cell) {
        cell = [[ChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    cell.tintColor = [UIColor RGBNav];
    
    /**
     *  单元格的选中类型一定不能设置为 UITableViewCellSelectionStyleNone，如果加上这一句，全选勾选不出来
     */
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.model = self.gameArrs[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70.0f;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!(_index.length==0)) {
         [tableView deselectRowAtIndexPath:_index animated:YES];//选中后的反显颜色即刻消失
    }
    _index=indexPath;
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([self.branTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.branTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.branTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.branTableView setLayoutMargins:UIEdgeInsetsZero];
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

-(void)getNetworkData{
    
    NSString *uStr =[NSString stringWithFormat:@"%@brand/querybrand.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"]};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        
        
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"brandlist"];
          
            self.gameArrs = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                Brandmodle *model=[[Brandmodle alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.gameArrs addObject:model];
            }
            if (self.gameArrs.count==0) {
                [_branTableView addEmptyViewWithImageName:@"" title:@"暂无经营品牌信息，添加几条吧～～"];
                _branTableView.emptyView.hidden = NO;
            }
            [_branTableView reloadData];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到更多品牌信息" andInterval:1.0];
            [_branTableView addEmptyViewWithImageName:@"" title:@"暂无经营品牌信息，添加几条吧～～"];
            _branTableView.emptyView.hidden = NO;
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登陆超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }
        
    }failure:^(NSError *error) {
        
    }view:self.view MBPro:YES];
    
}


@end
