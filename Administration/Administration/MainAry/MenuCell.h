//
//  MenuCell.h
//  快速入口轮番
//
//  Created by yhj on 16/1/13.
//  Copyright © 2016年 QQ:1787354782 QQ群:524884683. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHJBtnView.h"

@interface MenuCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray;

@end
