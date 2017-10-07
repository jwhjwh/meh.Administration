//
//  ViewChooseEdit.h
//  Administration
//
//  Created by zhang on 2017/9/26.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewChooseEditDelegate <NSObject>

@required

-(void)getState;

@end

@interface ViewChooseEdit : UIView

@property(nonatomic,assign)id<ViewChooseEditDelegate>delegate;
@property (nonatomic,strong)NSArray *arrayButton;
@property (nonatomic,weak)UITableView *tableView;
@end
