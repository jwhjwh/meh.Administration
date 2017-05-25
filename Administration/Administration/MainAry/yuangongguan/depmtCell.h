//
//  depmtCell.h
//  Administration
//
//  Created by zhang on 2017/5/25.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface depmtCell : UITableViewCell
@property(nonatomic,retain)UILabel *mLabel;
@property (nonatomic,retain)UILabel *xLabel;
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier arr:(NSArray*)arr;
@end
