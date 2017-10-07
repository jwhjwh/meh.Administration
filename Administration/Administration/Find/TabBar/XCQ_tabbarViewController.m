
//  XCQ_tabbarViewController.m
//  自定义tabbar
//
//  Created by Mr.X on 2016/12/14.
//  Copyright © 2016年 Mr.X. All rights reserved.
//

#import "XCQ_tabbarViewController.h"
#import "MainViewController.h" //首页
#import "UIDevice+FEPlatForm.h"//判断机型
#import "IntercalateController.h"//设置
#import "ChatViewController.h"

#import "ContactsController.h"
#import "ContactsController.h" //联系人
#import "XCQ_tabbar.h"
#import <UserNotifications/UserNotifications.h>
#import "ChatUIHelper.h"
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";
@interface XCQ_tabbarViewController () <UIAlertViewDelegate,EMChatManagerDelegate>

{
    ContactsController *_chatListVC;
}
@property(nonatomic,assign) BOOL FirstLoad ;
@property(nonatomic,retain) UIView *CustomTabBar;
@property (nonatomic, strong) XCQ_tabbar *currentButton; // 当前选中的Btn
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end

@implementation XCQ_tabbarViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_FirstLoad)
    {
        //只能写到这个方法里,要不self.viewControllers为空
        NSArray * tabBarBtns=self.tabBar.subviews;
        for (UIView * tabBarBtn in tabBarBtns)
        {
            tabBarBtn.hidden=YES;
        }
        
        CGFloat itemWidth=self.view.bounds.size.width/self.viewControllers.count;
        
        for (int i=0; i<self.viewControllers.count; i++)
        {
            //iphone x
            NSString* phoneModel = [UIDevice devicePlatForm];//方法在下面
            NSLog(@"%@",phoneModel);
            CGFloat Xheig;
            if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
                Xheig = 83;
            }else{
                Xheig = 50;
            }
            UIViewController * vc=[self.viewControllers objectAtIndex:i];
            XCQ_tabbar *btn =[[XCQ_tabbar alloc]initWithFrame:CGRectMake(i*itemWidth, 0, itemWidth, Xheig)
                                            withUnSelectedImg:vc.tabBarItem.image
                                              withSelectedImg:vc.tabBarItem.selectedImage
                                                    withTitle:vc.tabBarItem.title];
            btn.tag=99000+i;
            [btn setClickEventTarget:self action:@selector(tabBtnClick:)];
            [self.tabBar addSubview:btn];
            [self.XCQ_TabArr addObject:btn];
        }
        XCQ_tabbar * selecedBtn=(XCQ_tabbar *)[self.tabBar viewWithTag:self.selectedIndex+99000];
        selecedBtn.selected=YES;
        
        _FirstLoad = NO;
    }
}


-(void)tabBtnClick:(XCQ_tabbar *)btn
{
    self.currentButton = (XCQ_tabbar *)[self.tabBar viewWithTag:self.selectedIndex+99000] ;
    
    //为侧滑所用-------x
    CGFloat Xheig;
    NSString* phoneModel = [UIDevice devicePlatForm];//方法在下面
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        Xheig = 83;
    }else{
        Xheig = 50;
    }
    self.tabBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - Xheig, [UIScreen mainScreen].bounds.size.width, Xheig);
    
    //    [NSNotificationCenter defaultCenter] postNotificationName:@"KpzTabbarSelectNotification" object:3
    
   
    
    if (self.currentButton != btn)
    {
        self.currentButton.selected = NO ;
        btn.selected = YES ;
        self.currentButton = btn;
        self.selectedIndex  =btn.tag - 99000 ;
    }
    
    // 双次点击刷新
    //      k++;
    ////    UIViewController * tbSelectedController = self.selectedViewController;
    //
    //        if (self.selectedIndex == 0 && k%2 !=0) {
    //            UINavigationController * nav = self.viewControllers[0];
    //            TheMainRootViewController * rootvc = nav.viewControllers[0];
    //            [rootvc.mainVC  doubleClickRefreshVC];
    //
    //        k = 1;
    //    }
}

// 这个是在tabbar 按钮上添加徽标 以及徽标的条数
-(void)setRedIndex:(BOOL)redIndex andControllerIndex:(NSInteger)ControllerIndex andBudgeNum:(NSInteger)budgeNum
{
    
    XCQ_tabbar *btn = self.XCQ_TabArr[ControllerIndex];
    
    [btn setRedIndex:redIndex andBudgeNum:budgeNum];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _FirstLoad = YES ;
//    NOTIFY_ADD(setupUntreatedApplyCount, kSetupUntreatedApplyCount);
    NOTIFY_ADD(setupUnreadMessageCount, kSetupUnreadMessageCount);
    NOTIFY_ADD(networkChanged, kConnectionStateChanged);
    [self setupUnreadMessageCount];
    [ChatUIHelper shareHelper].contactViewVC = _chatListVC;
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

-(instancetype)initWithNomarImageArr:(NSArray *)nomarImageArr andSelectImageArr:(NSArray *)selectImageArr andtitleArr:(NSArray *)titleArr
{
    
    self = [super init];
    if (self) {
        MainViewController *MainVC = [[MainViewController alloc]init];
        IntercalateController *IntercalateVC = [[IntercalateController alloc]init];
        ContactsController *ContactsVC= [[ContactsController alloc]init];
       
        
    
        
        
        NSArray *VCArr =@[MainVC,ContactsVC,IntercalateVC] ;
        
        NSMutableArray *viewControllers = [NSMutableArray array] ;
        
        
        for (NSInteger i = 0; i < 3; i++)
        {
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VCArr[i]];
            navi.navigationBar.barTintColor = [UIColor RGBNav];
            navi.edgesForExtendedLayout = UIRectEdgeNone ;
            navi.navigationController.navigationBar.translucent = NO ;
            
                       // 导航栏字体的颜色
            [navi.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
            
            navi.tabBarItem.image = [UIImage imageNamed:nomarImageArr[i]];
            navi.tabBarItem.selectedImage = [UIImage imageNamed:selectImageArr[i]];
           
            navi.tabBarItem.title = titleArr[i];
            navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [viewControllers addObject:navi];
        }
        self.viewControllers = viewControllers;
        //用来装kpztabbar的数组
        self.XCQ_TabArr = [NSMutableArray array];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

//- (void)setupUntreatedApplyCount
//{
//    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
//    if (_contactsVC) {
//        if (unreadCount > 0) {
//            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            _contactsVC.tabBarItem.badgeValue = nil;
//        }
//    }
//}

- (void)networkChanged
{
    _connectionState = [ChatUIHelper shareHelper].connectionState;
}

#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        //        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        //        [chatController hideImagePicker];
    }
    else if(_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}
-(void)didReceiveUserNotification:(UNNotification *)notification
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                        chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#else
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#endif
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#else
                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#endif
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}
- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}
- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                        chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#else
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#endif
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#else
                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#endif
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}


@end
