//
//  CellPostil.m
//  testView
//
//  Created by zhang on 2017/8/18.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "CellPostil.h"
@implementation CellPostil

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *labelTime = [[UILabel alloc]init];
        labelTime.textColor = [UIColor lightGrayColor];
        labelTime.font = [UIFont systemFontOfSize:10];
        labelTime.text = @"刚刚";
        [self.contentView addSubview:labelTime];
        [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
            make.top.mas_equalTo(self.contentView.mas_top).offset(3);
            // make.width.mas_equalTo(100);
            make.height.mas_equalTo(10);
        }];
        self.labelTime = labelTime;
        
        UIButton *buttonComp = [[UIButton alloc]init];
        [buttonComp setTitle:@"完成" forState:UIControlStateNormal];
        buttonComp.titleLabel.font = [UIFont systemFontOfSize:10];
        [buttonComp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.contentView addSubview:buttonComp];
        [buttonComp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
            make.top.mas_equalTo(self.contentView.mas_top).offset(2);
//            make.width.mas_equalTo(20);
            make.height.mas_equalTo(10);
        }];
        self.buttonComp = buttonComp;
        
        
        UIPlaceHolderTextView *textView1 = [[UIPlaceHolderTextView alloc]init];
        textView1.textColor = GetColor(129, 104, 82, 1);
        textView1.font = [UIFont systemFontOfSize:14];
        textView1.backgroundColor = GetColor(235, 227, 203, 1);
        textView1.scrollEnabled = NO;
        textView1.placeholder = @"批注对象：例：@“本月计划超额完成";
        [self.contentView addSubview:textView1];
        
        UIPlaceHolderTextView *textView2 = [[UIPlaceHolderTextView alloc]init];
        textView2.textColor = [UIColor lightGrayColor];
        textView2.font = [UIFont systemFontOfSize:14];
        textView2.backgroundColor = GetColor(235, 227, 203, 1);
        textView2.scrollEnabled = NO;
        textView2.placeholder = @"批注内容：例：@“很好，继续努力";
        [self.contentView addSubview:textView2];
        
        [textView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(20);
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
            make.bottom.mas_equalTo(textView2.mas_top).offset(-1);
            //make.height.mas_equalTo(@30);
        }];
        self.textView1 = textView1;

        [textView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
            make.top.mas_equalTo(textView1.mas_bottom).offset(1);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            //make.height.mas_equalTo(@30);
        }];
        self.textView2 = textView2;
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
