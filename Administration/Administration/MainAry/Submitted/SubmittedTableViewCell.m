//
//  SubmittedTableViewCell.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "SubmittedTableViewCell.h"

@implementation SubmittedTableViewCell
-(void)loadDataFromModel:(SubmittedModel *)model{
    
    NSString *imageStr = [NSString stringWithFormat:@"%@%@",KURLHeader,model.icon];
    [self.txImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]placeholderImage:[UIImage imageNamed:@"head_icon"]];
    self.txImageView.layer.masksToBounds = YES;
    self.txImageView.layer.cornerRadius =25.0f;
    self.nameLabel.text = model.name;
    self.iponeLabel.text = model.account;
    NSString *Subimagestr = [NSString stringWithFormat:@"%@%@",KURLHeader,model.picture];
    [self.submittedImage sd_setImageWithURL:[NSURL URLWithString:Subimagestr]placeholderImage:[UIImage imageNamed:@"ph_mt"]];
    
    self.submittedLabel.text = model.describe;
    
    self.birLabel.text = model.dateTimes;

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
