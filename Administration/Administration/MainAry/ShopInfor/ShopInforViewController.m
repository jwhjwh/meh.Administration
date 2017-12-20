//
//  ShopInforViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/12/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ShopInforViewController.h"
#import "QZConditionFilterView.h"
#import "UIView+Extension.h"
#import "cityModel.h"
#import "ProvinceModel.h"
#import "ZoneModel.h"
#import "ShopNameViewController.h"

@interface ShopInforViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    NSArray *_selectedDataSource1Ary;
    NSArray *_selectedDataSource2Ary;
    NSArray *_selectedDataSource3Ary;
    
   
}
@property (strong,nonatomic) QZConditionFilterView *conditionFilterView;
@property (strong,nonatomic) NSMutableArray *proviceNameAry;
@property (strong,nonatomic) NSMutableArray *cityNameAry;
@property (strong,nonatomic) NSMutableArray *areaNameAry;

@property (strong,nonatomic) NSMutableArray *proviceNameidAry;
@property (strong,nonatomic) NSMutableArray *cityNameidAry;

@property (strong,nonatomic) NSString *filename;

@property (strong,nonatomic) NSMutableArray *proviceAry;
@property (strong,nonatomic) NSMutableArray *cityAry;
@property (strong,nonatomic) NSMutableArray *areaAry;

@property (strong,nonatomic) NSString *provice;
@property (strong,nonatomic) NSString *city;
@property (strong,nonatomic) NSString *area;
@property (strong,nonatomic) NSString *StoreName;
@end

