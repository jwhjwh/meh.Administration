//
//  SubmittedTableViewCell.h
//  Administration
//
//  Created by 九尾狐 on 2017/3/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmittedModel.h"
@interface SubmittedTableViewCell : UITableViewCell
-(void)loadDataFromModel:(SubmittedModel *)model;
@property (weak, nonatomic) IBOutlet UIImageView *txImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iponeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *submittedImage;
@property (weak, nonatomic) IBOutlet UILabel *submittedLabel;
@property (weak, nonatomic) IBOutlet UILabel *birLabel;

@end
