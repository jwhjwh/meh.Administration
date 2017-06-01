//
//  ManageViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/5/20.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ManageViewController.h"
#import "GuideTableViewCell.h"

#import "DepalistController.h"
#import "JoblistController.h"

#import "CreaViewController.h"
#import "CreateViewController.h"

@interface ManageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UIButton *sousuoBtn;//搜索框
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSArray *indexArray;
@property (nonatomic ,retain)NSArray *gameArrs;
@property (nonatomic ,retain)NSArray *nameArrs;
@end

@implementation ManageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"员工管理";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    _indexArray=@[@"创建账号",@"员工管理"];
    _nameArrs = @[@[@"创建员工账号"],@[@"按职位查看",@"按部门查看"]];
    _gameArrs =@[@[@"yggl_01"],@[@"yggl_02",@"yggl_03"]];
    [self addViewremind];
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addViewremind{

    _sousuoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sousuoBtn.frame=CGRectMake(10, 74, Scree_width-20, 40);
    [_sousuoBtn setBackgroundImage:[UIImage imageNamed:@"ss_ico01"] forState:UIControlStateNormal];
    //防止图片变灰
    _sousuoBtn.adjustsImageWhenHighlighted = NO;
    _sousuoBtn.layer.masksToBounds = YES;
    _sousuoBtn.layer.cornerRadius = 8.0;
    [_sousuoBtn addTarget:self action:@selector(Touchsearch)forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_sousuoBtn];
    self.tableView= [[UITableView alloc]initWithFrame:CGRectMake(0,_sousuoBtn.bottom+10,self.view.bounds.size.width,self.view.bounds.size.height-50) style:UITableViewStylePlain];
    self.tableView.dataSource=self;
    self.tableView.delegate =self;
    self.tableView.scrollEnabled =NO; //设置tableview 不能滚动
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
}

-(void)Touchsearch{
    //SearchViewController
    SearchViewController *SearchVC = [[SearchViewController alloc]init];
    [self.navigationController showViewController:SearchVC sender:nil];
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_nameArrs[section]count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _indexArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = GetColor(230,230,230,1);
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor grayColor];
    header.textLabel.font = [UIFont systemFontOfSize:14.0f];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * str = [NSString stringWithFormat:@"  %@",_indexArray[section]];
    return str;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.gameArrs.count>0) {
        return 30;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"gameCell";
    GuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (!cell) {
        cell = [[GuideTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    /**
     *  单元格的选中类型一定不能设置为 UITableViewCellSelectionStyleNone，如果加上这一句，全选勾选不出来
     */
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = _nameArrs[indexPath.section][indexPath.row];
    cell.image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@", _gameArrs[indexPath.section][indexPath.row]]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row ==0) {
            NSLog(@"创建员工账号");
            CreaViewController *creaVC = [[CreaViewController alloc]init];
            //CreateViewController *creaVC = [[CreateViewController alloc]init];
            [self.navigationController pushViewController:creaVC animated:YES];
        }
    }else{
        if (indexPath.row ==0) {
            JoblistController *Joblist=[[JoblistController alloc]init];
            [self.navigationController pushViewController:Joblist animated:YES];
        
        }else{
            DepalistController *DepVC=[[DepalistController alloc]init];
            [self.navigationController pushViewController:DepVC animated:YES];
        }
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
         UIEdgeInsets UIEgde = UIEdgeInsetsMake(0, 15, 0, 15);
          [cell setSeparatorInset:UIEgde];
    }else{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    }
}

@end
