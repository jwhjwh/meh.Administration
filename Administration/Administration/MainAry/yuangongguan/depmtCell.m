//
//  depmtCell.m
//  Administration
//
//  Created by zhang on 2017/5/25.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "depmtCell.h"

@implementation depmtCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier arr:(NSArray*)arr numcode:(int)numcode{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews:arr num:numcode];
    }
    return self;
}
- (void) addSubviews:(NSArray*)arr num:(int)numm {
   
    _mLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 90, 30)];
    _mLabel.font=[UIFont systemFontOfSize:16];
    [self addSubview:_mLabel];
    
    for (int i=0; arr.count>i; i++) {
   
        _xLabel=[[UILabel alloc]initWithFrame:CGRectMake(170, 15+i*30, Scree_width-170, 20)];
        if (i>=1) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(120,40+(i-1)*25, Scree_width-120, 1)];
            view.backgroundColor = GetColor(230,230,230,1);
            [self addSubview:view];
        }
        if (numm  == 1) {
            _xLabel.textColor = [UIColor lightGrayColor];
        }
        _xLabel.numberOfLines=0;
        _xLabel.text=arr[i];
        _xLabel.font=[UIFont systemFontOfSize:14];
        [self addSubview:_xLabel];
    }
   
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
