//
//  TargetViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/10/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TargetViewController.h"
#import "WJTextView.h"
@interface TargetViewController ()
@property (nonatomic,strong) WJTextView *textView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,assign) int a;
@end

@implementation TargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _a=_number.intValue;
    switch (_a) {
        case 0:{
            self.title=@"店家问题简述";
        }
            
            break;
        case 1:{
            self.title=@"品牌介入策略及跟进规划";
        }
            
            break;
        case 2:{
            self.title=@"店家要求事项及解决办法";
        }
            break;
        case 3:
            self.title = @"同事协助须知";
            break;
        case 10:
            self.title= @"存在优势及问题";
            break;
        case 11:
            self.title= @"经营状况";
            break;
        case 12:
            self.title= @"常到顾客";
            break;
        case 13:
            self.title= @"拓客计划";
            break;
        default:
            break;
    }
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
    if([_number isEqualToString: @"11"]){
        _textView.placehoder = @"必填";
    }
    
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
    _textView.isAutoHeight = YES;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 20.0;
    
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

@end
