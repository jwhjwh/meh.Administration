//
//  ItemCell.m
//  demo
//
//  Created by zhong on 17/1/16.
//  Copyright © 2017年 Xz Studio. All rights reserved.
//

#import "ItemCell.h"


@interface ItemCell ()

@end

@implementation ItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat containerX = 10;
        CGFloat containerY = 5;
        CGFloat containerW = self.bounds.size.width - 2 * containerX;
        CGFloat containerH = self.bounds.size.height - 2 * containerY;
        _container = [[UIView alloc] initWithFrame:CGRectMake(containerX, containerY, containerW, containerH)];
        _container.backgroundColor = [UIColor whiteColor];
//        _container.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
//        _container.layer.borderColor = [UIColor colorWithRed:232 / 255.0 green:232 / 255.0 blue:232 / 255.0 alpha:1.0].CGColor;
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, _container.frame.size.width-10,_container.frame.size.width-10)];
        _icon.userInteractionEnabled=YES;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_icon.frame), containerW, containerH - CGRectGetMaxY(_icon.frame))];
        _titleLabel.textColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        //省略
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _rightUpperButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 22,0, 20, 20)];
        [_rightUpperButton addTarget:self action:@selector(rightUpperButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_container addSubview:_icon];
        [_container addSubview:_titleLabel];
        [self.contentView addSubview:_container];
        
    }
    return self;
}

-(void)rightUpperButtonAction{
    
}



@end
