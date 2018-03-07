//
//  VCSendMessage.m
//  Administration
//
//  Created by zhang on 2017/11/3.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCSendMessage.h"

@interface VCSendMessage ()

@end

@implementation VCSendMessage


-(void)setUI
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, kTopHeight, Scree_width, 21)];
    label.text = @"请选择送出祝福的方式";
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    
    CGPoint center = self.view.center;
    center.x = self.view.frame.size.width / 2;
    center.y = self.view.frame.size.height / 2;
    
    UIButton *buttonMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonMessage addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    buttonMessage.frame = CGRectMake(100, 150, 80, 90);
    
    [buttonMessage setImage:[UIImage imageNamed:@"dx_ico1"] forState:0];
    [buttonMessage setTitle:@"短信" forState:0];
    [buttonMessage setTitleColor:[UIColor lightGrayColor] forState:0];
    
    [buttonMessage setTitleEdgeInsets:UIEdgeInsetsMake(70, -buttonMessage.imageView.bounds.size.width-70, 5, 0)];
    [buttonMessage setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    
    buttonMessage.frame = CGRectMake(center.x-40, 100, 80, 90);

    [self.view addSubview:buttonMessage];
    
    
    UIButton *buttonChat = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonChat addTarget:self action:@selector(openWeChat) forControlEvents:UIControlEventTouchUpInside];
    buttonChat.frame = CGRectMake(100, 280, 80, 90);
    [buttonChat setImage:[UIImage imageNamed:@"wx_ico1"] forState:0];
    [buttonChat setTitle:@"微信" forState:0];
    [buttonChat setTitleColor:[UIColor lightGrayColor] forState:0];
    
    [buttonChat setTitleEdgeInsets:UIEdgeInsetsMake(70, -buttonChat.imageView.bounds.size.width-70, 5, 0)];
    [buttonChat setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    
    buttonChat.frame = CGRectMake(center.x-40, 230, 80, 90);
    
    [self.view addSubview:buttonChat];
    
}

-(void)sendMessage
{
    NSURL *url = [NSURL URLWithString:@"sms://"];
    
    [[UIApplication sharedApplication] openURL:url];
}

-(void)openWeChat
{
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url
    if (canOpen)
    {
        
        [[UIApplication sharedApplication] openURL:url];
    }else
    {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请安装微信" andInterval:1];
        return;
    }
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"送出祝福";
    [self setUI];
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
