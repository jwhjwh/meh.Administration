//
//  ViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@interface ViewController ()<UITextFieldDelegate>
@property (strong,nonatomic) UITextField *PassText;//密码
@property (strong,nonatomic) UITextField *valiText;//识别码
@property (strong,nonatomic) UIImageView *HeadView;//头像
@property (strong,nonatomic) UIImageView *rentouView;//人头图片
@property (strong,nonatomic) UIImageView *suoziView;//🔒图片
@property (strong,nonatomic) UIImageView *shibieView;//识别码图片
@property (strong,nonatomic) UIView *view1;//第一条线
@property (strong,nonatomic) UIView *view2;//第二条线
@property (strong,nonatomic) UIView *view3;//第三条线
@property (strong,nonatomic) UIButton *logBtn;//登陆按钮

@property (strong,nonatomic) MainViewController *Main;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = [UIColor redColor];
//

    
    UIImageView *customBackgournd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj01"]];
   
 
    [self.view addSubview:customBackgournd];
    [customBackgournd  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
//    NSString * token = [USER_DEFAULTS valueForKey:@"token"];
//    NSString *urlStr =[NSString stringWithFormat:@"%@/Goods/getGoodsLack",KURLHeader];
//    NSDictionary *info=@{@"token":token};
//    
//    NSString *string =[ZXDNetworking encryptStringWithMD5:token];
//    NSDictionary *dict=@{@"params":string};
//     [[ZXDNetworking shareManager]POST:urlStr parameters:dict success:^(id responseObject) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
