//
//  CellChargePerson.h
//  Administration
//
//  Created by zhang on 2017/11/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellChargePerson : UITableViewCell

@property (nonatomic,weak)UILabel *labelTitle;
@property (nonatomic,weak)UIImageView *imageViewAdd;
@property (nonatomic,weak)UIButton *buttonDel;
@property (nonatomic,weak)UIButton *buttonRed;
@property (nonatomic,weak)UILabel *labelName;

@property (nonatomic,strong)NSDictionary *dict;
@end
