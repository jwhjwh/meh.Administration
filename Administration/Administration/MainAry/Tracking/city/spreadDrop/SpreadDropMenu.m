//
//  SpreadDropMenu.m
//  MYDropMenu
//
//  Created by 孟遥 on 2017/2/24.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import "SpreadDropMenu.h"
#import "AFNetworking.h"
#import "ProvinceModel.h"
#import "cityModel.h"
#import "ZoneModel.h"
#import "SpreadTableViewCell.h"
BOOL isAllSelected;
#define  GetColor(RED,GREEN,BLUE,ALPHAl) [UIColor colorWithRed:RED / 255.0 green:GREEN / 255.0 blue:BLUE / 255.0 alpha:ALPHAl]
@interface SpreadDropMenu () <UITableViewDataSource, UITableViewDelegate>
/** 省数据数组 */

@property(nonatomic,strong)NSMutableArray *provinceNary;

/** 市数据数组 */
@property(nonatomic,strong)NSMutableArray *CityNary;

/** 区数据数组 */
@property(nonatomic,strong)NSMutableArray *ZoneNary;

/** 省数据列表 */
@property(nonatomic,strong)UITableView *provinceTableView;

/** 市数据列表 */
@property(nonatomic,strong)UITableView *CityTableView;
/** 区数据列表 */

@property(nonatomic,strong)UITableView *ZoneTableView;

@property (nonatomic,strong) UIButton * sajkdlBTN;
@property (nonatomic,strong) UIButton *handleButton1;

@property (nonatomic,strong) NSString *kbdaRY;

@property (nonatomic,strong) NSString *kbdaRY2;
@property (nonatomic,strong) NSString *kbdaRY3;
@property (nonatomic,strong) NSString *kbdaRY4;
@property (nonatomic,strong) NSMutableArray *ary;


@property(nonatomic,strong)UIView *backvIEW;
@end

@implementation SpreadDropMenu


