//
//  PositioningViewController.m
//  Administration
//  定位
//  Created by 九尾狐 on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "PositioningViewController.h"
#import "YUFoldingSectionHeader.h"
#import "PersonneTableViewCell.h"
#import "PerLomapController.h"
#import "PersonModel.h"
@interface PositioningViewController ()<YUFoldingSectionHeaderDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;

@property (strong,nonatomic) NSMutableArray *InterNameAry;
@property (strong,nonatomic) NSArray *array;
@property (strong,nonatomic) NSMutableArray *shiNameAry;
@property (strong,nonatomic) NSMutableArray *neiNameAry;
@property (strong,nonatomic) NSMutableArray *wuNameAry;
@property (strong,nonatomic) NSMutableArray *yeNameAry;
@property (strong,nonatomic) NSMutableArray *pinNameAry;
@property (strong,nonatomic) NSMutableArray *xingNameAry;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSMutableArray *tempMArray; // 用于判断手风琴的某个层级是否展开
@property (nonatomic, strong) NSMutableArray *statusArray;
@property (nonatomic,retain)UITableView *tableView;
@end

@implementation PositioningViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"员工位置";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(bLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    [self suabView];
    [self loadData];
}
-(void)bLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)suabView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource=self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonneTableViewCell" bundle:nil] forCellReuseIdentifier:@"CARRY"];
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeStatusBarOrientationNotification:)  name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

-(void)onChangeStatusBarOrientationNotification:(NSNotification *)notification
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)loadData{
    NSString *uStr =[NSString stringWithFormat:@"%@user/findAllUser.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"]};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        _shiNameAry=[NSMutableArray array];
        _neiNameAry=[NSMutableArray array];
        _yeNameAry=[NSMutableArray array];
        _wuNameAry=[NSMutableArray array];
        _pinNameAry=[NSMutableArray array];
        _xingNameAry=[NSMutableArray array];
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *resuAry = responseObject[@"userList"];
            for (NSDictionary *newDict in resuAry) {
                PersonModel *model = [[PersonModel alloc]init];
                [model setValuesForKeysWithDictionary:newDict];
                
                switch (model.roleId.intValue) {
                    case 2:
                        [_shiNameAry addObject:model];
                        break;
                    case 3:
                        [_neiNameAry addObject:model];
                        break;
                    case 4:
                        [_wuNameAry addObject:model];
                        break;
                    case 5:
                        [_yeNameAry addObject:model];
                        break;
                    case 6:
                        [_pinNameAry addObject:model];
                        break;
                    case 7:
                        [_xingNameAry addObject:model];
                        break;
                    default:
                        break;
                }
                
            }
            _InterNameAry=[NSMutableArray arrayWithObjects:_shiNameAry,_neiNameAry,_wuNameAry,_yeNameAry,_pinNameAry,_xingNameAry,nil];
            _array=@[@"市场人员",@"内勤人员",@"物流人员",@"业务人员",@"品牌经理",@"行政管理"];
            //            for (int i = 0; i<_InterNameAry.count; i++) {
            //                NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
            //                [mDic setObject:[NSString stringWithFormat:@"%@(%lu)",_array[i],(unsigned long)[_InterNameAry[i]count]] forKey:@"name"];
            //                [mDic setObject:_InterNameAry[i] forKey:@"mArr"];
            //                [self.mArray addObject:mDic];
            //                [self.tempMArray addObject:@"0"];
            //            }
            
            [self.tableView reloadData];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到联系人" andInterval:1.0];
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
#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
// 返回箭头的位置
-(YUFoldingSectionHeaderArrowPosition )perferedArrowPosition

{
    // 没有赋值，默认箭头在左
    NSUInteger intger=1;
    self.arrowPosition=intger;
    return self.arrowPosition ? :YUFoldingSectionHeaderArrowPositionLeft;
}


-(NSMutableArray *)statusArray
{
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    if (_statusArray.count) {
        if (_statusArray.count > _InterNameAry.count) {
            [_statusArray removeObjectsInRange:NSMakeRange(_InterNameAry.count - 1, _statusArray.count - _InterNameAry.count)];
        }else if (_statusArray.count < _InterNameAry.count) {
            for (NSInteger i = _InterNameAry.count - _statusArray.count; i < _InterNameAry.count; i++) {
                [_statusArray addObject:[NSNumber numberWithInteger:YUFoldingSectionStateFlod]];
            }
        }
    }else{
        for (NSInteger i = 0; i <_InterNameAry.count; i++) {
            [_statusArray addObject:[NSNumber numberWithInteger:YUFoldingSectionStateFlod]];
        }
    }
    return _statusArray;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _InterNameAry.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ if (((NSNumber *)self.statusArray[section]).integerValue == YUFoldingSectionStateShow) {
    return [_InterNameAry[section]count];
}
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.style == UITableViewStylePlain) {
        return 0;
    }else{
        return 0.001;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YUFoldingSectionHeader *sectionHeaderView = [[YUFoldingSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,50)  withTag:section];
    [sectionHeaderView setupWithBackgroundColor:[UIColor whiteColor]
     
                                    titleString:[NSString stringWithFormat:@"%@(%ld)",_array[section],[_InterNameAry[section]count]]
                                     titleColor:[UIColor blackColor]
                                      titleFont:[UIFont systemFontOfSize:16]
                              descriptionString:[NSString string]
                               descriptionColor:[UIColor whiteColor]
                                descriptionFont:[UIFont systemFontOfSize:13]
                                     arrowImage:[UIImage imageNamed:@"jiantou_03"]
                                  arrowPosition:[self perferedArrowPosition]
                                   sectionState:((NSNumber *)self.statusArray[section]).integerValue];
    
    sectionHeaderView.tapDelegate = self;
    
    return sectionHeaderView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonneTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CARRY" forIndexPath:indexPath];
    PersonModel *model= _InterNameAry[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    [cell loadDataFromModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    PersonModel *model= _InterNameAry[indexPath.section][indexPath.row];
    PerLomapController *perLomaVC=[[PerLomapController alloc]init];
    perLomaVC.uesrId=model.nameid;
    perLomaVC.name=model.name;
    perLomaVC.account=[NSString stringWithFormat:@"%ld",(long)model.account];
    [self.navigationController pushViewController:perLomaVC animated:YES];
}

#pragma mark - YUFoldingSectionHeaderDelegate

-(void)yuFoldingSectionHeaderTappedAtIndex:(NSInteger)index
{
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[index]).boolValue;
    
    [self.statusArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!currentIsOpen]];
    
    NSInteger numberOfRow = [_InterNameAry[index]count];
    NSMutableArray *rowArray = [NSMutableArray array];
    if (numberOfRow) {
        for (NSInteger i = 0; i < numberOfRow; i++) {
            [rowArray addObject:[NSIndexPath indexPathForRow:i inSection:index]];
        }
    }
    if (rowArray.count) {
        if (currentIsOpen) {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }else{
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
