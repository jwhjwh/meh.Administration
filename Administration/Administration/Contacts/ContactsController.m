//
//  ContactsController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ContactsController.h"
#import "inftionxqController.h"
#import "CrowdViewController.h"
#import "BuildViewController.h"

#import "ApplyViewController.h"

#import <UserNotifications/UserNotifications.h>
#import "ChatUIHelper.h"
#import "ChatViewController.h"
#import "RobotManager.h"
#import "InvitationManager.h"

@interface ContactsController ()<UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate,EMGroupManagerDelegate>
@property (strong,nonatomic) UIButton *sousuoBtn;//搜索框
@property (strong,nonatomic) UIView *view1;//第一条线
@property (strong,nonatomic) UILabel * lxLabel;//最近联系人Label
@property (strong,nonatomic) UITableView *ZJLXTable;//最近联系人列表
@property (nonatomic,strong)NSMutableArray *dataArray;//数据源
@property (nonatomic,strong)NSMutableArray *ImageAry;//各部门图片

@property (nonatomic,strong)NSMutableArray *dataSource;

@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end

@implementation ContactsController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;

    [self registerNotifications];
    [self refreshAndSortView];
    [self reloadApplyView];
    [self tableViewDidTriggerHeaderRefresh];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
  
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
}
- (void)dealloc{
    [self unregisterNotifications];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"通讯录";
    UIBarButtonItem *lifttitem = [[UIBarButtonItem alloc] initWithTitle:@"群" style:(UIBarButtonItemStyleDone) target:self action:@selector(liftItemAction)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [lifttitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = lifttitem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"创建群" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemA)];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    [self UIBtn];
    

}
-(void)UIBtn{
    //搜索按钮
    _sousuoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *imageBtn = [UIImage imageNamed:@"ss_ico01"];
    [_sousuoBtn setBackgroundImage:imageBtn forState:UIControlStateNormal];
    //防止图片变灰
    _sousuoBtn.adjustsImageWhenHighlighted = NO;
    _sousuoBtn.layer.masksToBounds = YES;
    _sousuoBtn.layer.cornerRadius = 8.0;
    [_sousuoBtn addTarget:self action:@selector(Touchsearch)forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_sousuoBtn];
    [_sousuoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(self.view.mas_top).offset(70);
        make.height.mas_equalTo(40);
    }];
    //分割线
    _view1 = [[UIView alloc]init];
    _view1.backgroundColor = [UIColor RGBview];
    [self.view addSubview:_view1];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(_sousuoBtn.mas_bottom).offset(6);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
    UIView *view=[[UIView alloc]init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(_view1.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(49);
    }];
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setBackgroundImage:[UIImage imageNamed:@"archite"] forState:UIControlStateNormal];
    but.adjustsImageWhenHighlighted = NO;
    but.frame=CGRectMake(13,5, 39,39);
    //防止图片变灰
    [view addSubview:but];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(65,10 ,100, 29)];
    label.text=@"按职位选择";
    [view addSubview:label];

    UIButton *buton=[UIButton buttonWithType:UIButtonTypeCustom];
    [buton setBackgroundImage:[UIImage imageNamed:@"jiantou_03"] forState:UIControlStateNormal];
    buton.frame=CGRectMake(Scree_width-35,15,19,19);
    //防止图片变灰
    [view addSubview:buton];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor RGBview];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];
    //最近联系人
    _lxLabel = [[UILabel alloc]init];
    _lxLabel.text= @"最近联系人";
    _lxLabel.textColor = [UIColor RGBview];
    _lxLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_lxLabel];
    [_lxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.top.mas_equalTo(line.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor RGBview];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(_lxLabel.mas_bottom).offset(5);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];
    //最近联系人列表
    _ZJLXTable = [[UITableView alloc]init];
    _ZJLXTable.backgroundColor = [UIColor whiteColor];
   // _ZJLXTable.separatorStyle = UITableViewCellSelectionStyleNone;
    _ZJLXTable.delegate = self;
    _ZJLXTable.dataSource = self;
    [self.view addSubview:_ZJLXTable];    
    //去除多余的cell线
    [ZXDNetworking setExtraCellLineHidden:_ZJLXTable];
    [_ZJLXTable registerNib:[UINib nibWithNibName:@"ZJLXRTableViewCell" bundle:nil] forCellReuseIdentifier:@"BASE"];
    [_ZJLXTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom).offset(5);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-49);
    }];

}


