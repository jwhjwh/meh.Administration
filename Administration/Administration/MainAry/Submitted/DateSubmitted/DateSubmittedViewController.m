//
//  DateSubmittedViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DateSubmittedViewController.h"

@interface DateSubmittedViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)  UIScrollView *dateScroll;
@property (strong, nonatomic)  UIImageView *dateImage;//图片
@property (strong, nonatomic)      UILabel *dayLabel;//时间
@property (strong, nonatomic)      UILabel *placeLabel;//地点
@property (strong, nonatomic)      UILabel *thingsLabel;//做的事情
@property (strong, nonatomic)      UILabel *progressLabel;//进展程度
@property (strong,nonatomic) NSString *lableStr;
@property (strong,nonatomic) NSString *daysTR;
@property (strong,nonatomic) NSString *IMAGESTR;
@end

@implementation DateSubmittedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"报岗详情";
    [self datenetworking];
    self.view.backgroundColor = [UIColor whiteColor];
   
}

-(void)dateViewUi{
    _dateScroll = [[UIScrollView alloc]init];
    _dateScroll.delegate = self;
    _dateScroll.backgroundColor = [UIColor whiteColor];
    
    _dateScroll.contentSize = CGSizeMake(self.view.frame.size.width,self.view.bounds.size.height*2);
    [self.view addSubview:_dateScroll];
    [_dateScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));;
    }];
    
    //详情图片
    _dateImage = [[UIImageView alloc]init];
    [_dateImage sd_setImageWithURL:[NSURL URLWithString:_IMAGESTR]placeholderImage:[UIImage imageNamed:@"ph_mt"]];
    [_dateScroll addSubview:_dateImage];
    [_dateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (_dateScroll.mas_top).offset(5);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(@240);
    }];
    //时间
    UILabel *sjLabel = [[UILabel alloc]init];
    sjLabel.text = @"时间:";
    sjLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [_dateScroll addSubview:sjLabel];
    [sjLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateImage.mas_bottom).offset(30);
        make.left.equalTo(_dateScroll.mas_left).offset(10);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@21);
    }];
    _dayLabel = [[UILabel alloc]init];
    _dayLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _dayLabel.text = _daysTR;
    [_dateScroll addSubview:_dayLabel];
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sjLabel.mas_top).offset(0);
        make.left.equalTo(sjLabel.mas_right).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(@21);
    }];
    UIView *xView = [[UIView alloc]init];
    xView.backgroundColor = GetColor(188, 176, 195, 1);
    [_dateScroll addSubview:xView];
    [xView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sjLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(@2);
    }];
    //地点
    UILabel *ddLabel = [[UILabel alloc]init];
    ddLabel.text = @"地点:";
    ddLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    
    [_dateScroll addSubview:ddLabel];
    [ddLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xView.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@21);
    }];
    _placeLabel = [[UILabel alloc]init];
    _placeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _placeLabel.numberOfLines = 0;
    [_dateScroll addSubview:_placeLabel];
    [_placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ddLabel.mas_top).offset(0);
        make.left.equalTo(ddLabel.mas_right).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(@21);
    }];
    [_placeLabel sizeToFit];
    
    UIView *xView1 = [[UIView alloc]init];
    xView1.backgroundColor = GetColor(188, 176, 195, 1);
    [_dateScroll addSubview:xView1];
    [xView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_placeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(@2);
    }];
    //做的事情
    UILabel *zdLabel = [[UILabel alloc]init];
    zdLabel.text = @"做的事情:";
    zdLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    
    [_dateScroll addSubview:zdLabel];
    [zdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xView1.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@21);
    }];
    _thingsLabel = [[UILabel alloc]init];
    _thingsLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _thingsLabel.numberOfLines = 0;
    _thingsLabel.text  = _lableStr;
    
    [_dateScroll addSubview:_thingsLabel];
    if (_lableStr == nil||[_lableStr isEqualToString:@""]) {
        [_thingsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(zdLabel.mas_top).offset(0);
            make.left.mas_equalTo(zdLabel.mas_right).offset(10);
            make.width.mas_equalTo(self.view.mas_width).offset(-110);
            make.height.mas_equalTo(@21);
        }];
        
    }else{
        [_thingsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(zdLabel.mas_top).offset(0);
            make.left.mas_equalTo(zdLabel.mas_right).offset(10);
            make.width.mas_equalTo(self.view.mas_width).offset(-110);
            
        }];

    }
        [_thingsLabel sizeToFit];
    
    UIView *xView2 = [[UIView alloc]init];
    xView2.backgroundColor = GetColor(188, 176, 195, 1);
    [_dateScroll addSubview:xView2];
    [xView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thingsLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(@2);
    }];
    //进展程度
    UILabel *jzLabel = [[UILabel alloc]init];
    jzLabel.text = @"进展程度:";
    jzLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [_dateScroll addSubview:jzLabel];
    [jzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xView2.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@21);
    }];
    _progressLabel = [[UILabel alloc]init];
    _progressLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _progressLabel.numberOfLines = 0;
    [_dateScroll addSubview:_progressLabel];
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jzLabel.mas_top).offset(0);
        make.left.equalTo(jzLabel.mas_right).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(@21);
    }];
    [_progressLabel sizeToFit];
    
    UIView *xView3 = [[UIView alloc]init];
    xView3.backgroundColor = GetColor(188, 176, 195, 1);
    [_dateScroll addSubview:xView3];
    [xView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(@2);
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)datenetworking{
    
    NSString *urlStr =[NSString stringWithFormat:@"%@picreport/getPicById.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"pid":_contentid};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSDictionary *loadDic = responseObject[@"picReport"];
            _IMAGESTR = [NSString stringWithFormat:@"%@%@",KURLHeader,loadDic[@"picture"]];
            NSString *Loadtime = loadDic[@"dateTimes"];
            Loadtime = [Loadtime substringToIndex:16];
            _daysTR = Loadtime;
            _lableStr = loadDic[@"describe"];
             [self dateViewUi];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
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
