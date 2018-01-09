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
    self.txImageView.layer.cornerRadius =21.0f;
    self.nameLabel.text = model.name;
    self.iponeLabel.text = model.account;
    NSString *Subimagestr = [NSString stringWithFormat:@"%@%@",KURLHeader,model.picture];
    [self.submittedImage sd_setImageWithURL:[NSURL URLWithString:Subimagestr]placeholderImage:[UIImage imageNamed:@"ph_mt"]];
    
    
    //model.dateTimes = //截取掉下标7之后的字符串
    
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate  *yesterday;
    
   
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    NSString * todayString = [[today description] substringToIndex:4];
    NSString * yesterdayString = [[yesterday description] substringToIndex:4];
    
    
    NSString * dateString = [model.dates substringToIndex:4];
    
    if ([dateString isEqualToString:todayString])
    {
        NSLog(@"今年") ;
      
        NSString *datastr = [model.dates substringFromIndex:5];
        
        NSString * todayString1 = [[today description] substringToIndex:10];
        NSString * yesterdayString1 = [[yesterday description] substringToIndex:10];
        
        NSString * dateString1 = [model.dates substringToIndex:10];
        
        NSString *sfmstr =[datastr substringFromIndex:6];
        
        if ([dateString1 isEqualToString:todayString1])
        {
           NSLog(@"今天") ;
            self.birLabel.text = [NSString stringWithFormat:@"今天 : %@",[sfmstr substringToIndex:5]];
        } else if ([dateString1 isEqualToString:yesterdayString1])
        {
            NSLog(@"昨天") ;
            self.birLabel.text = [NSString stringWithFormat:@"昨天 : %@",[sfmstr substringToIndex:5]];
        }else{
            self.birLabel.text = [datastr substringToIndex:11];
        }
    } else if ([dateString isEqualToString:yesterdayString])
    {
        self.birLabel.text = [model.dates substringToIndex:16];
    }
    
    
    
   
    
    self.submittedLabel.text  = [NSString stringWithFormat:@"时间 %@",[model.dateTimes substringToIndex:10]] ;
    
    self.DdLabel.text = [NSString stringWithFormat:@"地点 %@",model.locations];
    
    self.swgkLabel.text = [NSString stringWithFormat:@"事务概括 %@",model.describe];
    
    self.progress.text = [NSString stringWithFormat:@"进展程度  %@",model.progress];
    /*
     describe = 456; -- 时间
     locations = 123; --地点
     progress = 789; --事务概括
     */    
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
