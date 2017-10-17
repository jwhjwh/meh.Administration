//
//  ViewChooseBacklog.h
//  Administration
//
//  Created by zhang on 2017/10/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewChooseBacklogDelegate <NSObject>

@required

-(void)getChoosed;

@end

@interface ViewChooseBacklog : UIView

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)id<ViewChooseBacklogDelegate> delegate;
@property (nonatomic,strong)NSArray *arrayTitle;
@end
