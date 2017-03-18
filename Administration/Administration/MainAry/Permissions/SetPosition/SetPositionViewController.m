//
//  SetPositionViewController.m
//  Administration
// 角色设定。  15根线 10个按钮 20个标签。20个texfiled
//  Created by 九尾狐 on 2017/3/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "SetPositionViewController.h"
BOOL YWZJBOOL;
BOOL SCZJBOOL;
BOOL YWJLBOOL;
BOOL SCJLBOOL;
BOOL YWBOOL;
BOOL MDBOOL;
BOOL XZGLBOOL;
BOOL WLBOOL;
BOOL NQBOOL;
NSUInteger rooow;
NSUInteger roosw;
@interface SetPositionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    
}


//标签
@property (strong,nonatomic) UILabel *XZZWLabel;//顶部标签
//按钮
@property (strong,nonatomic) UIButton *ZJLBtn;//总经理
@property (strong,nonatomic) UIButton *YWZJBtn;//业务总监
@property (strong,nonatomic) UIButton *SCZJBtn;//市场总监
@property (strong,nonatomic) UIButton *YWJLbTN;//业务经理
@property (strong,nonatomic) UIButton *SCJLBtn;//市场经理
@property (strong,nonatomic) UIButton *YWBtn;//业务
@property (strong,nonatomic) UIButton *MDBtn;//美导
@property (strong,nonatomic) UIButton *XZGLBtn;//行政管理
@property (strong,nonatomic) UIButton *WLBtn;//物流
@property (strong,nonatomic) UIButton *NQBtn;//内勤

//线
@property (strong,nonatomic)UIView *view1;//总经理下面的竖线
@property (strong,nonatomic)UIView *view2;//总经理竖线下面的横线
@property (strong,nonatomic)UIView *view3;//横线下面的左竖线
@property (strong,nonatomic)UIView *view4;//左竖线下面的横线
@property (strong,nonatomic)UIView *view5;//横线下面的左小竖线
@property (strong,nonatomic)UIView *view6;//业务总监下面的竖线
@property (strong,nonatomic)UIView *view7;//业务经理下面的竖线
@property (strong,nonatomic)UIView *view8;//横线下面的右小竖线
@property (strong,nonatomic)UIView *view9;//市场总监下面的竖线
@property (strong,nonatomic)UIView *view10;//市场经理下面的竖线
@property (strong,nonatomic)UIView *view11;//横线下面的右竖线
@property (strong,nonatomic)UIView *view12;//行政管理下面的小竖线
@property (strong,nonatomic)UIView *view13;//小竖线下面的横线
@property (strong,nonatomic)UIView *view14;//物流上面的竖线
@property (strong,nonatomic)UIView *view15;//内勤上面的竖线


@property (strong,nonatomic)UIImageView *gouimage1;
@property (strong,nonatomic)UIImageView *gouimage2;
@property (strong,nonatomic)UIImageView *gouimage3;
@property (strong,nonatomic)UIImageView *gouimage4;
@property (strong,nonatomic)UIImageView *gouimage5;
@property (strong,nonatomic)UIImageView *gouimage6;
@property (strong,nonatomic)UIImageView *gouimage7;
@property (strong,nonatomic)UIImageView *gouimage8;
@property (strong,nonatomic)UIImageView *gouimage9;

@property (strong,nonatomic) NSMutableArray *XZZWArry;
@property (strong,nonatomic) NSMutableArray *XGXZZWArry;


@property (strong,nonatomic) UILabel  *asklLabel;
@property (strong,nonatomic) UITextField *xgtextFie;
@end

@implementation SetPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YWZJBOOL = YES;
    SCZJBOOL = YES;
    YWJLBOOL = YES;
    SCJLBOOL = YES;
    YWBOOL = YES;
    MDBOOL = YES;
    XZGLBOOL = YES;
    WLBOOL = YES;
    NQBOOL = YES;
    
    self.view.backgroundColor = GetColor(255, 255, 255, 1);
    _XZZWArry = [[NSMutableArray alloc]init];
    [_XZZWArry addObject:@"总经理"];
    [self complexUI];
    // Do any additional setup after loading the view.
}

