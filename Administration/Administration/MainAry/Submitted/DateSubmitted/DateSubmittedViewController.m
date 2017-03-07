//
//  DateSubmittedViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DateSubmittedViewController.h"

@interface DateSubmittedViewController ()

@end

@implementation DateSubmittedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"报岗详情";
    [self dateViewUI];
}

-(void)dateViewUI{
    
    NSString *urlStr =[NSString stringWithFormat:@"%@picreport/getPicById.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"pid":_contentid};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSDictionary *loadDic = responseObject[@"picReport"];
            NSString *subimagestr = [NSString stringWithFormat:@"%@%@",KURLHeader,loadDic[@"picture"]];
           [_dateImage sd_setImageWithURL:[NSURL URLWithString:subimagestr]placeholderImage:[UIImage imageNamed:@"ph_mt"]];
            NSString *Loadtime = loadDic[@"dateTimes"];
            Loadtime = [Loadtime substringToIndex:16];
            _dayLabel.text = Loadtime;
            _thingsLabel.text = loadDic[@"describe"];
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
