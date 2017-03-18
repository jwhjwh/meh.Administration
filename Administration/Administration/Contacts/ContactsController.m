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


#import "ChatViewController.h"
#import "YunChatListCell.h"

@interface ContactsController ()<UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate>
@property (strong,nonatomic) UIButton *sousuoBtn;//搜索框
@property (strong,nonatomic) UIView *view1;//第一条线
@property (strong,nonatomic) UILabel * lxLabel;//最近联系人Label
@property (strong,nonatomic) UITableView *ZJLXTable;//最近联系人列表
@property (nonatomic,strong)NSMutableArray *dataArray;//数据源
@property (nonatomic,strong)NSMutableArray *ImageAry;//各部门图片


@property (nonatomic,strong) NSMutableArray *dataLoadDataSource;   //当前用户的所有会话列表
@property (nonatomic,strong) NSMutableArray      *groupArry;             //所有群
@property (nonatomic,strong) NSMutableArray      *friendsArry;           //所有好友

@end

@implementation ContactsController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
 
}
- (id)init{
    self = [super init];
    if(self){
        //注册一个监听对象到监听列表中,监听环信SDK事件
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];//登录相关的回调
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //删除了好友
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRemoveFirendGroup:) name:@"didRemoveFirendGroup" object:nil];
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
//    //各部门按钮
//    for (int i = 0 ; i < 4; i++) {
//        NSInteger index = i % 4;
//        NSInteger page = i / 4;
//        UIButton *aBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        aBt.adjustsImageWhenHighlighted = NO;
//        aBt.backgroundColor = [UIColor clearColor];
//        aBt.frame = CGRectMake(index * (Scree_width/4)+Height_Space, page  * (Button_Height + Height_Space)+Start_Y+70, Button_Width, Button_Height);
//
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Contact%d",i]];
//        [aBt setBackgroundImage:image forState:UIControlStateNormal];
//        aBt.tag= i;
//        [aBt addTarget:self action:@selector(TouchAbt:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:aBt];
//    }
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
//-(void)TouchAbt:(UIButton *)aBt{
//    PersonnelViewController *PersonVC = [[PersonnelViewController alloc]init];
//    switch (aBt.tag) {
//        case 0:
//            PersonVC.roleld= @"2";
//            [self.navigationController showViewController:PersonVC sender:nil];
//            break;
//        case 1:
//            PersonVC.roleld= @"5";
//            [self.navigationController showViewController:PersonVC sender:nil];
//            break;
//        case 2:
//            PersonVC.roleld= @"3";
//            [self.navigationController showViewController:PersonVC sender:nil];
//            break;
//        case 3:
//            PersonVC.roleld= @"4";
//            [self.navigationController showViewController:PersonVC sender:nil];
//            break;
//            
//        default:
//            break;
//    }
//    
//    
//    
//    
//    
//}

#pragma -mark UITableViewDelegate,UITableViewDataSource
//设置每个分区的单元格数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataLoadDataSource.count;
}

