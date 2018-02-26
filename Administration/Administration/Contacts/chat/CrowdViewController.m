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
@property (nonatomic,strong) NSMutableArray *resultArr;
@end

@implementation CrowdViewController

-(void)getGroup
{
    [self.groupArr removeAllObjects];
   // [GroupModel shareGroupModel].resultArr = [[NSMutableArray alloc]init];
    NSString *urlStr =[NSString stringWithFormat:@"%@group/selectMyGroup.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *userid = [USER_DEFAULTS objectForKey:@"userid"];
    
    NSDictionary *dictInfo = @{@"appkey":appKeyStr,@"usersid":userid,@"roleId":[USER_DEFAULTS objectForKey:@"roleId"],@"companyInfoId":[USER_DEFAULTS valueForKey:@"companyinfoid"]};
    [ZXDNetworking GET:urlStr parameters:dictInfo success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.groupArr = [[responseObject valueForKey:@"list"]mutableCopy];
            NSMutableArray *arrayDefalut = [NSMutableArray array];
            NSMutableArray *arrayCreated = [NSMutableArray array];
            NSMutableArray *arrayJoined = [NSMutableArray array];
            for (NSDictionary *dict in self.groupArr) {
                int code = [dict[@"joinType"] intValue];
                if (code==0) {
                    [arrayDefalut addObject:dict];
                }else if(code==1)
                {
                    [arrayCreated addObject:dict];
                }else
                {
                    [arrayJoined addObject:dict];
                }
            }
            [self.resultArr insertObject:arrayDefalut atIndex:0];
            [self.resultArr insertObject:arrayCreated atIndex:1];
            [self.resultArr insertObject:arrayJoined atIndex:2];
            
            [self.tableView reloadData];
            return ;
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
            return;
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"token超时请重新登录" andInterval:1.0];
            return;
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"1111"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.resultArr removeAllObjects];
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
    
   
    
    self.resultArr = [NSMutableArray array];
    self.groupArr = [NSMutableArray array];
}


- (void)reloadDataSource
{
    [self.groupArr removeAllObjects];
    
   // NSArray *rooms = [[EMClient sharedClient].groupManager getJoinedGroups];
   // [self.groupArr addObjectsFromArray:rooms];
    
    [self.tableView reloadData];
}
#pragma mark - EMGroupManagerDelegate

//- (void)didUpdateGroupList:(NSArray *)groupList
//{
//    [self.groupArr removeAllObjects];
//    [self.groupArr addObjectsFromArray:groupList];
//    [self.tableView reloadData];
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.resultArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.resultArr[section]count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.resultArr[section] count]!=0) {
        if (section==0) {
            return [NSString stringWithFormat:@"默认的群（%lu）",(unsigned long)[self.resultArr[section]count]];
        }else if(section==1)
        {
            return [NSString stringWithFormat:@"我创建的群（%lu）",(unsigned long)[self.resultArr[section]count]];
        }else
            return [NSString stringWithFormat:@"我加入的群（%lu）",(unsigned long)[self.resultArr[section]count]];
    }
    else
        return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GroupCell";
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dictInfo = self.resultArr[indexPath.section][indexPath.row];
   // UserCacheInfo * userInfo = [UserCacheManager getById:self.dictInfo[@"id"]];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",dictInfo[@"name"]];
    [EMSDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"forHTTPHeaderField:@"Accept"];
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@",KURLImage,dictInfo[@"img"]];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:stringUrl] placeholderImage:[UIImage imageNamed:@"banben100"] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"error = %@",error);
    }];
    int unread = [dictInfo[@"unread"] intValue];
    if (unread!=0) {
        cell.noReadLabel.text = [NSString stringWithFormat:@"%@",dictInfo[@"unread"]];
    }
    else
    {
        cell.noReadLabel.hidden = YES;
    }
    cell.model = dictInfo;
    
   
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.resultArr[section] count]!=0) {
        return 30;
    }
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
//设置分区的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //设置cell选中的效果
    
    EaseEmotionManager *manager = [[ EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:5 emotions:[EaseEmoji allEmoji]];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = self.resultArr[indexPath.section][indexPath.row];
//    EMGroup *group = [self.groupArr objectAtIndex:indexPath.row];
    ChatViewController  *chatController = [[ChatViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%@",dic[@"groupNumber"]] conversationType:EMConversationTypeGroupChat];
    
    chatController.dictInfo = dic;
    chatController.isGroup = YES;
    chatController.hidesBottomBarWhenPushed = YES;
    chatController.title = dic[@"name"];
    chatController.groupNmuber = dic[@"groupNumber"];
    [chatController.faceView setEmotionManagers:@[manager]];
    [self.navigationController pushViewController:chatController animated:YES];
    
    if ([self.resultArr[0] count]!=0&&indexPath.section==0) {
        [ShareModel shareModel].isDefaultGroup = YES;
    }else
    {
        [ShareModel shareModel].isDefaultGroup = NO;
    }
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
