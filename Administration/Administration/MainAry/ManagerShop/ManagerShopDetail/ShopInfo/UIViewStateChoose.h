//
//  UIViewStateChoose.h
//  Administration
//
//  Created by zhang on 2017/12/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewStateChooseDelegate <NSObject>

@required

-(void)getClickRow:(UITableView *)tableview;

@end

@interface UIViewStateChoose : UIView

@property (nonatomic,assign)id<UIViewStateChooseDelegate>delegate;

@end
