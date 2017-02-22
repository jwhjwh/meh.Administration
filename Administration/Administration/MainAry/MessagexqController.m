//
//  MessagexqController.m
//  Administration
//
//  Created by zhang on 2017/2/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "MessagexqController.h"

@interface MessagexqController ()

@end

@implementation MessagexqController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title =@"待批注";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    UIButton *rightn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightn.frame =CGRectMake(0, 0,35,28);
    [rightn setTitle:@"审核" forState: UIControlStateNormal ];
    [rightn addTarget: self action: @selector(butrightItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *rightnItem=[[UIBarButtonItem alloc]initWithCustomView:rightn];
    self.navigationItem.rightBarButtonItem=rightnItem;
    
    
    NSString *urlStr =[NSString stringWithFormat:@"%@manager/bqueryallinfo.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"code":_codeStr,@"Sort":_sortStr,@"flag":_flagStr,@"id":_IdStr,@"remark":_remarkStr};
    NSLog(@"++==%@",info);
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
//        self.dataArray = [NSMutableArray array];
//        NSArray *array=[responseObject valueForKey:@"Sums"];
//        for (NSDictionary *dic in array) {
//            mesgeModel *model=[[mesgeModel alloc]init];
//            [model setValuesForKeysWithDictionary:dic];
//            [self.dataArray addObject:model];
//        }
        
//        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)butrightItem{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
