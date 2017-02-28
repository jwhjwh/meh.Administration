//
//  YHJBtnView.m
//  快速入口轮番
//
//  Created by yhj on 16/1/13.
//  Copyright © 2016年 QQ:1787354782 QQ群:524884683. All rights reserved.
//

#import "YHJBtnView.h"

@implementation YHJBtnView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title imageStr:(NSString *)imageStr
{
#define frameWidth frame.size.width
#define imageWidth 59  // 图片宽度,高度等
#define imageTopH  15  // 图片距顶距离
    
    self=[super initWithFrame:frame];
    if (self) {
        
        {
            // image
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((frameWidth-imageWidth)/2,imageTopH,imageWidth,imageWidth)];
            imageView.backgroundColor=[UIColor whiteColor];
            imageView.image=[UIImage imageNamed:imageStr];
            [self addSubview:imageView];
        }
       
        {
            // title
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, imageTopH+imageWidth,frameWidth, imageWidth/2)];
            titleLabel.text=title;
            titleLabel.textAlignment=NSTextAlignmentCenter;
            titleLabel.font=[UIFont systemFontOfSize:14];
            [self addSubview:titleLabel];
        }
    }
    return self;
}

@end
