//
//  ViewChooseScore.h
//  testTableView
//
//  Created by zhang on 2017/9/20.
//  Copyright © 2017年 zhang. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol ViewChooseScoreDelegate <NSObject>

@required

-(void)getIndexPath;

@end

@interface ViewChooseScore : UIView

@property (nonatomic,strong)NSArray *arrayContent;
@property (nonatomic,assign)id<ViewChooseScoreDelegate>delegate;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSString *score;
@property (nonatomic,strong)NSString *stringTitle;
@property (nonatomic,strong)UILabel *label;
@end