-(void)complexUI{
    
    
    infonTableview= [[UITableView alloc]init];
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    [infonTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.bottom).offset(0);
    }];
   
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 210)];
    topView.backgroundColor = [UIColor whiteColor];
    infonTableview.tableHeaderView=topView;
    
    _XZZWLabel = [[UILabel alloc]init];
    _XZZWLabel.text = @"请勾选您公司的职位";
    _XZZWLabel.textColor = GetColor(102, 102, 102, 1);
    _XZZWLabel.font = [UIFont systemFontOfSize: 14.0];
    [topView addSubview:_XZZWLabel];
    [_XZZWLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.view.mas_top).offset(70);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo (self.view.mas_right).offset(-10);
        make.height.mas_offset(@21);
    }];
    _ZJLBtn = [[UIButton alloc]init];
    [_ZJLBtn setTitle:@"总经理" forState:UIControlStateNormal];
    _ZJLBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_ZJLBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_ZJLBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_ZJLBtn.layer setCornerRadius:3];
    [_ZJLBtn.layer setBorderWidth:1];//设置边界的宽度
    [_ZJLBtn.layer setBorderColor:([UIColor orangeColor].CGColor)];
    [topView addSubview:_ZJLBtn];
    [_ZJLBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_XZZWLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.width.mas_offset (70);
        make.height.mas_offset(21);
    }];
    UIImageView *gouimage = [[UIImageView alloc]init];
    gouimage.image = [UIImage imageNamed:@"xz_ico1"];
    [topView addSubview:gouimage];
    [gouimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_ZJLBtn.mas_right).offset(3);
        make.bottom.mas_equalTo(_ZJLBtn.mas_bottom).offset(0);
        make.height.mas_offset(10);
        make.width.mas_offset(10);
    }];
    
    _view1 = [[UIView alloc]init];
    _view1.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view1];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ZJLBtn.mas_bottom).offset(0);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(20);
    }];
    _view2 = [[UIView alloc]init];
    _view2.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view2];
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view1.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(kWidth*200);
        make.right.mas_equalTo(self.view.mas_right).offset(-kWidth*160);
        make.height.mas_offset(2);
    }];
    _view3 = [[UIView alloc]init];
    _view3.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view3];
    [_view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view2.mas_bottom).offset(0);
        make.left.mas_equalTo(_view2.mas_left).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(20);
    }];
    _view4 = [[UIView alloc]init];
    _view4.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view4];
    [_view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view3.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view3.mas_centerX).offset(0);
        make.width.mas_offset(90);
        make.height.mas_offset(2);
    }];
    _view5 = [[UIView alloc]init];
    _view5.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view5];
    [_view5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view4.mas_bottom).offset(0);
        make.left.mas_equalTo(_view4.mas_left).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(10);
    }];
    _YWZJBtn = [[UIButton alloc]init];
    [_YWZJBtn setTitle:@"业务总监" forState:UIControlStateNormal];
    [_YWZJBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _YWZJBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_YWZJBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_YWZJBtn.layer setCornerRadius:3];
    [_YWZJBtn.layer setBorderWidth:1];//设置边界的宽度
    [_YWZJBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    //在controller中设置按钮的目标-动作，其中目标是self，也就是控制器自身，动作是用目标提供的BtnClick:方法，
    [_YWZJBtn addTarget:self action:@selector(YWZJBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _YWZJBtn.tag = 110;
    [topView addSubview:_YWZJBtn];
    [_YWZJBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view5.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view5.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view6 = [[UIView alloc]init];
    _view6.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view6];
    [_view6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_YWZJBtn.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_YWZJBtn.mas_centerX).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(15);
    }];
    _YWJLbTN = [[UIButton alloc]init];
    [_YWJLbTN setTitle:@"业务经理" forState:UIControlStateNormal];
    [_YWJLbTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _YWJLbTN.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_YWJLbTN.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_YWJLbTN.layer setCornerRadius:3];
    [_YWJLbTN.layer setBorderWidth:1];//设置边界的宽度
    [_YWJLbTN.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [_YWJLbTN addTarget:self action:@selector(YWJLbTNClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_YWJLbTN];
    [_YWJLbTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view6.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view6.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view7 = [[UIView alloc]init];
    _view7.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view7];
    [_view7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_YWJLbTN.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_YWJLbTN.mas_centerX).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(15);
    }];
    _YWBtn = [[UIButton alloc]init];
    [_YWBtn setTitle:@"业务" forState:UIControlStateNormal];
    [_YWBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _YWBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_YWBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_YWBtn.layer setCornerRadius:3];
    [_YWBtn.layer setBorderWidth:1];//设置边界的宽度
    [_YWBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [_YWBtn addTarget:self action:@selector(YWBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:_YWBtn];
    [_YWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view7.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view7.mas_centerX).offset(0);
        make.width.mas_offset (@60);
        make.height.mas_offset(@21);
    }];
    _view8 = [[UIView alloc]init];
    _view8.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view8];
    [_view8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view4.mas_bottom).offset(0);
        make.right.mas_equalTo(_view4.mas_right).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(10);//
        
    }];
    _SCZJBtn = [[UIButton alloc]init];
    [_SCZJBtn setTitle:@"市场总监" forState:UIControlStateNormal];
    [_SCZJBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _SCZJBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_SCZJBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_SCZJBtn.layer setCornerRadius:3];
    [_SCZJBtn.layer setBorderWidth:1];//设置边界的宽度
    [_SCZJBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [_SCZJBtn addTarget:self action:@selector(SCZJBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_SCZJBtn];
    [_SCZJBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view8.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view8.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view9 = [[UIView alloc]init];
    _view9.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view9];
    [_view9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_SCZJBtn.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_SCZJBtn.mas_centerX).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(15);
    }];
    _SCJLBtn = [[UIButton alloc]init];
    [_SCJLBtn setTitle:@"市场经理" forState:UIControlStateNormal];
    [_SCJLBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _SCJLBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_SCJLBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_SCJLBtn.layer setCornerRadius:3];
    [_SCJLBtn.layer setBorderWidth:1];//设置边界的宽度
    [_SCJLBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [_SCJLBtn addTarget:self action:@selector(SCJLBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_SCJLBtn];
    [_SCJLBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view9.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view9.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view10 = [[UIView alloc]init];
    _view10.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view10];
    [_view10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_SCJLBtn.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_SCJLBtn.mas_centerX).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(15);
    }];
    _MDBtn = [[UIButton alloc]init];
    [_MDBtn setTitle:@"美导" forState:UIControlStateNormal];
    [_MDBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _MDBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_MDBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_MDBtn.layer setCornerRadius:3];
    [_MDBtn.layer setBorderWidth:1];//设置边界的宽度
    [_MDBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [_MDBtn addTarget:self action:@selector(MDBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_MDBtn];
    [_MDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view10.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view10.mas_centerX).offset(0);
        make.width.mas_offset (@60);
        make.height.mas_offset(@21);
    }];
    _view11 = [[UIView alloc]init];
    _view11.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view11];
    [_view11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view2.mas_bottom).offset(0);
        make.right.mas_equalTo(_view2.mas_right).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(32);
    }];
    _XZGLBtn = [[UIButton alloc]init];
    [_XZGLBtn setTitle:@"行政管理" forState:UIControlStateNormal];
    [_XZGLBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _XZGLBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_XZGLBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_XZGLBtn.layer setCornerRadius:3];
    [_XZGLBtn.layer setBorderWidth:1];//设置边界的宽度
    [_XZGLBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [_XZGLBtn addTarget:self action:@selector(XZGLBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_XZGLBtn];
    [_XZGLBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view11.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view11.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view12 = [[UIView alloc]init];
    _view12.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view12];
    [_view12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_XZGLBtn.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view11.mas_centerX).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(10);
    }];
    _view13 = [[UIView alloc]init];
    _view13.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view13];
    [_view13 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view12.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view12.mas_centerX).offset(0);
        make.width.mas_offset(70);
        make.height.mas_offset(2);
    }];
    _view14 = [[UIView alloc]init];
    _view14.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view14];
    [_view14 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view13.mas_bottom).offset(0);
        make.left.mas_equalTo(_view13.mas_left).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(10);
    }];
    _WLBtn = [[UIButton alloc]init];
    [_WLBtn setTitle:@"物流 " forState:UIControlStateNormal];
    [_WLBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _WLBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_WLBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_WLBtn.layer setCornerRadius:3];
    [_WLBtn.layer setBorderWidth:1];//设置边界的宽度
    [_WLBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [_WLBtn addTarget:self action:@selector(WLBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_WLBtn];
    [_WLBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view14.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view14.mas_centerX).offset(0);
        make.width.mas_offset (@60);
        make.height.mas_offset(@21);
    }];
    _view15 = [[UIView alloc]init];
    _view15.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:_view15];
    [_view15 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view13.mas_bottom).offset(0);
        make.right.mas_equalTo(_view13.mas_right).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(10);
    }];
    _NQBtn = [[UIButton alloc]init];
    [_NQBtn setTitle:@"内勤" forState:UIControlStateNormal];
    [_NQBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _NQBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_NQBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_NQBtn.layer setCornerRadius:3];
    [_NQBtn.layer setBorderWidth:1];//设置边界的宽度
    [_NQBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [_NQBtn addTarget:self action:@selector(NQBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_NQBtn];
    [_NQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view15.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view15.mas_centerX).offset(0);
        make.width.mas_offset (@60);
        make.height.mas_offset(@21);
    }];
    _gouimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 10, 10)];
    [_YWZJBtn addSubview:_gouimage1];
    
    _gouimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 10, 10)];
    [_YWJLbTN addSubview:_gouimage2];
    
    _gouimage4 = [[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 10, 10)];
    [_SCZJBtn addSubview:_gouimage4];
    
    _gouimage5 = [[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 10, 10)];
    [_SCJLBtn addSubview:_gouimage5];
    
    _gouimage7 = [[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 10, 10)];
    [_XZGLBtn addSubview:_gouimage7];
    
    _gouimage3 = [[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 10, 10)];
    [_YWBtn addSubview:_gouimage3];
    
    _gouimage6 = [[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 10, 10)];
    [_MDBtn addSubview:_gouimage6];
    
    _gouimage8 = [[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 10, 10)];
    [_WLBtn addSubview:_gouimage8];
    
    _gouimage9 = [[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 10, 10)];
    [_NQBtn addSubview:_gouimage9];
    
    
    

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *asdklLabel = nil;
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        
        cell.textLabel.text = @"您选择的职位";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        cell.textLabel.textColor = GetColor(117, 117, 117, 1);

       
    }
    for(_asklLabel in cell.subviews){
        
        if([_asklLabel isMemberOfClass:[UILabel class]])
        {
            [_asklLabel removeFromSuperview];
        }
    }
    _asklLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 1, 80, 28)];
    _asklLabel.text = _XZZWArry[indexPath.row];
    _asklLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _asklLabel.textAlignment = NSTextAlignmentCenter;
    _asklLabel.textColor = [UIColor orangeColor];
    [_asklLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_asklLabel.layer setCornerRadius:3];
    [_asklLabel.layer setBorderWidth:1];//设置边界的宽度
    [_asklLabel.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [cell addSubview:_asklLabel];
    
    asdklLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 1, 40, 28)];
    asdklLabel.text = @"修改为";
    asdklLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    asdklLabel.textColor = GetColor(117, 117, 117, 1);
    [cell addSubview:asdklLabel];
    

    for(_xgtextFie in cell.subviews){
        
        if([_xgtextFie isKindOfClass:[UITextField class]])
            
        {
            
            [_xgtextFie removeFromSuperview];
            
        }
        
    }
    _xgtextFie = [[UITextField alloc]initWithFrame:CGRectMake(240, 1, self.view.bounds.size.width-242, 28)];
    _xgtextFie.textColor = [UIColor orangeColor];
    _xgtextFie.placeholder =_XZZWArry[indexPath.row];
    _xgtextFie.font = [UIFont boldSystemFontOfSize:13.0f];
    [_xgtextFie.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_xgtextFie.layer setCornerRadius:3];
    [_xgtextFie.layer setBorderWidth:1];//设置边界的宽度
    [_xgtextFie.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [cell addSubview:_xgtextFie];

    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _XZZWArry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)addtableViewCellZWUI{
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rooow inSection:0];
    [indexPaths addObject: indexPath];
    
    [infonTableview beginUpdates];
    
    [infonTableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    
    [infonTableview endUpdates];

}
-(void)dimissTabelCellZWUI{
    NSArray *_tempIndexPathArr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:roosw inSection:0]];
    [infonTableview beginUpdates];
    [infonTableview deleteRowsAtIndexPaths:_tempIndexPathArr withRowAnimation:UITableViewRowAnimationFade];
    [infonTableview endUpdates];
}

