//
//  VCShopAddress.m
//  Administration
//
//  Created by zhang on 2017/12/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCShopAddress.h"
#import "UIPlaceHolderTextView.h"
#import "VCSetShopArea.h"
@interface VCShopAddress ()<UITextViewDelegate>
@property (nonatomic,weak)UIPlaceHolderTextView *textView;
@property (nonatomic,weak)UIButton *button;
@end

@implementation VCShopAddress

#pragma -mark custem

-(void)setUI
{
    self.view.backgroundColor = GetColor(222, 223, 224, 1);
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightItem)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [right setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, kTopHeight,Scree_width, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitle:[ShareModel shareModel].stringArea forState:UIControlStateNormal];
    [button setTitleColor:GetColor(222, 223, 225, 1) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(chooseArea) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.button = button;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(Scree_width-30, 10, 15, 15)];
    imageView.image = [UIImage imageNamed:@"jiantou_03"];
    [button addSubview:imageView];
    
    UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(0, kTopHeight+44, Scree_width, 44)];
    textView.placeholder = @"详细地址";
    textView.scrollEnabled =  NO;
    textView.font = [UIFont systemFontOfSize:17];
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    
}

-(void)chooseArea
{
    VCSetShopArea *vc = [[VCSetShopArea alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)rightItem
{
    [ShareModel shareModel].addressDetil = self.textView.text;
    
    if ([[ShareModel shareModel].stringArea isEqualToString:@""]) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择区域" andInterval:1.0];
        return;
    }else
    {
         [self.navigationController popViewControllerAnimated:YES];
        [ShareModel shareModel].addressDetil = self.textView.text;
    }
}

#pragma -mark textView
-(void)textViewDidChange:(UITextView *)textView
{
    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(Scree_width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, Scree_width, size.height+23);
}

#pragma -mark system
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
    [self.button setTitle:[ShareModel shareModel].stringArea forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"门店地址";
    [ShareModel shareModel].stringArea = @"选择区域";
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
