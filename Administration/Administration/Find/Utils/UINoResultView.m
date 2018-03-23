//
//  UINoResultView.m
//  hhhh
//
//  Created by zhang on 2018/3/23.
//  Copyright © 2018年 zhang. All rights reserved.
//

#import "UINoResultView.h"

@implementation UINoResultView

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI:title];
    }
    return self;
}

-(void)setUI:(NSString *)string
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *viewCenter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)];
    viewCenter.center = self.center;
    [self addSubview:viewCenter];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-75, 0, 150, 120)];
    imageView.image = [UIImage imageNamed:@"zw_ico01"];
    [viewCenter addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 110,self.frame.size.width, 80)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    label.text = string;
    [viewCenter addSubview:label];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
