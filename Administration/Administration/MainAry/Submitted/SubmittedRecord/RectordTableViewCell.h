//
//  RectordTableViewCell.h
//  Administration
//
//  Created by 九尾狐 on 2017/3/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RectordModel.h"
@interface RectordTableViewCell : UITableViewCell
-(void)loadDataFromModel:(RectordModel *)model;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *submittedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *submittedImage;
@end
