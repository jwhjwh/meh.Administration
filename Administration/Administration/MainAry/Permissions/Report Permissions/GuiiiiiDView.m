//
//  GuiDView.m
//  Administration
//
//  Created by 九尾狐 on 2017/4/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GuiiiiiDView.h"

#define WIDTHh [UIScreen mainScreen].bounds.size.width
#define HEIGHTt [UIScreen mainScreen].bounds.size.height
@implementation GuiiiiiDView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //布局子视图
        [self guiDView];
    }
    return self;
}
-(void)guiDView{
    _acode = 1;
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTHh, HEIGHTt)];
    _view1.backgroundColor = GetColor(127, 127, 127, 0.8);
    [self addSubview:_view1];
    _imageview1 = [[UIImageView alloc]init];
    _imageview1.image = [UIImage imageNamed:@"bg_mt01"];
    [_view1 addSubview:_imageview1];
    [_imageview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_view1.mas_centerY).offset(-80);
        make.left.mas_equalTo(_view1.mas_left).offset(50);
        make.right.mas_equalTo(_view1.mas_right).offset(-50);
        make.height.mas_equalTo(120);
    }];
    
    _biaoLabel = [[UILabel alloc]init];
    _biaoLabel.text = @"报表批注权限解析";
    _biaoLabel.font = [UIFont systemFontOfSize:17.0f];
    _biaoLabel.textAlignment = NSTextAlignmentCenter;
    [_view1 addSubview:_biaoLabel];
    [_biaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageview1.mas_top).offset(10);
        make.left.mas_equalTo(_imageview1.mas_left).offset(10);
        make.right.mas_equalTo(_imageview1.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    _neiRLabel = [[UILabel alloc]init];
    _neiRLabel.text = @"只有被授予权限的职位才可以进行对报表的批注，没有授予权限的职位不能对报表进行批注只能看";
    _neiRLabel.font = [UIFont systemFontOfSize:15.0f];
    _neiRLabel.numberOfLines = 0;
    _neiRLabel.textColor=  GetColor(112, 112, 112, 1);
    [_view1 addSubview:_neiRLabel];
    [_neiRLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_biaoLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(_imageview1.mas_left).offset(20);
        make.right.mas_equalTo(_imageview1.mas_right).offset(-20);
        make.bottom.mas_equalTo(_imageview1.mas_bottom).offset(-10);
    }];
    _XYBBtn = [[UIButton alloc]init];
    [_XYBBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _XYBBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    _XYBBtn.layer.borderWidth = 1.0f;
    _XYBBtn.layer.cornerRadius = 15.0f;
    _XYBBtn.backgroundColor = [UIColor clearColor];
    _XYBBtn.layer.masksToBounds = YES;
    [_XYBBtn addTarget:self
                action:@selector(BtnClick)
      forControlEvents:UIControlEventTouchUpInside];
    [_view1 addSubview:_XYBBtn];
    [_XYBBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageview1.mas_bottom).offset(20);
        make.centerX.mas_equalTo(_imageview1.mas_centerX).offset(0);
        make.width.mas_offset(100);
        make.height.mas_offset(30);
    }];
}
-(void)BtnClick{
    switch (_acode) {
        case 1:{
            _imageview1.image = [UIImage imageNamed:@"bg_mt02"];
            _biaoLabel.text = @"例:";
            _neiRLabel.text = @"业务写的报表只有被授予权限的业务经理和行政管理职位所进行批注而其他职位只能查看不能进行批注\n\n";
            [_imageview1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_view1.mas_top).offset(231);
                make.left.mas_equalTo(_view1.mas_left).offset(50);
                make.right.mas_equalTo(_view1.mas_right).offset(-50);
                make.height.mas_equalTo(170);
            }];
            [_biaoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_imageview1.mas_top).offset(40);
                make.left.mas_equalTo(_imageview1.mas_left).offset(10);
                make.right.mas_equalTo(_imageview1.mas_right).offset(-10);
                make.height.mas_equalTo(20);
            }];
            [_neiRLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_biaoLabel.mas_bottom).offset(10);
                make.left.mas_equalTo(_imageview1.mas_left).offset(20);
                make.right.mas_equalTo(_imageview1.mas_right).offset(-20);
                make.bottom.mas_equalTo(_imageview1.mas_bottom).offset(-10);
            }];
            [_XYBBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_imageview1.mas_bottom).offset(20);
                make.centerX.mas_equalTo(_imageview1.mas_centerX).offset(0);
                make.width.mas_offset(100);
                make.height.mas_offset(30);
            }];
        }
            _acode=2;
            NSLog(@"%d",_acode);
            break;
        case 2:{
            _acode= 3;
            _imageview1.image = [UIImage imageNamed:@"bg_mt01"];
            [_biaoLabel removeFromSuperview];
            _neiRLabel.text = @"只有被勾选的职位才有对报表批注的权限呦！马上去勾选吧！！！\n\n";
            [_XYBBtn setTitle:@"马上去" forState:UIControlStateNormal];
            [_imageview1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_view1.mas_centerY).offset(-80);
                make.left.mas_equalTo(_view1.mas_left).offset(50);
                make.right.mas_equalTo(_view1.mas_right).offset(-50);
                make.height.mas_equalTo(80);
                
            }];
            [_neiRLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_imageview1.mas_top).offset(10);
                make.left.mas_equalTo(_imageview1.mas_left).offset(20);
                make.right.mas_equalTo(_imageview1.mas_right).offset(-20);
                make.height.mas_equalTo(80);
                
            }];
            NSLog(@"acode=3");
        }
            break;
        case 3:
            NSLog(@"马上去");
            [self removeFromSuperview];
            break;
        default:
            break;
    }
}

@end
