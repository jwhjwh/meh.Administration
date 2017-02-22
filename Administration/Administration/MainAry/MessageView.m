//
//  MessageView.m
//  Administration
//
//  Created by 费腾 on 17/2/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "MessageView.h"

@implementation MessageView
//初始化所有的子视图
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //布局子视图
        [self allViews];
    }
    return self;
}

#pragma mark-----布局子视图
-(void)allViews{
    //获取到父视图的fram(width height)
    CGFloat selfWidth=self.frame.size.width;
    CGFloat selfHeight=self.frame.size.height;
    //创建一个UILable 并添加到self
    self.label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, selfWidth/3, selfHeight)];
   
    [self addSubview:self.label];
    //创建一个UITextField 并添加到self
    self.textField=[[UITextField alloc]initWithFrame:CGRectMake(selfWidth/3, 0, selfWidth/3*2, selfHeight)];
    [self addSubview:self.textField];
    self.view=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, Scree_width, 1)];
    self.view.backgroundColor=[UIColor blackColor];
    [self addSubview:self.view];
}

@end
