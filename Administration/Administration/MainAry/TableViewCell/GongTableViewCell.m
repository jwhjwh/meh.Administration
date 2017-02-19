//
//  GongTableViewCell.m
//  Administration
//
//  Created by 费腾 on 17/2/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GongTableViewCell.h"

@implementation GongTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
- (void) addSubviews {
    
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