//设置分区的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdetify = @"YunChatListCell";
    YunChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuseIdetify owner:self options:nil] lastObject];
        //设置tableview分割线长度(ios7/ios8)
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
    cell.messageNumbLabel.hidden = YES;
    
    //聊天的会话对象
    EMConversation *conversation = _dataLoadDataSource[indexPath.row];
    
    if (conversation.type == EMConversationTypeChat) {
        
        //单聊
        cell.headImageView.image =conversation.ext[@""];;
        cell.nicknameLabel.text =conversation.ext[@""];
        cell.signatureLabel.text = [self subTitleMessageByConversation:conversation];
        cell.timeLabel.text = [self lastMessageTimeByConversation:conversation];
        NSInteger num = [self unreadMessageCountByConversation:conversation];
        if(num>0){
            if(num > 99){
                cell.messageNumbLabel.text = [NSString stringWithFormat:@"99+"];
                cell.messageNumbLabel.frame = CGRectMake(35, 5, 30, 20);
            }else{
                cell.messageNumbLabel.text = [NSString stringWithFormat:@"%tu",num];
                cell.messageNumbLabel.frame = CGRectMake(40, 5, 20, 20);
            }
            cell.messageNumbLabel.hidden = NO;
        }
        
    }else if(conversation.type == EMConversationTypeGroupChat) {
        
        //群聊
        EMGroup *groupt;
        for (EMGroup *group in _groupArry) {
            if ([group.groupId isEqualToString:conversation.conversationId]) {
                groupt = group;
                break;
            }
        }
        
        cell.headImageView.image = [UIImage imageNamed:@"head2"];
        cell.nicknameLabel.text = [NSString stringWithFormat:@"%@【群】",groupt.subject];
        cell.signatureLabel.text = [NSString stringWithFormat:@"%@:%@",[self subNameMessageByConversation:conversation],[self subTitleMessageByConversation:conversation]];
        cell.timeLabel.text = [self lastMessageTimeByConversation:conversation];
        NSInteger num = [self unreadMessageCountByConversation:conversation];
        if(num>0){
            if(num > 99){
                cell.messageNumbLabel.text = [NSString stringWithFormat:@"99+"];
                cell.messageNumbLabel.frame = CGRectMake(35, 5, 30, 20);
            }else{
                cell.messageNumbLabel.text = [NSString stringWithFormat:@"%tu",num];
                cell.messageNumbLabel.frame = CGRectMake(40, 5, 20, 20);
            }
            cell.messageNumbLabel.hidden = NO;
        }
        
    }
    
    return cell;
}
//选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置cell选中的效果
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //聊天的会话对象
    EMConversation *conversation = _dataLoadDataSource[indexPath.row];
    if (conversation.type == EMConversationTypeChat) {
        
        //单聊
        ChatViewController *chat = [[ChatViewController alloc]initWithConversationChatter:conversation.conversationId conversationType:EMConversationTypeChat];
        [self.navigationController pushViewController:chat animated:YES];
        
    }else if(conversation.type == EMConversationTypeGroupChat) {
        //群聊
        for (EMGroup *group in _groupArry) {
            if ([group.groupId isEqualToString:conversation.conversationId]) {
                ChatViewController *chat = [[ChatViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
                [self.navigationController pushViewController:chat animated:YES];
                break;
            }
        }
        
    }
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

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id msgBody = lastMessage.body;
    if ([msgBody isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = msgBody;
        ret = textBody.text;
    } else if ([msgBody isKindOfClass:[EMImageMessageBody class]]) {
        EMImageMessageBody *imgBody = msgBody;
        ret = imgBody.displayName;
    } else if ([msgBody isKindOfClass:[EMVoiceMessageBody class]]) {
        EMVoiceMessageBody *voiceBody = msgBody;
        ret = voiceBody.displayName;
    } else if ([msgBody isKindOfClass:[EMVideoMessageBody class]]) {
        EMVideoMessageBody *videoBody = msgBody;
        ret = videoBody.displayName;
    }
}
    return ret;
}
// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}
// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    return  ret;
}

//获取最后一条消息的发送者
- (NSString *)subNameMessageByConversation:(EMConversation *)conversation{
    EMMessage *lastMessage = [conversation latestMessage];
    NSDictionary *ext = lastMessage.ext;   //(环信：扩展消息）
    if(ext){
        return [NSString stringWithFormat:@"%@:",[ext objectForKey:@"name"]];
    }else{
        return lastMessage.from;
    }
}
//当前登陆用户的会话对象列表
- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    
    return ret;
}
//获取群和好友列表
//- (void)reloadDataNews{
//    [self.friendsArry removeAllObjects];
//    [self.groupArry removeAllObjects];
//    
//    //好友列表
//    EMError *error = nil;
//    NSArray *buddyListB = [[EMClient sharedClient].chatManager fetchBuddyListWithError:&error];
//    NSLog(@"%@",error);
//    NSMutableArray *buddyList = [[NSMutableArray alloc] initWithArray:buddyListB];
//    
//    if(buddyList.count > 0){
//        [self.friendsArry addObjectsFromArray:buddyList];
//    }
//    
//    //群组列表
//   NSArray *roomsList = [[EMClient sharedClient].chatManager groupManager];
//    if(roomsList.count > 0){
//        [self.groupArry addObjectsFromArray:roomsList];
//    }
//}
//未读消息改变时
-(void)didUnreadMessagesCountChanged{
//    [self reloadDataNews];
    _dataLoadDataSource = [self loadDataSource];
    [_ZJLXTable reloadData];
}

//群组列表变化后的回调
- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error{
//    [self reloadDataNews];
    _dataLoadDataSource = [self loadDataSource];
    [_ZJLXTable reloadData];
}


@end
