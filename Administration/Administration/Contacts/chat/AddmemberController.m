//
//  AddmemberController.m
//  Administration
//
//  Created by zhang on 2017/3/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AddmemberController.h"
#import "inftionxqController.h"
#import "ChatgrouController.h"
#import "LVModel.h"
#import "LVFmdbTool.h"

#import "RobotManager.h"
@interface AddmemberController ()<UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate,EMGroupManagerDelegate>

@property (strong,nonatomic) UIButton *sousuoBtn;//搜索框
@property (strong,nonatomic) UIView *view1;//第一条线
@property (strong,nonatomic) UILabel * lxLabel;//最近联系人Label
@property (strong,nonatomic) UITableView *ZJLXTable;//最近联系人列表
@property (nonatomic,strong)NSMutableArray *dataArray;//数据源
@property (nonatomic,strong) NSMutableArray *deleteArrarys;//选中的数据
@property (nonatomic,strong)NSMutableArray *ImageAry;//各部门图片
@property (nonatomic,strong)UIView *loni;
@property (nonatomic,strong)UIButton *allDelButton;
@property (nonatomic,strong)UIButton *delButton;

/** 标记是否全选 */
@property (nonatomic ,assign)BOOL isAllSelected;
@end

@implementation AddmemberController
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    NSMutableArray *array=[NSMutableArray arrayWithArray:[LVFmdbTool queryData:nil]];
//    self.dataArray=[NSMutableArray arrayWithArray:[[array reverseObjectEnumerator] allObjects]];
//    [self.ZJLXTable reloadData];
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerNotifications];
    [self refreshAndSortView];
    
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
    self.navigationItem.title=@"添加群成员";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    [self UIBtn];
    [self tableViewDidTriggerHeaderRefresh];
    self.isAllSelected = NO;
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)UIBtn{
    //搜索按钮
    UIView *viewles=[[UIView alloc]init];
    [self.view addSubview:viewles];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SeachTap:)];
    [viewles addGestureRecognizer:tap];
    [viewles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.mas_equalTo(40);
    }];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"seach"] forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    button.frame=CGRectMake(13,7,30,30);
    //防止图片变灰
    [viewles addSubview:button];
    UILabel *labelSeach=[[UILabel alloc]initWithFrame:CGRectMake(50, 5, 80, 30)];
    labelSeach.text=@"搜索";
    [viewles addSubview:labelSeach];
    
    //分割线
    _view1 = [[UIView alloc]init];
    _view1.backgroundColor = [UIColor RGBview];
    [self.view addSubview:_view1];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(viewles.mas_bottom);
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
    UITapGestureRecognizer *taposition = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SpotionTap:)];
    [view addGestureRecognizer:taposition];
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
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr. minimumPressDuration=0.3f;
    [_ZJLXTable addGestureRecognizer:longPressGr];
    /*=========================至关重要============================*/
    _ZJLXTable.allowsMultipleSelectionDuringEditing = YES;
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ZJLXRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BASE"forIndexPath:indexPath];
//      cell.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:0];
//    cell.model=self.dataArray[indexPath.row];
    NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
    EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _deleteArrarys = [NSMutableArray array];
    for (NSIndexPath *indexPath in _ZJLXTable.indexPathsForSelectedRows) {
        [_deleteArrarys addObject:self.dataArray[indexPath.row]];
    }
      [_delButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[_deleteArrarys count]] forState:UIControlStateNormal];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    [_deleteArrarys removeObject:[self.dataArray objectAtIndex:indexPath.row]];
    [_delButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[_deleteArrarys count]] forState:UIControlStateNormal];
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture {
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        _ZJLXTable.editing = !_ZJLXTable.editing;
        if (_ZJLXTable.editing) {
            _loni=[[UIView alloc]initWithFrame:CGRectMake(0,Scree_height-49,Scree_width/2,1)];
            _loni.backgroundColor=GetColor(230, 230, 230, 1);
            [self.view addSubview:_loni];
            _allDelButton=[UIButton buttonWithType:UIButtonTypeCustom];
            _allDelButton.frame=CGRectMake(0,Scree_height-48,Scree_width/2,48);
            [_allDelButton setTitle:@"全选" forState:UIControlStateNormal];
            [_allDelButton setTitleColor:GetColor(7, 138, 249, 1) forState:UIControlStateNormal];
            [_allDelButton addTarget:self action:@selector(allDelBtn) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_allDelButton];
            
            _delButton=[UIButton buttonWithType:UIButtonTypeCustom];
            _delButton.frame=CGRectMake(Scree_width/2,Scree_height-49,Scree_width/2, 49);
            [_delButton setTitle:@"确定" forState:UIControlStateNormal];
            [_delButton setBackgroundColor:GetColor(204, 174, 212, 1)];
            [_delButton addTarget:self action:@selector(deltButn) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_delButton];
        }else{
            [_loni removeFromSuperview];
            [_allDelButton removeFromSuperview];
            [_delButton removeFromSuperview];
        }
    }
}
//所点选的按钮
-(void)deleteArr
{
    
  
    
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
    
}
-(void)allDelBtn{

    self.isAllSelected = !self.isAllSelected;
    
    for (int i = 0; i<self.dataArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        if (self.isAllSelected) {
            [self.ZJLXTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
              [_delButton setTitle:[NSString stringWithFormat:@"确定(%d)",i+1] forState:UIControlStateNormal];
           
        }else{//反选
            [_delButton setTitle:@"确定(0)" forState:UIControlStateNormal];
            [self.ZJLXTable deselectRowAtIndexPath:indexPath animated:YES];
            
        }
    }
}
-(void)deltButn{
    _ZJLXTable.editing = !_ZJLXTable.editing;
    [_loni removeFromSuperview];
    [_allDelButton removeFromSuperview];
    [_delButton removeFromSuperview];
    NSMutableArray *source = [NSMutableArray array];
     for (NSIndexPath *indexPath in _ZJLXTable.indexPathsForSelectedRows) {
        [source addObject:self.dataArray[indexPath.row]];
    }
  
    __weak AddmemberController *weakSelf = self;
    NSString *username = [[EMClient sharedClient] currentUsername];
    NSString *messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join groups \'%@\'"), username, self.textStr];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:self.textStr description:nil invitees:source message:messageStr setting:nil error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (group && !error) {
                [weakSelf showHint:NSLocalizedString(@"group.create.success", @"create group success")];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            else{
                [weakSelf showHint:NSLocalizedString(@"group.create.fail", @"Failed to create a group, please operate again")];
            }
        });
    });

    ChatgrouController *chatGrVC=[[ChatgrouController alloc]init];
    [self.navigationController pushViewController:chatGrVC animated:YES];
}
-(void)SpotionTap:(UITapGestureRecognizer*)sender{
    
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
        if (converstion.type==EMConversationTypeChat) {
        model = [self modelForConversation:converstion];
        }
       
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
            __weak AddmemberController *weakSelf = self;
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
    __weak  AddmemberController *weakSelf = self;
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
#pragma mark - EMChatManagerDelegate
//监听消息
- (void)didReceiveMessages:(NSArray *)aMessages
{
    
    [self tableViewDidTriggerHeaderRefresh];
    
}
//#pragma mark - EMGroupManagerDelegate
//
//- (void)didUpdateGroupList:(NSArray *)groupList
//{
//    [self tableViewDidTriggerHeaderRefresh];
//}
@end
