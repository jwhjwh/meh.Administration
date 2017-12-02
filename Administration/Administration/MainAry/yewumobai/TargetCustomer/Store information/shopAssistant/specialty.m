//
//  specialty.m
//  Administration
//
//  Created by 九尾狐 on 2017/12/1.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "specialty.h"
#import "WJTextView.h"
@interface specialty ()
@property (nonatomic,strong) WJTextView *textView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,assign) int a;
@end

@implementation specialty

- (void)viewDidLoad {
    [super viewDidLoad];
    _a=_number.intValue;
    self.title=@"点评建议";
    self.view.backgroundColor = [UIColor colorWithRed:(237/255.0) green:(237/255.0) blue:(237/255.0) alpha:1];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    if (self.modifi ==YES) {
        UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction)];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightitem;
    }
    _scrollView=[[UIScrollView alloc]init];
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_scrollView];
    // 创建textView
    _textView = [[WJTextView alloc]init];
    // 设置颜色
    _textView.backgroundColor = [UIColor whiteColor];
    // 设置提示文字
   
    if (self.dateStr.length>0) {
        _textView.text = self.dateStr;
    }
    
    
    // 设置提示文字颜色
    _textView.placehoderColor = [UIColor colorWithRed:(188/255.0) green:(176/255.0) blue:(195/255.0) alpha:1];
    // 设置textView的字体
    _textView.font = [UIFont systemFontOfSize:15];
    // 设置内容是否有弹簧效果
    _textView.alwaysBounceVertical = YES;
    // 设置textView的高度根据文字自动适应变宽
    //_textView.isAutoHeight = YES;
    _textView.layer.masksToBounds = YES;
    
    
    _textView.editable=self.modifi;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 添加到视图上
    [_scrollView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(92);
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@180);
    }];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));;
    }];
    UIView *view = [[UIView alloc]init];
    [_scrollView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_offset(220);
    }];
    NSArray *biaoqary = [[NSArray alloc]initWithObjects:@"按摩",@"手法",@"懂经络",@"会销售",@"懂皮肤",@"生理学",@"会控场",@"会培训",@"会主持",@"会心理",@"生物学",@"中医学",@"懂礼仪",nil];
     NSArray *biaoqtagary = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",nil];
    
    
    UILabel *bianqianlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 30)];
    bianqianlabel.text = @"标签:";
    [view addSubview:bianqianlabel];
    for (int i= 0; i<biaoqary.count; i++) {
        NSInteger k = [biaoqtagary[i] integerValue];
        if (i<4) {
            UIButton *bqbtn = [[UIButton alloc]initWithFrame:CGRectMake(70+(10+(i*70)), 10, 50, 30)];
            [bqbtn setTitle:biaoqary[i] forState:UIControlStateNormal];
            bqbtn.tag =k;
            bqbtn.backgroundColor = [UIColor colorWithRed:(237/255.0) green:(237/255.0) blue:(237/255.0) alpha:0.4];
             bqbtn.titleLabel.font = [UIFont systemFontOfSize:kWidth*25];
            [bqbtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
            [bqbtn.layer setCornerRadius:3];
            [bqbtn.layer setBorderWidth:1];//设置边界的宽度
            [bqbtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
            [bqbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
             [bqbtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:bqbtn];
        
        }else if(i<8){
            UIButton *bqbtn = [[UIButton alloc]initWithFrame:CGRectMake(70+(10+((i-4)*70)), 60, 50, 30)];
            [bqbtn setTitle:biaoqary[i] forState:UIControlStateNormal];
            bqbtn.tag = k;
            bqbtn.backgroundColor = [UIColor colorWithRed:(237/255.0) green:(237/255.0) blue:(237/255.0) alpha:0.4];
            bqbtn.titleLabel.font = [UIFont systemFontOfSize:kWidth*25];
            [bqbtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
            [bqbtn.layer setCornerRadius:3];
            [bqbtn.layer setBorderWidth:1];//设置边界的宽度
            [bqbtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
            [bqbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
             [bqbtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:bqbtn];
        }else if (i<12){
            UIButton *bqbtn = [[UIButton alloc]initWithFrame:CGRectMake(70+(10+((i-8)*70)), 110, 50, 30)];
            [bqbtn setTitle:biaoqary[i] forState:UIControlStateNormal];
            bqbtn.tag = k;
            bqbtn.backgroundColor = [UIColor colorWithRed:(237/255.0) green:(237/255.0) blue:(237/255.0) alpha:0.4];
            bqbtn.titleLabel.font = [UIFont systemFontOfSize:kWidth*25];
            [bqbtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
            [bqbtn.layer setCornerRadius:3];
            [bqbtn.layer setBorderWidth:1];//设置边界的宽度
            [bqbtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
            [bqbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
             [bqbtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:bqbtn];
        }else{
            UIButton *bqbtn = [[UIButton alloc]initWithFrame:CGRectMake(70+(10+((i-12)*70)), 160, 50, 30)];
            [bqbtn setTitle:biaoqary[i] forState:UIControlStateNormal];
            bqbtn.tag = k;
            bqbtn.backgroundColor = [UIColor colorWithRed:(237/255.0) green:(237/255.0) blue:(237/255.0) alpha:0.4];
            bqbtn.titleLabel.font = [UIFont systemFontOfSize:kWidth*25];
            [bqbtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
            [bqbtn.layer setCornerRadius:3];
            [bqbtn.layer setBorderWidth:1];//设置边界的宽度
            [bqbtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
            [bqbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [view addSubview:bqbtn];
              [bqbtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}
-(void)button1BackGroundNormal:(UIButton *)bbtn{

    if([_textView.text rangeOfString:bbtn.titleLabel.text].location !=NSNotFound)//_roaldSearchText
    {
        NSString *strUrl = [_textView.text stringByReplacingOccurrencesOfString:bbtn.titleLabel.text withString:@""];
        _textView.text = strUrl;
        bbtn.backgroundColor = [UIColor colorWithRed:(237/255.0) green:(237/255.0) blue:(237/255.0) alpha:0.4];
    }
    else
    {
            NSString *strrr = [[NSString alloc]init];
            strrr = [_textView.text stringByAppendingString:bbtn.titleLabel.text];
            _textView.text = strrr;
            bbtn.backgroundColor = [UIColor colorWithRed:(230/255.0) green:(230/255.0) blue:(230/255.0) alpha:1];
    }
    
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemAction{
    self.blcokStr(_textView.text,_a);
    [self.navigationController popViewControllerAnimated:YES];
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
