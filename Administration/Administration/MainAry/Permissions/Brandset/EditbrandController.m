//
//  EditbrandController.m
//  Administration
//
//  Created by zhang on 2017/5/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "EditbrandController.h"
#import "HoderReusableView.h"
#import "multiController.h"
#import "DirectorController.h"
#import "inftionxqController.h"
#import "ZXYAlertView.h"
#import "branModel.h"
#import "ItemCell.h"
#import "DirtmsnaModel.h"
#import "EmistController.h"
#import "ModifyController.h"
@interface EditbrandController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSIndexPath *index;
    BOOL isSele;
    BOOL isSelede;
    BOOL ismay;
    BOOL isEay;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIButton *Button;
@property (nonatomic,strong) branModel *Bmodeld;
@property (nonatomic,strong) branModel *Bmold;
@property (nonatomic,strong) DirtmsnaModel *dirMoeld;
@property (nonatomic,strong) DirtmsnaModel *dirtMoeld;
//品牌
@property (nonatomic,strong)NSMutableArray *branarr;
//品牌加减
@property (strong,nonatomic) NSArray *dateAry;
@property (strong,nonatomic) NSArray *daAry;
//总监加减
@property (strong,nonatomic) NSArray *DrieAry;
@property (strong,nonatomic) NSArray *DrAry;
//总监
@property (strong,nonatomic) NSMutableArray *paleAry;
//经理
@property (strong,nonatomic) NSMutableArray *ManaAry;
//员工
@property (strong,nonatomic) NSMutableArray *EmisAry;
//名称
@property (nonatomic,retain) NSString *nameBarn;

@property (nonatomic,retain) UIView *fotView;
//品牌字符串
@property (nonatomic,retain) NSString *BrandID;
//人员字符串
@property (nonatomic,retain) NSString *employees;
//人员字符串
@property (nonatomic,retain) NSString *mid;


@property (nonatomic,retain) NSString *ident;
@end

