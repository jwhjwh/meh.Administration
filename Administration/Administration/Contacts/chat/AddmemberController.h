//
//  AddmemberController.h
//  Administration
//
//  Created by zhang on 2017/3/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddmemberController : UIViewController
@property (nonatomic,strong)UIImage *goursIamge;
@property (nonatomic,strong)NSString *textStr;
/** @brief 当前加载的页数 */
@property (nonatomic) int page;

/** @brief 是否启用下拉加载更多，默认为NO */
@property (nonatomic) BOOL showRefreshHeader;
/** @brief 是否启用上拉加载更多，默认为NO */
@property (nonatomic) BOOL showRefreshFooter;
/** @brief 是否显示无数据时的空白提示，默认为NO(未实现提示页面) */
@property (nonatomic) BOOL showTableBlankView;
@property (nonatomic) BOOL isAddMenber;
@property (nonatomic,strong) NSString *groupID;
@property (nonatomic,strong) NSString *groupinformationId;
@end
