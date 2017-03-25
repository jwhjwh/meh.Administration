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
BOOL QDBOOL;
NSUInteger rooow;
NSUInteger roosw;
@interface SetPositionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    
}

@property (strong,nonatomic) UITableViewCell *cell;
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

@property (strong,nonatomic) UIButton *footerButton;
@property (strong,nonatomic) UIView *topView;
@property (strong,nonatomic) UIView *footerView;
@property (strong,nonatomic) UIView *popFootCellView;

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

@property (strong,nonatomic) UIView *asdjklView;


//修改的职位名称
@property (strong,nonatomic) NSString *XGZJLStr;//总经理
@property (strong,nonatomic) NSString *YWZJStr;//业务总监
@property (strong,nonatomic) NSString *YWJLStr;//业务经理
@property (strong,nonatomic) NSString *YWStr;//业务
@property (strong,nonatomic) NSString *SCZJStr;//市场总监
@property (strong,nonatomic) NSString *SCJLStr;//市场经理
@property (strong,nonatomic) NSString *MDStr;//美导
@property (strong,nonatomic) NSString *XZGLLStr;//行政管理
@property (strong,nonatomic) NSString *WLStr;//物流
@property (strong,nonatomic) NSString *NQStr;//内勤


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
    QDBOOL = YES;
    self.view.backgroundColor = GetColor(255, 255, 255, 1);
    _XZZWArry = [[NSMutableArray alloc]init];
    [_XZZWArry addObject:@"总经理"];
    [self complexUI];
    _XGZJLStr = @"总经理";
    _YWJLStr = @"业务经理";
    _YWZJStr = @"业务总监";
    _YWStr = @"业务";
    _SCZJStr = @"市场总监";
    _SCJLStr = @"市场经理";
    _MDStr = @"美导";
    _XZGLLStr = @"行政管理";
    _WLStr = @"物流";
    _NQStr = @"内勤";
    // Do any additional setup after loading the view.
}

