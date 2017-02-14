//
//  XCQ_tabbarViewController.h
//  自定义tabbar
//
//  Created by Mr.X on 2016/12/14.
//  Copyright © 2016年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCQ_tabbarViewController : UITabBarController

@property (nonatomic,strong) NSMutableArray *XCQ_TabArr;

-(instancetype)initWithNomarImageArr:(NSArray *)nomarImageArr
                   andSelectImageArr:(NSArray *)selectImageArr
                         andtitleArr:(NSArray *)titleArr;


-(void)setRedIndex:(BOOL)redIndex
andControllerIndex:(NSInteger)ControllerIndex
       andBudgeNum:(NSInteger)budgeNum;
@end
