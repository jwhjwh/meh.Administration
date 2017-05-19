//
//  multiController.m
//  Administration
//
//  Created by zhang on 2017/4/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "multiController.h"
#import "AddbranController.h"
#import "ChooseTableViewCell.h"
#import "BranTableViewCell.h"
#import "Brandmodle.h"
@interface multiController ()
<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *branTableView;
@property (nonatomic,strong)UIView *view1;
@property (nonatomic,strong)NSMutableArray *indexArray;
/** 数据源 */
@property (nonatomic ,strong)NSMutableArray *gameArrs;
@property (nonatomic,strong) NSMutableArray *deleteArrarys;//选中的数据
@property (nonatomic,strong)NSIndexPath *index;
@property (nonatomic,strong)UIButton *allDelButton;
@property (nonatomic,strong)UIButton *delButton;
/** 标记是否全选 */
@property (nonatomic ,assign)BOOL isAllSelected;
@property (nonatomic,strong)NSArray *array;
@end

@implementation multiController
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
    self.branTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-48)];
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
    
    _delButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _delButton.backgroundColor =[UIColor whiteColor];
    _delButton.frame=CGRectMake(Scree_width/2,Scree_height-48,Scree_width/2,48);
    [_delButton setTitle:@"确认" forState:UIControlStateNormal];
    [_delButton setTitleColor:GetColor(7, 138, 249, 1) forState:UIControlStateNormal];
    [_delButton addTarget:self action:@selector(deltButn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_delButton];
    UIButton *butt=[UIButton buttonWithType:UIButtonTypeCustom];
    butt.backgroundColor =[UIColor whiteColor];
    butt.frame=CGRectMake(0,Scree_height-48,Scree_width/2,48);
    [butt setTitle:@"全选" forState:UIControlStateNormal];
    [butt setTitleColor:GetColor(7, 138, 249, 1) forState:UIControlStateNormal];
    [butt addTarget:self action:@selector(allDelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butt];
    _view1=[[UIView alloc]initWithFrame:CGRectMake(Scree_width/2-0.5,Scree_height-44,1,39)];
    _view1.backgroundColor = [UIColor RGBview];
    [self.view addSubview:_view1];
    [self getNetworkData];
}
-(void)deltButn{
 
        NSMutableArray *deleteArrarys = [NSMutableArray array];
    if (self.gameArrs.count==2) {
        for (NSIndexPath *indexPath in _branTableView.indexPathsForSelectedRows) {
            if (indexPath.section==1) {
                [deleteArrarys addObject:self.gameArrs[indexPath.section][indexPath.row]];
            }
        }
    }else{
        for (NSIndexPath *indexPath in _branTableView.indexPathsForSelectedRows) {
            [deleteArrarys addObject:self.gameArrs[indexPath.section][indexPath.row]];
        }
    }
    if (_num==1) {
          NSMutableArray *Barr=[NSMutableArray array];
          for (branModel *model in deleteArrarys ) {
            [Barr addObject:[NSString stringWithFormat:@"%@",model.ID]];
          }
        
        if(Barr.count>0){
             [self updateDepartarr:deleteArrarys string:[NSString stringWithFormat:@"%@",Barr]];
        }
    }else{
        self.blockArr(deleteArrarys);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.gameArrs.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(self.gameArrs.count==2){
    if (indexPath.section==0) {
        return NO;
    }
    return YES;
}else{
    return YES;

}
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return   [self.gameArrs[section] count];
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = GetColor(230,230,230,1);
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString * str = [NSString stringWithFormat:@"  %@",_indexArray[section]];
    return str;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.gameArrs.count==2) {
        if (indexPath.section==0) {
            static NSString *identifi = @"Cell";
            BranTableViewCell *cell = [[BranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
            if (!cell) {
                cell = [[BranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
                cell.backgroundColor =[UIColor whiteColor];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.branmodel = self.gameArrs[indexPath.section][indexPath.row];
            return cell;
        }else{
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
            cell.model = self.gameArrs[indexPath.section][indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
    }else{
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
        cell.model = self.gameArrs[indexPath.section][indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        return cell;

    }
    
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
   
        if (self.gameArrs.count==2) {
            _deleteArrarys = [NSMutableArray array];
            for (NSIndexPath *indexPath in _branTableView.indexPathsForSelectedRows) {
                   if (indexPath.section==1) {
                [_deleteArrarys addObject:self.gameArrs[indexPath.section][indexPath.row]];
                _delButton.backgroundColor=GetColor(206, 175,219 ,1);
                [_delButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[_deleteArrarys count]] forState:UIControlStateNormal];
                   }
            }
           
           
        }else{
            _deleteArrarys = [NSMutableArray array];
            for (NSIndexPath *indexPath in _branTableView.indexPathsForSelectedRows) {
                if (indexPath.section==0) {
                    [_deleteArrarys addObject:self.gameArrs[indexPath.section][indexPath.row]];
                }
            }
            _delButton.backgroundColor=GetColor(206, 175,219 ,1);
            [_delButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[_deleteArrarys count]] forState:UIControlStateNormal];
        }
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
           if (self.gameArrs.count==2) {
    if (indexPath.section==1) {
        [_deleteArrarys removeObject:[self.gameArrs[indexPath.section] objectAtIndex:indexPath.row]];
        if (_deleteArrarys.count==0) {
            _delButton.backgroundColor=[UIColor whiteColor];
        }
        
        [_delButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[_deleteArrarys count]] forState:UIControlStateNormal];
           }
  }else{
      [_deleteArrarys removeObject:[self.gameArrs[indexPath.section] objectAtIndex:indexPath.row]];
      if (_deleteArrarys.count==0) {
          _delButton.backgroundColor=[UIColor whiteColor];
      }
      
      [_delButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[_deleteArrarys count]] forState:UIControlStateNormal];
           }
}
-(void)allDelBtn{
    self.isAllSelected = !self.isAllSelected;
    if (self.gameArrs.count==1) {
        _array=self.gameArrs[0];
        for (int i = 0; i<_array.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            if (self.isAllSelected) {
                [self.branTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                [_delButton setTitle:[NSString stringWithFormat:@"确定(%d)",i+1] forState:UIControlStateNormal];
                _delButton.backgroundColor=GetColor(206, 175,219 ,1);
            }else{//反选
                _delButton.backgroundColor =[UIColor whiteColor];
                [_delButton setTitle:@"确定(0)" forState:UIControlStateNormal];
                [self.branTableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
    }else{
        _array=self.gameArrs[1];
        for (int i = 0; i<_array.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:1];
            if (self.isAllSelected) {
                [self.branTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                [_delButton setTitle:[NSString stringWithFormat:@"确定(%d)",i+1] forState:UIControlStateNormal];
                _delButton.backgroundColor=GetColor(206, 175,219 ,1);
            }else{//反选
                _delButton.backgroundColor =[UIColor whiteColor];
                [_delButton setTitle:@"确定(0)" forState:UIControlStateNormal];
                [self.branTableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }

    }
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
    
    NSString *uStr =[NSString stringWithFormat:@"%@brand/queryBrandGroup.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"Num":@"1",@"CompanyInfoId":compid};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        
        
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"list"];
            
            self.gameArrs = [NSMutableArray array];
            for (NSArray *arrNum in array) {
                if (arrNum.count>0) {
                    NSMutableArray *arrBrand= [NSMutableArray array];
                    for (NSDictionary *dic in arrNum) {
                        Brandmodle *model=[[Brandmodle alloc]init];
                        [model setValuesForKeysWithDictionary:[NSDictionary changeType:dic]];
                        [arrBrand  addObject:model];
                    }
                    [self.gameArrs addObject:arrBrand];
                }
            }
            if (self.gameArrs.count==2) {
                _indexArray=[NSMutableArray arrayWithObjects:@"已分配给其他部门的品牌",@"待分配的品牌", nil];
            }else{
                _indexArray=[NSMutableArray arrayWithObjects:@"待分配的品牌",nil];
            }
            if (self.gameArrs.count==0) {
                [_branTableView addEmptyViewWithImageName:@"" title:@"暂无经营品牌信息，添加几条吧～～"  Size:20.0];
                _branTableView.emptyView.hidden = NO;
            }
            [_branTableView reloadData];
    
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到更多品牌信息" andInterval:1.0];
            [_branTableView addEmptyViewWithImageName:@"" title:@"暂无经营品牌信息，添加几条吧～～" Size:20.0];
            _branTableView.emptyView.hidden = NO;
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
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
-(void)updateDepartarr:(NSMutableArray*)array string:(NSString*)str{
    
    NSString *uStr =[NSString stringWithFormat:@"%@user/updateDepartmentBrand.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"DepartmentID":_BarandID,@"Num":@"1",@"BrandID": str};
    
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"添加品牌成功" andInterval:1.0];
            self.blockArr(array);
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.3 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"添加品牌失败" andInterval:1.0];
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
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
