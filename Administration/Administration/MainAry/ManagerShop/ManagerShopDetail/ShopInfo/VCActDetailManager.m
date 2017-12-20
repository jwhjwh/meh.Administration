//
//  VCActDetail.m
//  Administration
//
//  Created by zhang on 2017/12/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCActDetailManager.h"

@interface VCActDetailManager ()<UITextViewDelegate>
@property (nonatomic,weak)UITextView *textView;
@end

@implementation VCActDetailManager

#pragma -mark custem

-(void)setUI
{
    self.view.backgroundColor = GetColor(234, 235, 236, 1);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(submitData)];
    NSDictionary *dict =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    
    NSString *string = @"公司近年来举办的大型活动简介，取得的成效及影响等简要说明概括方便于对该店个年经营状况的对比、分析、总结";
    CGSize size = [string boundingRectWithSize:CGSizeMake(Scree_width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, kTopHeight, Scree_width-20, 30)];
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    label.text = string;
    [self.view addSubview:label];
    label.frame = CGRectMake(10, kTopHeight, Scree_width-20, size.height);
    
    CGSize size1 = [self.content boundingRectWithSize:CGSizeMake(Scree_width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    if (size1.height<50) {
        size1.height = 50;
    }else
    {
        size1.height = size1.height;
    }
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, label.frame.size.height+kTopHeight+10, Scree_width-20, size1.height)];
    textView.font = [UIFont systemFontOfSize:17];
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    textView.backgroundColor = [UIColor whiteColor];
    textView.text = self.content;
    textView.userInteractionEnabled = NO;
    [self.view addSubview:textView];
    
    if ([ShareModel shareModel].showRightItem) {
        self.navigationItem.rightBarButtonItem = rightItem;
        textView.userInteractionEnabled = YES;
    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.textView = textView;
}

-(void)submitData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/insertSummary.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    if (self.textView.text.length==0) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写内容" andInterval:1.0];
        return;
    }
    
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"StoreId":[ShareModel shareModel].shopID,
                           @"SummaryTypeid":self.actID,
                           @"Summarys":self.textView.text
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view  MBPro:YES];
}

-(void)textViewDidChange:(UITextView *)textView
{
    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    if (size.height<50) {
        size.height=50;
    }
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, size.height);
    
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动概要";
    
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
