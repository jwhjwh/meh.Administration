//
//  InteredAlertView.h
//  Administration
//
//  Created by 九尾狐 on 2017/9/30.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^InteredAlert)(NSString *selectIndex);//编码

@interface InteredAlertView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;//标题label
@property (nonatomic, strong) NSArray *titles;//string数组
@property (nonatomic,strong) NSArray *isofary;
@property (nonatomic, copy) InteredAlert selectIndex;

+(InteredAlertView *)showWithTitle:(NSString *)title
                        titles:(NSArray *)titles
                      isof:(NSArray *)isofary
                   selectIndex:(InteredAlert)selectIndex;


@end
