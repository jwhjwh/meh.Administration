//
//  PersonneTableViewCell.h
//  Administration
//
//  Created by 九尾狐 on 2017/2/21.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"


@interface PersonneTableViewCell : UITableViewCell
-(void)loadDataFromModel:(PersonModel *)model;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *TelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *TXImage;

@end
