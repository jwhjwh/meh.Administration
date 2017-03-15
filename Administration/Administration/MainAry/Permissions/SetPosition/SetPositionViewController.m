//
//  SetPositionViewController.m
//  Administration
// 角色设定。  15根线 10个按钮 20个标签。20个texfiled
//  Created by 九尾狐 on 2017/3/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "SetPositionViewController.h"

@interface SetPositionViewController ()

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



@end

@implementation SetPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColor(255, 255, 255, 1);
    [self complexUI];
    // Do any additional setup after loading the view.
}
-(void)complexUI{
    _XZZWLabel = [[UILabel alloc]init];
    _XZZWLabel.text = @"请勾选您公司的职位";
    _XZZWLabel.textColor = GetColor(102, 102, 102, 1);
    [self.view addSubview:_XZZWLabel];
    [_XZZWLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.view.mas_top).offset(70);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo (self.view.mas_right).offset(-10);
        make.height.mas_offset(@21);
    }];
    _ZJLBtn = [[UIButton alloc]init];
    [_ZJLBtn setTitle:@"总经理" forState:UIControlStateNormal];
    [_ZJLBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_ZJLBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_ZJLBtn.layer setCornerRadius:2];
    [_ZJLBtn.layer setBorderWidth:2];//设置边界的宽度
    [_ZJLBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [self.view addSubview:_ZJLBtn];
    [_ZJLBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_XZZWLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.width.mas_offset (@100);
        make.height.mas_offset(@21);
    }];
    _view1 = [[UIView alloc]init];
    _view1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view1];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ZJLBtn.mas_bottom).offset(0);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(20);
    }];
    _view2 = [[UIView alloc]init];
    _view2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view2];
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view1.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(130);
        make.right.mas_equalTo(self.view.mas_right).offset(-100);
        make.height.mas_offset(2);
    }];
    _view3 = [[UIView alloc]init];
    _view3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view3];
    [_view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view2.mas_bottom).offset(0);
        make.left.mas_equalTo(_view2.mas_left).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(20);
    }];
    _view4 = [[UIView alloc]init];
    _view4.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view4];
    [_view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view3.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view3.mas_centerX).offset(0);
        make.width.mas_offset(90);
        make.height.mas_offset(2);
    }];
    _view5 = [[UIView alloc]init];
    _view5.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view5];
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
    [_YWZJBtn.layer setCornerRadius:2];
    [_YWZJBtn.layer setBorderWidth:2];//设置边界的宽度
    [_YWZJBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [self.view addSubview:_YWZJBtn];
    [_YWZJBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view5.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view5.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view6 = [[UIView alloc]init];
    _view6.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view6];
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
    [_YWJLbTN.layer setCornerRadius:2];
    [_YWJLbTN.layer setBorderWidth:2];//设置边界的宽度
    [_YWJLbTN.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [self.view addSubview:_YWJLbTN];
    [_YWJLbTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view6.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view6.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view7 = [[UIView alloc]init];
    _view7.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view7];
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
    [_YWBtn.layer setCornerRadius:2];
    [_YWBtn.layer setBorderWidth:2];//设置边界的宽度
    [_YWBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [self.view addSubview:_YWBtn];
    [_YWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view7.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view7.mas_centerX).offset(0);
        make.width.mas_offset (@60);
        make.height.mas_offset(@21);
    }];
    _view8 = [[UIView alloc]init];
    _view8.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view8];
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
    [_SCZJBtn.layer setCornerRadius:2];
    [_SCZJBtn.layer setBorderWidth:2];//设置边界的宽度
    [_SCZJBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [self.view addSubview:_SCZJBtn];
    [_SCZJBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view8.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view8.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view9 = [[UIView alloc]init];
    _view9.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view9];
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
    [_SCJLBtn.layer setCornerRadius:2];
    [_SCJLBtn.layer setBorderWidth:2];//设置边界的宽度
    [_SCJLBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [self.view addSubview:_SCJLBtn];
    [_SCJLBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view9.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view9.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view10 = [[UIView alloc]init];
    _view10.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view10];
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
    [_MDBtn.layer setCornerRadius:2];
    [_MDBtn.layer setBorderWidth:2];//设置边界的宽度
    [_MDBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [self.view addSubview:_MDBtn];
    [_MDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view10.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view10.mas_centerX).offset(0);
        make.width.mas_offset (@60);
        make.height.mas_offset(@21);
    }];
    _view11 = [[UIView alloc]init];
    _view11.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view11];
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
    [_XZGLBtn.layer setCornerRadius:2];
    [_XZGLBtn.layer setBorderWidth:2];//设置边界的宽度
    [_XZGLBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [self.view addSubview:_XZGLBtn];
    [_XZGLBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view11.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view11.mas_centerX).offset(0);
        make.width.mas_offset (@70);
        make.height.mas_offset(@21);
    }];
    _view12 = [[UIView alloc]init];
    _view12.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view12];
    [_view12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_XZGLBtn.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view11.mas_centerX).offset(0);
        make.width.mas_offset(2);
        make.height.mas_offset(10);
    }];
    _view13 = [[UIView alloc]init];
    _view13.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view13];
    [_view13 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view12.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view12.mas_centerX).offset(0);
        make.width.mas_offset(70);
        make.height.mas_offset(2);
    }];
    _view14 = [[UIView alloc]init];
    _view14.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view14];
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
    [_WLBtn.layer setCornerRadius:2];
    [_WLBtn.layer setBorderWidth:2];//设置边界的宽度
    [_WLBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [self.view addSubview:_WLBtn];
    [_WLBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view14.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view14.mas_centerX).offset(0);
        make.width.mas_offset (@60);
        make.height.mas_offset(@21);
    }];
    _view15 = [[UIView alloc]init];
    _view15.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view15];
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
    [_NQBtn.layer setCornerRadius:2];
    [_NQBtn.layer setBorderWidth:2];//设置边界的宽度
    [_NQBtn.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [self.view addSubview:_NQBtn];
    [_NQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_view15.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_view15.mas_centerX).offset(0);
        make.width.mas_offset (@60);
        make.height.mas_offset(@21);
    }];





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
