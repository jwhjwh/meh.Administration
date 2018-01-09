//
//  CellChargePerson.m
//  Administration
//
//  Created by zhang on 2017/11/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellChargePerson.h"

@implementation CellChargePerson

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    UILabel *labelTitle = [[UILabel alloc]init];
    labelTitle.text = @"负责区域";
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelArea = [[UILabel alloc]init];
    labelArea.numberOfLines = 0;
    [self.contentView addSubview:labelArea];
    [labelArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(labelTitle.mas_bottom).offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
    }];
    self.labelArea = labelArea;
}

-(void)setDict:(NSDictionary *)dict
{
    NSArray *array = dict[@"lists"];
    
    NSMutableArray *arrayArea = [NSMutableArray array];
    for (NSDictionary *dictinfo in array) {
        if ([dictinfo[@"province"]isKindOfClass:[NSNull class]]) {
            self.labelArea.text = @"暂无分配区域";
            return;
        }else
        {
            NSData *jsonData = [dictinfo[@"province"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *province = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            NSString * stringProvince = [NSString stringWithFormat:@"%@\\",province[@"provinceName"]];
            NSArray *arrayCity = province[@"cityList"];
            for (int i=0;i<arrayCity.count;i++) {
                
                NSDictionary *dictCity = arrayCity[i];
                if (i>0) {
                    stringProvince = [stringProvince stringByAppendingFormat:@"\n        %@\\",dictCity[@"cityName"] ];
                }else
                {
                    stringProvince = [stringProvince stringByAppendingFormat:@"%@\\",dictCity[@"cityName"] ];
                }
                
                NSArray *arrayCountry = dictCity[@"countyList"];
                stringProvince = [stringProvince stringByAppendingFormat:@"%@",[arrayCountry componentsJoinedByString:@"\\"]];
                if (arrayCountry.count==0) {
                    stringProvince = [stringProvince stringByAppendingFormat:@"%@全部",[arrayCountry componentsJoinedByString:@"\\"]];
                }
                
            }
            [arrayArea addObject:stringProvince];
            
        }
    }
    
    self.labelArea.text = [arrayArea componentsJoinedByString:@"\n"];
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
