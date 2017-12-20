//
//  UIChooseArea.h
//  Administration
//
//  Created by zhang on 2017/12/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIChooseAreaDelegate <NSObject>

@required

-(void)getChooseArea;

@end

@interface UIChooseArea : UIView

@property (nonatomic,assign) id <UIChooseAreaDelegate> delegate;
@property (nonatomic,strong)NSMutableDictionary *dictArea;
@end