@implementation EditbrandController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.ident isEqualToString:@"1"]) {
   
        [self getNetworkData];
        self.ident=@"0";
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"编辑";
    self.hidesBottomBarWhenPushed = YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    _Bmodeld =[[branModel alloc]init];
    _Bmodeld.brandLogo=@"images/tj_ico01.png";
    _Bmodeld.finsk=@"";
    _Bmold =[[branModel alloc]init];
    _Bmold.brandLogo=@"images/sc_ico01.png";
    _Bmold.finsk=@"";
    _dirMoeld =[[DirtmsnaModel alloc]init];
    _dirMoeld.icon=@"images/tj_ico01.png";
    _dirMoeld.name=@"";
    _dirtMoeld =[[DirtmsnaModel alloc]init];
    _dirtMoeld.icon=@"images/sc_ico01.png";
    _dirtMoeld.name=@"";
    _daAry=[[NSMutableArray alloc]initWithObjects:_Bmodeld,nil];
    _dateAry=@[_Bmodeld,_Bmold];
    

    _DrieAry=[[NSMutableArray alloc]initWithObjects:_dirMoeld,nil];
    _DrAry=@[_dirMoeld,_dirtMoeld];
  
    [self getNetworkData];
    isSelede=YES;
    isSele=YES;
    ismay=YES;
    isEay=YES;
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
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, Scree_width, Scree_height-64) collectionViewLayout:layout];
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
    _Button=[[UIButton alloc]init];
    _Button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_Button setTitle:_nameStr forState:UIControlStateNormal];
    [_Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_Button addTarget:self action:@selector(targetButton) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:_Button];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_top).offset(10);
        make.left.mas_equalTo(self.headerView.mas_left).offset(10);
        make.right.mas_equalTo(self.headerView.mas_right).offset(-10);
        make.height.offset(20);
    }];
    [_Button mas_makeConstraints:^(MASConstraintMaker *make) {
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
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo]]placeholderImage:[UIImage imageNamed:@"tx23"]];
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
    ItemCell *cell = (ItemCell *) [collectionView cellForItemAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 1:{
            
            if (_branarr.count==1&&indexPath.row ==0) {
                [self addbaranded];
            }else if (_branarr.count>=3&&indexPath.row == _branarr.count-2) {
                [self addcollectionView:collectionView foleg:NO arr:_branarr Num:1];
                [self addbaranded];
                isSelede=YES;
            }else if (_branarr.count>=3&&indexPath.row == _branarr.count-1) {
                if (isSelede==NO) {
                    [self addcollectionView:collectionView foleg:NO arr:_branarr Num:1];
                    isSelede=YES;
                }else{
                    [self addcollectionView:collectionView foleg:YES arr:_branarr Num:1];
                    isSelede=NO;
                }
            }else{
                if (isSelede==NO) {
                    if (_branarr.count==3&&indexPath.row==0) {
                      [ELNAlerTool showAlertMassgeWithController:self andMessage:@"品牌不能为空，请先添加在删除" andInterval:1.0];
                    }else{
                        branModel *model =  _branarr[indexPath.row];
                        [self getDataBrandString:@"manager/delDepartmentBrand.action" NSString:@"删除失败"branid:model.ID num:1];
                        __weak __typeof__(self) weakSelf = self;
                        weakSelf.Str=^(){
                            [_branarr removeObjectAtIndex:indexPath.row];
                            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                            if (_branarr.count==2) {
                                [_branarr removeLastObject];
                                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:1];
                                [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                                isSelede=YES;
                                [cell.rightUpperButton removeFromSuperview];
                            }
                        };

                    }
                }else{
                    //查看详情
                    
                }
            }
            
        }
            break;
        case 2:{
            
            if (_paleAry.count==1&&indexPath.row ==0) {
                [self addpaledNstring:@"添加负责总监"];
            }else if (_paleAry.count>=3&&indexPath.row == _paleAry.count-2) {
                [self addcollectionView:collectionView foleg:NO arr:_paleAry Num:2];
                [self addpaledNstring:@"添加负责总监"];
                isSele=YES;
            }else if (_paleAry.count>=3&&indexPath.row == _paleAry.count-1) {
                if (isSele==NO) {
                    [self addcollectionView:collectionView foleg:NO arr:_paleAry  Num:2];
                    isSele=YES;
                }else{
                    [self addcollectionView:collectionView foleg:YES arr:_paleAry  Num:2];
                    isSele=NO;
                }
            }else{
                if (isSele==NO) {
                DirtmsnaModel *model =  _paleAry[indexPath.row];
                [self getDataBrandString:@"manager/delDepartmentManager.action" NSString:@"删除失败"branid:model.usersid num:2];
                    __weak __typeof__(self) weakSelf = self;
                    weakSelf.Str=^(){
                    [_paleAry removeObjectAtIndex:indexPath.row];
                    [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                    if (_paleAry.count==2) {
                        [_paleAry removeLastObject];
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:2];
                        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                        isSele=YES;
                        [cell.rightUpperButton removeFromSuperview];
                    }
                    };
                }else{
                    //查看详情
                    inftionxqController *inftionC=[[inftionxqController alloc]init];
                    DirtmsnaModel *model = _paleAry[indexPath.row];
                    inftionC.IDStr =model.usersid;
                    [self.navigationController pushViewController:inftionC animated:YES];
                }
            }
            
            
        }
            break;
        case 3:{
            if (_ManaAry.count==1&&indexPath.row ==0) {
                [self addMaryNstring:@"添加负责经理"];
            }else if (_ManaAry.count>=3&&indexPath.row == _ManaAry.count-2) {
                [self addcollectionView:collectionView foleg:NO arr:_ManaAry Num:3];
                [self addMaryNstring:@"添加负责经理"];
                ismay=YES;
            }else if (_ManaAry.count>=3&&indexPath.row == _ManaAry.count-1) {
                if (ismay==NO) {
                    [self addcollectionView:collectionView foleg:NO arr:_ManaAry Num:3];
                    ismay=YES;
                }else{
                    [self addcollectionView:collectionView foleg:YES arr:_ManaAry Num:3];
                    ismay=NO;
                }
            }else{
                if (ismay==NO) {
                    DirtmsnaModel *model =  _ManaAry[indexPath.row];
                    [self getDataBrandString:@"manager/delDepartmentManager.action" NSString:@"删除失败"branid:model.usersid num:2];
                    __weak __typeof__(self) weakSelf = self;
                    weakSelf.Str=^(){
                    [_ManaAry removeObjectAtIndex:indexPath.row];
                    [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                    if (_ManaAry.count==2) {
                        [_ManaAry removeLastObject];
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:3];
                        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                        ismay=YES;
                        [cell.rightUpperButton removeFromSuperview];
                    }
                    };
                }else{
                    //查看详情
                    //查看详情
                    inftionxqController *inftionC=[[inftionxqController alloc]init];
                    DirtmsnaModel *model = _ManaAry[indexPath.row];
                    inftionC.IDStr =model.usersid;
                    [self.navigationController pushViewController:inftionC animated:YES];
                }
            }
            
        }
            break;
        case 4:{
            if (_EmisAry.count==1&&indexPath.row ==0) {
                [self addEmis];
            }else if (_EmisAry.count>=3&&indexPath.row == _EmisAry.count-2) {
                [self addcollectionView:collectionView foleg:NO arr:_EmisAry Num:4];
                [self addEmis];
                isEay=YES;
            }else if (_EmisAry.count>=3&&indexPath.row == _EmisAry.count-1) {
                if (isEay==NO) {
                    [self addcollectionView:collectionView foleg:NO arr:_EmisAry Num:4];
                    isEay=YES;
                }else{
                    [self addcollectionView:collectionView foleg:YES arr:_EmisAry Num:4];
                    isEay=NO;
                }
            }else{
                if (isEay==NO) {
                    DirtmsnaModel *model =  _EmisAry[indexPath.row];
                    [self getDataBrandString:@"manager/delDepartmentEmployee.action" NSString:@"删除失败"branid:model.usersid num:2];
                    __weak __typeof__(self) weakSelf = self;
                    weakSelf.Str=^(){
                    [_EmisAry removeObjectAtIndex:indexPath.row];
                    [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                    if (_EmisAry.count==2) {
                        [_EmisAry removeLastObject];
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:4];
                        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                        isEay=YES;
                        [cell.rightUpperButton removeFromSuperview];
                    }
                    };
                }else{
                    //查看详情
                    inftionxqController *inftionC=[[inftionxqController alloc]init];
                    DirtmsnaModel *model = _EmisAry[indexPath.row];
                    inftionC.IDStr =model.usersid;
                    [self.navigationController pushViewController:inftionC animated:YES];
                }
            }
            
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
            if ([[responseObject valueForKey:@"bList"]count]==0) {
            _branarr=[[NSMutableArray alloc]initWithObjects:_Bmodeld,nil];
            }else{
                _branarr=[NSMutableArray array];
                for (NSDictionary *dic in [responseObject valueForKey:@"bList"]) {
                    branModel *model=[[branModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_branarr addObject:model];
                }
                for (branModel *model in _dateAry) {
                    [_branarr addObject:model];
                }
            }
          
            if ([[[NSDictionary changeType:responseObject] valueForKey:@"dInfo"]isEqual:@""]) {
                _paleAry=[[NSMutableArray alloc]initWithObjects:_dirMoeld,nil];
             
            }else{
                _paleAry=[NSMutableArray array];
                DirtmsnaModel *model=[[DirtmsnaModel alloc]init];
                [model setValuesForKeysWithDictionary: [responseObject valueForKey:@"dInfo"]];
                [_paleAry addObject:model];
                for (DirtmsnaModel *model in _DrAry) {
                    [_paleAry addObject:model];
                    }
            }
            if ([[[NSDictionary changeType:responseObject] valueForKey:@"mInfo"]isEqual:@""]) {
                _ManaAry=[[NSMutableArray alloc]initWithObjects:_dirMoeld,nil];
            }else{
                _ManaAry=[NSMutableArray array];
                DirtmsnaModel *model=[[DirtmsnaModel alloc]init];
                [model setValuesForKeysWithDictionary: [responseObject valueForKey:@"mInfo"]];
                [_ManaAry addObject:model];
                for (DirtmsnaModel *model in _DrAry) {
                    [_ManaAry addObject:model];
                }
            }
            if ([[responseObject valueForKey:@"eList"]count]==0) {
                _EmisAry=[[NSMutableArray alloc]initWithObjects:_dirMoeld,nil];
            }else{
                _EmisAry=[NSMutableArray array];
                for (NSDictionary *dic in [responseObject valueForKey:@"eList"]) {
                    DirtmsnaModel *model=[[DirtmsnaModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_EmisAry addObject:model];
                }
                for (DirtmsnaModel *model in _DrAry) {
                    [_EmisAry addObject:model];
                }
            }
            
            [_collectionView reloadData];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有品牌信息" andInterval:1.0];
            
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
-(void)addbaranded{
    multiController *multiCV=[[multiController alloc]init];
    multiCV.num=1;
    multiCV.BarandID=_BarandID;
    multiCV.blockArr =^(NSMutableArray *array){
        _branarr=[NSMutableArray array];
        _branarr=array;
        for (branModel *model in _dateAry) {
            [_branarr addObject:model];
        }
        
       _ident=@"1";
    };
    [self.navigationController pushViewController:multiCV animated:YES];
}
-(void)addpaledNstring:(NSString*)str {
    DirectorController *multiCV=[[DirectorController alloc]init];
    multiCV.str=str;
    multiCV.Num=1;
    multiCV.Numstr=@"1";
    multiCV.BarandID=_BarandID;
    multiCV.blockArray =^(NSMutableArray *arr){
        _paleAry=[NSMutableArray array];
        _paleAry=arr;
        
        for (DirtmsnaModel *model in _DrAry) {
            [_paleAry addObject:model];
        }
        
        [_collectionView reloadData];
    };
    
    [self.navigationController pushViewController:multiCV animated:YES];
}
-(void)addMaryNstring:(NSString*)str {
    DirectorController *multiCV=[[DirectorController alloc]init];
    multiCV.str=str;
    multiCV.Num=1;
    multiCV.Numstr=@"1";
    multiCV.BarandID=_BarandID;
    multiCV.blockArray =^(NSMutableArray *arr){
        _ManaAry=[NSMutableArray array];
        _ManaAry=arr;
        for (DirtmsnaModel *model in _DrAry) {
            [_ManaAry addObject:model];
        }
        [_collectionView reloadData];
    };
    
    [self.navigationController pushViewController:multiCV animated:YES];
}
-(void)addEmis{
    EmistController *multiCV=[[EmistController alloc]init];
    multiCV.str=@"添加员工";
    multiCV.num=1;
    multiCV.Numstr=@"1";
    multiCV.BarandID=_BarandID;
    multiCV.blockArr =^(NSMutableArray *arr){
        _EmisAry=[NSMutableArray array];
        _EmisAry=arr;
        for (DirtmsnaModel *model in _DrAry) {
            [_EmisAry addObject:model];
        }
         _ident=@"1";
    };
    
    [self.navigationController pushViewController:multiCV animated:YES];
}

-(void)addcollectionView:(UICollectionView*)collectionView foleg:(BOOL)foleg  arr:(NSMutableArray *)arry Num:(int)Num{
    NSArray *arr= [arry subarrayWithRange:NSMakeRange(0,arry.count-2)];
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (int i = 0; i < arr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:Num];
        [indexPaths addObject:indexPath];
    }
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    } completion:^(BOOL finished) {
        for (NSIndexPath *indexPath in indexPaths) {
            ItemCell *celled = (ItemCell *) [collectionView cellForItemAtIndexPath:indexPath];
            
            [ celled.rightUpperButton setImage:[UIImage imageNamed:@"scbut"] forState:UIControlStateNormal];
            if (foleg==YES) {
                [celled addSubview:celled.rightUpperButton];
            }else{
                [celled.rightUpperButton removeFromSuperview];
            }
            
        }
    }];
}
-(void)targetButton{
    ModifyController *modify=[[ModifyController alloc]init];
    modify.BarandID =_BarandID;
    modify.blockStr =^(NSString *str){
        
    [_Button setTitle:str forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:modify animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getDataBrandString:(NSString *)Url NSString:(NSString*)string branid:(NSString*)branid num:(int)num{
     NSString *uStr =[NSString stringWithFormat:@"%@%@",KURLHeader,Url];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic;
    if (num==1) {
        dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"DepartmentID":_BarandID,@"BrandID":branid};
    }else{
         dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"eid":branid,@"DepartmentID":_BarandID};
    }
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
          [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除成功" andInterval:1.0];
            _Str();
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:string andInterval:1.0];
            
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
