//
//  XCQ_tabbar.m
//  自定义tabbar
//
//  Created by Mr.X on 2016/12/14.
//  Copyright © 2016年 Mr.X. All rights reserved.
//

#import "XCQ_tabbar.h"

@implementation XCQ_tabbar

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



-(id)initWithFrame:(CGRect)frame
 withUnSelectedImg:(UIImage *)unSelectedImg
   withSelectedImg:(UIImage *)selectedImg
         withTitle:(NSString *)tabbarTitle
{
    if (self = [super initWithFrame:frame]) {
        
        // 图标的红点标记默认为0
        self.redIndex = NO ;
        self.unSelectedImg = unSelectedImg ;
        self.selectedImg = selectedImg ;
        
        //存放标题和icon图标的view
        self.itemView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/4, 49)];
        [self addSubview:self.itemView];
        
        //标题
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(-2, 30, self.bounds.size.width, 20)];
        self.titleLabel.text = tabbarTitle ;
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter ;
        self.titleLabel.tag = 1002 ;
        [self.itemView addSubview:self.titleLabel];
        
        //icon 图标
        self.tabbarImgView = [[UIImageView alloc]initWithImage:unSelectedImg];
        self.tabbarImgView.frame = CGRectMake(0, 0, 25, 25) ;
        self.tabbarImgView.center  =CGPointMake(self.titleLabel.center.x, self.titleLabel.center.y-22);
        self.tabbarImgView.tag = 1001 ;
        [self.itemView addSubview:self.tabbarImgView];
        
        //点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapOne:)];
        [self.itemView addGestureRecognizer:tap];
        self.itemView.userInteractionEnabled  = YES ;

        
    }
    return self ;
}

//选中的时候icon和文字颜色正选和反选状态
-(void)setSelected:(BOOL)selected
{
    if (_tabbarSelected != selected)
    {
        _tabbarSelected =selected ;
        
        UIImageView *imageView =(UIImageView *) [self viewWithTag:1001];
        UILabel *label = (UILabel *)[self viewWithTag:1002] ;
        if (selected)
        {
            imageView.image = self.selectedImg ;
            label.textColor = [UIColor blackColor];
        }
        else
        {
            imageView.image = self.unSelectedImg ;
            label.textColor = [UIColor blackColor ];
            
        }
    }
    
}

- (void)TapOne:(id)sender
{
    // 在适当的时候，调用事件的方法
    // 防Xcode6的内存警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.tabbarTarget performSelector:self.tabbarAction withObject:self];
#pragma clang diagnostic pop
}



//图标的红点标记
-(void)setRedIndex:(BOOL)redIndex andBudgeNum:(NSInteger)budgeNum
{
    if (redIndex && budgeNum > 0)
    {
        for (UIView *indexView in self.tabbarImgView.subviews)
        {
            [indexView removeFromSuperview];
        }
        
        UILabel *indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
        indexLabel.center = CGPointMake(self.tabbarImgView.frame.size.width + 2, 2);
        indexLabel.backgroundColor = [UIColor redColor];
        indexLabel.layer.cornerRadius = indexLabel.frame.size.width/2.0;
        indexLabel.clipsToBounds = YES;
        //        indexLabel.text = [NSString stringWithFormat:@"%li",budgeNum];
        indexLabel.textColor = [UIColor whiteColor];
        indexLabel.font = [UIFont systemFontOfSize:10];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        [self.tabbarImgView addSubview:indexLabel];
    }
    else
    {
        for (UIView *indexView in self.tabbarImgView.subviews)
        {
            [indexView removeFromSuperview];
        }
    }
}


-(void)setClickEventTarget:(id)target action:(SEL)action
{
    self.tabbarTarget =target ;
    self.tabbarAction =action ;
}



-(void)dealloc
{
    self.unSelectedImg = nil;
    self.selectedImg = nil ;
    self.tabbarAction =nil ;
    self.tabbarTarget = nil ;
}





@end
