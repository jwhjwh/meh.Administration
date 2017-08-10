//
//  RectordTableViewCell.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "RectordTableViewCell.h"

@implementation RectordTableViewCell



-(void)loadDataFromModel:(SubmittedModel *)model{
    NSString *Subimagestr = [NSString stringWithFormat:@"%@%@",KURLHeader,model.picture];
    [self.submittedImage sd_setImageWithURL:[NSURL URLWithString:Subimagestr]placeholderImage:[UIImage imageNamed:@"ph_mt"]];
    
    self.dayLabel.text = [model.dates substringToIndex:16];
    
    self.submittedLabel.text  = [NSString stringWithFormat:@"时间 %@",[model.dateTimes substringToIndex:10]] ;
    
    self.cityLabel.text = [NSString stringWithFormat:@"地点 %@",model.locations];
    
    self.NRLabel.text = [NSString stringWithFormat:@"事务概括 %@",model.describe];
    
    self.JZCDLabel.text = [NSString stringWithFormat:@"进展程度  %@",model.progress];
    
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
