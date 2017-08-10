//
//  RectordTableViewCell.h
//  Administration
//
//  Created by 九尾狐 on 2017/3/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmittedModel.h"
@interface RectordTableViewCell : UITableViewCell
-(void)loadDataFromModel:(SubmittedModel *)model;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *submittedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *submittedImage;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *NRLabel;
@property (weak, nonatomic) IBOutlet UILabel *JZCDLabel;
@end
