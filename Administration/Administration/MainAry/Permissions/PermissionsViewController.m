//
//  PermissionsViewController.m
//  Administration
//  权限管理
//  Created by 九尾狐 on 2017/3/2.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "PermissionsViewController.h"
#import "CreateViewController.h"
#import "CodeViewController.h"
#import "StructureViewController.h"
#import "SetPositionViewController.h"
#import "AddBrandViewController.h"
#import "ReportPermissionsVC.h"
#import "BrandsetController.h"
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
    _arr = [[NSArray alloc]initWithObjects:@"职业结构介绍(必看)",@"公司职位设置",@"品牌设置",@"品牌部设置",@"业务部设置",@"报表权限设置",@"识别码",nil];
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)InterTableUI
{
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,20,self.view.bounds.size.width,self.view.bounds.size.height+29) style:UITableViewStylePlain];
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    
    [self.view addSubview:infonTableview];
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = GetColor(201, 201, 201, 1);
    [infonTableview addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.bottom.equalTo(infonTableview.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arr.count;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    
    view.backgroundColor =GetColor(201, 201, 201, 1);
    
    
    return view;
    
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
            SetPositionViewController *setPostionVC= [[ SetPositionViewController alloc]init]; [self.navigationController pushViewController:setPostionVC animated:YES];
        }
            break;
        case 2:{
            AddBrandViewController *addBrandVC=[[AddBrandViewController alloc]init];
            [self.navigationController pushViewController:addBrandVC animated:YES];
        }
            break;

        case 3:{
            BrandsetController *brandVC=[[BrandsetController alloc]init];
            [self.navigationController pushViewController:brandVC animated:YES];
        }
            break;
        case 4:
            
            
            break;
        case 5:{
            ReportPermissionsVC *perortVC = [[ReportPermissionsVC alloc]init];
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
        /*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
