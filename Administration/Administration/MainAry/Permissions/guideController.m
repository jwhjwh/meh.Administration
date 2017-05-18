//
//  guideController.m
//  Administration
//
//  Created by zhang on 2017/4/27.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "guideController.h"
#import "GuideTableViewCell.h"
#import "VTingPromotView.h"
#import "branModel.h"
@interface guideController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *indexArray;
@property (nonatomic ,strong)NSMutableArray *gameArrs;
@property (nonatomic ,strong)NSString *nameStr;

@end

@implementation guideController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_tlile;
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    [self addViewremind];
    [self getNetworkData];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addViewremind{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight-150)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    UIButton *buttn = [UIButton buttonWithType:UIButtonTypeCustom];
    buttn.frame =CGRectMake(Scree_width/2-18,self.tableView.bottom+15,36,36);
    [buttn setBackgroundImage:[UIImage imageNamed:@"tj_ico"] forState:UIControlStateNormal];
    [buttn setAdjustsImageWhenHighlighted:NO];
    [buttn addTarget: self action: @selector(addrenid) forControlEvents: UIControlEventTouchUpInside];
     [self.view addSubview:buttn];
}
-(void)addrenid{
    VTingPromotView *view = [[VTingPromotView alloc] initWithFrame:self.view.bounds  testStr:@"添加类别名称"];
   __weak typeof(self) weakself = self;
    view.blockname = ^(NSString *pwd){
        if(pwd.length==0){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"输入内容不能为空" andInterval:1.0];
            
        }else{
            _nameStr =pwd;
            [weakself addGetNetworkData];
        }
    };
    [view showPopViewAnimate:YES];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return   self.gameArrs.count;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = GetColor(230,230,230,1);
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.gameArrs[indexPath.row];
        cell.image.image=[UIImage imageNamed:@"ds_ico"];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}
//编辑
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction * action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        
        [self removedGetNetworkData:indexPath];
    }];
  
    action1.backgroundColor = GetColor(206, 175,219 ,1);
    UITableViewRowAction * action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //Action 2
        __weak typeof(self) weakself = self;
        VTingPromotView *view = [[VTingPromotView alloc] initWithFrame:self.view.bounds testStr:@"编辑类别名称"];
        view.blockname = ^(NSString *pwd){
            
            if(pwd.length==0){
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"输入内容不能为空" andInterval:1.0];
                
            }else{
                _nameStr =pwd;
                [weakself updatePosition:indexPath];
            }
        };
        [view showPopViewAnimate:YES];
    }];
   
    action2.backgroundColor = GetColor(220,220,220,1);
    return @[action1,action2];
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)getNetworkData{
    
    NSString *uStr =[NSString stringWithFormat:@"%@manager/queryPositionLevel.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"Num":@"1",@"CompanyInfoId":compid};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
         NSArray *arr = [responseObject valueForKey:@"list"];
            self.gameArrs=[NSMutableArray array];
            for (NSDictionary *dic in arr) {
                branModel *model=[[branModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.gameArrs addObject:model];
            }
            if (self.gameArrs.count>0) {
                _indexArray=[NSMutableArray arrayWithObjects:@"分类", nil];
                  _tableView.emptyView.hidden = YES;
            }
            [_tableView reloadData];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到更多品牌信息" andInterval:1.0];
            [_tableView addEmptyViewWithImageName:@"" title:@"还没添加任何内容请点击下方进行添加!" Size:16.0];
            _tableView.emptyView.hidden = NO;
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
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

-(void)addGetNetworkData{
    NSString *uStr =[NSString stringWithFormat:@"%@manager/addPositionLevel.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"Num":@"1",@"CompanyInfoId":compid,@"LevelName":_nameStr};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                branModel *model=[[branModel alloc]init];
                model.levelName=_nameStr;
                model.ID= [responseObject valueForKey:@"id"];
                [self.gameArrs addObject:model];
                [_tableView reloadData];
            if (self.gameArrs.count>0) {
                _tableView.emptyView.hidden = YES;
                _indexArray=[NSMutableArray arrayWithObjects:@"分类", nil];
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.gameArrs.count-1 inSection:0]
                                            animated:YES
                scrollPosition:UITableViewScrollPositionMiddle];
                
            }
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"添加失败" andInterval:1.0];
//            [_tableView addEmptyViewWithImageName:@"" title:@"还没添加任何内容请点击下方进行添加"];
            _tableView.emptyView.hidden = NO;
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
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
-(void)removedGetNetworkData:(NSIndexPath*)path{
    NSString *uStr =[NSString stringWithFormat:@"%@manager/delPositionLevel.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
      branModel *model = self.gameArrs[path.row];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"Num":@"1",@"CompanyInfoId":compid,@"id":model.ID};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
         [self.gameArrs removeObjectAtIndex:path.row];
         [_tableView reloadData];
            if(self.gameArrs.count==0){
            [_tableView addEmptyViewWithImageName:@"" title:@"还没添加任何内容请点击下方进行添加!" Size:16.0];
            }
            
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除失败" andInterval:1.0];
//            [_tableView addEmptyViewWithImageName:@"" title:@"还没添加任何内容请点击下方进行添加"];
            _tableView.emptyView.hidden = NO;
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
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
-(void)updatePosition:(NSIndexPath*)IndexPath{
    NSString *uStr =[NSString stringWithFormat:@"%@manager/updatePositionLevel.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    branModel *model = self.gameArrs[IndexPath.row];
    model.levelName=_nameStr;
 
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"Num":@"1",@"CompanyInfoId":compid,@"id":model.ID,@"LevelName":_nameStr};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
        [self.gameArrs replaceObjectAtIndex:IndexPath.row withObject:model];
            [_tableView reloadData];
            
            
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改失败" andInterval:1.0];
            //            [_tableView addEmptyViewWithImageName:@"" title:@"还没添加任何内容请点击下方进行添加"];
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
