//
//  EmistController.m
//  Administration
//
//  Created by zhang on 2017/5/9.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "EmistController.h"
#import "EMlistTableViewCell.h"
#import "PJSearchBar.h"
@interface EmistController ()<UITableViewDelegate,UITableViewDataSource,PJSearchBarDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;  //数据源
@property (nonatomic,strong) NSMutableArray *deleteArrarys;//选中的数据
@property (nonatomic, strong) PJSearchBar *searchBar;      //搜索框
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, retain) NSMutableArray *resultArr;   //搜索结果
@property (nonatomic, assign) BOOL isSearch;               //判断是否在搜索
@property (nonatomic, strong) NSString *firstInputString;  //搜索第一个输入字母

@property (nonatomic,strong)UIView *view1;
@property (nonatomic,strong)NSMutableArray *indexArray;
@property (nonatomic,strong)UIButton *allDelButton;
@property (nonatomic,strong)UIButton *delButton;
/** 标记是否全选 */
@property (nonatomic ,assign)BOOL isAllSelected;
@end

@implementation EmistController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_str;
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;

    
  
    

    [self addDataSource];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)deltButn{
    
    NSMutableArray *deleteArrarys = [NSMutableArray array];
    for (NSIndexPath *indexPath in _tableView.indexPathsForSelectedRows) {
            [deleteArrarys addObject:self.dataSource[indexPath.row]];
    }
    
    self.blockArr(deleteArrarys);
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)allDelBtn{
    self.isAllSelected = !self.isAllSelected;
        for (int i = 0; i<self.dataSource.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            if (self.isAllSelected) {
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                [_delButton setTitle:[NSString stringWithFormat:@"确定(%d)",i+1] forState:UIControlStateNormal];
                _delButton.backgroundColor=GetColor(206, 175,219 ,1);
            }else{//反选
                _delButton.backgroundColor =[UIColor whiteColor];
                [_delButton setTitle:@"确定(0)" forState:UIControlStateNormal];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
  
}
- (void)initSubviews{
   
   
         _searchBar = [[PJSearchBar alloc] initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, 40) placeholder:@"搜索"];
         _searchBar.delegate = self;
         _searchBar.barTintColor = [UIColor redColor];
         [self.view addSubview:_searchBar];
         
         _searchText = @"";
         [self.view addSubview:self.tableView];
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
    
}

- (void)addDataSource{
  
    NSString *uStr =[NSString stringWithFormat:@"%@user/queryFreeEmployee.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"Num":@"1",@"CompanyInfoId":compid};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
     
        
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"list"];
            
                    for (NSDictionary *dic in array) {
                        DirtmsnaModel *model=[[DirtmsnaModel alloc]init];
                        [model setValuesForKeysWithDictionary:dic];
                       [self.dataSource addObject:model];
                    }
            [self initSubviews];
            if (self.dataSource.count==0) {
                [_tableView addEmptyViewWithImageName:@"" title:@"暂无员工～～"  Size:20.0];
                _tableView.emptyView.hidden = NO;
            }else{
                 _indexArray=[NSMutableArray arrayWithObjects:@"员工列表",nil];
            }
            [_tableView reloadData];
            
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到更多品牌信息" andInterval:1.0];
            [_tableView addEmptyViewWithImageName:@"" title:@"暂无员工～～～～" Size:20.0];
            _tableView.emptyView.hidden = NO;
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

//    [self.dataSource addObjectsFromArray:dataArray];
    [self.tableView reloadData];
}
#pragma mark TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSearch) {
        return 1 ;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearch) {
        return self.resultArr.count ;
    }else{
        return self.dataSource.count;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = GetColor(230,230,230,1);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataSource.count>0) {
        return 30;
    }else{
        return 0;
    }
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString * str = [NSString stringWithFormat:@"  %@",_indexArray[section]];
    return str;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMlistTableViewCell *cell = [[EMlistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[EMlistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    //改变圆心颜色
    cell.tintColor = [UIColor RGBNav];
    cell.selectionStyle =  UITableViewCellSelectionStyleDefault;
    
    cell.backgroundColor = [UIColor whiteColor];
    if (self.isSearch) {
        cell.model = self.resultArr[indexPath.row];
    }else{
        cell.model = _dataSource[indexPath.row];
    }
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
   
            _deleteArrarys = [NSMutableArray array];
            for (NSIndexPath *indexPath in _tableView.indexPathsForSelectedRows) {
              
                    [_deleteArrarys addObject:_dataSource[indexPath.row]];
                
            }
            _delButton.backgroundColor=GetColor(206, 175,219 ,1);
            [_delButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[_deleteArrarys count]] forState:UIControlStateNormal];
      
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
  
        [_deleteArrarys removeObject:[_dataSource objectAtIndex:indexPath.row]];
        if (_deleteArrarys.count==0) {
            _delButton.backgroundColor=[UIColor whiteColor];
        }
        
        [_delButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[_deleteArrarys count]] forState:UIControlStateNormal];
 
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        _searchText = @"";
        self.isSearch = NO;
        [self.tableView reloadData];
    }
    NSLog(@" --- %@",searchText);
    [_resultArr removeAllObjects];
    
    if (searchText.length == 1) {
        self.firstInputString = searchText;
    }
    for (NSArray *searchArray in self.dataSource) {
        for (NSString *searchStr in searchArray) {
            if ([searchStr rangeOfString:searchText].location != NSNotFound) {
                [self.resultArr addObject:searchStr];
            }
        }
    }
    if (_resultArr.count) {
        self.isSearch = YES;
        [self.tableView reloadData];
    }
}


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.isSearch = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    self.isSearch = NO;
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark LazyLoading
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, self.view.bounds.size.width, self.view.bounds.size.height - 104-48) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        _tableView.editing =YES;
      
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (NSMutableArray *)resultArr{
    if (!_resultArr) {
        _resultArr = [[NSMutableArray alloc]init];
    }
    return _resultArr;
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

-(void)upDataSearchSpecialOffe{
    NSString *uStr =[NSString stringWithFormat:@"%@manager/fuzzyQueryFreeEmployee.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
      NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"key":self.searchBar.text};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        _resultArr=[NSMutableArray array];
        
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"list"];
            
            for (NSDictionary *dic in array) {
                DirtmsnaModel *model=[[DirtmsnaModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_resultArr addObject:model];
            }
            if (self.dataSource.count==0) {
                [_tableView addEmptyViewWithImageName:@"" title:@"暂无员工～～"  Size:20.0];
                _tableView.emptyView.hidden = NO;
            }else{
                _indexArray=[NSMutableArray arrayWithObjects:@"员工列表",nil];
            }
            [_tableView reloadData];
            
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到更多品牌信息" andInterval:1.0];
            [_tableView addEmptyViewWithImageName:@"" title:@"暂无员工～～～～" Size:20.0];
            _tableView.emptyView.hidden = NO;
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
