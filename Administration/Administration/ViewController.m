//
//  ViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    NSString * token = [USER_DEFAULTS valueForKey:@"token"];
    NSString *urlStr =[NSString stringWithFormat:@"%@/Goods/getGoodsLack",KURLHeader];
    NSDictionary *info=@{@"token":token};
    
    NSString *string =[ZXDNetworking encryptStringWithMD5:token];
    NSDictionary *dict=@{@"params":string};
     [[ZXDNetworking shareManager]POST:urlStr parameters:dict success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"dsfsdfds");
    //asfhioenmtsdhoig

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