- (void)viewDidLoad {
    [super viewDidLoad];
    _ary = [[NSMutableArray alloc]init];
    self.view.backgroundColor = GetColor(231, 231, 231, 1);
    self.provinceNary=[NSMutableArray array];
    NSString *urlStr=[NSString stringWithFormat:@"http://apis.map.qq.com/ws/district/v1/list?key=K3VBZ-M6WWV-PPSPY-UVGGC-DRM2Z-PGBMV"];
    [ZXDNetworking GET:urlStr parameters:nil success:^(id responseObject) {
        NSMutableArray *messageData=[responseObject objectForKey:@"result"];
        self.CityNary=[NSMutableArray array];
        for (NSDictionary  *dic in messageData[0]) {
            ProvinceModel *model =[[ProvinceModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.provinceNary addObject:model];
        }
        [self.provinceTableView reloadData];
        [self loadView];
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = GetColor(231, 231, 231, 1);
    self.view = view;
    
    // 初始化表视图
    _provinceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width/3)-30, 300) style:UITableViewStylePlain];
    _provinceTableView.backgroundColor=[UIColor whiteColor];
    _provinceTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _provinceTableView.rowHeight = 50;
    _provinceTableView.dataSource = self;
    _provinceTableView.delegate = self;
    // _provinceTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self setExtraCellLineHidden:_provinceTableView];
    [self.view addSubview:_provinceTableView];
    
    _handleButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handleButton1 setTitle:@"确定" forState:UIControlStateNormal];
    [_handleButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_handleButton1 addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
    _handleButton1.frame = CGRectMake(2*((self.view.frame.size.width/3)-29), 270, 2*((self.view.frame.size.width/3)-30), 30);
    [self.view addSubview:_handleButton1];
}
-(void)loadViewCity{
    _CityTableView = [[UITableView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/3)-29, 0, (self.view.frame.size.width/3)-30, 300) style:UITableViewStylePlain];
    _CityTableView.backgroundColor=GetColor(236, 236, 236, 1);
    _CityTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _CityTableView.rowHeight = 50;
    _CityTableView.dataSource = self;
    _CityTableView.delegate = self;
    [self setExtraCellLineHidden:_CityTableView];
    [self.view addSubview:_CityTableView];
    
}
-(void)loadViewZone{
    _ZoneTableView = [[UITableView alloc] initWithFrame:CGRectMake((_CityTableView.frame.size.width+_provinceTableView.frame.size.width)+2, 0, (self.view.frame.size.width)-((_CityTableView.frame.size.width+_provinceTableView.frame.size.width)+2), 270) style:UITableViewStylePlain];
    _ZoneTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _ZoneTableView.backgroundColor=GetColor(236, 236, 236, 1);
    _ZoneTableView.rowHeight = 50;
    _ZoneTableView.dataSource = self;
    _ZoneTableView.delegate = self;
    [_ZoneTableView setEditing:YES animated:YES];
    [self setExtraCellLineHidden:_ZoneTableView];
    [self.view addSubview:_ZoneTableView];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(((self.view.frame.size.width/3)*2)-29, 0, (self.view.frame.size.width/3)+29, 30)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.backgroundColor = GetColor(236, 236, 236, 1);
    _ZoneTableView.tableHeaderView = view1;
    _sajkdlBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (view1.frame.size.width), 30)];
    [_sajkdlBTN setTitle:@"全选" forState:UIControlStateNormal];
    // _sajkdlBTN.textLabel.font = [UIFont systemFontOfSize:14.0f];
    _sajkdlBTN.titleLabel.font= [UIFont systemFontOfSize:14.0f];
    [_sajkdlBTN setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_sajkdlBTN addTarget:self action:@selector(masgeClick:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:_sajkdlBTN];
    _ZoneTableView.editing = YES;
    isAllSelected = NO;
    _ZoneTableView.allowsMultipleSelectionDuringEditing = YES;
    
    
    
    
    
}
-(void)masgeClick:(UIButton *)btn{
    if (isAllSelected == NO) {
        
        isAllSelected = YES;
        [btn setTitle:@"取消全选" forState:UIControlStateNormal];
        ZoneModel *ProvinceModel1 =[[ZoneModel alloc]init];
        NSMutableArray *kbsuaRY = [[NSMutableArray alloc]init];
        for (int i = 0; i < _ZoneNary.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [_ZoneTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            _kbdaRY3 = [_ZoneNary componentsJoinedByString:@","];
            ProvinceModel1 = _ZoneNary[indexPath.row];
            [_ary addObject:ProvinceModel1.fullname];
            
            for (NSString *str in _ary) {
                if (![kbsuaRY containsObject:str]) {
                    [kbsuaRY addObject:str];
                }
            }
        }
        [_ary removeAllObjects];
        [_ary addObjectsFromArray:kbsuaRY];
    } else {
        
        isAllSelected = NO;
        [btn setTitle:@"全选" forState:UIControlStateNormal];
        
        for (int i = 0; i < _ZoneNary.count; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [_ZoneTableView deselectRowAtIndexPath:indexPath animated:YES];
            _kbdaRY3 = @"";
            [_ary removeAllObjects];
        }
    }
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _ZoneTableView) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }else{
        return UITableViewCellEditingStyleNone ;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 30;
}
#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.provinceTableView) {
        return self.provinceNary.count;
    }
    else if (tableView == self.CityTableView){
        return self.CityNary.count;
    }
    else{
        return self.ZoneNary.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.provinceTableView) {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        ProvinceModel *c = self.provinceNary[indexPath.row];
        cell.textLabel.highlightedTextColor = [UIColor blueColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        
        cell.textLabel.text = c.fullname;
        return cell;
        
    }
    else if (tableView == self.CityTableView){
        static NSString *cellIdentifier = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = GetColor(236, 236, 236, 1);
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 17)];
            title.highlightedTextColor=[UIColor blueColor];
            title.font = [UIFont systemFontOfSize:13];
            title.textColor=[UIColor blackColor];
            title.tag = 2015;
            [cell.contentView addSubview:title];
        }
        // 取出数据
        cityModel *ProvinceModel1 = _CityNary[indexPath.row];
        // 取出子视图
        UILabel *title      = (UILabel *)[cell.contentView viewWithTag:2015];
        NSString *provinceName=[NSString stringWithFormat:@"%@",ProvinceModel1.fullname];
        title.text           = provinceName;
        return cell;
        
    }
    else{
        
        SpreadTableViewCell *cell = [SpreadTableViewCell creatWithTableView:tableView];
        ZoneModel *ProvinceModel1 = _ZoneNary[indexPath.row];
        NSString *provinceName=[NSString stringWithFormat:@"%@",ProvinceModel1.fullname];
        cell.textLabel.text = provinceName;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor = [UIColor blueColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        return cell;
        
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.ZoneTableView) {
        if ([_sajkdlBTN.titleLabel.text isEqualToString:@"取消全选"]) {
            [_sajkdlBTN setTitle:@"全选" forState:UIControlStateNormal];
            [_ZoneTableView deselectRowAtIndexPath:indexPath animated:YES];
            isAllSelected = NO;
        }
        ZoneModel *ProvinceModel1 = _ZoneNary[indexPath.row];
        [_ary removeObject:ProvinceModel1.fullname];
    }
}
#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.provinceTableView) {
        self.CityNary=[NSMutableArray array];
        ProvinceModel *ProvinceModel1 = _provinceNary[indexPath.row];
        NSString *urlStr=[NSString stringWithFormat:@"http://apis.map.qq.com/ws/district/v1/getchildren?&id=%@&key=K3VBZ-M6WWV-PPSPY-UVGGC-DRM2Z-PGBMV", ProvinceModel1.mid];
        [ZXDNetworking GET:urlStr parameters:nil success:^(id responseObject) {
            NSMutableArray *messageData=[responseObject objectForKey:@"result"];
            for (NSDictionary  *dic in messageData[0]) {
                cityModel *model =[[cityModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.CityNary addObject:model];
            }
            [self.CityTableView reloadData];
            [self.ZoneTableView removeFromSuperview];
            [self.CityTableView removeFromSuperview];
            [self loadViewCity];
            for (int i = 0; i < _ZoneNary.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [_ZoneTableView deselectRowAtIndexPath:indexPath animated:YES];
            }
            [_ary removeAllObjects];
            if (isAllSelected == YES)  {
                
                isAllSelected = NO;
                [_sajkdlBTN setTitle:@"全选" forState:UIControlStateNormal];
                
                for (int i = 0; i < _ZoneNary.count; i++) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [_ZoneTableView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
            ProvinceModel *c = _provinceNary[indexPath.row];
            _kbdaRY = [[NSString alloc]initWithString:c.fullname];
            
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
    }else if (tableView == self.CityTableView){
        cityModel *ProvinceModel1 = _CityNary[indexPath.row];
        self.ZoneNary=[NSMutableArray array];
        NSString *urlString = [NSString stringWithFormat:@"http://apis.map.qq.com/ws/district/v1/getchildren?&id=%@&key=K3VBZ-M6WWV-PPSPY-UVGGC-DRM2Z-PGBMV", ProvinceModel1.did];
        [ZXDNetworking GET:urlString parameters:nil success:^(id responseObject) {
            NSMutableArray *messageData=[responseObject objectForKey:@"result"];
            for (NSDictionary  *dicc in messageData[0]) {
                ZoneModel *model =[[ZoneModel alloc]init];
                [model setValuesForKeysWithDictionary:dicc];
                [self.ZoneNary addObject:model];
                [self.ZoneTableView removeFromSuperview];
                [self.ZoneTableView reloadData];
                [self loadViewZone];
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:NO];
        if (isAllSelected == YES)  {
            isAllSelected = NO;
            [_sajkdlBTN setTitle:@"全选" forState:UIControlStateNormal];
            for (int i = 0; i < _ZoneNary.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [_ZoneTableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
        
        for (int i = 0; i < _ZoneNary.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [_ZoneTableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        [_ary removeAllObjects];
        cityModel *ProvinceModel2 = _CityNary[indexPath.row];
        _kbdaRY2 = [[NSString alloc]initWithString:ProvinceModel2.fullname];
        
        [self.ZoneTableView reloadData];
        
        
    }else  if(tableView == self.ZoneTableView){
        
        [_ZoneTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        ZoneModel *ProvinceModel1 = _ZoneNary[indexPath.row];
        NSLog(@"%@",ProvinceModel1.fullname);
        [_ary insertObject:ProvinceModel1.fullname atIndex:0];
        if (_ary.count == _ZoneNary.count) {
            
            [_sajkdlBTN setTitle:@"取消全选" forState:UIControlStateNormal];
            isAllSelected = YES;
        }
        
        _kbdaRY3 = [[NSString alloc]initWithString:ProvinceModel1.fullname];
        
        
        
        
        
        
    }
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = GetColor(236,236, 236, 1);
    [tableView setTableFooterView:view];
}
- (void)makeSure
{
    if (_ary.count>0) {
        if (self.shengback) {
            self.shengback(_kbdaRY);
            NSLog(@"省：%@",_kbdaRY);
        }
        if (self.shiback) {
            self.shiback(_kbdaRY2);
            NSLog(@"市：%@",_kbdaRY2);
        }
        if (self.callback) {
            self.callback(_ary);
            NSLog(@"区：%@",_ary);
        }
    }else{
        _handleButton1.enabled = NO;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];   //菜单消失
}
@end
