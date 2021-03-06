//
//  CellTabelDetail.m
//  Administration
//
//  Created by zhang on 2017/8/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellTabelDetail.h"

@implementation CellTabelDetail
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *lableTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lableTitle];
        [lableTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
            make.top.mas_equalTo(self.contentView.mas_top).offset(5);
            make.height.mas_equalTo(17);
        }];
        self.labelTitle = lableTitle;
        
        UITextView *textView = [[UITextView alloc]init];
        textView.font = [UIFont systemFontOfSize:17];
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textView.layer.borderWidth = 1.0f;
        textView.textColor = [UIColor lightGrayColor];
        textView.scrollEnabled = NO;
        textView.userInteractionEnabled = NO;
        [self.contentView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
            make.top.mas_equalTo(lableTitle.mas_bottom).offset(5);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
        }];
        self.textView = textView;
        
        UIButton *button = [[UIButton alloc]init];
        [button setBackgroundImage:[UIImage imageNamed:@"tjpco01"] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
            make.top.mas_equalTo(self.contentView.mas_top).offset(5);
            make.width.mas_equalTo(23);
            make.height.mas_equalTo(20);
        }];
        self.button = button;
        
    }
    return self;
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
