//
//  CrowdViewController.m
//  Administration
//
//  Created by zhang on 2017/3/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CrowdViewController.h"
#import "GroupCell.h"
#import "ChatViewController.h"
@interface CrowdViewController ()<UITableViewDelegate, UITableViewDataSource,EMGroupManagerDelegate,EaseMessageViewControllerDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** 群组列表 */
@property (nonatomic, strong) NSMutableArray *groupArr;
@property (nonatomic,strong) NSDictionary *dictInfo;
@end

@implementation CrowdViewController

-(void)getGroup
{
   // [GroupModel shareGroupModel].resultArr = [[NSMutableArray alloc]init];
    NSString *urlStr =[NSString stringWithFormat:@"%@group/selectMyGroup.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *userid = [USER_DEFAULTS objectForKey:@"userid"];
    
    NSDictionary *dictInfo = @{@"appkey":appKeyStr,@"usersid":userid,@"roleId":[USER_DEFAULTS objectForKey:@"roleId"],@"companyInfoId":[USER_DEFAULTS valueForKey:@"companyinfoid"]};
    __weak typeof(self)weakSelf = self;
    [ZXDNetworking GET:urlStr parameters:dictInfo success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            weakSelf.groupArr = [responseObject valueForKey:@"list"];
           // [self didUpdateGroupList:weakSelf.groupArr];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getGroup];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"我的群";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28, 28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    // 创建群组列表
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView registerClass:NSClassFromString(@"GroupCell.h") forCellReuseIdentifier:@"GroupCell"];
    self.tableView = tableView;
    
    //去除多余的cell线
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    
    [self reloadDataSource];
  
    self.groupArr = [NSMutableArray array];
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
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    self.dictInfo = self.groupArr[indexPath.row];
//    cell.headImageView.image = [UIImage imageNamed:dictInfo[@"img"]];
//    cell.nameLabel.text = dictInfo[@"name"];
//    cell.noReadLabel.text = dictInfo[@"unread"];
 //   cell.model = self.groupArr[indexPath.row];
    UserCacheInfo * userInfo = [UserCacheManager getById:self.dictInfo[@"id"]];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", self.dictInfo[@"name"]];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.AvatarUrl] placeholderImage:[UIImage imageNamed:@"banben100"]];
    if (self.dictInfo[@"unread"]!=0) {
        cell.noReadLabel.text = [NSString stringWithFormat:@"%@",self.dictInfo[@"unread"]];
    }
    else
    {
        [cell.noReadLabel removeFromSuperview];
    }
    
   
    return cell;
}
//设置分区的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //设置cell选中的效果
    
    EaseEmotionManager *manager = [[ EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:5 emotions:[EaseEmoji allEmoji]];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = self.groupArr[indexPath.row];
//    EMGroup *group = [self.groupArr objectAtIndex:indexPath.row];
    
    ChatViewController  *chatController = [[ChatViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%@",dic[@"groupNumber"]] conversationType:EMConversationTypeGroupChat];
    
    chatController.dictInfo = self.dictInfo;
    chatController.hidesBottomBarWhenPushed = YES;
    chatController.title = dic[@"name"];
    [chatController.faceView setEmotionManagers:@[manager]];
    [self.navigationController pushViewController:chatController animated:YES];
    
    
    NSLog(@"dic = %@",dic);
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
