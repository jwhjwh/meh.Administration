//
//  UIChooseState.h
//  Administration
//
//  Created by zhang on 2018/3/5.
//  Copyright © 2018年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIChooseDelegate <NSObject>

@required
-(void)getChooseIndexPath:(NSIndexPath *)indexPath;

@end


@interface UIChooseState : UIView

@property (nonatomic,assign)id<UIChooseDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array;

@end
