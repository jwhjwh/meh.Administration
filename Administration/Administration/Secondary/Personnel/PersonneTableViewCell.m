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
    NSString *uStr =[NSString stringWithFormat:@"%@user/findAllUser.action%@",KURLHeader,model.icon];

    [self.TXImage setImageWithURL:[NSURL URLWithString:uStr]placeholderImage:[UIImage imageNamed:@"tx100"]];
    self.NameLabel.text = model.name;
    self.TelLabel.text = model.account;
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
