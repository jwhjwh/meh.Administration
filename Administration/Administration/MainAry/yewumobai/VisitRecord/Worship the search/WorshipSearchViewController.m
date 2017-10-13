//
//  WorshipSearchViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/9/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//
//详细搜索
#import "WorshipSearchViewController.h"
#import "YZPPickView.h"
#import "OneDateViewController.h"
#import "InterestedsearchViewController.h"
@interface WorshipSearchViewController ()<YZPPickViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
}
@property (nonatomic,strong)UILabel *proviceLabel;
@property (nonatomic,strong)UILabel *cityLabel;
@property (nonatomic,strong)UILabel *areaLabel;

@property (strong,nonatomic) NSMutableArray *proviceNameAry;
@property (strong,nonatomic) NSMutableArray *cityNameAry;
@property (strong,nonatomic) NSMutableArray *areaNameAry;
@property (strong,nonatomic) NSString *filename;



@end


@implementation WorshipSearchViewController
-(void)viewWillAppear:(BOOL)animated{
    [self getNetworkData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"详细搜索";
    self.view.backgroundColor =GetColor(230, 230, 230, 1);
    _filename = [[NSString alloc]init];
    
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
    [self worshipSearchUI];
    [self getNetworkData];
}
- (void)didSelectPickView:(Provice*)provice city:(City *)city area:(Area *)area {
    NSLog(@"%@%@%@",provice.name,city.name,area.name);
    
    _proviceLabel.text = [NSString stringWithFormat:@"%@",provice.name];
    _cityLabel.text = [NSString stringWithFormat:@"%@",city.name];
    _areaLabel.text = [NSString stringWithFormat:@"%@",area.name];
    NSString *string =  [UnCodePlace addressWithProviceCode:provice.code withCityCode:city.code withAreaCode:area.code];
    
    NSLog(@"%@\n %@-%@-%@",string,provice.name,city.name,area.name);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}
-(void)rightItemAction:(UIBarButtonItem*)sender{
    
    if (_proviceLabel.text == nil) {
        
    }else{
        
        if (_proviceNameAry.count>1) {
            [_proviceNameAry insertObject:_proviceLabel.text atIndex:0];
            [_cityNameAry insertObject:_cityLabel.text atIndex:0];
            [_areaNameAry insertObject:_areaLabel.text atIndex:0];
        }else{
            [_proviceNameAry addObject:_proviceLabel.text];
            [_cityNameAry addObject:_cityLabel.text];
            [_areaNameAry addObject:_areaLabel.text];
        }
    
        if (_proviceNameAry.count>5) {
             [_proviceNameAry removeObjectAtIndex:5];
             [_cityNameAry removeObjectAtIndex:5];
             [_areaNameAry removeObjectAtIndex:5];
        }
        
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:_proviceNameAry,@"provice",_cityNameAry,@"city",_areaNameAry,@"area",nil];
        
        
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        [dataDic setObject:dic1 forKey:@"搜索记录"];
        [dataDic writeToFile:_filename atomically:YES];
        
        if ([self.intere isEqualToString:@"1"]) {
            InterestedsearchViewController * intereVC = [[InterestedsearchViewController alloc]init];
            intereVC.provice =_proviceLabel.text;
            intereVC.city =_cityLabel.text;
            intereVC.area =_areaLabel.text;
            intereVC.strId = self.strId;
            [self.navigationController pushViewController:intereVC animated:YES];
        }else if ([self.intere isEqualToString:@"2"]){
            InterestedsearchViewController * intereVC = [[InterestedsearchViewController alloc]init];
            intereVC.provice =_proviceLabel.text;
            intereVC.city =_cityLabel.text;
            intereVC.area =_areaLabel.text;
            intereVC.strId = self.strId;
            intereVC.TCVC =@"1";
            [self.navigationController pushViewController:intereVC animated:YES];
        }else{
            OneDateViewController *OneDate = [[OneDateViewController alloc]init];
            OneDate.provice =_proviceLabel.text;
            OneDate.city =_cityLabel.text;
            OneDate.area =_areaLabel.text;
            OneDate.strId = self.strId;
            [self.navigationController pushViewController:OneDate animated:YES];
        }
        
        
    }
    
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)worshipSearchUI{
    NSString* phoneModel = [UIDevice devicePlatForm];
    
    _proviceLabel = [[UILabel alloc]init];
    _proviceLabel.backgroundColor = [UIColor whiteColor];
    _proviceLabel.font = [UIFont systemFontOfSize:14];
    _proviceLabel.text = @"省";
    _proviceLabel.adjustsFontSizeToFitWidth = YES;
    _proviceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_proviceLabel];
    
    _cityLabel = [[UILabel alloc]init];
     _cityLabel.backgroundColor = [UIColor whiteColor];
    _cityLabel.font = [UIFont systemFontOfSize:14];
    _cityLabel.text = @"市";
    _cityLabel.adjustsFontSizeToFitWidth = YES;
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_cityLabel];
    
    _areaLabel = [[UILabel alloc]init];
     _areaLabel.backgroundColor = [UIColor whiteColor];
    _areaLabel.text = @"区";
    _areaLabel.font = [UIFont systemFontOfSize:14];
    _areaLabel.adjustsFontSizeToFitWidth = YES;
    _areaLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_areaLabel];
    
    YZPPickView *pickView = [[YZPPickView alloc] init];
    pickView.delegate = self;
    pickView.hasDefaul = YES;
    [self.view addSubview:pickView];
    
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        _proviceLabel.frame = CGRectMake(0, 88, self.view.frame.size.width/3, 30);
        _cityLabel.frame = CGRectMake(self.view.frame.size.width/3, 88, self.view.frame.size.width/3, 30);
        _areaLabel.frame = CGRectMake((self.view.frame.size.width/3)*2, 88, self.view.frame.size.width/3, 30);
        pickView.frame = CGRectMake(0, 128, self.view.frame.size.width, 200);
        
    }else{
        _proviceLabel.frame = CGRectMake(0, 64, self.view.frame.size.width/3, 30);
        _cityLabel.frame = CGRectMake(self.view.frame.size.width/3, 64, self.view.frame.size.width/3, 30);
        _areaLabel.frame = CGRectMake((self.view.frame.size.width/3)*2, 64, self.view.frame.size.width/3, 30);
        pickView.frame = CGRectMake(0, 94, [UIScreen mainScreen].bounds.size.width, 200);
    }
    
    UILabel *ssjlLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, pickView.bottom+10, [UIScreen mainScreen].bounds.size.width, 30)];
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
    
    if ([self.intere isEqualToString:@"1"]) {
        InterestedsearchViewController * intereVC = [[InterestedsearchViewController alloc]init];
        intereVC.provice =_proviceLabel.text;
        intereVC.city =_cityLabel.text;
        intereVC.area =_areaLabel.text;
        intereVC.strId = self.strId;
        [self.navigationController pushViewController:intereVC animated:YES];
    }else{
        OneDateViewController *OneDate = [[OneDateViewController alloc]init];
        OneDate.provice =_proviceLabel.text;
        OneDate.city =_cityLabel.text;
        OneDate.area =_areaLabel.text;
        OneDate.strId = self.strId;
        [self.navigationController pushViewController:OneDate animated:YES];
    }

    
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
@end
