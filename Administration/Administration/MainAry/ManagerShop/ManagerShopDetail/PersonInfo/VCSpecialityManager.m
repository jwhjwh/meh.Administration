//
//  VCSpeciality.m
//  Administration
//
//  Created by zhang on 2017/12/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCSpecialityManager.h"

@interface VCSpecialityManager ()<UITextViewDelegate>
@property (nonatomic,weak)UITextView *textView;
@end

@implementation VCSpecialityManager
#pragma -mark custem
-(void)setUI
{
    [ShareModel shareModel].dianping = @"";
    self.title = self.stringTitle;
    
    self.view.backgroundColor = GetColor(234, 235, 236, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGSize size = [self.content boundingRectWithSize:CGSizeMake(Scree_width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    if (size.height<50) {
        size.height=50;
    }else
    {
        size.height = size.height;
    }
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, kTopHeight+10, Scree_width-20, size.height)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.text = self.content;
    textView.font = [UIFont systemFontOfSize:17];
    textView.scrollEnabled = NO;
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightItem)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [right setTitleTextAttributes:dict forState:UIControlStateNormal];
    if ([ShareModel shareModel].showRightItem) {
       self.navigationItem.rightBarButtonItem = right; 
    }
    
}

-(void)rightItem
{
    switch ([self.state intValue]) {
        case 1:
            [ShareModel shareModel].jiankeng = self.textView.text;
            break;
        case 2:
            [ShareModel shareModel].zaizuo = self.textView.text;
            break;
        case 3:
            [ShareModel shareModel].teshu = self.textView.text;
            break;
        case 4:
            [ShareModel shareModel].xiaofei = self.textView.text;
            break;
        case 5:
            [ShareModel shareModel].techang = self.textView.text;
            break;
        case 6:
            [ShareModel shareModel].pingpan = self.textView.text;
            break;
        case 7:
            [ShareModel shareModel].dianping = self.textView.text;
            break;
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark textView
-(void)textViewDidChange:(UITextView *)textView
{
    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(Scree_width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    if (size.height<50) {
        size.height=50;
    }else
    {
        size.height = size.height;
    }
    textView.frame = CGRectMake(10, kTopHeight+10, Scree_width-20, size.height);
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
