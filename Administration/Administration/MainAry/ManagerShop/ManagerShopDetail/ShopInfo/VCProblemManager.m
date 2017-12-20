//
//  VCProblem.m
//  Administration
//
//  Created by zhang on 2017/12/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCProblemManager.h"

@interface VCProblemManager ()<UITextViewDelegate>
@property (nonatomic,weak)UITextView *textView;
@end

@implementation VCProblemManager

-(void)rightDone
{
    [ShareModel shareModel].jingying = self.textView.text;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [ShareModel shareModel].jingying = @"";
    
    self.view.backgroundColor = GetColor(222, 222, 222, 1);
    
    CGSize size = [self.Content boundingRectWithSize:CGSizeMake(Scree_width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(15, kTopHeight+20, Scree_width-30, 50)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.font  =[UIFont systemFontOfSize:17];
    textView.text = self.Content;
    textView.delegate = self;
    textView.scrollEnabled = NO;
    [self.view addSubview:textView];
    self.textView = textView;
    
    if (size.height<50) {
        size.height = 50;
    }else
    {
        size.height = size.height;
    }
    
    textView.frame = CGRectMake(15, kTopHeight+20, Scree_width-30, size.height);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightDone)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    
    if ([ShareModel shareModel].showRightItem) {
        self.navigationItem.rightBarButtonItem = rightItem;
        textView.userInteractionEnabled = YES;
    }else
    {
        textView.userInteractionEnabled = NO;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    if (size.height<50) {
        size.height = 50;
    }else
    {
        size.height = size.height;
    }
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, size.height+20);
    
    switch ([self.state intValue]) {
        case 1:
            [ShareModel shareModel].wenti = textView.text;
            break;
        case 2:
            [ShareModel shareModel].chaodao = textView.text;
            break;
        case 3:
            [ShareModel shareModel].jingying = textView.text;
            break;
        case 4:
            [ShareModel shareModel].tuoke = textView.text;
            break;
            
        default:
            break;
    }
    
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
