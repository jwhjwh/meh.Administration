//
//  CellSetBrithday.m
//  Administration
//
//  Created by zhang on 2017/11/3.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellSetBrithday.h"

@interface CellSetBrithday ()

@end

@implementation CellSetBrithday

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
    UIImageView *imageViewHead = [[UIImageView alloc]init];
    [self.contentView addSubview:imageViewHead];
    [imageViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    self.imageViewHead = imageViewHead;
    
    
    
    UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc]init];
   // textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:17];
    textView.placeholder = @"填写描述";
    textView.scrollEnabled = NO;
    textView.editable = NO;
    [self.contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewHead.mas_right).offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-40);
        make.top.mas_equalTo(self.contentView.mas_top).offset(7);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-7);
    }];
    self.textView = textView;
}

//- (void)textViewDidChange:(UITextView *)textView
//{
//    CGRect frame = textView.frame;
//    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
//    CGSize size = [textView sizeThatFits:constraintSize];
//    if (size.height<=frame.size.height) {
//        size.height=frame.size.height;
//    }
//    textView.frame = CGRectMake(frame.origin.x, frame.origin.y,self.contentView.frame.size.width, size.height);
//
//    UITableView *tableView = [self tableView];
//    [tableView beginUpdates];
//    [tableView endUpdates];
//}
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
