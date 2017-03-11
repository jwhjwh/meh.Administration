//
//  RectordTableViewCell.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "RectordTableViewCell.h"

@implementation RectordTableViewCell



-(void)loadDataFromModel:(RectordModel *)model{
    
    
    
    
    NSString *Subimagestr = [NSString stringWithFormat:@"%@%@",KURLHeader,model.picture];
    [self.submittedImage sd_setImageWithURL:[NSURL URLWithString:Subimagestr]placeholderImage:[UIImage imageNamed:@"ph_mt"]];
    
    self.submittedLabel.text = model.describe;
    
    self.dayLabel.text = model.dateTimes;
    
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
