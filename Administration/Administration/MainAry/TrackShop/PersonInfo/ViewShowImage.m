//
//  ViewShowImage.m
//  Administration
//
//  Created by zhang on 2017/12/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewShowImage.h"

@implementation ViewShowImage


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    self.backgroundColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Scree_width-50, Scree_width-50)];
    imageView.center = self.center;
    [self addSubview:imageView];
    
    self.imageView = imageView;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
