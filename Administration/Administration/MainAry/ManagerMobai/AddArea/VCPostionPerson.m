//
//  VCPostionPerson.m
//  Administration
//
//  Created by zhang on 2017/11/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCPostionPerson.h"

@interface VCPostionPerson ()

@end

@implementation VCPostionPerson

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/selelctDRusers.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":self.postionID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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