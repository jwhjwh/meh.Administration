//
//  activity.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "activity.h"
#import "WJTextView.h"
@interface activity ()<UITextFieldDelegate>
@property (nonatomic,strong) WJTextView *textView;
@end

@implementation activity

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动概要";
    self.view.backgroundColor = GetColor(237, 237, 237, 1);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    if ([_shopname  isEqualToString:@"1"]) {
        
    }else{
        if (self.modifi ==YES) {
            UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction)];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
            [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = rightitem;
        }else{
            UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(bjandrightItemAction:)];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
            
            [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = rightitem;
        }
    }
    
    [self UI];
}
-(void)UI{
    UILabel *toplabel = [[UILabel alloc]init];
    NSString* phoneModel = [UIDevice devicePlatForm];
    toplabel.text = @"公司近年来举办的大型活动简介,取得的成效及影响等简要说明概括方便于对该店各年经营状况的对比,分析,总结";
    toplabel.textColor = [UIColor lightGrayColor];
    toplabel.font = [UIFont systemFontOfSize:13];
    toplabel.numberOfLines = 0;
    [self.view addSubview:toplabel];
    
    _textView = [[WJTextView alloc]init];
    // 设置颜色
    _textView.backgroundColor = [UIColor whiteColor];
    // 设置提示文字
   
        _textView.placehoder = @"填写活动概要";
    
    
    if (self.dateStr.length>0) {
        _textView.text = self.dateStr;
    }
    // 设置提示文字颜色
    _textView.placehoderColor = [UIColor colorWithRed:(188/255.0) green:(176/255.0) blue:(195/255.0) alpha:1];
    // 设置textView的字体
    _textView.font = [UIFont systemFontOfSize:15];
    // 设置内容是否有弹簧效果
    _textView.alwaysBounceVertical = YES;
    // 设置textView的高度根据文字自动适应变宽
    _textView.isAutoHeight = YES;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius =  0.0;
    _textView.editable=self.modifi;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        toplabel.frame = CGRectMake(10, 88, self.view.bounds.size.width-20, 50);
        _textView.frame = CGRectMake(10, 160, self.view.bounds.size.width-20, 180);
    }else{
        toplabel.frame = CGRectMake(10, 64, self.view.bounds.size.width-20, 50);
        _textView.frame = CGRectMake(10, 140, self.view.bounds.size.width-20, 180);
    }
    
    
    [self.view addSubview:_textView];
    
}
-(void)bjandrightItemAction:(UIBarButtonItem *)btnnnn{
    NSString *strbtn = [NSString stringWithFormat:@"%@",btnnnn.title];
    if ([strbtn isEqualToString:@"编辑"]) {
        _textView.editable = YES;
        btnnnn.title = @"完成";
    }else{
        NSString *uStr =[NSString stringWithFormat:@"%@shop/updateSummarys.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.StoreId,@"SummaryTypeid":self.SummaryTypeid,@"Summarys":_textView.text,@"Summaryid":self.Summaryid,@"RoleId":self.strId};
        [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"上传成功" sureBtn:@"确认" cancleBtn:nil];
                alertView.resultIndex = ^(NSInteger index){
                    btnnnn.title = @"编辑";
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
            }
            
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
    }
    
    
}
-(void)rightItemAction{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/insertSummary.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"StoreId":self.StoreId,@"SummaryTypeid":self.SummaryTypeid,@"Summarys":_textView.text};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"上传成功" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
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
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
