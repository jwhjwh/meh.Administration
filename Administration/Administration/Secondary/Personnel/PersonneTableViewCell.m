//
//  PersonneTableViewCell.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/21.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "PersonneTableViewCell.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
@implementation PersonneTableViewCell

-(void)loadDataFromModel:(PersonModel *)model
{
    NSString *uStr =[NSString stringWithFormat:@"%@%@",KURLImage,model.icon];
    [self.TXImage sd_setImageWithURL:[NSURL URLWithString:uStr]placeholderImage:[UIImage imageNamed:@"tx100"]];
    self.NameLabel.text = model.name;
    self.TelLabel.text =[NSString stringWithFormat:@"%ld", (long)model.account];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _TXImage.layer.masksToBounds = YES;
    _TXImage.layer.cornerRadius =25.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
