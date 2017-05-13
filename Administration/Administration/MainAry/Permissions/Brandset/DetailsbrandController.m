//
//  DetailsbrandController.m
//  Administration
//
//  Created by zhang on 2017/4/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DetailsbrandController.h"
#import "HoderReusableView.h"
#import "multiController.h"
#import "DirectorController.h"
#import "inftionxqController.h"
#import "ZXYAlertView.h"
#import "branModel.h"
#import "ItemCell.h"
#import "DirtmsnaModel.h"
#import "EmistController.h"

@interface DetailsbrandController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSIndexPath *index;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) branModel *Bmodeld;
@property (nonatomic,strong) branModel *Bmold;
@property (nonatomic,strong) DirtmsnaModel *dirMoeld;
@property (nonatomic,strong) DirtmsnaModel *dirtMoeld;
//品牌
@property (nonatomic,strong)NSArray *branarr;


//总监
@property (strong,nonatomic) NSArray *paleAry;
//经理
@property (strong,nonatomic) NSArray *ManaAry;
//员工
@property (strong,nonatomic) NSArray *EmisAry;

//名称
@property (nonatomic,retain) NSString *nameBarn;


@property (nonatomic,retain) UIView *fotView;
//品牌字符串
@property (nonatomic,retain) NSString *BrandID;
//人员字符串
@property (nonatomic,retain) NSString *employees;
//人员字符串
@property (nonatomic,retain) NSString *mid;
@end

@implementation DetailsbrandController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_nameStr;
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    
    [self getNetworkData];

}
-(void)InterTableUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth / 5, kScreenWidth / 5+10);
    //(2.1设置列间距(每个Item上下的间距)
    layout.minimumLineSpacing=0.5;
    //(2.2设置上下间距(图片左右间距大小
    layout.minimumInteritemSpacing=0;
    //    layout.sectionInset=UIEdgeInsetsMake(0.5, 0.25, 0.5,0.25);
    //    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 35);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    //注册ReusableView（相当于头部）
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [_collectionView registerClass:[HoderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    [_collectionView registerClass:[ItemCell class] forCellWithReuseIdentifier:@"ItemCell"];
    //广告栏位置大小
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenHeight,70)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    UILabel * label=[[UILabel alloc]init];
    label.text =@"名称";
    [self.headerView addSubview:label];
    _textField=[[UITextField alloc]init];
    _textField.text =_nameStr;

    [self.headerView addSubview:_textField];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_top).offset(10);
        make.left.mas_equalTo(self.headerView.mas_left).offset(10);
        make.right.mas_equalTo(self.headerView.mas_right).offset(-10);
        make.height.offset(20);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.headerView.mas_right).offset(-10);
        make.top.mas_equalTo(label.mas_bottom).offset(5);
        make.left.mas_equalTo(self.headerView.mas_left).offset(10);
        make.height.offset(30);
    }];
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
//section列数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}
//row行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{   if(section==0){
    return 0;
}else if(section==1){
    return _branarr.count;
}else if (section==2){
    return _paleAry.count;
}else if (section==3){
    return _ManaAry.count;
}else{
    return _EmisAry.count;
}
}
//section 高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return CGSizeMake(kScreenWidth, 70);
    }else{
        return CGSizeMake(kScreenWidth, 30);
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ItemCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 1:{
            branModel *model=_branarr[indexPath.row];
            cell.titleLabel.text =model.finsk;
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo]]placeholderImage:[UIImage imageNamed:@"tj_ico"]];
        }
            break;
        case 2:{
            DirtmsnaModel *model= _paleAry[indexPath.row];
            cell.titleLabel.text =model.name;
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.icon]]placeholderImage:[UIImage imageNamed:@"tx23"]];
        }
            break;
        case 3:{
            DirtmsnaModel *model= _ManaAry[indexPath.row];
            cell.titleLabel.text =model.name;
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.icon]]placeholderImage:[UIImage imageNamed:@"tx23"]];
        }
            break;
        case 4:{
            
            DirtmsnaModel *model= _EmisAry[indexPath.row];
            cell.titleLabel.text =model.name;
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.icon]]placeholderImage:[UIImage imageNamed:@"tx23"]];
        }
            break;
        default:
            break;
    }
    
    return cell;
    
}
//点击Item详情
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
               case 2:{
                   //查看详情
                   inftionxqController *inftionC=[[inftionxqController alloc]init];
                   DirtmsnaModel *model = _paleAry[indexPath.row];
                   inftionC.IDStr =model.usersid;
                   [self.navigationController pushViewController:inftionC animated:YES];
            
        }
            break;
        case 3:{
            //查看详情
            inftionxqController *inftionC=[[inftionxqController alloc]init];
            DirtmsnaModel *model = _ManaAry[indexPath.row];
            inftionC.IDStr =model.usersid;
            [self.navigationController pushViewController:inftionC animated:YES];
        }
            break;
        case 4:{
            //查看详情
            inftionxqController *inftionC=[[inftionxqController alloc]init];
            DirtmsnaModel *model = _EmisAry[indexPath.row];
            inftionC.IDStr =model.usersid;
            [self.navigationController pushViewController:inftionC animated:YES];
            
        }
            break;
        default:
            break;
    }
    
}
//头部显示的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                                UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (indexPath.section==0) {
            [headerView addSubview:self.headerView];//头部广告栏
            return headerView;
        }else {
            HoderReusableView *headerReusaView = (HoderReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:
                                                                      UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
            headerReusaView.backgroundColor=GetColor(230,230,230,1);
            if(indexPath.section==1){
                headerReusaView.label.text =@"负责品牌";
                
                return headerReusaView;
            }else if (indexPath.section==2){
                headerReusaView.label.text = @"负责总监";
                
                return headerReusaView;
            } if(indexPath.section==3){
                headerReusaView.label.text =@"负责经理";
                
                return headerReusaView;
            }else if (indexPath.section==4){
                headerReusaView.label.text =@"员工列表";
                
                return headerReusaView;
            }
            
        }
    }
    return nil;
    
}

-(void)getNetworkData{
    
    NSString *uStr =[NSString stringWithFormat:@"%@manager/queryDepartmentInfo.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"Num":@"1",@"CompanyInfoId":compid,@"DepartmentID":_BarandID};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        
        
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
               [self InterTableUI];
            if ([[dic valueForKey:@"bList"]count]==0) {
                _branarr=@[@"1"];
            }else{
               _branarr=[dic valueForKey:@"bList"];
            }
            
            if ([[[NSDictionary changeType:dic] valueForKey:@"dInfo"]isEqualToString:@""]) {
                _paleAry=@[@"1"];
            }else{
                _paleAry=[NSMutableArray arrayWithObjects:[dic valueForKey:@"dInfo"],nil];
            }
            _ManaAry=[NSMutableArray arrayWithObjects:[dic valueForKey:@"eList"],nil];
            if ([[dic valueForKey:@"mInfo"]count]==0) {
                _EmisAry=@[@"1"];
            }else{
                _EmisAry=[dic valueForKey:@"mInfo"];
            }
            [_collectionView reloadData];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有品牌信息" andInterval:1.0];
           
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