-(void)Touchsearch{
    //SearchViewController
    SearchViewController *SearchVC = [[SearchViewController alloc]init];
    [self.navigationController showViewController:SearchVC sender:nil];

}

#pragma -mark UITableViewDelegate,UITableViewDataSource
//设置每个分区的单元格数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

//设置分区的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
    EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
       if (cell == nil) {
        cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([self.dataArray count] <= indexPath.row) {
        return cell;
    }
    
    id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row];
       cell.model = model;
    
  
        NSMutableAttributedString *attributedText = [[self latestMessageTitleForConversationModel:model] mutableCopy];
        [attributedText addAttributes:@{NSFontAttributeName : cell.detailLabel.font} range:NSMakeRange(0, attributedText.length)];
        cell.detailLabel.attributedText =  attributedText;
    
    
  
        cell.timeLabel.text = [self latestMessageTimeForConversationModel:model];
   
    
    return cell;

}
//选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置cell选中的效果
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [self didSelectConversationModel:model];

 
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:nil];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.ZJLXTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
#pragma mark - data

-(void)refreshAndSortView
{
    if ([self.dataArray count] > 1) {
        if ([[self.dataArray objectAtIndex:0] isKindOfClass:[EaseConversationModel class]]) {
            NSArray* sorted = [self.dataArray sortedArrayUsingComparator:
                               ^(EaseConversationModel *obj1, EaseConversationModel* obj2){
                                   EMMessage *message1 = [obj1.conversation latestMessage];
                                   EMMessage *message2 = [obj2.conversation latestMessage];
                                   if(message1.timestamp > message2.timestamp) {
                                       return(NSComparisonResult)NSOrderedAscending;
                                   }else {
                                       return(NSComparisonResult)NSOrderedDescending;
                                   }
                               }];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:sorted];
        }
    }
    [self.ZJLXTable reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)rightItemA{
    BuildViewController *creatVC=[[BuildViewController alloc]init];
    [self.navigationController pushViewController:creatVC animated:YES];
}
-(void)liftItemAction{
    CrowdViewController *CrowdVC=[[CrowdViewController alloc]init];
    [self.navigationController pushViewController:CrowdVC animated:YES];
}
/*!
 @method@brief 加载会话列表 @discussion @result
 */
- (void)tableViewDidTriggerHeaderRefresh
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    

    
    [self.dataArray removeAllObjects];
    for (EMConversation *converstion in sorted) {
        EaseConversationModel *model = nil;
      
            model = [self modelForConversation:converstion];
      
        
        if (model) {
            [self.dataArray addObject:model];
        }
    }
    
    [self.ZJLXTable reloadData];
    [self tableViewDidFinishTriggerHeader:YES reload:NO];
}
#pragma mark - setter

- (void)setShowRefreshHeader:(BOOL)showRefreshHeader
{
    if (_showRefreshHeader != showRefreshHeader) {
        _showRefreshHeader = showRefreshHeader;
        if (_showRefreshHeader) {
            __weak ContactsController *weakSelf = self;
            self.ZJLXTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerHeaderRefresh];
            }];
            self.ZJLXTable.mj_header.accessibilityIdentifier = @"refresh_header";
            //            header.updatedTimeHidden = YES;
        }
        else{
            [self.ZJLXTable setMj_header:nil];
        }
    }
}


- (void)setShowTableBlankView:(BOOL)showTableBlankView
{
    if (_showTableBlankView != showTableBlankView) {
        _showTableBlankView = showTableBlankView;
    }
}
#pragma mark - public refresh

- (void)autoTriggerHeaderRefresh
{
    if (self.showRefreshHeader) {
        [self tableViewDidTriggerHeaderRefresh];
    }
}
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload
{
    __weak  ContactsController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [weakSelf.ZJLXTable reloadData];
        }
        
        if (isHeader) {
            [weakSelf.ZJLXTable.mj_header endRefreshing];
        }
        else{
            [weakSelf.ZJLXTable.mj_footer endRefreshing];
        }
    });
}

