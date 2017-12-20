//
//  VCSetShopArea.m
//  Administration
//
//  Created by zhang on 2017/12/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCSetShopArea.h"
#import "YZPPickView.h"
@interface VCSetShopArea ()<YZPPickViewDelegate>
@property (nonatomic,weak)YZPPickView *pickView;
@property (nonatomic,strong)NSArray *arrayProvince;
@property (nonatomic,strong)NSArray *arrayCity;
@property (nonatomic,strong)NSArray *arrayCountry;
@end

@implementation VCSetShopArea

#pragma -mark custem

-(void)setUI
{
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightItem)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [right setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = right;
    
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, kTopHeight, Scree_width, 44)];
    label.text = @"请选择省市区（县）";
    [self.view addSubview:label];
    
    YZPPickView *pickView = [[YZPPickView alloc]initWithFrame:CGRectMake(0, kTopHeight+44, Scree_width, 100)];
    pickView.delegate = self;
    [self.view addSubview:pickView];
    self.pickView = pickView;
}

-(void)rightItem
{
    [ShareModel shareModel].stringProvince = @"北京市";
    [ShareModel shareModel].stringCity = @"北京市";
    [ShareModel shareModel].stringCountry = @"东城区";
    
    if ([[ShareModel shareModel].stringArea isEqualToString:@"选择区域"]) {
        [ShareModel shareModel].stringArea = @"北京市 北京市 东城区";
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma -mark pickView

-(void)didSelectPickView:(Provice *)provice city:(City *)city area:(Area *)area
{
    [ShareModel shareModel].stringProvince = provice.name;
    [ShareModel shareModel].stringCity = city.name;
    [ShareModel shareModel].stringCountry = area.name;
    [ShareModel shareModel].stringArea = [NSString stringWithFormat:@"%@ %@ %@",provice.name,city.name,area.name];
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"所在区域";
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
