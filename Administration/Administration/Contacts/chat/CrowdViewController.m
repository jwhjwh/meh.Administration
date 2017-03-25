//
//  CrowdViewController.m
//  Administration
//
//  Created by zhang on 2017/3/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CrowdViewController.h"

#import "ChatViewController.h"
@interface CrowdViewController ()<UITableViewDelegate, UITableViewDataSource,EMGroupManagerDelegate>

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
    
    //去除多余的cell线
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    
    [self reloadDataSource];
    // 获取群列表·
    NSArray *array = [[EMClient sharedClient].groupManager getJoinedGroups];
  
    self.groupArr = [NSMutableArray arrayWithArray:array];
    if (self.groupArr.count == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // 从服务器获取群列表
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = nil;
            NSArray *groups = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    [MBProgressHUD hideHUDForView: self.view animated:NO];
                    [weakself.groupArr removeAllObjects];
                    [weakself.groupArr addObjectsFromArray:groups];
                    [weakself.tableView reloadData];
                }
            });
        });
    }
    if (self.groupArr.count==0) {
    [_tableView addEmptyViewWithImageName:@"" title:@"暂无经群组，创建一个吧～～"];
        _tableView.emptyView.hidden = NO;
    }
    [_tableView reloadData];
    
}
- (void)reloadDataSource
{
    [self.groupArr removeAllObjects];
    
    NSArray *rooms = [[EMClient sharedClient].groupManager getJoinedGroups];
    [self.groupArr addObjectsFromArray:rooms];
    
    [self.tableView reloadData];
}
#pragma mark - EMGroupManagerDelegate

- (void)didUpdateGroupList:(NSArray *)groupList
{
    [self.groupArr removeAllObjects];
    [self.groupArr addObjectsFromArray:groupList];
    [self.tableView reloadData];
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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    EMGroup *group = self.groupArr[indexPath.row];
    UserCacheInfo * userInfo = [UserCacheManager getById:group.groupId];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", group.subject];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:userInfo.AvatarUrl] placeholderImage:[UIImage imageNamed:@"banben100"]];
    //2、调整大小
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.layer.masksToBounds = YES;
    // 设置圆角半径
    cell.imageView.layer.cornerRadius =20.0f;
    return cell;
}
//设置分区的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //设置cell选中的效果
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EMGroup *group = [self.groupArr objectAtIndex:indexPath.row];
    ChatViewController  *chatController = [[ChatViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
    
    chatController.title = group.subject;
    [self.navigationController pushViewController:chatController animated:YES];
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
