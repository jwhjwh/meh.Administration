//
//  AddbranController.m
//  Administration
//
//  Created by zhang on 2017/4/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AddbranController.h"
#import "HoderReusableView.h"
#import "CbrandController.h"
#import "multiController.h"
#import "DirectorController.h"
#import "ZXYAlertView.h"
#import "branModel.h"
#import "ItemCell.h"
#import "DirtmsnaModel.h"
@interface AddbranController ()<UICollectionViewDelegate, UICollectionViewDataSource,ZXYAlertViewDelegate,UITextViewDelegate>
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
@property (nonatomic,strong)NSMutableArray *branarr;

//品牌加减
@property (strong,nonatomic) NSArray *dateAry;
@property (strong,nonatomic) NSArray *daAry;
//总监
@property (strong,nonatomic) NSMutableArray *paleAry;
//经理
@property (strong,nonatomic) NSMutableArray *ManaAry;
//总监加减
@property (strong,nonatomic) NSArray *DrieAry;
@property (strong,nonatomic) NSArray *DrAry;
//名称
@property (nonatomic,retain) NSString *nameBarn;


@property (nonatomic,retain) UIView *fotView;

@property (nonatomic,strong)NSString *branID;

@end

@implementation AddbranController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加品牌部";
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;

    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(masgegeClick)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    [self InterTableUI];
    _Bmodeld =[[branModel alloc]init];
    _Bmodeld.brandLogo=@"";
    _Bmodeld.finsk=@"";
    _Bmold =[[branModel alloc]init];
    _Bmold.brandLogo=@"";
    _Bmold.finsk=@"";
    _dirMoeld =[[DirtmsnaModel alloc]init];
    _dirMoeld.icon=@"";
    _dirMoeld.name=@"";
    _dirtMoeld =[[DirtmsnaModel alloc]init];
    _dirtMoeld.icon=@"";
    _dirtMoeld.name=@"";
   
    
    _branarr=[[NSMutableArray alloc]initWithObjects:_Bmodeld,nil];
    _daAry=[[NSMutableArray alloc]initWithObjects:_Bmodeld,nil];
    _dateAry=@[_Bmodeld,_Bmold];
    
    _paleAry=[[NSMutableArray alloc]initWithObjects:_dirMoeld,nil];
    _DrieAry=[[NSMutableArray alloc]initWithObjects:_dirMoeld,nil];
    _DrAry=@[_dirMoeld,_dirtMoeld];
    
    _ManaAry=[[NSMutableArray alloc]initWithObjects:_dirMoeld,nil];

   

}
-(void)InterTableUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth / 5, kScreenWidth / 5+10);
    //(2.1设置列间距(每个Item上下的间距)
    layout.minimumLineSpacing=0.5;
    //(2.2设置上下间距(图片左右间距大小
    layout.minimumInteritemSpacing=0;
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 35);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
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
    _textField.placeholder = @"请输入品牌名称";
    [_textField addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
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
-(void)masgegeClick{
   
    if (_nameBarn==nil ||_branID.length==0) {
    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请完善信息" andInterval:1.0];
    }else{
        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要添加此品牌部" sureBtn:@"确认" cancleBtn:@"取消"];
        
        alertView.resultIndex = ^(NSInteger index){
            
                NSLog(@"%@",[NSString stringWithFormat:@"%@",_branID]);
                NSString *urlStr =[NSString stringWithFormat:@"%@user/addDepartment",KURLHeader];
                NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
                NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
                NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
                NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":@"1",@"BrandID":[NSString stringWithFormat:@"%@",_branID],@"DepartmentName":_nameBarn};
                [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
                    if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"添加成功" andInterval:1.0];
                        _nameBarn = nil;
                        [_branarr removeAllObjects];
                        [_collectionView reloadData];
                        self.blockStr();
                    }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
                        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登陆超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
                        
                        alertView.resultIndex = ^(NSInteger index){
                            ViewController *loginVC = [[ViewController alloc] init];
                            UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                            [self presentViewController:loginNavC animated:YES completion:nil];
                        };
                        [alertView showMKPAlertView];
                    }
                    
                    [_collectionView reloadData];
                } failure:^(NSError *error) {
                    
                } view:self.view MBPro:YES];
            
        };
        [alertView showMKPAlertView];

    }
  }
-(void)FieldText:(UITextField*)sender{
    
    switch (sender.tag) {
        case 0:{
            _nameBarn=sender.text;
        

        }
            break;
        default:
            break;
    }
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
    return 10;
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
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.icon]]placeholderImage:[UIImage imageNamed:@"tj_ico"]];
        }
            break;
        case 3:{
            DirtmsnaModel *model= _ManaAry[indexPath.row];
            cell.titleLabel.text =model.name;
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.icon]]placeholderImage:[UIImage imageNamed:@"tj_ico"]];
        }
            break;
        case 4:{
            
            cell.titleLabel.text =@"121323";
            cell.icon.image=[UIImage imageNamed:@"tj_ico"];
        }
            break;
        default:
            break;
    }
    
    return cell;
    
}
//点击Item详情
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    switch (indexPath.section) {
        case 1:{
            multiController *multiCV=[[multiController alloc]init];
            multiCV.blockArr =^(NSMutableArray *array){
                _branarr=[NSMutableArray array];
                _branarr=array;
                for (branModel *model in _daAry) {
                    [_branarr addObject:model];
                }
                
                [_collectionView reloadData];
            };
            [self.navigationController pushViewController:multiCV animated:YES];
            
        }
            break;
        case 2:{
            DirectorController *multiCV=[[DirectorController alloc]init];
            multiCV.str=@"添加负责总监";
            multiCV.blockArray =^(NSMutableArray *arr){
                _paleAry=[NSMutableArray array];
                _paleAry=arr;
                for (branModel *model in _DrieAry) {
                    [_paleAry addObject:model];
                }
                
                [_collectionView reloadData];
            };
            
            [self.navigationController pushViewController:multiCV animated:YES];
        }
            break;
        case 3:{
            DirectorController *mulCV=[[DirectorController alloc]init];
            mulCV.str=@"添加负责经理";
            mulCV.blockArray =^(NSMutableArray *arr){
                _ManaAry=[NSMutableArray array];
                _ManaAry=arr;
                for (branModel *model in _DrieAry) {
                    [_ManaAry addObject:model];
                }
                
                [_collectionView reloadData];
            };
            
            [self.navigationController pushViewController:mulCV animated:YES];
        }
            break;
        case 4:{
          
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