#pragma mark - private

/*!
 @method
 @brief 获取会话最近一条消息内容提示
 @discussion
 @param conversationModel  会话model
 @result 返回传入会话model最近一条消息提示
 */
- (NSString *)_latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSEaseLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSEaseLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSEaseLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSEaseLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSEaseLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}
/*!
 @method
 @brief 获取会话最近一条消息时间
 @discussion
 @param conversationModel  会话model
 @result 返回传入会话model最近一条消息时间
 */
- (NSString *)_latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp ;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return latestMessageTime;
}

#pragma mark - getter

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(NSAttributedString *)latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
        
        if (lastMessage.direction == EMMessageDirectionReceive) {
            NSString *from = @"";
            NSDictionary *ext = lastMessage.ext;   //(环信：扩展消息）
            if(ext){
                from = [NSString stringWithFormat:@"%@:",[ext objectForKey:@"name"]];
            }else{
                from = lastMessage.from;
            }
            latestMessageTitle = [NSString stringWithFormat:@"%@", latestMessageTitle];
        }
        
        NSDictionary *ext = conversationModel.conversation.ext;
        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atAll", nil), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atAll", nil).length)];
            
        }
        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atMe", @"[Somebody @ me]"), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atMe", @"[Somebody @ me]").length)];
        }
        else {
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
        }
    }
    
    return attributedStr;

}
- (NSString *)latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    
    return latestMessageTime;
}
#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)modelForConversation:(EMConversation *)conversation
{
    
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == EMConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
            model.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
        } else {
            UserCacheInfo *user = [UserCacheManager getById:conversation.conversationId];
            if (user) {
                model.title= user.NickName;
                model.avatarURLPath = user.AvatarUrl;
            }
        }
    } else if (model.conversation.type == EMConversationTypeGroupChat) {
        NSString *imageName = @"tx23";
        if (![conversation.ext objectForKey:@"subject"])
        {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.conversationId]) {
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.subject forKey:@"subject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        NSDictionary *ext = conversation.ext;
        model.title = [ext objectForKey:@"subject"];
        imageName = [[ext objectForKey:@"isPublic"] boolValue] ? @"tx23" : @"tx23";
        model.avatarImage = [UIImage imageNamed:imageName];
    }
    return model;
}
- (void)didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
                ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
                [self.navigationController pushViewController:chatController animated:YES];
            } else {
            
              ChatViewController  *chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];

                chatController.title = conversationModel.title;
                [self.navigationController pushViewController:chatController animated:YES];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [self.ZJLXTable reloadData];
    }
}
#pragma mark - EMChatManagerDelegate
//监听消息
- (void)didReceiveMessages:(NSArray *)aMessages
{
   
    [self tableViewDidTriggerHeaderRefresh];
    for(EMMessage *message in aMessages){
        //        [UserCacheManager saveInfo:message.ext];// 通过消息的扩展属
        
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];


//            switch (state) {
//                case UIApplicationStateActive:
//                    [self playSoundAndVibration];
//                    break;
//                case UIApplicationStateInactive:
//                    [self playSoundAndVibration];
//                    break;
//                case UIApplicationStateBackground:
//                    [self showNotificationWithMessage:message];
//                    break;
//                default:
//                    break;
//       
//
//        }
    }
      

    
}
#pragma mark - EMGroupManagerDelegate

- (void)didUpdateGroupList:(NSArray *)groupList
{
    [self tableViewDidTriggerHeaderRefresh];
}
//同意添加好友或者群组
- (void)reloadApplyView
{
    NSString *loginName =  [[EMClient sharedClient] currentUsername];
    if(loginName && [loginName length] > 0)
    {
        NSLog(@"%@",loginName);
        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        [self.dataSource addObjectsFromArray:applyArray];
        NSLog(@"%lu",(unsigned long)applyArray.count);
        if (self.dataSource.count>0) {
            for ( ApplyEntity *entity  in self.dataSource) {
                ApplyStyle applyStyle = [entity.style intValue];
                EMError *error;
                if (applyStyle == ApplyStyleJoinGroup){
                    error = [[EMClient sharedClient].groupManager declineInvitationFromGroup:entity.groupId inviter:entity.applicantUsername reason:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
//                        [self.dataSource removeObject:entity];
                        [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginName];
                    }
                      });
                }
            }
           
        }

    }
}
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}


