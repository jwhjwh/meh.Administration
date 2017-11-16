//
//  ViewChooseCity.h
//  Administration
//
//  Created by zhang on 2017/11/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ViewChooseCityDelegate <NSObject>

@required
-(void)getCity;

@end

@interface ViewChooseCity : UIView

@property (nonatomic,assign)id<ViewChooseCityDelegate>delegate;

@property (nonatomic,strong)NSMutableArray *arrayProvince;
@property (nonatomic,strong)NSMutableArray *arrayCity;
@property (nonatomic,strong)NSMutableArray *arrayCountry;

@property (nonatomic,strong)NSString *stringAll;

@end
