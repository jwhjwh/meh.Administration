//
//  VCAddPersonSpeciality.m
//  Administration
//
//  Created by zhang on 2017/12/27.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCAddPersonSpeciality.h"
#define Start_X          80.0f      // 第一个按钮的X坐标
#define Start_Y          220.0f     // 第一个按钮的Y坐标
#define Width_Space      5.0f      // 2个按钮之间的横间距
#define Height_Space     20.0f     // 竖间距
#define Button_Height   30.0f    // 高
#define Button_Width    60.0f   //宽
@interface VCAddPersonSpeciality ()<UITextViewDelegate>
@property (nonatomic,weak)UITextView *textView;
@property (nonatomic,strong)NSMutableArray  *arrayContent;
@property (nonatomic)BOOL isSelected;
@end

@implementation VCAddPersonSpeciality

-(void)setUI
{
    self.view.backgroundColor = GetColor(235,235,235,1);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.arrayContent = [[[ShareModel shareModel].techang componentsSeparatedByString:@","]mutableCopy];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightItem)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    if ([ShareModel shareModel].showRightItem) {
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, kTopHeight+20, Scree_width-20, 44)];
    textView.font = [UIFont systemFontOfSize:17];
    textView.scrollEnabled = NO;
    textView.userInteractionEnabled =  NO;
    textView.delegate = self;
    textView.text = [self.arrayContent componentsJoinedByString:@","];
    [self.view addSubview:textView];
    self.textView = textView;
    
    NSArray * arrayTitle = @[@"按摩",@"手法",@"懂经络",@"会销售",@"懂皮肤",@"生理学",@"会控场",@"会培训",@"会主持",@"会心理",@"生物学",@"中医学",@"懂礼仪"];
    
    if ([ShareModel shareModel].showRightItem) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 220, 60, 21)];
        label.text = @"标签：";
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        label.layer.borderWidth = 1.0f;
        [self.view addSubview:label];
        
        for (int i = 0 ; i < 13; i++) {
            NSInteger index = i % 4;
            NSInteger page = i / 4;
            
            // 圆角按钮
            UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            mapBtn.frame = CGRectMake(index * (Button_Width + Width_Space)+ Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width,Button_Height);
            mapBtn.layer.cornerRadius = 5;
            mapBtn.layer.masksToBounds = YES;
            mapBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            mapBtn.layer.borderWidth = 1.0f;
            [mapBtn setTitle:arrayTitle[i] forState:UIControlStateNormal];
            [mapBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [mapBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:mapBtn];
        }
    }
}

-(void)rightItem
{
    [ShareModel shareModel].techang = self.textView.text;
}

-(void)textViewDidChange:(UITextView *)textView
{
    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:17]} context:nil].size;
    
    
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, size.height+23);
}

-(void)buttonPress:(UIButton *)sender
{
    
    NSString *string = sender.titleLabel.text;
    if ([self.arrayContent containsObject:string]) {
        [self.arrayContent removeObject:string];
    }else
    {
        [self.arrayContent addObject:string];
    }
    self.textView.text = [self.arrayContent componentsJoinedByString:@","];
    [self textViewDidChange:self.textView];
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"特长";
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
