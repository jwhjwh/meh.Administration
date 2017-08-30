//
//  SiginViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/8/30.
//  Copyright © 2017年 九尾狐. All rights reserved.
//  陌拜--签到

#import "SiginViewController.h"

@interface SiginViewController ()

@end

@implementation SiginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"签到";
    self.view.backgroundColor = [UIColor whiteColor];
    [self intdata];
}
-(void)tableViewUI{

    
}

//请求数据
-(void)intdata{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectSign.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
   NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"CompanyInfoId":companyinfoid};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}
-(void)updateSigin{

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
