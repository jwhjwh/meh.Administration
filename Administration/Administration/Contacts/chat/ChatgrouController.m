//
//  ChatgrouController.m
//  Administration
//
//  Created by zhang on 2017/3/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ChatgrouController.h"
#import "GroupdetailController.h"
@interface ChatgrouController ()

@end

@implementation ChatgrouController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"工作交流";
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}
-(void)rightItem{
    GroupdetailController *groupdVC=[[GroupdetailController alloc]init];
    [self.navigationController pushViewController:groupdVC animated:YES];
}



@end