-(void)complexUI{
    infonTableview= [[UITableView alloc]init];
    infonTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    [infonTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.bottom).offset(0);
    }];
   
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 210)];
    _topView.backgroundColor = [UIColor whiteColor];
    infonTableview.tableHeaderView=_topView;
    
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 280)];
    _footerView.backgroundColor = [UIColor whiteColor];
    infonTableview.tableFooterView=_footerView;
    
    _footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // 为button设置frame
    _footerButton.layer.cornerRadius = 5;
    [_footerButton setTitle:@"确定" forState:UIControlStateNormal];
     [_footerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _footerButton.titleLabel.font =[UIFont systemFontOfSize: 14.0];
    [_footerButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_footerButton.layer setCornerRadius:3];
    [_footerButton.layer setBorderWidth:1];//设置边界的宽度
    [_footerButton.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    //在controller中设置按钮的目标-动作，其中目标是self，也就是控制器自身，动作是用目标提供的BtnClick:方法，
    [_footerButton addTarget:self action:@selector(footerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_footerButton];
    [_footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_footerView.mas_top).offset(40);
        make.centerX.mas_equalTo(_footerView.mas_centerX).offset(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(kWidth*200);
    }];
    
    _XZZWLabel = [[UILabel alloc]init];
    _XZZWLabel.text = @"请勾选您公司的职位";
    _XZZWLabel.textColor = GetColor(102, 102, 102, 1);
    _XZZWLabel.font = [UIFont systemFontOfSize: 14.0];
    [_topView addSubview:_XZZWLabel];
    [_XZZWLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_topView.mas_top).offset(6);
        make.left.mas_equalTo(_topView.mas_left).offset(10);
        make.right.mas_equalTo (_topView.mas_right).offset(-10);
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
    [_topView addSubview:_ZJLBtn];
    [_ZJLBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_XZZWLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(_topView.mas_centerX).offset(0);
        make.width.mas_offset (70);
        make.height.mas_offset(21);
    }];
    UIImageView *gouimage = [[UIImageView alloc]init];
    gouimage.image = [UIImage imageNamed:@"xz_ico1"];
    [_topView addSubview:gouimage];
    [gouimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_ZJLBtn.mas_right).offset(3);
        make.bottom.mas_equalTo(_ZJLBtn.mas_bottom).offset(0);
        make.height.mas_offset(10);
        make.width.mas_offset(10);
    }];
    
    _view1 = [[UIView alloc]init];
    _view1.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view1];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ZJLBtn.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_topView.mas_centerX).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(20);
    }];
    _view2 = [[UIView alloc]init];
    _view2.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view2];
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view1.mas_bottom).offset(0);
        make.left.mas_equalTo(_topView.mas_left).offset(kWidth*200);
        make.right.mas_equalTo(_topView.mas_right).offset(-kWidth*160);
        make.height.mas_offset(2);
    }];
    _view3 = [[UIView alloc]init];
    _view3.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view3];
    [_view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view2.mas_bottom).offset(0);
        make.left.mas_equalTo(_view2.mas_left).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(20);
    }];
    _view4 = [[UIView alloc]init];
    _view4.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view4];
    [_view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view3.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view3.mas_centerX).offset(0);
        make.width.mas_offset(90);
        make.height.mas_offset(2);
    }];
    _view5 = [[UIView alloc]init];
    _view5.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view5];
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
    [_topView addSubview:_YWZJBtn];
    [_YWZJBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view5.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view5.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view6 = [[UIView alloc]init];
    _view6.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view6];
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
    [_topView addSubview:_YWJLbTN];
    [_YWJLbTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view6.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view6.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view7 = [[UIView alloc]init];
    _view7.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view7];
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
    
    [_topView addSubview:_YWBtn];
    [_YWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view7.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view7.mas_centerX).offset(0);
        make.width.mas_offset (@60);
        make.height.mas_offset(@21);
    }];
    _view8 = [[UIView alloc]init];
    _view8.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view8];
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
    [_topView addSubview:_SCZJBtn];
    [_SCZJBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view8.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view8.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view9 = [[UIView alloc]init];
    _view9.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view9];
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
    [_topView addSubview:_SCJLBtn];
    [_SCJLBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view9.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view9.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view10 = [[UIView alloc]init];
    _view10.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view10];
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
    [_topView addSubview:_MDBtn];
    [_MDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view10.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view10.mas_centerX).offset(0);
        make.width.mas_offset (@60);
        make.height.mas_offset(@21);
    }];
    _view11 = [[UIView alloc]init];
    _view11.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view11];
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
    [_topView addSubview:_XZGLBtn];
    [_XZGLBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view11.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view11.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view12 = [[UIView alloc]init];
    _view12.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view12];
    [_view12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_XZGLBtn.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view11.mas_centerX).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(10);
    }];
    _view13 = [[UIView alloc]init];
    _view13.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view13];
    [_view13 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view12.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view12.mas_centerX).offset(0);
        make.width.mas_offset(70);
        make.height.mas_offset(2);
    }];
    _view14 = [[UIView alloc]init];
    _view14.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view14];
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
    [_topView addSubview:_WLBtn];
    [_WLBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view14.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view14.mas_centerX).offset(0);
        make.width.mas_offset (@60);
        make.height.mas_offset(@21);
    }];
    _view15 = [[UIView alloc]init];
    _view15.backgroundColor = [UIColor lightGrayColor];
    [_topView addSubview:_view15];
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
    [_topView addSubview:_NQBtn];
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
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    _cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *asdklLabel = nil;
    _cell.tag = [indexPath row];
    if (_cell ==nil)
    {
        _cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        
        _cell.textLabel.text = @"您选择的职位";
        _cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _cell.textLabel.textColor = GetColor(117, 117, 117, 1);

       
    }
    for(_asklLabel in _cell.subviews){
        
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
    [_cell addSubview:_asklLabel];
    
    asdklLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 1, 40, 28)];
    asdklLabel.text = @"修改为";
    asdklLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    asdklLabel.textColor = GetColor(117, 117, 117, 1);
    [_cell addSubview:asdklLabel];
    

    for(_xgtextFie in _cell.subviews){
        
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
    _xgtextFie.tag = row;
    [_xgtextFie addTarget:self action:@selector(idNoFieldText:) forControlEvents:UIControlEventEditingChanged];
    [_cell addSubview:_xgtextFie];

    
    return _cell;
}
- (void)idNoFieldText:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
            if (textField.text.length==0) {
                _XGZJLStr = @"总经理";
            }else{
                _XGZJLStr = textField.text;
            }
            break;
        case 1:
             NSLog(@"%@%uld",textField.text,textField.text.length);
            if ([textField.placeholder isEqualToString:@"业务经理"]) {
                if (textField.text.length>0) {
                    _YWJLStr = textField.text;
                }else{
                    _YWJLStr = @"业务经理";
                }
            }else if ([textField.placeholder isEqualToString:@"业务总监"]){
                if (textField.text.length>0) {
                    _YWZJStr = textField.text;
                }else{
                    _YWZJStr = @"业务总监";
                }
            }else if ([textField.placeholder isEqualToString:@"业务"]){
                if (textField.text.length>0) {
                    _YWStr = textField.text;
                }else{
                    _YWStr = @"业务";
                }
            }else if ([textField.placeholder isEqualToString:@"市场总监"]){
                if (textField.text.length>0) {
                    _SCZJStr = textField.text;
                }else{
                    _SCZJStr = @"市场总监";
                }
            }
            else if ([textField.placeholder isEqualToString:@"市场经理"]){
                if (textField.text.length>0) {
                    _SCJLStr = textField.text;
                }else{
                    _SCJLStr = @"市场经理";
                }
            }
            else if ([textField.placeholder isEqualToString:@"美导"]){
                if (textField.text.length>0) {
                    _MDStr = textField.text;
                }else{
                    _MDStr = @"美导";
                }
            }else if ([textField.placeholder isEqualToString:@"行政管理"]){
                if (textField.text.length>0) {
                    _XZGLLStr = textField.text;
                }else{
                    _XZGLLStr = @"行政管理";
                }
            }else if ([textField.placeholder isEqualToString:@"物流"]){
                if (textField.text.length>0) {
                    _WLStr = textField.text;
                }else{
                    _WLStr = @"物流";
                }
            }
            else if ([textField.placeholder isEqualToString:@"内勤"]){
                if (textField.text.length>0) {
                    _NQStr = textField.text;
                }else{
                    _NQStr = @"内勤";
                }
            }
            break;
        case 2:
             NSLog(@"%@%uld",textField.text,textField.text.length);
            if ([textField.placeholder isEqualToString:@"业务经理"]) {
                if (textField.text.length>0) {
                    _YWJLStr = textField.text;
                }else{
                    _YWJLStr = @"业务经理";
                }
            }else if ([textField.placeholder isEqualToString:@"业务总监"]){
                if (textField.text.length>0) {
                    _YWZJStr = textField.text;
                }else{
                    _YWZJStr = @"业务总监";
                }
            }else if ([textField.placeholder isEqualToString:@"业务"]){
                if (textField.text.length>0) {
                    _YWStr = textField.text;
                }else{
                    _YWStr = @"业务";
                }
            }else if ([textField.placeholder isEqualToString:@"市场总监"]){
                if (textField.text.length>0) {
                    _SCZJStr = textField.text;
                }else{
                    _SCZJStr = @"市场总监";
                }
            }
            else if ([textField.placeholder isEqualToString:@"市场经理"]){
                if (textField.text.length>0) {
                    _SCJLStr = textField.text;
                }else{
                    _SCJLStr = @"市场经理";
                }
            }
            else if ([textField.placeholder isEqualToString:@"美导"]){
                if (textField.text.length>0) {
                    _MDStr = textField.text;
                }else{
                    _MDStr = @"美导";
                }
            }else if ([textField.placeholder isEqualToString:@"行政管理"]){
                if (textField.text.length>0) {
                    _XZGLLStr = textField.text;
                }else{
                    _XZGLLStr = @"行政管理";
                }
            }else if ([textField.placeholder isEqualToString:@"物流"]){
                if (textField.text.length>0) {
                    _WLStr = textField.text;
                }else{
                    _WLStr = @"物流";
                }
            }
            else if ([textField.placeholder isEqualToString:@"内勤"]){
                if (textField.text.length>0) {
                    _NQStr = textField.text;
                }else{
                    _NQStr = @"内勤";
                }
            }
            break;
        case 3:
             NSLog(@"%@%uld",textField.text,textField.text.length);
            if ([textField.placeholder isEqualToString:@"业务经理"]) {
                if (textField.text.length>0) {
                    _YWJLStr = textField.text;
                }else{
                    _YWJLStr = @"业务经理";
                }
            }else if ([textField.placeholder isEqualToString:@"业务总监"]){
                if (textField.text.length>0) {
                    _YWZJStr = textField.text;
                }else{
                    _YWZJStr = @"业务总监";
                }
            }else if ([textField.placeholder isEqualToString:@"业务"]){
                if (textField.text.length>0) {
                    _YWStr = textField.text;
                }else{
                    _YWStr = @"业务";
                }
            }else if ([textField.placeholder isEqualToString:@"市场总监"]){
                if (textField.text.length>0) {
                    _SCZJStr = textField.text;
                }else{
                    _SCZJStr = @"市场总监";
                }
            }
            else if ([textField.placeholder isEqualToString:@"市场经理"]){
                if (textField.text.length>0) {
                    _SCJLStr = textField.text;
                }else{
                    _SCJLStr = @"市场经理";
                }
            }
            else if ([textField.placeholder isEqualToString:@"美导"]){
                if (textField.text.length>0) {
                    _MDStr = textField.text;
                }else{
                    _MDStr = @"美导";
                }
            }else if ([textField.placeholder isEqualToString:@"行政管理"]){
                if (textField.text.length>0) {
                    _XZGLLStr = textField.text;
                }else{
                    _XZGLLStr = @"行政管理";
                }
            }else if ([textField.placeholder isEqualToString:@"物流"]){
                if (textField.text.length>0) {
                    _WLStr = textField.text;
                }else{
                    _WLStr = @"物流";
                }
            }
            else if ([textField.placeholder isEqualToString:@"内勤"]){
                if (textField.text.length>0) {
                    _NQStr = textField.text;
                }else{
                    _NQStr = @"内勤";
                }
            }
            break;
        case 4:
             NSLog(@"%@%uld",textField.text,textField.text.length);
            if ([textField.placeholder isEqualToString:@"业务经理"]) {
                if (textField.text.length>0) {
                    _YWJLStr = textField.text;
                }else{
                    _YWJLStr = @"业务经理";
                }
            }else if ([textField.placeholder isEqualToString:@"业务总监"]){
                if (textField.text.length>0) {
                    _YWZJStr = textField.text;
                }else{
                    _YWZJStr = @"业务总监";
                }
            }else if ([textField.placeholder isEqualToString:@"业务"]){
                if (textField.text.length>0) {
                    _YWStr = textField.text;
                }else{
                    _YWStr = @"业务";
                }
            }else if ([textField.placeholder isEqualToString:@"市场总监"]){
                if (textField.text.length>0) {
                    _SCZJStr = textField.text;
                }else{
                    _SCZJStr = @"市场总监";
                }
            }
            else if ([textField.placeholder isEqualToString:@"市场经理"]){
                if (textField.text.length>0) {
                    _SCJLStr = textField.text;
                }else{
                    _SCJLStr = @"市场经理";
                }
            }
            else if ([textField.placeholder isEqualToString:@"美导"]){
                if (textField.text.length>0) {
                    _MDStr = textField.text;
                }else{
                    _MDStr = @"美导";
                }
            }else if ([textField.placeholder isEqualToString:@"行政管理"]){
                if (textField.text.length>0) {
                    _XZGLLStr = textField.text;
                }else{
                    _XZGLLStr = @"行政管理";
                }
            }else if ([textField.placeholder isEqualToString:@"物流"]){
                if (textField.text.length>0) {
                    _WLStr = textField.text;
                }else{
                    _WLStr = @"物流";
                }
            }
            else if ([textField.placeholder isEqualToString:@"内勤"]){
                if (textField.text.length>0) {
                    _NQStr = textField.text;
                }else{
                    _NQStr = @"内勤";
                }
            }
            break;
        case 5:
             NSLog(@"%@%uld",textField.text,textField.text.length);
            if ([textField.placeholder isEqualToString:@"业务经理"]) {
                if (textField.text.length>0) {
                    _YWJLStr = textField.text;
                }else{
                    _YWJLStr = @"业务经理";
                }
            }else if ([textField.placeholder isEqualToString:@"业务总监"]){
                if (textField.text.length>0) {
                    _YWZJStr = textField.text;
                }else{
                    _YWZJStr = @"业务总监";
                }
            }else if ([textField.placeholder isEqualToString:@"业务"]){
                if (textField.text.length>0) {
                    _YWStr = textField.text;
                }else{
                    _YWStr = @"业务";
                }
            }else if ([textField.placeholder isEqualToString:@"市场总监"]){
                if (textField.text.length>0) {
                    _SCZJStr = textField.text;
                }else{
                    _SCZJStr = @"市场总监";
                }
            }
            else if ([textField.placeholder isEqualToString:@"市场经理"]){
                if (textField.text.length>0) {
                    _SCJLStr = textField.text;
                }else{
                    _SCJLStr = @"市场经理";
                }
            }
            else if ([textField.placeholder isEqualToString:@"美导"]){
                if (textField.text.length>0) {
                    _MDStr = textField.text;
                }else{
                    _MDStr = @"美导";
                }
            }else if ([textField.placeholder isEqualToString:@"行政管理"]){
                if (textField.text.length>0) {
                    _XZGLLStr = textField.text;
                }else{
                    _XZGLLStr = @"行政管理";
                }
            }else if ([textField.placeholder isEqualToString:@"物流"]){
                if (textField.text.length>0) {
                    _WLStr = textField.text;
                }else{
                    _WLStr = @"物流";
                }
            }
            else if ([textField.placeholder isEqualToString:@"内勤"]){
                if (textField.text.length>0) {
                    _NQStr = textField.text;
                }else{
                    _NQStr = @"内勤";
                }
            }
            break;
        case 6:
             NSLog(@"%@%uld",textField.text,textField.text.length);
            if ([textField.placeholder isEqualToString:@"业务经理"]) {
                if (textField.text.length>0) {
                    _YWJLStr = textField.text;
                }else{
                    _YWJLStr = @"业务经理";
                }
            }else if ([textField.placeholder isEqualToString:@"业务总监"]){
                if (textField.text.length>0) {
                    _YWZJStr = textField.text;
                }else{
                    _YWZJStr = @"业务总监";
                }
            }else if ([textField.placeholder isEqualToString:@"业务"]){
                if (textField.text.length>0) {
                    _YWStr = textField.text;
                }else{
                    _YWStr = @"业务";
                }
            }else if ([textField.placeholder isEqualToString:@"市场总监"]){
                if (textField.text.length>0) {
                    _SCZJStr = textField.text;
                }else{
                    _SCZJStr = @"市场总监";
                }
            }
            else if ([textField.placeholder isEqualToString:@"市场经理"]){
                if (textField.text.length>0) {
                    _SCJLStr = textField.text;
                }else{
                    _SCJLStr = @"市场经理";
                }
            }
            else if ([textField.placeholder isEqualToString:@"美导"]){
                if (textField.text.length>0) {
                    _MDStr = textField.text;
                }else{
                    _MDStr = @"美导";
                }
            }else if ([textField.placeholder isEqualToString:@"行政管理"]){
                if (textField.text.length>0) {
                    _XZGLLStr = textField.text;
                }else{
                    _XZGLLStr = @"行政管理";
                }
            }else if ([textField.placeholder isEqualToString:@"物流"]){
                if (textField.text.length>0) {
                    _WLStr = textField.text;
                }else{
                    _WLStr = @"物流";
                }
            }
            else if ([textField.placeholder isEqualToString:@"内勤"]){
                if (textField.text.length>0) {
                    _NQStr = textField.text;
                }else{
                    _NQStr = @"内勤";
                }
            }
            break;
        case 7:
             NSLog(@"%@%uld",textField.text,textField.text.length);
            if ([textField.placeholder isEqualToString:@"业务经理"]) {
                if (textField.text.length>0) {
                    _YWJLStr = textField.text;
                }else{
                    _YWJLStr = @"业务经理";
                }
            }else if ([textField.placeholder isEqualToString:@"业务总监"]){
                if (textField.text.length>0) {
                    _YWZJStr = textField.text;
                }else{
                    _YWZJStr = @"业务总监";
                }
            }else if ([textField.placeholder isEqualToString:@"业务"]){
                if (textField.text.length>0) {
                    _YWStr = textField.text;
                }else{
                    _YWStr = @"业务";
                }
            }else if ([textField.placeholder isEqualToString:@"市场总监"]){
                if (textField.text.length>0) {
                    _SCZJStr = textField.text;
                }else{
                    _SCZJStr = @"市场总监";
                }
            }
            else if ([textField.placeholder isEqualToString:@"市场经理"]){
                if (textField.text.length>0) {
                    _SCJLStr = textField.text;
                }else{
                    _SCJLStr = @"市场经理";
                }
            }
            else if ([textField.placeholder isEqualToString:@"美导"]){
                if (textField.text.length>0) {
                    _MDStr = textField.text;
                }else{
                    _MDStr = @"美导";
                }
            }else if ([textField.placeholder isEqualToString:@"行政管理"]){
                if (textField.text.length>0) {
                    _XZGLLStr = textField.text;
                }else{
                    _XZGLLStr = @"行政管理";
                }
            }else if ([textField.placeholder isEqualToString:@"物流"]){
                if (textField.text.length>0) {
                    _WLStr = textField.text;
                }else{
                    _WLStr = @"物流";
                }
            }
            else if ([textField.placeholder isEqualToString:@"内勤"]){
                if (textField.text.length>0) {
                    _NQStr = textField.text;
                }else{
                    _NQStr = @"内勤";
                }
            }
            break;
        case 8:
             NSLog(@"%@%uld",textField.text,textField.text.length);
            if ([textField.placeholder isEqualToString:@"业务经理"]) {
                if (textField.text.length>0) {
                    _YWJLStr = textField.text;
                }else{
                    _YWJLStr = @"业务经理";
                }
            }else if ([textField.placeholder isEqualToString:@"业务总监"]){
                if (textField.text.length>0) {
                    _YWZJStr = textField.text;
                }else{
                    _YWZJStr = @"业务总监";
                }
            }else if ([textField.placeholder isEqualToString:@"业务"]){
                if (textField.text.length>0) {
                    _YWStr = textField.text;
                }else{
                    _YWStr = @"业务";
                }
            }else if ([textField.placeholder isEqualToString:@"市场总监"]){
                if (textField.text.length>0) {
                    _SCZJStr = textField.text;
                }else{
                    _SCZJStr = @"市场总监";
                }
            }
            else if ([textField.placeholder isEqualToString:@"市场经理"]){
                if (textField.text.length>0) {
                    _SCJLStr = textField.text;
                }else{
                    _SCJLStr = @"市场经理";
                }
            }
            else if ([textField.placeholder isEqualToString:@"美导"]){
                if (textField.text.length>0) {
                    _MDStr = textField.text;
                }else{
                    _MDStr = @"美导";
                }
            }else if ([textField.placeholder isEqualToString:@"行政管理"]){
                if (textField.text.length>0) {
                    _XZGLLStr = textField.text;
                }else{
                    _XZGLLStr = @"行政管理";
                }
            }else if ([textField.placeholder isEqualToString:@"物流"]){
                if (textField.text.length>0) {
                    _WLStr = textField.text;
                }else{
                    _WLStr = @"物流";
                }
            }
            else if ([textField.placeholder isEqualToString:@"内勤"]){
                if (textField.text.length>0) {
                    _NQStr = textField.text;
                }else{
                    _NQStr = @"内勤";
                }
            }
            break;
        case 9:
             NSLog(@"%@%uld",textField.text,textField.text.length);
            if ([textField.placeholder isEqualToString:@"业务经理"]) {
                if (textField.text.length>0) {
                    _YWJLStr = textField.text;
                }else{
                    _YWJLStr = @"业务经理";
                }
            }else if ([textField.placeholder isEqualToString:@"业务总监"]){
                if (textField.text.length>0) {
                    _YWZJStr = textField.text;
                }else{
                    _YWZJStr = @"业务总监";
                }
            }else if ([textField.placeholder isEqualToString:@"业务"]){
                if (textField.text.length>0) {
                    _YWStr = textField.text;
                }else{
                    _YWStr = @"业务";
                }
            }else if ([textField.placeholder isEqualToString:@"市场总监"]){
                if (textField.text.length>0) {
                    _SCZJStr = textField.text;
                }else{
                    _SCZJStr = @"市场总监";
                }
            }
            else if ([textField.placeholder isEqualToString:@"市场经理"]){
                if (textField.text.length>0) {
                    _SCJLStr = textField.text;
                }else{
                    _SCJLStr = @"市场经理";
                }
            }
            else if ([textField.placeholder isEqualToString:@"美导"]){
                if (textField.text.length>0) {
                    _MDStr = textField.text;
                }else{
                    _MDStr = @"美导";
                }
            }else if ([textField.placeholder isEqualToString:@"行政管理"]){
                if (textField.text.length>0) {
                    _XZGLLStr = textField.text;
                }else{
                    _XZGLLStr = @"行政管理";
                }
            }else if ([textField.placeholder isEqualToString:@"物流"]){
                if (textField.text.length>0) {
                    _WLStr = textField.text;
                }else{
                    _WLStr = @"物流";
                }
            }
            else if ([textField.placeholder isEqualToString:@"内勤"]){
                if (textField.text.length>0) {
                    _NQStr = textField.text;
                }else{
                    _NQStr = @"内勤";
                }
            }
            break;
            
        default:
            break;
    }

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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
    
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
    NSLog(@"%ld",(long)_xgtextFie.tag);

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
        
        [_YWBtn.layer setBorderColor:([UIColor orangeColor].CGColor)];
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
        
        [_YWBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
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
-(void)YWBtnClick:(UIButton *)btn{
    //业务
    
    if (YWBOOL == YES) {
        [_YWJLbTN.layer setBorderColor:([UIColor orangeColor].CGColor)];
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
        [_YWJLbTN.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
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
        
        [_MDBtn.layer setBorderColor:([UIColor orangeColor].CGColor)];
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
        
        [_MDBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
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
-(void)MDBtnClick:(UIButton *)btn{
    //美导
    if (MDBOOL == YES) {
        [_SCJLBtn.layer setBorderColor:([UIColor orangeColor].CGColor)];
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
        [_SCJLBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
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
-(void)footerButtonClick:(UIButton *)btn{
    
    if (QDBOOL == YES) {
        _asdjklView = [[UIView alloc]init];
        _asdjklView.backgroundColor  = [UIColor clearColor];
         [btn setTitle:@"修改" forState:UIControlStateNormal];
        _YWZJBtn.enabled = NO;
        _YWJLbTN.enabled = NO;
        _YWBtn.enabled = NO;
        _SCZJBtn.enabled = NO;
        _SCJLBtn.enabled = NO;
        _MDBtn.enabled = NO;
        _XZGLBtn.enabled = NO;
        _WLBtn.enabled = NO;
        _NQBtn.enabled = NO;
        QDBOOL =NO;
        [infonTableview addSubview:_asdjklView];
        [_asdjklView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).offset(0);
            make.top.mas_equalTo(infonTableview.tableHeaderView.mas_bottom).offset(20);
            make.right.mas_equalTo(self.view.mas_right).offset(0);
            make.height.mas_offset(30*_XZZWArry.count);
        }];
        }else{
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        _YWZJBtn.enabled = YES;
        _YWJLbTN.enabled = YES;
        _YWBtn.enabled = YES;
        _SCZJBtn.enabled = YES;
        _SCJLBtn.enabled = YES;
        _MDBtn.enabled = YES;
        _XZGLBtn.enabled = YES;
        _WLBtn.enabled = YES;
        _NQBtn.enabled = YES;
        QDBOOL = YES;//sendSubviewToBack
        [_asdjklView removeFromSuperview];
    }
    [self addTabcellViewUI];
}
-(void)addTabcellViewUI{
    
    if ([_footerButton.titleLabel.text isEqualToString:@"修改"]) {
        _popFootCellView = [[UIView alloc]init];
        _popFootCellView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:_popFootCellView];
        [_popFootCellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_footerButton.mas_bottom).offset(10);
            make.left.mas_equalTo(self.view.mas_left).offset(0);
            make.right.mas_equalTo(self.view.mas_right).offset(0);
            make.height.mas_offset(210);
        }];
        UILabel *zjlLabel = [[UILabel alloc]init];
        zjlLabel.text = _XGZJLStr;
        zjlLabel.font = [UIFont systemFontOfSize: 12.0];
        zjlLabel.textColor = [UIColor blackColor];
        zjlLabel.textAlignment = NSTextAlignmentCenter;
        [zjlLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [zjlLabel.layer setCornerRadius:3];
        [zjlLabel.layer setBorderWidth:1];//设置边界的宽度
        [zjlLabel.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        [_popFootCellView addSubview:zjlLabel];
        
        [zjlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo (_popFootCellView.mas_top).offset(10);
            make.centerX.mas_equalTo(_popFootCellView.mas_centerX).offset(0);
            make.width.mas_offset (70);
            make.height.mas_offset(21);
        }];
        UIView *view1 = [[UIView alloc]init];
        view1.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view1];
        if ((XZGLBOOL == NO && YWZJBOOL == NO )||
            (XZGLBOOL == NO && SCZJBOOL == NO)||
            (XZGLBOOL == NO && SCZJBOOL == NO && YWZJBOOL == NO)||
            (YWZJBOOL == NO && WLBOOL == NO)||
            (YWZJBOOL ==NO &&NQBOOL==NO)||
            (SCZJBOOL ==NO && WLBOOL==NO)||
            (SCZJBOOL ==NO && NQBOOL==NO)||
            (YWJLBOOL ==NO && WLBOOL ==NO)||
            (SCJLBOOL ==NO && NQBOOL ==NO)||
            (YWJLBOOL == NO && NQBOOL == NO)||
            (XZGLBOOL == NO && YWJLBOOL == NO && SCJLBOOL == NO)||
            (SCJLBOOL == NO && WLBOOL == NO)) {
            [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(zjlLabel.mas_bottom).offset(0);
                make.centerX.mas_equalTo(_popFootCellView.mas_centerX).offset(0);
                make.width.mas_offset(2);
                make.height.mas_offset(20);
            }];
        }else{
            [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(zjlLabel.mas_bottom).offset(0);
                make.centerX.mas_equalTo(_popFootCellView.mas_centerX).offset(0);
                make.width.mas_offset(2);
                make.height.mas_offset(0);
            }];
        }
        
        UIView * view2 = [[UIView alloc]init];
        view2.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view2];
        if ((XZGLBOOL == NO && YWZJBOOL == NO )||
            (XZGLBOOL == NO && SCZJBOOL == NO)||
            (XZGLBOOL == NO && SCZJBOOL == NO && YWZJBOOL == NO)||
            (YWZJBOOL == NO && WLBOOL == NO)||
            (YWZJBOOL ==NO &&NQBOOL==NO)||
            (SCZJBOOL ==NO && WLBOOL==NO)||
            (SCZJBOOL ==NO && NQBOOL==NO)||
            (YWJLBOOL ==NO && WLBOOL ==NO)||
            (SCJLBOOL ==NO && NQBOOL ==NO)||
            (YWJLBOOL == NO && NQBOOL == NO)||
            (XZGLBOOL == NO && YWJLBOOL == NO && SCJLBOOL == NO)||
            (SCJLBOOL == NO && WLBOOL == NO)) {
            [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view1.mas_bottom).offset(0);
                make.left.mas_equalTo(_popFootCellView.mas_left).offset(kWidth*200);
                make.right.mas_equalTo(_popFootCellView.mas_right).offset(-kWidth*160);
                make.height.mas_offset(2);
            }];

        }else{
            [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view1.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view1.mas_centerX).offset(0);
                make.width.mas_equalTo(2);
                make.height.mas_offset(2);
            }];
        }
        UIView *view3 = [[UIView alloc]init];
        view3.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view3];
        if (XZGLBOOL == NO || WLBOOL == NO ||NQBOOL == NO) {
            [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view2.mas_bottom).offset(0);
                make.right.mas_equalTo(view2.mas_right).offset(0);
                make.width.mas_offset(2);
                make.height.mas_offset(32);
            }];
        }
        
        
        UIView *view4 = [[UIView alloc]init];
        view4.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view4];
        if (YWZJBOOL == NO||SCZJBOOL == NO ||YWJLBOOL ==NO ||SCJLBOOL ==NO) {
            [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view2.mas_bottom).offset(0);
                make.left.mas_equalTo(view2.mas_left).offset(0);
                make.width.mas_offset(2);
                make.height.mas_offset(20);
            }];
        }
        UIView *view5 = [[UIView alloc]init];
        view5.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view5];
        if ((YWZJBOOL == NO && SCZJBOOL == NO) || (YWZJBOOL == NO && SCJLBOOL == NO)||(YWJLBOOL == NO && SCZJBOOL == NO)||(YWJLBOOL == NO && SCJLBOOL == NO)) {
            [view5 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view4.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view4.mas_centerX).offset(0);
                make.width.mas_offset(90);
                make.height.mas_offset(2);
            }];
        }
        else{
            [view5 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view4.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view4.mas_centerX).offset(0);
                make.width.mas_offset(2);
                make.height.mas_offset(2);
            }];
        }
        
        UIView *view6 = [[UIView alloc]init];
        view6.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view6];
        if (YWZJBOOL == NO || YWJLBOOL == NO) {
            [view6 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view5.mas_bottom).offset(0);
                make.left.mas_equalTo(view5.mas_left).offset(0);
                make.width.mas_equalTo(2);
                make.height.mas_equalTo(20);
            }];
        }else{
            [view6 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view5.mas_bottom).offset(0);
                make.left.mas_equalTo(view5.mas_left).offset(0);
                make.width.mas_equalTo(2);
                make.height.mas_equalTo(2);
            }];
        }
        
        UIView *view7 = [[UIView alloc]init];
        view7.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view7];
        if (SCZJBOOL == NO || SCJLBOOL == NO) {
            [view7 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view5.mas_bottom).offset(0);
                make.right.mas_equalTo(view5.mas_right).offset(0);
                make.width.mas_equalTo(2);
                make.height.mas_equalTo(20);
            }];
        }else{
            [view7 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view5.mas_bottom).offset(0);
                make.right.mas_equalTo(view5.mas_right).offset(0);
                make.width.mas_equalTo(2);
                make.height.mas_equalTo(2);
            }];
        }
        
        UILabel *ywzjLabel = [[UILabel alloc]init];
        [_popFootCellView addSubview:ywzjLabel];
        if (YWZJBOOL==NO) {
            ywzjLabel.text = _YWZJStr;
            ywzjLabel.font = [UIFont systemFontOfSize: 12.0];
            ywzjLabel.textColor = [UIColor blackColor];
            ywzjLabel.textAlignment = NSTextAlignmentCenter;
            [ywzjLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
            [ywzjLabel.layer setCornerRadius:3];
            [ywzjLabel.layer setBorderWidth:1];//设置边界的宽度
            [ywzjLabel.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
            [ywzjLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view6.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view6.mas_centerX).offset(0);
                make.width.mas_offset (70);
                make.height.mas_offset(21);
            }];
        }else{
            ywzjLabel.text = @"";
            ywzjLabel.backgroundColor = [UIColor lightGrayColor];
            [ywzjLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view6.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view6.mas_centerX).offset(0);
                make.width.mas_offset (2);
                make.height.mas_offset(2);
            }];
        }
        
        UILabel *sczjLabel = [[UILabel alloc]init];
        [_popFootCellView addSubview:sczjLabel];
        if (SCZJBOOL == NO) {
            sczjLabel.text = _SCZJStr;
            sczjLabel.font = [UIFont systemFontOfSize: 12.0];
            sczjLabel.textColor = [UIColor blackColor];
            sczjLabel.textAlignment = NSTextAlignmentCenter;
            [sczjLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
            [sczjLabel.layer setCornerRadius:3];
            [sczjLabel.layer setBorderWidth:1];//设置边界的宽度
            [sczjLabel.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
            [sczjLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view7.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view7.mas_centerX).offset(0);
                make.width.mas_offset (70);
                make.height.mas_offset(21);
            }];
        }else{
            sczjLabel.text = @"";
            sczjLabel.backgroundColor = [UIColor lightGrayColor];
            [sczjLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view7.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view7.mas_centerX).offset(0);
                make.width.mas_offset (2);
                make.height.mas_offset(2);
            }];
        }
        
        UILabel *xzglLabel = [[UILabel alloc]init];
        
        
        [_popFootCellView addSubview:xzglLabel];
        if (XZGLBOOL == NO) {
            xzglLabel.text = _XZGLLStr;
            xzglLabel.font = [UIFont systemFontOfSize: 12.0];
            xzglLabel.textColor = [UIColor blackColor];
            xzglLabel.textAlignment = NSTextAlignmentCenter;
            [xzglLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
            [xzglLabel.layer setCornerRadius:3];
            [xzglLabel.layer setBorderWidth:1];//设置边界的宽度
            [xzglLabel.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
            [xzglLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view3.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view3.mas_centerX).offset(0);
                make.width.mas_offset (70);
                make.height.mas_offset(21);
            }];
        }else{
            xzglLabel.text = @"";
            xzglLabel.backgroundColor = [UIColor lightGrayColor];
            [xzglLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view3.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view3.mas_centerX).offset(0);
                make.width.mas_offset (2);
                make.height.mas_offset(2);
            }];
        }
        
        UIView *view8 = [[UIView alloc]init];
        view8.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view8];
        if (YWJLBOOL == NO) {
            [view8 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(ywzjLabel.mas_bottom).offset(0);
                make.centerX.mas_equalTo(ywzjLabel.mas_centerX).offset(0);
                make.width.mas_equalTo(2);
                make.height.mas_equalTo(20);
            }];
        }
        UIView * view9 = [[UIView alloc]init];
        view9.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view9];
        if (SCJLBOOL == NO) {
            [view9 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(sczjLabel.mas_bottom).offset(0);
                make.centerX.mas_equalTo(sczjLabel.mas_centerX).offset(0);
                make.width.mas_equalTo(2);
                make.height.mas_equalTo(20);
            }];
        }
        
        UILabel *ywjlLabel = [[UILabel alloc]init];
        ywjlLabel.font = [UIFont systemFontOfSize: 12.0];
        ywjlLabel.textColor = [UIColor blackColor];
        ywjlLabel.textAlignment = NSTextAlignmentCenter;
        [ywjlLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [ywjlLabel.layer setCornerRadius:3];
        [ywjlLabel.layer setBorderWidth:1];//设置边界的宽度
        [ywjlLabel.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        [_popFootCellView addSubview:ywjlLabel];
        if (YWJLBOOL == NO) {
            ywjlLabel.text = _YWJLStr;
            [ywjlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view8.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view8.mas_centerX).offset(0);
                make.width.mas_offset (70);
                make.height.mas_offset(21);
            }];
        }else{
            ywjlLabel.text = @"";
            [ywjlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view8.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view8.mas_centerX).offset(0);
                make.width.mas_offset (0);
                make.height.mas_offset(0);
            }];
        }
        UILabel *scjlLabel = [[UILabel alloc]init];
        
        scjlLabel.font = [UIFont systemFontOfSize: 12.0];
        scjlLabel.textColor = [UIColor blackColor];
        scjlLabel.textAlignment = NSTextAlignmentCenter;
        [scjlLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [scjlLabel.layer setCornerRadius:3];
        [scjlLabel.layer setBorderWidth:1];//设置边界的宽度
        [scjlLabel.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        [_popFootCellView addSubview:scjlLabel];
        if (SCJLBOOL == NO) {
            scjlLabel.text = _SCJLStr;
            [scjlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view9.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view9.mas_centerX).offset(0);
                make.width.mas_offset (70);
                make.height.mas_offset(21);
            }];
        }else{
            scjlLabel.text = @"";
            [scjlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view9.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view9.mas_centerX).offset(0);
                make.width.mas_offset (0);
                make.height.mas_offset(0);
            }];
        }
        
        UIView *view10 = [[UIView alloc]init];
        view10.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view10];
        if (YWJLBOOL == NO) {
            [view10 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(ywjlLabel.mas_bottom).offset(0);
                make.centerX.mas_equalTo(ywjlLabel.mas_centerX).offset(0);
                make.width.mas_offset(2);
                make.height.mas_offset(20);
            }];
        }
        
        
        UIView *view11 = [[UIView alloc]init];
        view11.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view11];
        if (SCJLBOOL == NO) {
            [view11 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(scjlLabel.mas_bottom).offset(0);
                make.centerX.mas_equalTo(scjlLabel.mas_centerX).offset(0);
                make.width.mas_offset(2);
                make.height.mas_offset(20);
            }];
        }
        
        UILabel *ywLabel = [[UILabel alloc]init];
        
        ywLabel.font = [UIFont systemFontOfSize: 12.0];
        ywLabel.textColor = [UIColor blackColor];
        ywLabel.textAlignment = NSTextAlignmentCenter;
        [ywLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [ywLabel.layer setCornerRadius:3];
        [ywLabel.layer setBorderWidth:1];//设置边界的宽度
        [ywLabel.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        [_popFootCellView addSubview:ywLabel];
        if (YWBOOL == NO) {
            ywLabel.text = _YWStr;
            [ywLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view10.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view10.mas_centerX).offset(0);
                make.width.mas_offset (70);
                make.height.mas_offset(21);
            }];
        }else{
            ywLabel.text = @"";
            [ywLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view10.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view10.mas_centerX).offset(0);
                make.width.mas_offset (0);
                make.height.mas_offset(0);
            }];
        }
        
        UILabel *mdLabel = [[UILabel alloc]init];
        
        mdLabel.font = [UIFont systemFontOfSize: 12.0];
        mdLabel.textColor = [UIColor blackColor];
        mdLabel.textAlignment = NSTextAlignmentCenter;
        [mdLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [mdLabel.layer setCornerRadius:3];
        [mdLabel.layer setBorderWidth:1];//设置边界的宽度
        [mdLabel.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        [_popFootCellView addSubview:mdLabel];
        if (MDBOOL == NO) {
            mdLabel.text = _MDStr;
            [mdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view11.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view11.mas_centerX).offset(0);
                make.width.mas_offset (70);
                make.height.mas_offset(21);
            }];
        }else{
            mdLabel.text = @"";
            [mdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view11.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view11.mas_centerX).offset(0);
                make.width.mas_offset (0);
                make.height.mas_offset(0);
            }];
        }
        
        UIView *view12 = [[UIView alloc]init];
        view12.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view12];
        if (WLBOOL == NO ||NQBOOL == NO) {
            [view12 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(xzglLabel.mas_bottom).offset(0);
                make.centerX.mas_equalTo(xzglLabel.mas_centerX).offset(0);
                make.width.mas_offset(2);
                make.height.mas_offset(20);
            }];
        }
        
        UIView *view13 = [[UIView alloc]init];
        view13.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view13];
        if (WLBOOL ==NO && NQBOOL == NO) {
            [view13 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view12.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view12.mas_centerX).offset(0);
                make.width.mas_offset(70);
                make.height.mas_offset(2);
            }];
        }else{
            [view13 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view12.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view12.mas_centerX).offset(0);
                make.width.mas_offset(2);
                make.height.mas_offset(2);
            }];
        }
        
        UIView *view14 = [[UIView alloc]init];
        view14.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view14];
        if (WLBOOL == NO) {
            [view14 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view13.mas_bottom).offset(0);
                make.left.mas_equalTo(view13.mas_left).offset(0);
                make.width.mas_offset(2);
                make.height.mas_offset(20);
            }];
        }else{
            [view14 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view13.mas_bottom).offset(0);
                make.left.mas_equalTo(view13.mas_left).offset(0);
                make.width.mas_offset(0);
                make.height.mas_offset(0);
            }];
        }
        
        UIView *view15 = [[UIView alloc]init];
        view15.backgroundColor = [UIColor lightGrayColor];
        [_popFootCellView addSubview:view15];
        if (NQBOOL == NO) {
            [view15 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view13.mas_bottom).offset(0);
                make.right.mas_equalTo(view13.mas_right).offset(0);
                make.width.mas_offset(2);
                make.height.mas_offset(20);
            }];
        }else{
            [view15 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view13.mas_bottom).offset(0);
                make.right.mas_equalTo(view13.mas_right).offset(0);
                make.width.mas_offset(0);
                make.height.mas_offset(0);
            }];
        }
        
        UILabel *wlLabel = [[UILabel alloc]init];
        
        wlLabel.font = [UIFont systemFontOfSize: 12.0];
        wlLabel.textColor = [UIColor blackColor];
        wlLabel.textAlignment = NSTextAlignmentCenter;
        [wlLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [wlLabel.layer setCornerRadius:3];
        [wlLabel.layer setBorderWidth:1];//设置边界的宽度
        [wlLabel.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        [_popFootCellView addSubview:wlLabel];
        if (WLBOOL == NO) {
            wlLabel.text = _WLStr;
            [wlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view14.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view14.mas_centerX).offset(0);
                make.width.mas_offset (60);
                make.height.mas_offset(21);
            }];
        }else{
            wlLabel.text = @"";
            [wlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view14.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view14.mas_centerX).offset(0);
                make.width.mas_offset (0);
                make.height.mas_offset(0);
            }];
        }
        
        UILabel *nqLabel = [[UILabel alloc]init];
        
        nqLabel.font = [UIFont systemFontOfSize: 12.0];
        nqLabel.textColor = [UIColor blackColor];
        nqLabel.textAlignment = NSTextAlignmentCenter;
        [nqLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [nqLabel.layer setCornerRadius:3];
        [nqLabel.layer setBorderWidth:1];//设置边界的宽度
        [nqLabel.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
        [_popFootCellView addSubview:nqLabel];
        if (NQBOOL == NO) {
            nqLabel.text = _NQStr;
            [nqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view15.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view15.mas_centerX).offset(0);
                make.width.mas_offset (60);
                make.height.mas_offset(21);
            }];
        }else{
            nqLabel.text = @"";
            [nqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (view15.mas_bottom).offset(0);
                make.centerX.mas_equalTo(view15.mas_centerX).offset(0);
                make.width.mas_offset (0);
                make.height.mas_offset(0);
            }];
        }
        
        }else{
        [_popFootCellView removeFromSuperview];
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
