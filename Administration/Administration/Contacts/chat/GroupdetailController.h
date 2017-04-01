//
//  GroupdetailController.h
//  Administration
//
//  Created by zhang on 2017/3/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  群组成员类型
 */
typedef enum{
    GroupOccupantTypeOwner,//创建者
    GroupOccupantTypeMember,//成员
}GroupOccupantType;

@interface GroupdetailController : UIViewController
@property (nonatomic,strong) NSString *popl;
- (instancetype)initWithGroupId:(NSString *)chatGroupId;

@end
