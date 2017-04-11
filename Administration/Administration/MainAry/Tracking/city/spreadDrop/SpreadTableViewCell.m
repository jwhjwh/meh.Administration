//
//  SpreadTableViewCell.m
//  城市选择
//
//  Created by 九尾狐 on 2017/3/30.
//  Copyright © 2017年 iSmartAlarm. All rights reserved.
//

#import "SpreadTableViewCell.h"

@implementation SpreadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)creatWithTableView:(UITableView *)tableView{
    static NSString *ID=@"Cell";
    SpreadTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[SpreadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor colorWithRed:(235/255.0f) green:(235/255.0f) blue:(235/255.0f) alpha:1];
        
    }
    return cell;
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  
    
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (editing) {
        for (UIControl *control in self.subviews){
            if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
                for (UIView *v in control.subviews)
                {
                    if ([v isKindOfClass: [UIImageView class]]) {
                        UIImageView *img=(UIImageView *)v;
                        
                        img.image = [UIImage imageNamed:@"djq_ico"];
                    }
                }
            }
        }
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"djh_ico"];
                    }else
                    {
                        
                        img.image=[UIImage imageNamed:@"djq_ico"];
                    }
                }
            }
        }
    }
    
}

@end
