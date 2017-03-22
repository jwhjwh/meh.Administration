//
//  CrowdViewController.m
//  Administration
//
//  Created by zhang on 2017/3/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CrowdViewController.h"

@interface CrowdViewController ()<UITableViewDelegate, UITableViewDataSource>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** 群组列表 */
@property (nonatomic, strong) NSMutableArray *groupArr;
@end

@implementation CrowdViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"我的群";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    // 创建群组列表
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    // 获取群列表
    NSArray *array = [[EMClient sharedClient].groupManager getJoinedGroups];
    self.groupArr = [NSMutableArray arrayWithArray:array];
    if (self.groupArr.count == 0) {
        // 从服务器获取群列表
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = nil;
            NSArray *groups = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    [weakself.groupArr removeAllObjects];
                    [weakself.groupArr addObjectsFromArray:groups];
                    [weakself.tableView reloadData];
                }
            });
        });
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    EMGroup *group = self.groupArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", group.groupId];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (void)dealloc {
    [[EMClient sharedClient].groupManager removeDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
