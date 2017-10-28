//
//  CellGonggao.m
//  Administration
//
//  Created by zhang on 2017/10/26.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellGonggao.h"

@interface CellGonggao ()

@end

@implementation CellGonggao

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc]init];
    textView.scrollEnabled = NO;
    [self.contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
    }];
    self.textView = textView;
}


//- (UITableView *)tableView
//{
//    UIView *tableView = self.superview;
//    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
//        tableView = tableView.superview;
//    }
//    return (UITableView *)tableView;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
