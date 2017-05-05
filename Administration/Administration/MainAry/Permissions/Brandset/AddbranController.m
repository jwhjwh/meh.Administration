//
//  AddbranController.m
//  Administration
//
//  Created by zhang on 2017/4/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AddbranController.h"
#import "CbrandController.h"
#import "multiController.h"
#import "ZXYAlertView.h"
#import "branModel.h"
#import "ItemCell.h"
static NSString *reuseID = @"itemCell";
static NSString *sectionHeaderID = @"sectionHeader";
@interface AddbranController ()<UICollectionViewDelegate, UICollectionViewDataSource,ZXYAlertViewDelegate,UITextViewDelegate>
{
  
    NSIndexPath *index;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *tileAry;
@property (strong,nonatomic) NSArray *paleAry;
@property (strong,nonatomic) NSArray *dateAry;
@property (nonatomic,retain) NSString *nameBarn;
@property (nonatomic,retain) NSString *nature;
@property (nonatomic,retain) NSString *Choobrand;
@property (nonatomic,retain) NSString *mainon;
@property (nonatomic,retain) UIView *fotView;
@property (nonatomic,strong)NSMutableArray *branarr;
@property (nonatomic,strong)NSString *branID;

@end

@implementation AddbranController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加品牌部";
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
    _branarr=[NSMutableArray array];
    _paleAry=@[@"请输入品牌名称"];
    _tileAry=@[@[@"名称",@"负责品牌"],@[@"负责总监",@"负责经理"]];

}
-(void)InterTableUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth / 4, kScreenWidth / 4);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 35);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
       [_collectionView registerClass:[ItemCell class] forCellWithReuseIdentifier:reuseID];
 
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
