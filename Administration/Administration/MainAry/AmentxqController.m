//
//  AmentxqController.m
//  Administration
//
//  Created by zhang on 2017/2/21.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AmentxqController.h"

@interface AmentxqController ()
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UILabel *tileLabel;
///头像
@property (nonatomic,retain)UIImageView *logoImage;
///标题
@property (nonatomic,retain)UILabel *titleLabel;
///时间
@property (nonatomic,retain)UILabel *timeLabel;
///发送人
@property (nonatomic,retain)UILabel *whoLabel;
///内容
@property (nonatomic,retain)UILabel *contLabel;
@property (nonatomic,assign)CGFloat Heigh;
@end

@implementation AmentxqController

- (void)viewDidLoad {
    [super viewDidLoad];
   _Heigh = [ELNAlerTool heighOfString:_gonModel.content font:[UIFont systemFontOfSize:16] width:self.view.frame.size.width-20];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.title=@"公告";
     self.view.backgroundColor=[UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    _scrollView=[[UIScrollView alloc]init];
    _scrollView.showsVerticalScrollIndicator = NO;;
    [self.view addSubview:_scrollView];
    _logoImage=[[UIImageView alloc]init];
    _logoImage.layer.masksToBounds = YES;
    // 设置圆角半径
    _logoImage.layer.cornerRadius =24.0f;
    [self.scrollView addSubview:_logoImage];
    _timeLabel=[[UILabel alloc]init];
    
    _timeLabel.textAlignment=NSTextAlignmentRight;
    _timeLabel.font=[UIFont systemFontOfSize:14];
    _timeLabel.textColor=[UIColor lightGrayColor];
    [self.scrollView addSubview:_timeLabel];
    
    _titleLabel=[[UILabel alloc]init];
    
    [self.scrollView addSubview:_titleLabel];
    _whoLabel=[[UILabel alloc]init];
    _whoLabel.textColor=[UIColor lightGrayColor];
    _whoLabel.font=[UIFont systemFontOfSize:14];
  
    [self.scrollView addSubview:_whoLabel];
    _contLabel=[[UILabel alloc]init];
    _contLabel.numberOfLines=0;
    _contLabel.backgroundColor=[UIColor colorWithRed:(243/255.0) green:(243/255.0) blue:(243/255.0) alpha:1];
    [self.scrollView addSubview:_contLabel];
 
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.top.mas_equalTo(self.scrollView.mas_top).offset(10);
        make.width.offset(48);
        make.height.offset(48);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_logoImage.mas_right).offset(5);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(_logoImage.mas_top);
        make.height.offset(20);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.width.offset(130);
        make.height.offset(16);
    }];
    [_whoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(_timeLabel.mas_bottom);
        make.left.mas_equalTo(_logoImage.mas_right).offset(5);
        make.height.offset(16);
    }];
    
    [_contLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(_whoLabel.mas_bottom).offset(2);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.height.offset(_Heigh+20);
    }];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 60, 0));;
    }];
    _titleLabel.text=_gonModel.title;
    NSString *timeStr = [_gonModel.time substringWithRange:NSMakeRange(5,11)];
    _timeLabel.text=timeStr;
    _contLabel.text=_gonModel.content;
    [_logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImageUrl,_gonModel.url]] placeholderImage:[UIImage  imageNamed:@"tx23"]];
    if (_gonModel.roleId ==1) {
        _whoLabel.text=@"来自老板";
    } else if (_gonModel.roleId == 7){
        _whoLabel.text=@"来自行政";
    }
 
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
