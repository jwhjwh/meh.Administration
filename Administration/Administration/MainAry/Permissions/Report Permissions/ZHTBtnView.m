//
//  ZHTBtnView.m
//  Administration
//
//  Created by 九尾狐 on 2017/4/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ZHTBtnView.h"


#define WIDTHh [UIScreen mainScreen].bounds.size.width

#define HEIGHTt [UIScreen mainScreen].bounds.size.height

@implementation ZHTBtnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr coode:(int)coode numarr:(NSArray *)numarr
{
    self = [super initWithFrame:frame];
    if (self) {
        //布局子视图
        _ywAry =arr;
        _numAry = numarr;
        _copde = coode;
        [self subViewUI];
        self.backgroundColor = [UIColor whiteColor];
        _NSywAry = [[NSMutableArray alloc]init];
        _NSmdAry = [[NSMutableArray alloc]init];
        _NSwlAry = [[NSMutableArray alloc]init];
        _NSnqAry = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)subViewUI{
    UILabel *xiaoBT = [[UILabel alloc]init];
    switch (_copde) {
        case 5:
            xiaoBT.text = @"业务报表:";
            break;
        case 2:
            xiaoBT.text = @"美导报表:";
            break;
        case 4:
            xiaoBT.text = @"物流报表:";
            break;
        case 3:
            xiaoBT.text = @"内勤报表:";
            break;
            
        default:
            break;
    }
    xiaoBT.font = [UIFont systemFontOfSize:kWidth*22];
    [self addSubview:xiaoBT];
    [xiaoBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    UILabel *ywLabel = [[UILabel alloc]init];
    switch (_copde) {
        case 5:
            ywLabel.text = @"业务";
            break;
        case 2:
            ywLabel.text = @"美导";
            break;
        case 4:
            ywLabel.text = @"物流";
            break;
        case 3:
            ywLabel.text = @"内勤";
            break;
            
        default:
            break;
    }
    ywLabel.textColor = GetColor(101, 101, 101, 1);
    ywLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    ywLabel.layer.borderWidth = 1.0f;
    ywLabel.layer.cornerRadius = 3.0f;
    ywLabel.backgroundColor = [UIColor whiteColor];
    ywLabel.layer.masksToBounds = YES;
    ywLabel.textAlignment = NSTextAlignmentCenter;
    ywLabel.font = [UIFont systemFontOfSize:kWidth*30];
    [self addSubview:ywLabel];
    
    [ywLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(xiaoBT.mas_bottom).offset(0);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(25);
    }];
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ywLabel.mas_bottom).offset(0);
        make.centerX.mas_equalTo(ywLabel.mas_centerX).offset(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(25);
    }];
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view1.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(50);
        make.right.mas_equalTo(self.mas_right).offset(-50);
        make.height.mas_equalTo(1);
    }];
    [self viewww:50 yy:171 v:view2];
    UILabel *changBT = [[UILabel alloc]init];
    changBT.text = @"可对报表标注的职位:";
    changBT.font = [UIFont systemFontOfSize:kWidth*22];
    [self addSubview:changBT];
    [changBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(view2.mas_top).offset(-5);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(view1.mas_left).offset(-10);
        make.height.mas_equalTo(20);
    }];


}
-(UIView *)viewww:(CGFloat)xx yy:(CGFloat)yy v:(UIView*)v{
    UIView* vieww = [[UIView alloc]init];
    [self addSubview:vieww];
    [vieww mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(v.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(20);
        
    }];
    for (int i = 0; i<_ywAry.count; i++) {
        UIView* viewww = [[UIView alloc]init];
        viewww.frame = CGRectMake((Scree_width-100)/(_ywAry.count-1)*i+xx, 0
                                  , 1, 20);
        viewww.backgroundColor = [UIColor lightGrayColor];
        [vieww addSubview:viewww];
    }
    
    [self viewbuton:50 yy:201  v:vieww tagg:_copde];
    return vieww;
}
-(UIView *)viewbuton:(CGFloat)xx yy:(CGFloat)yy  v:(UIView*)v tagg:(int)tagg{
    _viewbuton = [[UIView alloc]init];
    _viewbuton.tag = tagg;
    [self addSubview:_viewbuton];
    [_viewbuton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(v.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(30);
    }];
    _imageAry = [[NSMutableArray alloc]init];
    for (int i = 0; i<_ywAry.count; i ++) {
        _buttonname= [[UIButton alloc]init];
        [_buttonname setTitle:_ywAry[i] forState:UIControlStateNormal];
        _buttonname.frame = CGRectMake((Scree_width-100)/(_ywAry.count-1)*i+xx-(Scree_width-80)/4/2, 0, (Scree_width-80)/4, 25);
        
        _buttonname.tag = i;
        
        
        _buttonname.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _buttonname.layer.borderWidth = 1.0f;
        _buttonname.layer.cornerRadius = 2.0f;
        _buttonname.layer.masksToBounds = YES;
        [_buttonname setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _buttonname.font = [UIFont systemFontOfSize:kWidth*30];
        [_buttonname addTarget:self action:@selector(BtnClick: imageee:)forControlEvents:UIControlEventTouchUpInside];
       _gouimage1 = [[UIImageView alloc]init];
        _gouimage1.frame = CGRectMake(((Scree_width-80)/4)-10, 15, 10, 10);
        _gouimage1.tag= i;
        _gouimage1.image = [UIImage imageNamed:@""];
        [_imageAry addObject:_gouimage1];
        [_buttonname addSubview:_gouimage1];
        [_viewbuton addSubview:_buttonname];
    }
    
    
        [self xianViewUI];
    return _viewbuton;
}
-(void)xianViewUI{
    UIView *xxview = [[UIView alloc]init];
    xxview.backgroundColor  = GetColor(218, 218, 218, 1);
    [self addSubview:xxview];
    [xxview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_viewbuton.mas_bottom).offset(10);
        make.left.mas_equalTo(_viewbuton.mas_left).offset(10);
        make.right.mas_equalTo(_viewbuton.mas_right).offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    _qdbutton = [[UIButton alloc]init];
    [_qdbutton setTitle:@"确定" forState:UIControlStateNormal];
    _qdbutton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _qdbutton.layer.borderWidth = 1.0f;
    _qdbutton.layer.cornerRadius = 2.0f;
    _qdbutton.layer.masksToBounds = YES;
    [_qdbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _qdbutton.font = [UIFont systemFontOfSize:kWidth*30];
    _qdbutton.backgroundColor = [UIColor whiteColor];
    [_qdbutton addTarget:self action:@selector(qdbtnClick:)forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_qdbutton];
    [_qdbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(xxview.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.width.mas_equalTo(kWidth*150);
        make.height.mas_equalTo(25);
    }];
}
-(void)updatenetworkingNumarr:(int )power numarr:(NSArray*)numarr{
    NSString *urlStr = [NSString stringWithFormat:@"%@manager/updateReportPermission.action", KURLHeader];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *poower = [NSString stringWithFormat:@"%d", power];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"Num":poower,@"Power":[NSString stringWithFormat:@"%@",numarr]};
    NSLog(@"%@",dic);
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSLog(@"上传成功");
        }else{
            NSLog(@"上传失败");
        }
    } failure:^(NSError *error) {
        
    } view:self MBPro:YES];

}
-(void)qdbtnClick:(UIButton *)btn{
    switch (_viewbuton.tag) {
        case 5:
            [self updatenetworkingNumarr:5 numarr:_NSywAry];
            break;
        case 2:
            NSLog(@"点的是美导的确定");
            [self updatenetworkingNumarr:2 numarr:_NSmdAry];
            break;
            
        case 4:
            NSLog(@"点的是物流的确定");
            [self updatenetworkingNumarr:4 numarr:_NSwlAry];
            break;
        case 3:
            NSLog(@"点的是内勤的确定");
            [self updatenetworkingNumarr:3 numarr:_NSnqAry];
            break;
        default:
            break;
    }
}
-(void)buttonblueColorbackcolor{
    switch (_viewbuton.tag) {
        case 5:
            [_qdbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor blueColor] CGColor];
            _qdbutton.enabled = YES;
            break;
        case 2:
            [_qdbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor blueColor] CGColor];
            _qdbutton.enabled = YES;
            break;
        case 4:
            [_qdbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor blueColor] CGColor];
            _qdbutton.enabled = YES;
            break;
        case 3:
            [_qdbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor blueColor] CGColor];
            _qdbutton.enabled = YES;
            break;
            
        default:
            break;
    }
}
-(void)buttonligbackcolor{
    switch (_viewbuton.tag) {
        case 5:
            [_qdbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            _qdbutton.enabled = NO;
            break;
        case 2:
            [_qdbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            _qdbutton.enabled = NO;
            break;
        case 4:
            [_qdbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            _qdbutton.enabled = NO;
            break;
        case 3:
            [_qdbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            _qdbutton.enabled = NO;
            break;
            
        default:
            break;
    }

}
-(void)BtnClick:(UIButton *)btn imageee:(UIImageView *)ima{
    switch (_viewbuton.tag) {
        case 5:
            switch (btn.tag) {
                case 0:
                    _gouimage1 = _imageAry[0];
                    if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                        _gouimage1.image = [UIImage imageNamed:@""];
                        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        [_NSywAry removeObject:_numAry[btn.tag]];
                        if (_NSmdAry.count == 0) {
                            [self buttonligbackcolor];
                        }
                        
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSywAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                case 1:
                    _gouimage1 = _imageAry[1];
                     if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                         _gouimage1.image = [UIImage imageNamed:@""];
                         btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                         [_NSywAry removeObject:_numAry[btn.tag]];
                         if (_NSmdAry.count == 0) {
                             [self buttonligbackcolor];
                         }
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSywAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                case 2:
                    _gouimage1 = _imageAry[2];
                    if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                        _gouimage1.image = [UIImage imageNamed:@""];
                        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        [_NSywAry removeObject:_numAry[btn.tag]];
                        if (_NSmdAry.count == 0) {
                            [self buttonligbackcolor];
                        }
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSywAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                case 3:
                    _gouimage1 = _imageAry[3];
                     if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                         _gouimage1.image = [UIImage imageNamed:@""];
                         btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                         [_NSywAry removeObject:_numAry[btn.tag]];
                         if (_NSmdAry.count == 0) {
                             [self buttonligbackcolor];
                         }
                    }else{

                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSywAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (btn.tag) {
                case 0:
                    _gouimage1 = _imageAry[0];
                    if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                        _gouimage1.image = [UIImage imageNamed:@""];
                        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        [_NSmdAry removeObject:_numAry[btn.tag]];
                        if (_NSmdAry.count == 0) {
                            [self buttonligbackcolor];
                        }
                        
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSmdAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                        
                    }
                    break;
                case 1:
                    _gouimage1 = _imageAry[1];
                    if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                        _gouimage1.image = [UIImage imageNamed:@""];
                        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        [_NSmdAry removeObject:_numAry[btn.tag]];
                        if (_NSmdAry.count == 0) {
                            [self buttonligbackcolor];
                        }
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSmdAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                case 2:
                    _gouimage1 = _imageAry[2];
                    if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                        _gouimage1.image = [UIImage imageNamed:@""];
                        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        [_NSmdAry removeObject:_numAry[btn.tag]];
                        if (_NSmdAry.count == 0) {
                            [self buttonligbackcolor];
                        }
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSmdAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                case 3:
                    _gouimage1 = _imageAry[3];
                    if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                        _gouimage1.image = [UIImage imageNamed:@""];
                        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        [_NSmdAry removeObject:_numAry[btn.tag]];
                        if (_NSmdAry.count == 0) {
                            [self buttonligbackcolor];
                        }
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSmdAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                default:
                    break;
            }
            break;
        case 4:
            switch (btn.tag) {
                case 0:
                    _gouimage1 = _imageAry[0];
                     if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                         _gouimage1.image = [UIImage imageNamed:@""];
                         btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                         [_NSwlAry removeObject:_numAry[btn.tag]];
                         if (_NSwlAry.count == 0) {
                             [self buttonligbackcolor];
                         }
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSwlAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                case 1:
                    _gouimage1 = _imageAry[1];
                    if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                        _gouimage1.image = [UIImage imageNamed:@""];
                        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        [_NSwlAry removeObject:_numAry[btn.tag]];
                        if (_NSwlAry.count == 0) {
                            [self buttonligbackcolor];
                        }
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSwlAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                case 2:
                    _gouimage1 = _imageAry[2];
                    if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                        _gouimage1.image = [UIImage imageNamed:@""];
                        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        [_NSwlAry removeObject:_numAry[btn.tag]];
                        if (_NSwlAry.count == 0) {
                            [self buttonligbackcolor];
                        }
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSwlAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                case 3:
                    _gouimage1 = _imageAry[3];
                    if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                        _gouimage1.image = [UIImage imageNamed:@""];
                        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        [_NSwlAry removeObject:_numAry[btn.tag]];
                        if (_NSwlAry.count == 0) {
                            [self buttonligbackcolor];
                        }
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSwlAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (btn.tag) {
                case 0:
                    _gouimage1 = _imageAry[0];
                    if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                        _gouimage1.image = [UIImage imageNamed:@""];
                        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        [_NSnqAry removeObject:_numAry[btn.tag]];
                        if (_NSnqAry.count == 0) {
                            [self buttonligbackcolor];
                        }
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSnqAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                case 1:
                    _gouimage1 = _imageAry[1];
                    if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                        _gouimage1.image = [UIImage imageNamed:@""];
                        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        [_NSnqAry removeObject:_numAry[btn.tag]];
                        if (_NSnqAry.count == 0) {
                            [self buttonligbackcolor];
                        }
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSnqAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                case 2:
                    _gouimage1 = _imageAry[2];
                    if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                        _gouimage1.image = [UIImage imageNamed:@""];
                        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        [_NSnqAry removeObject:_numAry[btn.tag]];
                        if (_NSnqAry.count == 0) {
                            [self buttonligbackcolor];
                        }
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSnqAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                case 3:
                    _gouimage1 = _imageAry[3];
                    if ([_gouimage1.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
                        _gouimage1.image = [UIImage imageNamed:@""];
                        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        [_NSnqAry removeObject:_numAry[btn.tag]];
                        if (_NSnqAry.count == 0) {
                            [self buttonligbackcolor];
                        }
                    }else{
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
                        [_NSnqAry addObject:_numAry[btn.tag]];
                        [self buttonblueColorbackcolor];
                    }
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }

}


@end
