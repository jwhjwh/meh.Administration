
//  XCQ_tabbarViewController.m
//  自定义tabbar
//
//  Created by Mr.X on 2016/12/14.
//  Copyright © 2016年 Mr.X. All rights reserved.
//

#import "XCQ_tabbarViewController.h"
#import "MainViewController.h" //首页

#import "IntercalateController.h"//设置

#import "ContactsController.h" //联系人
#import "XCQ_tabbar.h"
@interface XCQ_tabbarViewController ()
@property(nonatomic,assign) BOOL FirstLoad ;
@property(nonatomic,retain) UIView *CustomTabBar;
@property (nonatomic, strong) XCQ_tabbar *currentButton; // 当前选中的Btn
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
            UIViewController * vc=[self.viewControllers objectAtIndex:i];
            
            XCQ_tabbar *btn =[[XCQ_tabbar alloc]initWithFrame:CGRectMake(i*itemWidth, 0, itemWidth, 50)
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
    
    //为侧滑所用
    self.tabBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49, [UIScreen mainScreen].bounds.size.width, 49);
    //    [NSNotificationCenter defaultCenter] postNotificationName:@"KpzTabbarSelectNotification" object:3
    
    NSLog(@"之前点击的下标为%li",self.selectedIndex);
    
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
            navi.navigationBar.barTintColor = [UIColor colorWithRed:155/256.0 green:89/256.0 blue:183/256.0 alpha:1];
            navi.edgesForExtendedLayout = UIRectEdgeNone ;
            navi.navigationController.navigationBar.translucent = NO ;
            
            // 导航栏字体的颜色
            [navi.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
            
            navi.tabBarItem.image = [UIImage imageNamed:nomarImageArr[i]];
            navi.tabBarItem.selectedImage = [UIImage imageNamed:selectImageArr[i]];
            navi.tabBarItem.title = titleArr[i];
            navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve ;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
