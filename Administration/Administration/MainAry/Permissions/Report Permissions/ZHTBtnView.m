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
        _NSkfAry = [[NSMutableArray alloc]init];
        _NSckAry = [[NSMutableArray alloc]init];
        _NScnAry = [[NSMutableArray alloc]init];
        _NScwjlAry = [[NSMutableArray alloc]init];
        _NSwljlAry = [[NSMutableArray alloc]init];
        _NSkfjlAry = [[NSMutableArray alloc]init];
        _NSscjlAry = [[NSMutableArray alloc]init];
        _NSywjlAry = [[NSMutableArray alloc]init];
        _NSkjAry = [[NSMutableArray alloc]init];
        
         _NSywoldAry = [[NSArray alloc]init];
         _NSmdoldAry = [[NSArray alloc]init];
         _NSwloldAry = [[NSArray alloc]init];
         _NSkfoldAry = [[NSArray alloc]init];
         _NSckoldAry = [[NSArray alloc]init];
         _NScnoldAry = [[NSArray alloc]init];
         _NScwjloldAry = [[NSArray alloc]init];
         _NSwljloldAry = [[NSArray alloc]init];
         _NSkfjloldAry = [[NSArray alloc]init];
         _NSscjloldAry = [[NSArray alloc]init];
         _NSywjloldAry = [[NSArray alloc]init];
         _NSkjoldAry = [[NSArray alloc]init];
        
        
        
        
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr coode:(int)coode numarr:(NSArray *)numarr powerAry:(NSArray*)powerAry
{
    self = [super initWithFrame:frame];
    if (self) {
        //布局子视图
        _ywAry =arr;
        _numAry = numarr;
        _copde = coode;
        _powerAry = powerAry;
        [self subViewUI];
        self.backgroundColor = [UIColor whiteColor];
        _NSywAry = [[NSMutableArray alloc]init];
        _NSmdAry = [[NSMutableArray alloc]init];
        _NSwlAry = [[NSMutableArray alloc]init];
        _NSkfAry = [[NSMutableArray alloc]init];
        _NSckAry = [[NSMutableArray alloc]init];
        _NScnAry = [[NSMutableArray alloc]init];
        _NScwjlAry = [[NSMutableArray alloc]init];
        _NSwljlAry = [[NSMutableArray alloc]init];
        _NSkfjlAry = [[NSMutableArray alloc]init];
        _NSscjlAry = [[NSMutableArray alloc]init];
        _NSywjlAry = [[NSMutableArray alloc]init];
        _NSkjAry = [[NSMutableArray alloc]init];
        
        
        _NSywoldAry = [[NSArray alloc]init];
        _NSmdoldAry = [[NSArray alloc]init];
        _NSwloldAry = [[NSArray alloc]init];
        _NSkfoldAry = [[NSArray alloc]init];
        _NSckoldAry = [[NSArray alloc]init];
        _NScnoldAry = [[NSArray alloc]init];
        _NScwjloldAry = [[NSArray alloc]init];
        _NSwljloldAry = [[NSArray alloc]init];
        _NSkfjloldAry = [[NSArray alloc]init];
        _NSscjloldAry = [[NSArray alloc]init];
        _NSywjloldAry = [[NSArray alloc]init];
        _NSkjoldAry = [[NSArray alloc]init];
        
        switch (_copde) {
            case 5:
                [_NSywAry addObjectsFromArray: powerAry];
                _NSywoldAry = powerAry;
                break;
            case 2:
                
                [_NSmdAry addObjectsFromArray: powerAry];
                _NSmdoldAry = powerAry;
                break;
            case 4:
                
                [_NSwlAry addObjectsFromArray:powerAry];
                _NSwloldAry = powerAry;
                break;
            case 3:
                [_NSkfAry addObjectsFromArray:powerAry];
                _NSkfoldAry = powerAry;
                break;
            case 14:
    
                [_NSckAry addObjectsFromArray:powerAry];
                _NSckoldAry = powerAry;
                break;
            case 16:
               
                [_NSkjAry addObjectsFromArray:powerAry];
                _NSkjoldAry = powerAry;
                break;
            case 17:
                
                [_NScnAry addObjectsFromArray:powerAry];
                _NScnoldAry = powerAry;
                break;
            case 15:
               
                [_NScwjlAry addObjectsFromArray:powerAry];
                _NScwjloldAry = powerAry;
                break;
            case 13:
               
                [_NSwljlAry addObjectsFromArray:powerAry];
                _NSwljloldAry = powerAry;
                break;
            case 12:
                
                [_NSkfjlAry addObjectsFromArray:powerAry];
                _NSkfjloldAry = powerAry;
                break;
            case 6:
                
                [_NSscjlAry addObjectsFromArray:powerAry];
                _NSscjloldAry = powerAry;
                break;
            case 8:
                
                [_NSywjlAry addObjectsFromArray:powerAry];
                _NSywjloldAry = powerAry;
                break;
                
            default:
                break;
        }
        

        
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
            xiaoBT.text = @"客服报表:";
            break;
        case 14:
            xiaoBT.text = @"仓库报表:";
            break;
        case 16:
            xiaoBT.text = @"会计报表:";
            break;
        case 17:
            xiaoBT.text = @"出纳报表:";
            break;
        case 15:
            xiaoBT.text = @"财务经理报表:";
            break;
        case 13:
            xiaoBT.text = @"物流经理报表:";
            break;
        case 12:
            xiaoBT.text = @"客服经理报表:";
            break;
        case 6:
            xiaoBT.text = @"市场经理报表:";
            break;
        case 8:
            xiaoBT.text = @"业务经理报表:";
            break;
            
        default:
            break;
    }
    xiaoBT.font = [UIFont systemFontOfSize:kWidth*22];
    [self addSubview:xiaoBT];
    [xiaoBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.width.mas_equalTo(80);
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
            ywLabel.text = @"客服";
            break;
        case 14:
            ywLabel.text = @"仓库";
            break;
        case 16:
            ywLabel.text = @"会计";
            break;
        case 17:
            ywLabel.text = @"出纳";
            break;
        case 15:
            ywLabel.text = @"财务经理";
            break;
        case 13:
            ywLabel.text = @"物流经理";
            break;
        case 12:
            ywLabel.text = @"客服经理";
            break;
        case 6:
            ywLabel.text = @"市场经理";
            break;
        case 8:
            ywLabel.text = @"业务经理";
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
        make.width.mas_equalTo(kWidth*150);
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
        if (_copde == 3) {
            make.left.mas_equalTo(self.mas_left).offset(40);
            make.right.mas_equalTo(self.mas_right).offset(-40);
        }else if (_ywAry.count ==1) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
            make.width.mas_offset(1);
        }
        else{
            make.left.mas_equalTo(self.mas_left).offset(50);
            make.right.mas_equalTo(self.mas_right).offset(-50);
        }
        
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
    if (_ywAry.count == 1) {
        UIView* viewww = [[UIView alloc]init];
        viewww.frame = CGRectMake((Scree_width/2)-0.5, 0
                                  , 1, 20);
        viewww.backgroundColor = [UIColor lightGrayColor];
        [vieww addSubview:viewww];
    }else{
        for (int i = 0; i<_ywAry.count; i++) {
            UIView* viewww = [[UIView alloc]init];
            if (_copde ==3) {
                viewww.frame = CGRectMake(((Scree_width-80)/(_ywAry.count-1))*i+40, 0
                                          , 1, 20);
            }else{
                viewww.frame = CGRectMake((Scree_width-100)/(_ywAry.count-1)*i+xx, 0
                                          , 1, 20);
            }
            
            viewww.backgroundColor = [UIColor lightGrayColor];
            [vieww addSubview:viewww];
        }
        

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
    _buttonAry = [[NSMutableArray alloc]init];
    for (int i = 0; i<_ywAry.count; i ++) {
        _buttonname= [[UIButton alloc]init];
        [_buttonname setTitle:_ywAry[i] forState:UIControlStateNormal];
        NSString *namele = _ywAry[i];
        if (_copde == 3) {
           _buttonname.frame = CGRectMake(((Scree_width-80)/(_ywAry.count-1))*i+40-namele.length*(kWidth*40)/2, 0, namele.length*(kWidth*35), 25);
            
            _buttonname.font = [UIFont systemFontOfSize:kWidth*25];
        }else if (_ywAry.count == 1){
            _buttonname.frame = CGRectMake((Scree_width/2)-namele.length*(kWidth*40)/2, 0, namele.length*(kWidth*40), 25);
            _buttonname.font = [UIFont systemFontOfSize:kWidth*30];
        }else{
         _buttonname.frame = CGRectMake((Scree_width-100)/(_ywAry.count-1)*i+xx-namele.length*(kWidth*40)/2, 0, namele.length*(kWidth*40), 25);
            _buttonname.font = [UIFont systemFontOfSize:kWidth*30];
        }
        _buttonname.tag = i;
        
        _buttonname.layer.borderWidth = 1.0f;
        _buttonname.layer.cornerRadius = 2.0f;
        _buttonname.layer.masksToBounds = YES;
        [_buttonname setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_buttonname addTarget:self action:@selector(BtnClick:)forControlEvents:UIControlEventTouchUpInside];
        
        [_buttonAry addObject:_buttonname];
       _gouimage1 = [[UIImageView alloc]init];
        if (_copde == 3) {
            _gouimage1.frame = CGRectMake(namele.length*(kWidth*40)-20, 15, 10, 10);
        }else
        {
        _gouimage1.frame = CGRectMake(namele.length*(kWidth*40)-10, 15, 10, 10);
        }
        
        _gouimage1.tag= i;
        
        [_imageAry addObject:_gouimage1];
        
        _buttonname.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _gouimage1.image = [UIImage imageNamed:@""];
        
        [_buttonname addSubview:_gouimage1];
        [_viewbuton addSubview:_buttonname];
    }
    for (int i = 0; i<_powerAry.count; i++) {
        for (NSString *strr in _powerAry) {
            NSString *str3 = [strr stringByReplacingOccurrencesOfString: @" " withString:@""];
            NSInteger num = [str3 integerValue];
            NSNumber *nums = @(num);
            BOOL isbool = [_numAry containsObject: nums];
            if (isbool == YES) {
                for (int j =0; j<_numAry.count; j++) {
                    if (_numAry[j]==nums) {
                        _gouimage1 = _imageAry[j];
                        _buttonname = _buttonAry[j];
                        _buttonname.layer.borderColor = [[UIColor orangeColor] CGColor];
                        _gouimage1.image = [UIImage imageNamed:@"xz_ico1"];
                    }
                }
                
            }
        }
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
-(void)updatenetworkingNumarr:(int )power numarr:(NSMutableArray*)numarr{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@manager/updateReportPermission.action", KURLHeader];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *poower = [NSString stringWithFormat:@"%d", power];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString*sttt;
    [numarr removeObject:@""""];
//    if (numarr.count>0) {
//        NSError *error = nil;
//        
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:numarr options:NSJSONWritingPrettyPrinted error:&error];
//      sttt = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    }else{
//        sttt = @"";
//    }
    [numarr removeObject:@"0"];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"Num":poower,@"Power":[NSString stringWithFormat:@"%@",numarr]};

    //dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"Num":poower,@"Power":sttt};
    NSLog(@"---%@",numarr);
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"修改成功" sureBtn:@"确认" cancleBtn:nil];
            [alertView showMKPAlertView];
        }else{
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"修改失败" sureBtn:@"确认" cancleBtn:nil];
            [alertView showMKPAlertView];
        }
    } failure:^(NSError *error) {
        
    } view:self MBPro:YES];

}
-(void)qdbtnClick:(UIButton *)btn{
    switch (_viewbuton.tag) {
        case 5:
            if (btn.layer.borderColor == [[UIColor blueColor] CGColor]) {
                 [self updatenetworkingNumarr:5 numarr:_NSywAry];
            }
            break;
        case 2:
            if (btn.layer.borderColor == [[UIColor blueColor] CGColor]) {
                [self updatenetworkingNumarr:2 numarr:_NSmdAry];
            }
            break;
        case 4:
            if (btn.layer.borderColor == [[UIColor blueColor] CGColor]) {
                [self updatenetworkingNumarr:4 numarr:_NSwlAry];
            }
            break;
        case 3:
            if (btn.layer.borderColor == [[UIColor blueColor] CGColor]) {
                [self updatenetworkingNumarr:3 numarr:_NSkfAry];
            }
            break;
        case 14:
            if (btn.layer.borderColor == [[UIColor blueColor] CGColor]) {
                [self updatenetworkingNumarr:14 numarr:_NSckAry];
            }
            break;
        case 16:
            if (btn.layer.borderColor == [[UIColor blueColor] CGColor]) {
                 [self updatenetworkingNumarr:16 numarr:_NSkjAry];
            }
            break;
        case 17:
            if (btn.layer.borderColor == [[UIColor blueColor] CGColor]) {
                [self updatenetworkingNumarr:17 numarr:_NScnAry];
            }
            break;
        case 15:
            if (btn.layer.borderColor == [[UIColor blueColor] CGColor]) {
                [self updatenetworkingNumarr:15 numarr:_NScwjlAry];
            }
            break;
        case 13:
            if (btn.layer.borderColor == [[UIColor blueColor] CGColor]) {
                [self updatenetworkingNumarr:13 numarr:_NSwljlAry];
            }
            break;
        case 12:
            if (btn.layer.borderColor == [[UIColor blueColor] CGColor]) {
                [self updatenetworkingNumarr:12 numarr:_NSkfjlAry];
            }
            break;
        case 6:
            if (btn.layer.borderColor == [[UIColor blueColor] CGColor]) {
                [self updatenetworkingNumarr:6 numarr:_NSscjlAry];
            }
            break;
        case 8:
            if (btn.layer.borderColor == [[UIColor blueColor] CGColor]) {
                [self updatenetworkingNumarr:8 numarr:_NSywjlAry];
            }
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
        case 14:
            [_qdbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor blueColor] CGColor];
            _qdbutton.enabled = YES;
            break;
        case 16:
            [_qdbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor blueColor] CGColor];
            _qdbutton.enabled = YES;
            break;
        case 17:
            [_qdbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor blueColor] CGColor];
            _qdbutton.enabled = YES;
            break;
        case 15:
            [_qdbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor blueColor] CGColor];
            _qdbutton.enabled = YES;
            break;
        case 13:
            [_qdbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor blueColor] CGColor];
            _qdbutton.enabled = YES;
            break;
        case 12:
            [_qdbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor blueColor] CGColor];
            _qdbutton.enabled = YES;
            break;
        case 6:
            [_qdbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor blueColor] CGColor];
            _qdbutton.enabled = YES;
            break;
        case 8:
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
        case 14:
            [_qdbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            _qdbutton.enabled = NO;
            break;
        case 16:
            [_qdbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            _qdbutton.enabled = NO;
            break;
        case 17:
            [_qdbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            _qdbutton.enabled = NO;
            break;
        case 15:
            [_qdbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            _qdbutton.enabled = NO;
            break;
        case 13:
            [_qdbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            _qdbutton.enabled = NO;
            break;
        case 12:
            [_qdbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            _qdbutton.enabled = NO;
            break;
        case 6:
            [_qdbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            _qdbutton.enabled = NO;
            break;
        case 8:
            [_qdbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _qdbutton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            _qdbutton.enabled = NO;
            break;
        default:
            break;
    }

}
-(void)BtnClick:(UIButton *)btn{
    switch (_viewbuton.tag) {
        case 5:
            [self backButton:btn nsarry:_NSywAry oldary:_NSywoldAry];
            break;
        case 2:
            [self backButton:btn nsarry:_NSmdAry oldary:_NSmdoldAry];
            break;
        case 4:
            [self backButton:btn nsarry:_NSwlAry oldary:_NSwloldAry];
            break;
        case 3:
            [self backButton:btn nsarry:_NSkfAry oldary:_NSkfoldAry];
            break;
        case 14:
            [self backButton:btn nsarry:_NSckAry oldary:_NSckoldAry];
            break;
        case 16:
            [self backButton:btn nsarry:_NSkjAry oldary:_NSkjoldAry];
            break;
        case 17:
            [self backButton:btn nsarry:_NScnAry oldary:_NScnoldAry];
            break;
        case 15:
            [self backButton:btn nsarry:_NScwjlAry oldary:_NScwjloldAry];
            break;
        case 13:
            [self backButton:btn nsarry:_NSwljlAry oldary:_NSwljloldAry];
            break;
        case 12:
            [self backButton:btn nsarry:_NSkfjlAry oldary:_NSkfjloldAry];
            break;
        case 6:
            [self backButton:btn nsarry:_NSscjlAry oldary:_NSscjloldAry];
            break;
        case 8:
            [self backButton:btn nsarry:_NSywjlAry oldary:_NSywjloldAry];
            break;
        default:
            break;
    }
}
-(void)backButton:(UIButton *)backButton nsarry:(NSMutableArray *)nsarry oldary:(NSArray*)oldary{
    switch (backButton.tag) {
        case 0:
            _gouimage1 = _imageAry[0];
            [self gouimageback:_gouimage1 btn:backButton nsary:nsarry oldary:oldary];
            break;
        case 1:
            _gouimage1 = _imageAry[1];
            [self gouimageback:_gouimage1 btn:backButton nsary:nsarry oldary:oldary];
            break;
        case 2:
            _gouimage1 = _imageAry[2];
            [self gouimageback:_gouimage1 btn:backButton nsary:nsarry oldary:oldary];
            break;
        case 3:
            _gouimage1 = _imageAry[3];
            [self gouimageback:_gouimage1 btn:backButton nsary:nsarry oldary:oldary];
            break;
        case 4:
            _gouimage1 = _imageAry[4];
            [self gouimageback:_gouimage1 btn:backButton nsary:nsarry oldary:oldary];
            break;
        default:
            break;
    }
}
-(void)gouimageback:(UIImageView*)gouimageback btn:(UIButton *)btn nsary:(NSMutableArray*)nsary oldary:(NSArray*)oldary{

    if ([gouimageback.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
        gouimageback.image = [UIImage imageNamed:@""];
        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        NSString *sttttt = [NSString stringWithFormat:@"%@",_numAry[btn.tag]];
        
        [nsary removeObject:sttttt];
        
     
       
        NSArray *selectWrong = [oldary filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF in %@)", nsary]];
        NSLog(@"不一样的%@",selectWrong);
        if (selectWrong.count>0) {
            [self buttonblueColorbackcolor];
        }else{
            NSArray *selectWrong1 = [nsary filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF in %@)", oldary]];
            if (selectWrong1.count>0) {
                [self buttonblueColorbackcolor];
            }else{
                [self buttonligbackcolor];
            }
        }
        
    }else{
        gouimageback.image = [UIImage imageNamed:@"xz_ico1"];
        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
        
        NSString *sttttt = [NSString stringWithFormat:@"%@",_numAry[btn.tag]];
        [nsary addObject:sttttt];
        
        [nsary removeObject:@""""];
        NSLog(@"选择的职位:%@",nsary);
        NSArray *selectWrong = [oldary filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF in %@)", nsary]];
        NSLog(@"不一样的%@",selectWrong);
        if (selectWrong.count>0) {
            [self buttonblueColorbackcolor];
        }else{
            NSArray *selectWrong1 = [nsary filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF in %@)", oldary]];
            if (selectWrong1.count>0) {
                [self buttonblueColorbackcolor];
            }else{
             [self buttonligbackcolor];
            }
           
        }
        
    }

}

@end
