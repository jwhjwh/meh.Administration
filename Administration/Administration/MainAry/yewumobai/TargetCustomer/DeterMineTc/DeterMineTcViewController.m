//
//  DeterMineTcViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/10/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DeterMineTcViewController.h"
#import "TargetTableViewController.h"
#import "ModifyVisitViewController.h"
#import "InterestedTabelViewController.h"
@interface DeterMineTcViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic ,retain)NSArray *nameArrs;
@end

@implementation DeterMineTcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.shopname;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    _nameArrs = @[@[@"目标客户确立表"],@[@"意向客户表"],@[@"陌拜记录表"]];
    [self addViewremind];
}
-(void)addViewremind{
    self.tableView= [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    NSString* phoneModel = [UIDevice devicePlatForm];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        self.tableView.frame =CGRectMake(0,88,self.view.bounds.size.width,self.view.bounds.size.height-50);
    }else{
        self.tableView.frame =CGRectMake(0,65,self.view.bounds.size.width,self.view.bounds.size.height-50);
    }
    self.tableView.dataSource=self;
    self.tableView.delegate =self;
    self.tableView.scrollEnabled =NO; //设置tableview 不能滚动
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0,190, self.view.bounds.size.width, 1)];
    view1.backgroundColor = [UIColor lightGrayColor];
    [self.tableView addSubview:view1];
    
}
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
    return _nameArrs.count;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = GetColor(230,230,230,1);
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor grayColor];
    header.textLabel.font = [UIFont systemFontOfSize:14.0f];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 20;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * str = [NSString stringWithFormat:@"  "];
    return str;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"gameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    /**
     *  单元格的选中类型一定不能设置为 UITableViewCellSelectionStyleNone，如果加上这一句，全选勾选不出来
     */
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, cell.width, 30)];
    tlelabel.text = _nameArrs[indexPath.section][indexPath.row];
    [cell addSubview:tlelabel];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        NSLog(@"目标客户确立表");
        TargetTableViewController *ttvc = [[TargetTableViewController alloc]init];
        ttvc.OldTargetVisitId = self.TargetVisitId;
        ttvc.isofyou = NO;
        ttvc.strId = self.strId;
        ttvc.cellend = NO;
        [self.navigationController pushViewController:ttvc animated:YES];
    }else if(indexPath.section ==1){
       NSLog(@"意向客户表");
        InterestedTabelViewController *intabel = [[InterestedTabelViewController alloc]init];
        intabel.shopId = self.shopId;
        intabel.strId = self.strId;
        intabel.isofyou = @"1";
        [self.navigationController pushViewController:intabel animated:YES];
    }else{
        NSLog(@"陌拜记录表");
        
        ModifyVisitViewController *visiVC = [[ModifyVisitViewController alloc]init];
        visiVC.strId = self.strId;
        visiVC.shopId = self.shopId;
        visiVC.andisofyou = @"1";
        [self.navigationController pushViewController:visiVC animated:YES];
    }
    
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
