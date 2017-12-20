//
//  UIViewChooseNumber.h
//  Administration
//
//  Created by zhang on 2017/12/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewChooseNumberDelegate <NSObject>

@required
-(void)getChoosed:(UIPickerView *)pickView;

@end

@interface UIViewChooseNumber : UIView

@property (nonatomic)BOOL showYear;
@property (nonatomic,strong)NSString *stringTitle;
@property (nonatomic,assign)id<UIViewChooseNumberDelegate>delegate;
@property (nonatomic,strong)NSString *selected;

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title ShowYear:(BOOL)showYear;

@end
