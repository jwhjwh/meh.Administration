//
//  VCTargetMobaiDetail.h
//  Administration
//
//  Created by zhang on 2018/2/27.
//  Copyright © 2018年 九尾狐. All rights reserved.
//

#import "BaseViewController.h"

@interface VCTargetMobaiDetail : BaseViewController
@property (nonatomic,strong) NSString *OldTargetVisitId;
@property (strong,nonatomic) NSString *strId;
@property (nonatomic, assign) BOOL isofyou;
@property (nonatomic, assign) BOOL cellend;
@property(strong,nonatomic)NSString *shopid;//店铺id

@property (strong,nonatomic) NSString *oneStore;

@property (nonatomic,strong)NSString *stringTitle;
@property (nonatomic,strong)NSString *mobaiID;

@end
