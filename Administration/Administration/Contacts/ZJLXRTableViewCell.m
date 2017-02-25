//
//  ZJLXRTableViewCell.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ZJLXRTableViewCell.h"

@implementation ZJLXRTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _TXImage.layer.masksToBounds = YES;
    _TXImage.layer.cornerRadius =22.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(LVModel *)model{
   self.NameLabel.text=model.name;
   self.TelLabel.text=model.Call;
   self.TXImage.image=[[UIImage alloc] initWithContentsOfFile:model.image];
   self.TimeLabel.text=model.time;
}
@end