//- (void)playSoundAndVibration{
//    NSTimeInterval timeInterval = [[NSDate date]
//                                   timeIntervalSinceDate:self.lastPlaySoundDate];
//    if (timeInterval < kDefaultPlaySoundInterval) {
//        //如果距离上次响铃和震动时间太短, 则跳过响铃
//        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
//        return;
//    }
//    
//    //保存最后一次响铃时间
//    self.lastPlaySoundDate = [NSDate date];
//    
//    // 收到消息时，播放音频
//    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
//    // 收到消息时，震动
//    [[EMCDDeviceManager sharedInstance] playVibration];
//}
//
//- (void)showNotificationWithMessage:(EMMessage *)message
//{
//    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
//    NSString *alertBody = nil;
//    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
//        EMMessageBody *messageBody = message.body;
//        NSString *messageStr = nil;
//        switch (messageBody.type) {
//            case EMMessageBodyTypeText:
//            {
//                messageStr = ((EMTextMessageBody *)messageBody).text;
//            }
//                break;
//            case EMMessageBodyTypeImage:
//            {
//                messageStr = NSLocalizedString(@"message.image", @"Image");
//            }
//                break;
//            case EMMessageBodyTypeLocation:
//            {
//                messageStr = NSLocalizedString(@"message.location", @"Location");
//            }
//                break;
//            case EMMessageBodyTypeVoice:
//            {
//                messageStr = NSLocalizedString(@"message.voice", @"Voice");
//            }
//                break;
//            case EMMessageBodyTypeVideo:{
//                messageStr = NSLocalizedString(@"message.video", @"Video");
//            }
//                break;
//            default:
//                break;
//        }
//        
//        do {
//            NSString *title = [UserCacheManager getNickById:message.from];
//            if (message.chatType == EMChatTypeGroupChat) {
//                NSDictionary *ext = message.ext;
//                if (ext && ext[kGroupMessageAtList]) {
//                    id target = ext[kGroupMessageAtList];
//                    if ([target isKindOfClass:[NSString class]]) {
//                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
//                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
//                            break;
//                        }
//                    }
//                    else if ([target isKindOfClass:[NSArray class]]) {
//                        NSArray *atTargets = (NSArray*)target;
//                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
//                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
//                            break;
//                        }
//                    }
//                }
//                NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
//                for (EMGroup *group in groupArray) {
//                    if ([group.groupId isEqualToString:message.conversationId]) {
//                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
//                        break;
//                    }
//                }
//            }
//            else if (message.chatType == EMChatTypeChatRoom)
//            {
//                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
//                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
//                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
//                if (chatroomName)
//                {
//                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
//                }
//            }
//            
//            alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
//        } while (0);
//    }
//    else{
//        alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
//    }
//    
//    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
//    BOOL playSound = NO;
//    if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
//        self.lastPlaySoundDate = [NSDate date];
//        playSound = YES;
//    }
//    
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
//    [userInfo setObject:message.conversationId forKey:kConversationChatter];
//    
//    //发送本地推送
//    if (NSClassFromString(@"UNUserNotificationCenter")) {
//        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
//        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//        if (playSound) {
//            content.sound = [UNNotificationSound defaultSound];
//        }
//        content.body =alertBody;
//        content.userInfo = userInfo;
//        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
//        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
//    }
//    else {
//        UILocalNotification *notification = [[UILocalNotification alloc] init];
//        notification.fireDate = [NSDate date]; //触发通知的时间
//        notification.alertBody = alertBody;
//        notification.alertAction = NSLocalizedString(@"open", @"Open");
//        notification.timeZone = [NSTimeZone defaultTimeZone];
//        if (playSound) {
//            notification.soundName = UILocalNotificationDefaultSoundName;
//        }
//        notification.userInfo = userInfo;
//        
//        //发送通知
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    }
//}
-(void)refresh
{
    [self refreshAndSortView];
}
-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}

@end
