//
//  ViewChooseState.h
//  Administration
//
//  Created by zhang on 2017/10/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewChooseStateDelegate <NSObject>

@required

-(void)getClickIndex;

@end


@interface ViewChooseState : UIView

@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,assign)id<ViewChooseStateDelegate>delegate;

@end
