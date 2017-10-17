//
//  CellBacklog.m
//  Administration
//
//  Created by zhang on 2017/10/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellBacklog.h"

@implementation CellBacklog


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    UIImageView *imageView1 = [[UIImageView alloc]init];
    imageView1.image = [UIImage imageNamed:@"weixuanzhong"];
    [self.contentView addSubview:imageView1];
    self.imageView1 = imageView1;
    
    
    UILabel *labelMode = [[UILabel alloc]init];
    labelMode.textColor = GetColor(72, 74, 75, 1);
    labelMode.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:labelMode];
    [labelMode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView1.mas_right).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(17);
    }];
    self.labelMode = labelMode;
    
    UILabel *labelDate = [[UILabel alloc]init];
    labelDate.font = [UIFont systemFontOfSize:15];
    labelDate.textColor = GetColor(127, 128, 120, 1);
    [self.contentView addSubview:labelDate];
    [labelDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView1.mas_right).offset(8);
        make.top.mas_equalTo(labelMode.mas_bottom).offset(5);
        make.height.mas_equalTo(15);
    }];
    self.labelDate = labelDate;
    
    UILabel *labelDetail = [[UILabel alloc]init];
    labelDetail.font = [UIFont systemFontOfSize:14];
    labelDetail.textColor = GetColor(192, 192, 192, 1);
    [self.contentView addSubview:labelDetail];
    [labelDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView1.mas_right).offset(8);
        make.top.mas_equalTo(labelDate.mas_bottom).offset(5);
        make.right.mas_equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(14);
    }];
    self.labelDetail = labelDetail;
    
    UILabel *labelTime = [[UILabel alloc]init];
    labelTime.font = [UIFont systemFontOfSize:12];
    labelTime.textColor = GetColor(192, 192, 192, 1);
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(14);
    }];
    self.labelTime = labelTime;
    
    UILabel *labelState = [[UILabel alloc]init];
    labelState.textColor = GetColor(192, 192, 192, 1);
    labelState.text = @"未完成";
    labelState.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:labelState];
    [labelState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo(labelTime.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    self.labelState = labelState;
    
    
    UIImageView *imageSelect = [[UIImageView alloc]init];
    imageSelect.hidden = YES;
    imageSelect.image = [UIImage imageNamed:@"zt_ico01"];
    [self.contentView addSubview:imageSelect];
    [imageSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(labelState.mas_left).offset(-2);
        make.top.mas_equalTo(labelTime.mas_bottom).offset(8);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(10);
    }];
    self.imageSelect = imageSelect;
}

-(void)setDict:(NSDictionary *)dict
{
    NSString *matterstype = [NSString stringWithFormat:@"%@",dict[@"matterstype"]];
    NSString *read = [NSString stringWithFormat:@"%@",dict[@"red"]];
    NSString *startDate = [dict[@"starttime"] substringWithRange:NSMakeRange(5, 5)];
    NSString *endDate;
    
    self.labelTime.text = [dict[@"remindertimes"]substringWithRange:NSMakeRange(5, 11)];
    
    self.labelDetail.text = dict[@"title"];
    
    if (![dict[@"endtime"] isKindOfClass:[NSNull class]]) {
        endDate = [dict[@"endtime"]substringWithRange:NSMakeRange(5, 5)];
    }

    
    if ([read isEqualToString:@"1"]) {
        self.labelState.text = @"已完成";
        self.labelState.textColor = GetColor(51, 172, 59, 1);
        self.imageSelect.hidden = NO;
    }else
    {
        self.labelState.text = @"未完成";
        self.labelState.textColor = GetColor(192, 192, 192, 1);
        self.imageSelect.hidden = YES;
    }
    
    if ([matterstype isEqualToString:@"1"]) {
        self.labelMode.text = @"日待办事项";
        self.labelDate.text = startDate;
    }else
    {
        self.labelDate.text = [NSString stringWithFormat:@"%@至%@",startDate,endDate];
        if([matterstype isEqualToString:@"2"])
       {
        self.labelMode.text = @"周待办事项";
       }else if([matterstype isEqualToString:@"3"])
       {
        self.labelMode.text = @"店待办事项";
        }else
        {
        self.labelMode.text = @"其他待办事项";
        }
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
