//
//  DateSubmittedViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DateSubmittedViewController.h"

@interface DateSubmittedViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
//服务器获取数据源
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *dataLabel;
@property (nonatomic,strong) NSMutableArray *ligdataLabel;

@property (strong, nonatomic)  UIImageView *dateImage;//图片

@property (nonatomic,strong) NSString *IMAGESTR;//图片地址

@property (nonatomic,strong) NSString *pusersid;

@end

@implementation DateSubmittedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"报岗详情";
    [self datenetworking];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataLabel =[NSMutableArray arrayWithObjects:@"时间",@"地点",@"事务概述",@"进展程度", nil];
    self.ligdataLabel =[NSMutableArray arrayWithObjects:@"选择时间",@"填写地点",@"填写事务概述",@"填写进展程度", nil];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)delemissClick{
    NSString *urlStr =[NSString stringWithFormat:@"%@picreport/deletePicReport.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"pid":_contentid,@"pusersid":_pusersid};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"删除成功" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                NSString *str= [[NSString alloc]init];
                str = @"1";
                self.datesubString(str);
                [self.navigationController popViewControllerAnimated:YES];
            
            };
            [alertView showMKPAlertView];

        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"0003"]){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除失败，没有删除权限" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除失败" andInterval:1.0];
        }

    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];

}
-(void)dateViewUi{
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.view.mas_top).offset(70);
        make.left.equalTo (self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    NSString *usersid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS  objectForKey:@"userid"]];
    
    if ([usersid isEqualToString:_pusersid]) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                        initWithTitle:@"删除"
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(delemissClick)];
        rightButton.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    
    
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        
        _dateImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, self.view.bounds.size.height-(50*4)-64-80)];
        [_dateImage sd_setImageWithURL:[NSURL URLWithString:_IMAGESTR]placeholderImage:[UIImage imageNamed:@"ph_mt"]];
        

        [cell addSubview:_dateImage];
    }else{
        cell.textLabel.text = _dataLabel[indexPath.row-1];
        cell.textLabel.textColor = [UIColor blackColor];
        NSString * labelStr = _dataArray[indexPath.row-1];
        
        CGSize labelSize = {0, 0};
        
        labelSize = [labelStr sizeWithFont:[UIFont systemFontOfSize:14]
                         constrainedToSize:CGSizeMake(self.view.bounds.size.width-130, 5000)
                             lineBreakMode:UILineBreakModeWordWrap];
        
       
        
        UILabel* NRtextLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 15, self.view.bounds.size.width-130, labelSize.height)];
        
        NRtextLabel.text =_dataArray[indexPath.row-1];
        NRtextLabel.font = [UIFont systemFontOfSize:14.0f];
        NRtextLabel.textColor = [UIColor blackColor];
       // NRtextLabel.textAlignment = NSTextAlignmentCenter;
        NRtextLabel.numberOfLines = 0;
        
        [cell addSubview:NRtextLabel];
    }
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return  self.view.bounds.size.height-(50*4)-64-80+20;
    }else{
        NSString * labelStr = _dataArray[indexPath.row-1];
        
        CGSize labelSize = {0, 0};
        
        labelSize = [labelStr sizeWithFont:[UIFont systemFontOfSize:14]
                     
                         constrainedToSize:CGSizeMake(self.view.bounds.size.width-130, 5000)
                             lineBreakMode:UILineBreakModeWordWrap];
        if (labelSize.height>50) {
            return labelSize.height+10;
        }else{
            return 50;
        }
    }
}

-(void)datenetworking{
    
    NSString *urlStr =[NSString stringWithFormat:@"%@picreport/getPicById.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"pid":_contentid};
    _dataArray = [[NSMutableArray alloc]init];
    _pusersid = [[NSString alloc]init];
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSDictionary *loadDic = responseObject[@"picReport"];
            _IMAGESTR = [NSString stringWithFormat:@"%@%@",KURLHeader,loadDic[@"picture"]];
            NSString *Loadtime = loadDic[@"dateTimes"];
            Loadtime = [Loadtime substringToIndex:10];
            [_dataArray addObject:Loadtime];
            [_dataArray addObject:loadDic[@"locations"]];
            [_dataArray addObject:loadDic[@"describe"]];
            [_dataArray addObject:loadDic[@"progress"]];
            _pusersid = loadDic[@"usersId"];
            [self dateViewUi];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


@end
