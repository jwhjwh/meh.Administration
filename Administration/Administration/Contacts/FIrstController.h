//
//  FIrstController.h
//  Segmente-Deno
//
//  Created by 郭军 on 2016/11/24.
//  Copyright © 2016年 JUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseConversationModel.h"
#import "EaseConversationCell.h"
@interface FIrstController : UIViewController
/** @brief 当前加载的页数 */
@property (nonatomic) int page;

/** @brief 是否启用下拉加载更多，默认为NO */
@property (nonatomic) BOOL showRefreshHeader;
/** @brief 是否启用上拉加载更多，默认为NO */
@property (nonatomic) BOOL showRefreshFooter;
/** @brief 是否显示无数据时的空白提示，默认为NO(未实现提示页面) */
@property (nonatomic) BOOL showTableBlankView;
- (void)refresh;
- (void)refreshDataSource;
@end
