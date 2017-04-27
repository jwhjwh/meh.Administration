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
@property (strong,nonatomic) NSArray *numAry;
@property (strong,nonatomic) UIView* viewbuton;
@property (strong,nonatomic) UIButton* buttonname;
@property (strong,nonatomic) UIButton* qdbutton;
@property (strong,nonatomic) UIImageView * gouimage1;
@property (strong,nonatomic) NSMutableArray *imageAry;

@property (strong,nonatomic) NSMutableArray *NSywAry;//业务权限数组
@property (strong,nonatomic) NSMutableArray *NSmdAry;//美导权限数组
@property (strong,nonatomic) NSMutableArray *NSwlAry;//物流。。。。
@property (strong,nonatomic) NSMutableArray *NSnqAry;//内勤。。。。

@property (assign,nonatomic) int copde;
- (instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr coode:(int)coode numarr:(NSArray *)numarr;
-(UIView *)viewww:(CGFloat)xx yy:(CGFloat)yy v:(UIView*)v;
-(UIView *)viewbuton:(CGFloat)xx yy:(CGFloat)yy names:(NSArray*)names v:(UIView*)v tagg:(int)tagg;
@end
