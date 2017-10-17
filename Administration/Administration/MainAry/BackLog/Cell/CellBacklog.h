//
//  CellBacklog.h
//  Administration
//
//  Created by zhang on 2017/10/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellBacklog : UITableViewCell
@property (nonatomic,weak)UILabel *labelMode;
@property (nonatomic,weak)UILabel *labelDetail;
@property (nonatomic,weak)UILabel *labelTime;
@property (nonatomic,weak)UILabel *labelDate;
@property (nonatomic,weak)UILabel *labelState;
@property (nonatomic,weak)UIImageView *imageSelect;
@property (nonatomic,weak)UIImageView *imageView1;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic)BOOL isSelect;
@end
