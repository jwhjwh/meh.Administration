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
@property (strong,nonatomic) NSMutableArray *NSckAry;//仓库。。。。
@property (strong,nonatomic) NSMutableArray *NSkfAry;//客服。。。。
@property (strong,nonatomic) NSMutableArray *NSkjAry;//会计。。。。
@property (strong,nonatomic) NSMutableArray *NScnAry;//出纳。。。。
@property (strong,nonatomic) NSMutableArray *NScwjlAry;//财务经理。。。。
@property (strong,nonatomic) NSMutableArray *NSwljlAry;//物流经理。。。。
@property (strong,nonatomic) NSMutableArray *NSkfjlAry;//客服经理。。。。
@property (strong,nonatomic) NSMutableArray *NSscjlAry;//市场经理。。。。
@property (strong,nonatomic) NSMutableArray *NSywjlAry;//业务经理。。。。
/*
 
 case 5:
 //@"业务";
 break;
 case 2:
 //@"美导";
 break;
 case 4:
 //@"物流";
 break;
 case 3:
 //@"客服";
 break;
 case 14:
 // @"仓库";
 break;
 case 16:
 //@"会计";
 break;
 case 17:
 //@"出纳";
 break;
 case 15:
 //@"财务总监";
 break;
 case 13:
 //@"物流经理";
 break;
 case 12:
 // @"客服经理";
 break;
 case 6:
 // @"市场经理";
 break;
 case 8:
 //@"业务经理";
 break;



 */

@property (assign,nonatomic) int copde;
- (instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr coode:(int)coode numarr:(NSArray *)numarr;
-(UIView *)viewww:(CGFloat)xx yy:(CGFloat)yy v:(UIView*)v;
-(UIView *)viewbuton:(CGFloat)xx yy:(CGFloat)yy names:(NSArray*)names v:(UIView*)v tagg:(int)tagg;
@end
