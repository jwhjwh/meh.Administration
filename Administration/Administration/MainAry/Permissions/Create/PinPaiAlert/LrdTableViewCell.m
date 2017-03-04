//
//  LrdTableViewCell.m
//  AlertTableView
//
//  Created by 键盘上的舞者 on 3/28/16.
//  Copyright © 2016 键盘上的舞者. All rights reserved.
//

#import "LrdTableViewCell.h"
#import "LrdDateModel.h"
#import "Masonry.h"

@interface LrdTableViewCell ()

@property (nonatomic, strong) UILabel *time;
@property (nonatomic,strong) UIImageView *image;


@end

@implementation LrdTableViewCell

#pragma mark 重写model的set方法

- (void)setModel:(LrdDateModel *)model {
    _model = model;
    self.time.text = model.finsk;
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo];
     UIImage *urlImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlstr]]];
    self.image = [[UIImageView alloc] initWithImage:urlImage];
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _time = [[UILabel alloc] init];
        _time.textColor = [UIColor grayColor];
        _time.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_time];
        
        _image = [[UIImageView alloc] init];
        _image.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_image];
        
        //设置约束
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
        
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            
            make.left.equalTo(_image.mas_right).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
        }];
        
        
                
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
