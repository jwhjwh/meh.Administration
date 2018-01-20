//
//  PermissionsViewController.m
//  Administration
//  权限管理
//  Created by 九尾狐 on 2017/3/2.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "PermissionsViewController.h"
#import "CodeViewController.h"
#import "StructureViewController.h"
#import "SetPosiViewController.h"
#import "BrandTableViewController.h"
#import "ReportPermissionsVC.h"
#import "DepartController.h"

#import "JobcatController.h"
@interface PermissionsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    
}
@property (nonatomic,retain)NSArray *arr;

@end

@implementation PermissionsViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"权限管理";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    [self InterTableUI];
    _arr = [[NSArray alloc]initWithObjects:@"职位结构介绍(必看)",@"公司职位设置",@"品牌设置",@"部门设置",@"职位类别设置",@"报表权限设置",@"识别码",nil];
    //
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)InterTableUI
{
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,20,self.view.bounds.size.width,self.view.bounds.size.height+29) style:UITableViewStylePlain];
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    infonTableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
     [ZXDNetworking setExtraCellLineHidden:infonTableview];
    [self.view addSubview:infonTableview];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _arr[indexPath.row];
    if ([cell.textLabel.text isEqualToString:@"职业结构介绍(必看)"]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
         NSRange range1 = {7,2};
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
        [cell.textLabel setAttributedText:attributedString];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
 
        case 0:{ //职位介绍
        StructureViewController *StructVC= [[StructureViewController alloc]init];
        [self.navigationController showViewController:StructVC sender:nil];
        }
            break;
        case 1:{ //公司职位设置
            SetPosiViewController *setPostionVC= [[ SetPosiViewController alloc]init];
            //[self.navigationController pushViewController:setPostionVC animated:YES];
            [self.navigationController showViewController:setPostionVC sender:nil];
        }
            break;
        case 2:{
            //品牌设置
//            AddBrandViewController *addBrandVC=[[AddBrandViewController alloc]init];
//
            BrandTableViewController *brandtableVC= [[BrandTableViewController alloc]init];
            [self.navigationController pushViewController:brandtableVC animated:YES];
        }
            break;

        case 3:{
            //部门设置
            DepartController *DepartVC=[[DepartController alloc]init];
            [self.navigationController pushViewController:DepartVC animated:YES];
        }
            break;
        case 4:{
            JobcatController * guideVC=[[JobcatController alloc]init];
            [self.navigationController pushViewController:guideVC animated:YES];
        }
            break;
         
        case 5:{
            //报表权限设置 CreateViewController
            ReportPermissionsVC *perortVC = [[ReportPermissionsVC alloc]init];
            // CreateViewController *perortVC = [[CreateViewController alloc]init];
            [self.navigationController showViewController:perortVC sender:nil];

          
        }
            break;
        case 6:{
            //识别码
            CodeViewController *codeVC = [[CodeViewController alloc]init];
            [self.navigationController showViewController:codeVC sender:nil];
        }
            break;
       
    
        default:
            break;
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
