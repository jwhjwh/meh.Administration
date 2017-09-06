//
//  SiginViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/8/30.
//  Copyright © 2017年 九尾狐. All rights reserved.
//  陌拜--签到

#import "SiginViewController.h"

@interface SiginViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
}
@property (nonatomic,retain)UITableView *infonTableview;
@property (nonatomic,strong)NSMutableArray *SigRecord;

@property (nonatomic,strong)NSString *MoodDescribe;

//---alr
@property (nonatomic,strong)UILabel *backlabel;
@property (nonatomic,strong)UIView* boomview;



@property (nonatomic,strong)NSMutableArray *dizhiAry;
@property (nonatomic,strong)NSMutableArray *sjAry;
@property (nonatomic,strong)NSMutableArray *xqAry;

@property (nonatomic,strong)UILabel *dizhilabel;
@property (nonatomic,strong)UILabel *shijianlabel;
@property (nonatomic,strong)UILabel *xqmslabel;

@end

@implementation SiginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"签到";
    self.view.backgroundColor = GetColor(237, 237, 237, 1);
    NSLog(@"shopid:%@ address:%@",self.shopid,self.Address);
    [self intdata];
    [self tableViewUI];
    _MoodDescribe = [[NSString alloc]init];
}
-(void)tableViewUI{
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.mas_offset(180);
    }];
    UIButton *SiginBtn = [[UIButton alloc]init];
    [SiginBtn setTitle:@"签 到\n11:25" forState:UIControlStateNormal];
    SiginBtn.titleLabel.numberOfLines = 2;
    SiginBtn.titleLabel.textAlignment =NSTextAlignmentCenter;
    SiginBtn.backgroundColor = GetColor(23, 137, 251, 1);
    SiginBtn.layer.masksToBounds = YES;
    SiginBtn.layer.cornerRadius = 50.0;//设置圆角
    [SiginBtn addTarget:self action:@selector(SigsingBtn:)forControlEvents: UIControlEventTouchUpInside];
    [topView addSubview:SiginBtn];
    [SiginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topView.mas_centerX);
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.width.mas_offset(100);
        make.height.mas_offset(100);
    }];
    UIImageView *sigimage = [[UIImageView alloc]init];
    sigimage.image = [UIImage imageNamed:@"qdjl_ico"];
    [self.view addSubview:sigimage];
    [sigimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.height.mas_offset(25);
        make.width.mas_offset(25);
    }];
    UILabel *singlabel = [[UILabel alloc]init];
    singlabel.text = @"签到记录";
    singlabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:singlabel];
    [singlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(10);
        make.left.mas_equalTo(sigimage.mas_right).offset(10);
        make.height.mas_offset(25);
        make.width.mas_offset(100);
    }];
    infonTableview= [[UITableView alloc]init];
    infonTableview.backgroundColor = GetColor(237, 237, 237, 1);
     infonTableview.separatorStyle= UITableViewCellSeparatorStyleNone;//没有分割线
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    
    [infonTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(singlabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
}
-(void)SigsingBtn:(UIButton *)btn{
    _boomview = [[UIView alloc]init];
    _boomview.backgroundColor = GetColor(127, 127, 127, 0.5);
    [self.view addSubview:_boomview];
    [_boomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    UIView *singView = [[UIView alloc]init];
    singView.backgroundColor = [UIColor whiteColor];
    singView.layer.masksToBounds = YES;
    singView.layer.cornerRadius = 5.0;//设置圆角
    [_boomview addSubview:singView];
    [singView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_boomview.mas_left).offset(35);
        make.right.mas_equalTo(_boomview.mas_right).offset(-35);
        make.top.mas_equalTo(_boomview.mas_top).offset(180);
        make.height.mas_equalTo(_boomview.mas_height).offset(-360);
    }];
    UIView *view3 = [[UIView alloc]init];
    view3.backgroundColor = [UIColor lightGrayColor];
    [singView addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(singView.mas_bottom).offset(0);
        make.height.mas_offset(40);
        make.width.mas_offset(1);
        make.centerX.mas_equalTo(singView.mas_centerX).offset(0);
    }];
    UIView *view4 = [[UIView alloc]init];
    view4.backgroundColor = [UIColor lightGrayColor];
    [singView addSubview:view4];
    [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(singView.mas_right).offset(0);
        make.left.mas_equalTo(singView.mas_left).offset(0);
        make.height.mas_offset(1);
        make.bottom.mas_equalTo(view3.mas_top).offset(0);
    }];
    
    UIButton *qxbtn = [[UIButton alloc]init];
    [qxbtn setTitle:@"取消" forState:UIControlStateNormal];
    [qxbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [qxbtn addTarget:self action:@selector(axorqdbtn:)forControlEvents: UIControlEventTouchUpInside];
    [singView addSubview:qxbtn];
    [qxbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(singView.mas_bottom).offset(0);
        make.left.mas_equalTo(singView.left).offset(0);
        make.top.mas_equalTo(view4.mas_bottom).offset(0);
        make.right.mas_equalTo(view3.mas_left).offset(0);
    }];
    UIButton *qdbtn = [[UIButton alloc]init];
    [qdbtn setTitle:@"确定" forState:UIControlStateNormal];
    [qdbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [qdbtn addTarget:self action:@selector(qdbtn:)forControlEvents: UIControlEventTouchUpInside];
    [singView addSubview:qdbtn];
    [qdbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(singView.mas_bottom).offset(0);
        make.left.mas_equalTo(view3.mas_right).offset(0);
        make.top.mas_equalTo(view4.mas_bottom).offset(0);
        make.right.mas_equalTo(singView.mas_right).offset(0);
    }];
    
    UIImageView *xlimage = [[UIImageView alloc]init];
    xlimage.image = [UIImage imageNamed:@"qd_ico"];
    [singView addSubview:xlimage];
    [xlimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(singView.mas_top).offset(10);
        make.left.mas_equalTo(singView.mas_left).offset(10);
        make.height.mas_offset(20);
        make.width.mas_offset(20);
    }];
    UILabel *singlabel =[[UILabel alloc]init];
    singlabel.text = @"签到";
    [singView addSubview:singlabel];
    [singlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(singView.mas_top).offset(5);
        make.centerX.mas_equalTo(singView.mas_centerX);
        make.height.mas_equalTo(30);
        make.width.mas_offset(50);
    }];
    UIView *xian1 = [[UIView alloc]init];
    xian1.backgroundColor = [UIColor lightGrayColor];
    [singView addSubview:xian1];
    [xian1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(singlabel.mas_bottom).offset(5);
        make.left.mas_equalTo(singView.mas_left);
        make.right.mas_equalTo(singView.mas_right);
        make.height.mas_offset(1);
    }];
    UIImageView *dwimage = [[UIImageView alloc]init];
    dwimage.image = [UIImage imageNamed:@"location_ico"];
    [singView addSubview:dwimage];
    [dwimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(xian1.mas_bottom).offset(5);
        make.left.mas_equalTo(singView.mas_left).offset(10);
        make.height.mas_offset(20);
        make.width.mas_offset(20);
    }];
    UILabel *dqwzlabel = [[UILabel alloc]init];
    dqwzlabel.numberOfLines = 0;
    NSString *_test  = [NSString stringWithFormat:@"当前位置:%@",self.Address];
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    //paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
    CGFloat emptylen = dqwzlabel.font.pointSize * 2;
    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_test attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    CGSize sizee = [_test sizeWithFont: [UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(singView.width-20,120)];
    dqwzlabel.attributedText = attrText;
    dqwzlabel.textColor =GetColor(150, 150, 150, 1);
    [singView addSubview:dqwzlabel];
    [dqwzlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(xian1.mas_bottom).offset(5);
        make.left.mas_equalTo(singView.mas_left).offset(10);
        make.right.mas_equalTo(singView.mas_right).offset(-10);
        make.width.mas_offset(sizee.height);
    }];
    UIView *xian2 = [[UIView alloc]init];
    xian2.backgroundColor= GetColor(238, 238, 238, 0.5);
    [singView addSubview:xian2];
    [xian2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(dqwzlabel.mas_bottom).offset(5);
        make.left.mas_equalTo(singView.mas_left);
        make.right.mas_equalTo(singView.mas_right);
        make.height.mas_offset(15);
    }];
    UILabel *qdsjlabel = [[UILabel alloc]init];
    qdsjlabel.text = [NSString stringWithFormat:@"签到时间: 11:25"];
    qdsjlabel.textColor = GetColor(150, 150, 150, 1);
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:qdsjlabel.text];
    // 需要改变的第一个文字的位置
    NSUInteger firstLoc = [[noteStr string] rangeOfString:@"签"].location;
    // 需要改变的最后一个文字的位置
    NSUInteger secondLoc = [[noteStr string] rangeOfString:@" "].location;
    // 需要改变的区间
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    // 改变颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    // 为label添加Attributed
    [qdsjlabel setAttributedText:noteStr];
    [singView addSubview:qdsjlabel];
    [qdsjlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(xian2.mas_bottom).offset(10);
        make.left.mas_equalTo(singView.mas_left).offset(15);
        make.right.mas_equalTo(singView.mas_right).offset(-10);
        make.height.mas_offset(30);
    }];
    
    UILabel *xqlabel = [[UILabel alloc]init];
    xqlabel.text = @"心情描述:";
    [singView addSubview:xqlabel];
    [xqlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(qdsjlabel.mas_bottom).offset(0);
        make.left.mas_equalTo(singView.mas_left).offset(15);
        make.width.mas_offset(80);
        make.height.mas_offset(30);
    }];
    UITextView *xqmstextView = [[UITextView alloc]init];
    xqmstextView.delegate = self;
    xqmstextView.font = [UIFont systemFontOfSize:15];
    xqmstextView.textColor = GetColor(160, 160, 160, 1);
    [singView addSubview:xqmstextView];
    [xqmstextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(qdsjlabel.mas_bottom).offset(0);
        make.left.mas_equalTo(xqlabel.mas_right).offset(10);
        make.right.mas_equalTo(singView.mas_right).offset(-10);
        make.bottom.mas_equalTo(view4.mas_top).offset(0);
    }];
    _backlabel = [[UILabel alloc]init];
    _backlabel.text = @"请填写心情描述";
    _backlabel.font = [UIFont systemFontOfSize:14];
    [xqmstextView addSubview:_backlabel];
    [_backlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(xqmstextView.mas_left).offset(2);
        make.top.mas_equalTo(xqmstextView.mas_top).offset(0);
        make.height.mas_offset(30);
        make.right.mas_equalTo(xqmstextView.mas_right).offset(0);
    }];
}
-(void)qdbtn:(UIButton *)btn{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/insertSign.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"Address":self.Address,@"ShopId":self.shopid,@"Types":self.Types,@"MoodDescribe":_MoodDescribe};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"签到成功" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [_boomview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [_boomview removeFromSuperview];
            };
            [alertView showMKPAlertView];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到更多品牌信息" andInterval:1.0];
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
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];

}
-(void)axorqdbtn:(UIButton *)btn{
    
        [_boomview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
         [_boomview removeFromSuperview];
    
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        _backlabel.hidden = YES;
        _MoodDescribe = textView.text;
    }else{
        _backlabel.hidden = NO;
        _MoodDescribe = @"";
        
    }
}
//请求数据
-(void)intdata{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectSign.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
   NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"ShopId":self.shopid,@"Types":self.Types};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *arr= [responseObject valueForKey:@"list"];
            _dizhiAry = [[NSMutableArray alloc]init];
            _sjAry = [[NSMutableArray alloc]init];
            _xqAry = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arr) {
                if ([dic valueForKey:@"address"] == nil) {
                    [_dizhiAry addObject:@""];
                }else{
                    [_dizhiAry  addObject:[dic valueForKey:@"address"]];
                }
                if ([dic valueForKey:@"dates"] == nil) {
                    [_sjAry addObject:@""];
                }else{
                [_sjAry  addObject:[dic valueForKey:@"dates"]];
                }
                if ([dic valueForKey:@"moodDescribe"] == nil) {
                    [_xqAry addObject:@""];
                }else{
                    [_xqAry  addObject:[dic valueForKey:@"moodDescribe"]];
                }
                
                
            
            }
            [infonTableview reloadData];
        }else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有签到记录" andInterval:1.0];
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
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"当前店铺没有签到记录" andInterval:1.0];
        }

        
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _sjAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return _dizhilabel.height+_shijianlabel.height+_xqmslabel.height+20;
    
    
    //return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *xiaolian = [[UIImageView alloc]init];
    xiaolian.image = [UIImage imageNamed:@"qd_ico"];
    [cell addSubview:xiaolian];
    [xiaolian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.mas_top).offset(2);
        make.left.mas_equalTo(cell.mas_left).offset(5);
        make.height.mas_offset(20);
        make.width.mas_offset(20);
    }];
    
    
   _dizhilabel = [[UILabel alloc]init];
    NSString *dizhitext = [NSString stringWithFormat:@"地址: %@",_dizhiAry[indexPath.row]];
    _dizhilabel.textColor = GetColor(150, 150, 150, 1);
    _dizhilabel.font = [UIFont systemFontOfSize:16];
    _dizhilabel.numberOfLines = 0;
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:dizhitext];
    // 需要改变的第一个文字的位置
    NSUInteger firstLoc = [[noteStr string] rangeOfString:@"地"].location;
    // 需要改变的最后一个文字的位置
    NSUInteger secondLoc = [[noteStr string] rangeOfString:@" "].location;
    // 需要改变的区间
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    // 改变颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    // 为label添加Attributed
    [_dizhilabel setAttributedText:noteStr];
    CGSize dizhimszee = [_dizhilabel.text sizeWithFont: [UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(cell.width-40,2000)];
    
    [cell addSubview:_dizhilabel];
    [_dizhilabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.mas_top).offset(5);
        make.left.mas_equalTo(xiaolian.mas_right).offset(5);
        make.right.mas_equalTo(cell.mas_right).offset(-10);
        make.height.mas_offset(dizhimszee.height);
    }];
    
    _shijianlabel= [[UILabel alloc]init];
    if (_sjAry[indexPath.row] == nil) {
        
    }else{
        NSString *sj = [[NSString alloc]initWithFormat:@"%@", [_sjAry[indexPath.row] substringWithRange:NSMakeRange(5, 11)]];
        _shijianlabel.text = [NSString stringWithFormat:@"时间: %@",sj];
    }
    
    _shijianlabel.textColor = GetColor(150, 150, 150, 1);
    _shijianlabel.font = [UIFont systemFontOfSize:16];
    NSMutableAttributedString *sjStr = [[NSMutableAttributedString alloc] initWithString:_shijianlabel.text];
    // 需要改变的第一个文字的位置
    NSUInteger qdsjlabelfirstLoc = [[sjStr string] rangeOfString:@"时"].location;
    // 需要改变的最后一个文字的位置
    NSUInteger qdsjlabelsecondLoc = [[sjStr string] rangeOfString:@" "].location;
    // 需要改变的区间
    NSRange qdsjlabelrange = NSMakeRange(qdsjlabelfirstLoc, qdsjlabelsecondLoc - qdsjlabelfirstLoc);
    // 改变颜色
    [sjStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:qdsjlabelrange];
    // 为label添加Attributed
    [_shijianlabel setAttributedText:sjStr];
    
    [cell addSubview:_shijianlabel];
    [_shijianlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_dizhilabel.mas_bottom).offset(5);
        make.left.mas_equalTo(xiaolian.mas_right).offset(5);
        make.right.mas_equalTo(cell.mas_right).offset(-10);
        make.height.mas_offset(35);
    }];
    
    _xqmslabel = [[UILabel alloc]init];
    NSString *labelstr = [NSString stringWithFormat:@"心情描述: %@",_xqAry[indexPath.row]];
    _xqmslabel.textColor = GetColor(150, 150, 150, 1);
    _xqmslabel.numberOfLines = 0;
    
    
    NSMutableAttributedString *xqmsStr = [[NSMutableAttributedString alloc] initWithString:labelstr];
    // 需要改变的第一个文字的位置
    NSUInteger xqmslabelfirstLoc = [[xqmsStr string] rangeOfString:@"心"].location;
    // 需要改变的最后一个文字的位置
    NSUInteger xqmslabelsecondLoc = [[xqmsStr string] rangeOfString:@" "].location;
    // 需要改变的区间
    NSRange xqmslabelrange = NSMakeRange(xqmslabelfirstLoc, xqmslabelsecondLoc - xqmslabelfirstLoc);
    // 改变颜色
    [xqmsStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:xqmslabelrange];
    // 为label添加Attributed
    [_xqmslabel setAttributedText:xqmsStr];
    CGSize xqmszee = [_xqmslabel.text sizeWithFont: [UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(cell.width-40,2000)];
    [cell addSubview:_xqmslabel];
    [_xqmslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shijianlabel.mas_bottom).offset(5);
        make.left.mas_equalTo(xiaolian.mas_right).offset(5);
        make.right.mas_equalTo(cell.mas_right).offset(-10);
        make.height.mas_offset(xqmszee.height);
    }];
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