@implementation ShopInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店家信息";
    self.view.backgroundColor = GetColor(238, 238, 238, 1);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    [self getNetworkData];
    [self provicenfnetworking];
}
-(void)nsstingalloc{
    _provice = [[NSString alloc]init];
    _provice = @"";
    _city = [[NSString alloc]init];
    _city = @"";
    _area = [[NSString alloc]init];
    _area = @"";
    _StoreName = [[NSString alloc]init];
    _StoreName = @"";
    
}
-(void)provicenfnetworking{
    NSString *urlStr=[NSString stringWithFormat:@"http://apis.map.qq.com/ws/district/v1/list?key=K3VBZ-M6WWV-PPSPY-UVGGC-DRM2Z-PGBMV"];
    [ZXDNetworking GET:urlStr parameters:nil success:^(id responseObject) {
        NSMutableArray *messageData=[responseObject objectForKey:@"result"];
        self.proviceAry=[NSMutableArray array];
        self.proviceNameidAry=[NSMutableArray array];
        for (NSDictionary  *dic in messageData[0]) {
            ProvinceModel *model =[[ProvinceModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.proviceAry addObject:model.fullname];
            [self.proviceNameidAry addObject:model.mid];
        }
        NSLog(@"%@",self.proviceAry);
        
        [self ui];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)ui{
     NSString* phoneModel = [UIDevice devicePlatForm];
    
    UIView *dename = [[UIView alloc]init];
    dename.backgroundColor = [UIColor whiteColor];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        dename.frame =CGRectMake(0, 88, [UIScreen mainScreen].bounds.size.width, 50);
    }else{
        dename.frame =CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 50);
    }
    UILabel *depanlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 30)];
    depanlabel.text = @"店名";
    depanlabel.font = [UIFont systemFontOfSize:14];
    [dename addSubview:depanlabel];
    
    UITextField *depanText = [[UITextField alloc]initWithFrame:CGRectMake(70, 10, self.view.bounds.size.width-70, 30)];
    depanText.textAlignment = NSTextAlignmentCenter;
    depanText.placeholder = @"请输入店名";
    depanText.font = [UIFont systemFontOfSize:14];
    [depanText addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
    [dename addSubview:depanText];
    
    [self.view addSubview:dename];
    
    _selectedDataSource1Ary = @[@"请选择省"];
    _selectedDataSource2Ary = @[@"请选择市"];
    _selectedDataSource3Ary = @[@"请选择区"];
    _conditionFilterView = [QZConditionFilterView conditionFilterViewWithFilterBlock:^(BOOL isFilter, NSArray *dataSource1Ary, NSArray *dataSource2Ary, NSArray *dataSource3Ary) {
        if (isFilter) {
            //网络加载请求 存储请求参数
            _selectedDataSource1Ary = dataSource1Ary;
            _selectedDataSource2Ary = dataSource2Ary;
            _selectedDataSource3Ary = dataSource3Ary;
        }else{
            // 不是筛选，全部赋初值（在这个工程其实是没用的，因为tableView是选中后必选的，即一旦选中就没有空的情况，但是如果可以清空筛选条件的时候就有必要 *重新* reset data）
            _selectedDataSource1Ary = @[@"请选择省"];
            _selectedDataSource2Ary = @[@"请选择市"];
            _selectedDataSource3Ary = @[@"请选择区"];
        }
        [self startRequest];
    }];
    _conditionFilterView.mj_y += dename.bottom+10;
    _conditionFilterView.dataAry1 = _proviceAry;
     _conditionFilterView.dataAry2 = _cityAry;
    _conditionFilterView.dataAry3 = _areaAry;
    
    // 初次设置默认显示数据，内部会调用block 进行第一次数据加载
    [_conditionFilterView bindChoseArrayDataSource1:_selectedDataSource1Ary DataSource2:_selectedDataSource2Ary DataSource3:_selectedDataSource3Ary];
    
    [self.view addSubview:_conditionFilterView];
    
    
    
    
    
    
    
    
    UILabel *ssjlLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,_conditionFilterView.bottom+80, [UIScreen mainScreen].bounds.size.width, 30)];
    ssjlLabel.font = [UIFont systemFontOfSize:14];
    ssjlLabel.backgroundColor = [UIColor whiteColor];
    ssjlLabel.textColor = GetColor(138, 138, 138, 1);
    NSString *_test  = @"搜索记录" ;
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
    CGFloat emptylen = ssjlLabel.font.pointSize * 2;
    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_test attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    ssjlLabel.attributedText = attrText;
    [self.view addSubview:ssjlLabel];
    infonTableview =[[UITableView alloc]initWithFrame:CGRectMake(0,ssjlLabel.bottom+10, kScreenWidth, kScreenHeight-(ssjlLabel.bottom+10))];
    infonTableview.delegate = self;
    infonTableview.dataSource = self;
    infonTableview.scrollEnabled =NO; //设置tableview 不能滚动
    [self.view addSubview: infonTableview];
    [ZXDNetworking setExtraCellLineHidden:infonTableview];
    
}
-(void)FieldText:(UITextField *)textfield{
    NSLog(@"%@",textfield.text);
    _StoreName = textfield.text;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    
    return _proviceNameAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    image.image = [UIImage imageNamed:@"ssjl"];
    [cell addSubview:image];
    
    UIButton *ssbbtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 10, 50, 30)    ];
    [ssbbtn setTitle:@"搜索" forState:UIControlStateNormal];
    ssbbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [ssbbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [ssbbtn addTarget:self action:@selector(TouchsearchCom:)forControlEvents: UIControlEventTouchUpInside];
    ssbbtn.tag = indexPath.section;
    [cell addSubview:ssbbtn];
    
    
    
    UILabel *dizhilabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10,self.view.frame.size.width-100, 30)];
    dizhilabel.text = [NSString stringWithFormat:@"%@   %@   %@",_proviceNameAry[indexPath.section],_cityNameAry[indexPath.section],_areaNameAry[indexPath.section]];
    dizhilabel.textColor = GetColor(130, 130, 130, 1);
    dizhilabel.font = [UIFont systemFontOfSize:15];
    dizhilabel.adjustsFontSizeToFitWidth = YES;
    dizhilabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:dizhilabel];
    return cell;
}
-(void)TouchsearchCom:(UIButton *)ssbbtn{
     ShopNameViewController *shopname= [[ShopNameViewController alloc]init];
    shopname.Province =_proviceNameAry[ssbbtn.tag];
    shopname.City =_cityNameAry[ssbbtn.tag];
    shopname.County =_areaNameAry[ssbbtn.tag];
    shopname.strId = self.strId;
     shopname.StoreName = self.StoreName;
   [self.navigationController pushViewController:shopname animated:YES];

}
-(void)rightItemAction:(UIBarButtonItem*)sender{

    ShopNameViewController *shopname= [[ShopNameViewController alloc]init];
    shopname.StoreName = self.StoreName;
    shopname.Province = self.provice;
    shopname.City = self.city;
    shopname.County = self.area;
    shopname.strId = self.strId;
    [self.navigationController pushViewController:shopname animated:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getNetworkData{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    _filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",self.strId]];
    //读文件
    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:_filename];
    if(dic2 == nil)
    {
        //1. 创建一个plist文件
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:_filename contents:nil attributes:nil];
        
        _proviceNameAry = [[NSMutableArray alloc]init];
        _cityNameAry = [[NSMutableArray alloc]init];
        _areaNameAry = [[NSMutableArray alloc]init];
    }
    else
    {
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:_filename];
        _proviceNameAry = [[NSMutableArray alloc]init];
        _cityNameAry = [[NSMutableArray alloc]init];
        _areaNameAry = [[NSMutableArray alloc]init];
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = dataDictionary[@"搜索记录"];
        _proviceNameAry =dic[@"provice"];
        _cityNameAry =dic[@"city"];
        _areaNameAry =dic[@"area"];
        [infonTableview reloadData];
        
    }
}
- (void)startRequest
{
    NSString *source1 = [NSString stringWithFormat:@"%@",_selectedDataSource1Ary.firstObject];
    NSString *source2 = [NSString stringWithFormat:@"%@",_selectedDataSource2Ary.firstObject];
    NSString *source3 = [NSString stringWithFormat:@"%@",_selectedDataSource3Ary.firstObject];
    
    // 可以用字符串在dic换成对应英文key
    NSLog(@"\n第一个条件:%@\n  第二个条件:%@\n  第三个条件:%@\n",source1,source2,source3);
    
    if (_provice==nil) {
        if([source1 isEqualToString:@"请选择省"]){
            
        }else{
            _provice = source1;
        }
        
    }else{
        if([source1 isEqualToString: _provice]){
            if (_city==nil) {
                _city=source2;
            }else{
                if ([source2 isEqualToString: _city]) {
                    if (_area ==nil) {
                        _area = source3;
                    }else{
                        if (source3!=_area) {
                            _area = source3;
                        }
                    }
                }else{
                    _city=source2;
                    _area = nil;
                    _selectedDataSource3Ary = @[@"请选择区"];
                    for (int y =0; y<_cityAry.count; y++) {
                        if ([source2 isEqualToString:_cityAry[y]]) {
                            ProvinceModel *ProvinceModel1 = _cityNameidAry[y];
                            NSString *urlString = [NSString stringWithFormat:@"http://apis.map.qq.com/ws/district/v1/getchildren?&id=%@&key=K3VBZ-M6WWV-PPSPY-UVGGC-DRM2Z-PGBMV", ProvinceModel1];
                            [ZXDNetworking GET:urlString parameters:nil success:^(id responseObject) {
                                NSMutableArray *messageData=[responseObject objectForKey:@"result"];
                                self.areaAry = [[NSMutableArray alloc]init];
                                for (NSDictionary  *dicc in messageData[0]) {
                                    ZoneModel *model =[[ZoneModel alloc]init];
                                    [model setValuesForKeysWithDictionary:dicc];
                                    [self.areaAry addObject:model.fullname];
                                    
                                }
                                _conditionFilterView.dataAry3 = _areaAry;
                                [_conditionFilterView reloadInputViews];
                            } failure:^(NSError *error) {
                                
                            } view:self.view MBPro:NO];
                        }
                        
                    }
                }
            }
            
        }else{
            _provice = source1;
            _city =nil;
            _area = nil;
            _selectedDataSource2Ary = @[@"请选择市"];
            _conditionFilterView.dataAry2 = nil;
            _selectedDataSource3Ary = @[@"请选择区"];
            _conditionFilterView.dataAry3= nil;
            for (int i =0; i<_proviceAry.count; i++) {
                if ([source1 isEqualToString:_proviceAry[i]]) {
                    NSLog(@"%d",i);
                    ProvinceModel *ProvinceModel1 = _proviceNameidAry[i];
                    NSString *urlStr=[NSString stringWithFormat:@"http://apis.map.qq.com/ws/district/v1/getchildren?&id=%@&key=K3VBZ-M6WWV-PPSPY-UVGGC-DRM2Z-PGBMV", ProvinceModel1];
                    [ZXDNetworking GET:urlStr parameters:nil success:^(id responseObject) {
                        NSMutableArray *messageData=[responseObject objectForKey:@"result"];
                        self.cityAry=[NSMutableArray array];
                        self.cityNameidAry=[NSMutableArray array];
                        for (NSDictionary  *dic in messageData[0]) {
                            cityModel *model =[[cityModel alloc]init];
                            [model setValuesForKeysWithDictionary:dic];
                            [self.cityAry addObject:model.fullname];
                            [self.cityNameidAry addObject:model.did];
                            
                        }
                        
                        _conditionFilterView.dataAry2 = _cityAry;
                        [_conditionFilterView reloadInputViews];
                        
                    } failure:^(NSError *error) {
                        
                    } view:self.view MBPro:YES];
                    
                }
            }
        }
    }
    
   
    
    NSLog(@"\n第一个条件:%@\n  第二个条件:%@\n  第三个条件:%@\n",_provice,_city,_area);
    
}
@end
