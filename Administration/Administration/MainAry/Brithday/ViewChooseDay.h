//
//  ViewChooseDay.h
//  Administration
//
//  Created by zhang on 2017/11/3.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewChooseDayDelegate <NSObject>

@required
-(void)getSelect;

@end

@interface ViewChooseDay : UIView

@property (nonatomic,weak)UICollectionView *collectView;
@property (nonatomic,assign)id<ViewChooseDayDelegate> delegate;

@property (nonatomic,strong)NSMutableArray *arraySelect;

@end