-(void)YWZJBtnClick:(UIButton *)btn{
    //业务总监
    if (YWZJBOOL == YES) {
        [btn.layer setBorderColor:([UIColor orangeColor].CGColor)];
        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
        [_XZZWArry addObject:@"业务总监"];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"业务总监"]){
                
                rooow = i;
                break;//一定要有break，否则会出错的。
                
            }
        }
        [self addtableViewCellZWUI];
        
        YWZJBOOL = NO;
    }else{
        [btn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        _gouimage1.image = [UIImage imageNamed:@""];
        
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"业务总监"]){
                [_XZZWArry removeObject: _XZZWArry[i]];
                roosw = i;
                break;//一定要有break，否则会出错的。
            }
        }
        [self dimissTabelCellZWUI];
        
        YWZJBOOL = YES;
    }
    
}
-(void)YWJLbTNClick:(UIButton *)btn{
    //业务经理
    if (YWJLBOOL == YES) {
        [btn.layer setBorderColor:([UIColor orangeColor].CGColor)];
        _gouimage2.image = [UIImage imageNamed:@"xz_ico1"];
        [_XZZWArry addObject:@"业务经理"];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"业务经理"]){
                rooow = i;
                break;//一定要有break，否则会出错的。
            }
        }
        [self addtableViewCellZWUI];
        YWJLBOOL = NO;
    }else{
        [btn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        _gouimage2.image = [UIImage imageNamed:@""];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"业务经理"]){
                [_XZZWArry removeObject: _XZZWArry[i]];
                roosw = i;
                break;//一定要有break，否则会出错的。
                
            }
            
        }
        [self dimissTabelCellZWUI];
        YWJLBOOL = YES;
    }
    NSLog(@"%hhd",YWJLBOOL);
    
}
-(void)YWBtnClick:(UIButton *)btn{
    //业务
    
    if (YWBOOL == YES) {
        [btn.layer setBorderColor:([UIColor orangeColor].CGColor)];
        _gouimage3.image = [UIImage imageNamed:@"xz_ico1"];
        [_XZZWArry addObject:@"业务"];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"业务"]){
                rooow = i;
                break;//一定要有break，否则会出错的。
            }
        }
        [self addtableViewCellZWUI];
        YWBOOL = NO;
    }else{
        [btn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        _gouimage3.image = [UIImage imageNamed:@""];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"业务"]){
                [_XZZWArry removeObject: _XZZWArry[i]];
                roosw = i;
                break;//一定要有break，否则会出错的。
                
            }
            
        }
        [self dimissTabelCellZWUI];
        YWBOOL = YES;
    }
}
-(void)SCZJBtnClick:(UIButton *)btn{
    //市场总监
    if (SCZJBOOL == YES) {
        [btn.layer setBorderColor:([UIColor orangeColor].CGColor)];
        _gouimage4.image = [UIImage imageNamed:@"xz_ico1"];
        [_XZZWArry addObject:@"市场总监"];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"市场总监"]){
                
                rooow = i;
                break;//一定要有break，否则会出错的。
            }
        }
        [self addtableViewCellZWUI];
        SCZJBOOL = NO;
    }else{
        [btn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        _gouimage4.image = [UIImage imageNamed:@""];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"市场总监"]){
                [_XZZWArry removeObject: _XZZWArry[i]];
                roosw = i;
                break;//一定要有break，否则会出错的。
            }
        }
        [self dimissTabelCellZWUI];
        
        SCZJBOOL = YES;
    }
}
-(void)SCJLBtnClick:(UIButton *)btn{
    //市场经理
    if (SCJLBOOL == YES) {
        [btn.layer setBorderColor:([UIColor orangeColor].CGColor)];
        _gouimage5.image = [UIImage imageNamed:@"xz_ico1"];
        [_XZZWArry addObject:@"市场经理"];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"市场经理"]){
                rooow = i;
                break;//一定要有break，否则会出错的。
            }
        }
        [self addtableViewCellZWUI];
        SCJLBOOL = NO;
    }else{
        [btn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        _gouimage5.image = [UIImage imageNamed:@""];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"市场经理"]){
                [_XZZWArry removeObject: _XZZWArry[i]];
                roosw = i;
                break;//一定要有break，否则会出错的。
            }
        }
        [self dimissTabelCellZWUI];
        SCJLBOOL = YES;
    }
}
-(void)MDBtnClick:(UIButton *)btn{
    //美导
    if (MDBOOL == YES) {
        [btn.layer setBorderColor:([UIColor orangeColor].CGColor)];
        _gouimage6.image = [UIImage imageNamed:@"xz_ico1"];
        [_XZZWArry addObject:@"美导"];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"美导"]){
                rooow = i;
                break;//一定要有break，否则会出错的。
            }
        }
        [self addtableViewCellZWUI];
        MDBOOL = NO;
    }else{
        [btn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        _gouimage6.image = [UIImage imageNamed:@""];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"美导"]){
                [_XZZWArry removeObject: _XZZWArry[i]];
                roosw = i;
                break;//一定要有break，否则会出错的。
            }
        }
        [self dimissTabelCellZWUI];
        MDBOOL = YES;
    }
}
-(void)XZGLBtnClick:(UIButton *)btn{
    //行政管理
    if (XZGLBOOL == YES) {
        [btn.layer setBorderColor:([UIColor orangeColor].CGColor)];
        _gouimage7.image = [UIImage imageNamed:@"xz_ico1"];
        [_XZZWArry addObject:@"行政管理"];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"行政管理"]){
                
                rooow = i;
                break;//一定要有break，否则会出错的。
                
            }
        }
        [self addtableViewCellZWUI];
        XZGLBOOL = NO;
    }else{
        [btn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        _gouimage7.image = [UIImage imageNamed:@""];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"行政管理"]){
                [_XZZWArry removeObject: _XZZWArry[i]];
                roosw = i;
                break;//一定要有break，否则会出错的。
                
            }
        }
        [self dimissTabelCellZWUI];
        XZGLBOOL = YES;
    }
}
-(void)WLBtnClick:(UIButton *)btn{
    //物流
    if (WLBOOL == YES) {
        [btn.layer setBorderColor:([UIColor orangeColor].CGColor)];
        _gouimage8.image = [UIImage imageNamed:@"xz_ico1"];
        [_XZZWArry addObject:@"物流"];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"物流"]){
                
                rooow = i;
                break;//一定要有break，否则会出错的。
                
            }
        }
        [self addtableViewCellZWUI];
        WLBOOL = NO;
    }else{
        [btn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        _gouimage8.image = [UIImage imageNamed:@""];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"物流"]){
                [_XZZWArry removeObject: _XZZWArry[i]];
                roosw = i;
                break;//一定要有break，否则会出错的。
            }
        }
        [self dimissTabelCellZWUI];
        WLBOOL = YES;
    }
}
-(void)NQBtnClick:(UIButton *)btn{
    //内勤
    if (NQBOOL == YES) {
        [btn.layer setBorderColor:([UIColor orangeColor].CGColor)];
        _gouimage9.image = [UIImage imageNamed:@"xz_ico1"];
        [_XZZWArry addObject:@"内勤"];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"内勤"]){
                
                rooow = i;
                break;//一定要有break，否则会出错的。
                
            }
        }
        [self addtableViewCellZWUI];
        NQBOOL = NO;
    }else{
        [btn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        _gouimage9.image = [UIImage imageNamed:@""];
        for (int i = 0;i<_XZZWArry.count;i++)
        {
            if ([_XZZWArry[i]isEqualToString:@"内勤"]){
                [_XZZWArry removeObject: _XZZWArry[i]];
                roosw = i;
                break;//一定要有break，否则会出错的。
                
            }
        }
        [self dimissTabelCellZWUI];
        NQBOOL = YES;
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
