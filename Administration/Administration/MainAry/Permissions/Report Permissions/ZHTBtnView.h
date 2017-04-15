//
//  ZHTBtnView.h
//  Administration
//
//  Created by 九尾狐 on 2017/4/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHTBtnView : UIView


@property (strong,nonatomic) NSArray *ywAry;
@property (strong,nonatomic) UIView* viewbuton;
@property (strong,nonatomic) UIButton* buttonname;
@property (strong,nonatomic) UIButton* qdbutton;
@property (assign,nonatomic) int copde;
- (instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr coode:(int)coode;
-(UIView *)viewww:(CGFloat)xx yy:(CGFloat)yy v:(UIView*)v;
-(UIView *)viewbuton:(CGFloat)xx yy:(CGFloat)yy names:(NSArray*)names v:(UIView*)v tagg:(int)tagg;
@end
