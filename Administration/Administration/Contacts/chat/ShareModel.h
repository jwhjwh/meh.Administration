//
//  ShareModel.h
//  Administration
//
//  Created by zhang on 2017/8/9.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject
+(ShareModel *)shareModel;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic) BOOL isGroup;
@property (nonatomic) BOOL isDefaultGroup;
@property (nonatomic ,strong)NSArray *arrayPosition;
@end
