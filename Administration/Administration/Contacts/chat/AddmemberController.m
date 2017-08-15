//
//  AddmemberController.m
//  Administration
//
//  Created by zhang on 2017/3/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AddmemberController.h"
#import "inftionxqController.h"
#import "LVModel.h"
#import "LVFmdbTool.h"
#import "ChoosePostionViewController.h"
#import "JoblistController.h"
#import "ChatViewController.h"
#import "ChatUIHelper.h"
#import "RobotManager.h"
#import "SelectCell.h"
#import "Cell.h"
#import "ModelArray.h"
#import "LineLayout.h"
@interface AddmemberController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>

@property (strong,nonatomic) UIView *view1;//第一条横线
@property (strong,nonatomic) UIView *view2;//第二条横线
@property (strong,nonatomic) UIView *view3;//第三条横线
@property (strong,nonatomic) UILabel * lxLabel;//最近联系人Label
@property (strong,nonatomic) UITableView *ZJLXTable;//最近联系人列表
@property (nonatomic,strong)NSMutableArray *dataArray;//数据源
@property (nonatomic,strong) NSMutableArray *deleteArrarys;//选中的数据
@property (nonatomic,strong)NSMutableArray *ImageAry;//各部门图片
@property (nonatomic,strong)UIButton *buttonAll;
@property (nonatomic,strong)UIButton *buttonSure;
@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,strong)UILabel *labelDivision;
@property (nonatomic,strong)NSMutableArray *arrayResult;
@property (nonatomic,strong)NSMutableString *stringText;
@property (nonatomic,strong)UIView *viewBack;
@property (nonatomic,strong)NSMutableArray *arraySearch;
@property (nonatomic,strong)NSArray *filterdArray;
@property (nonatomic,strong)NSMutableArray *arrayName;
@property (nonatomic,assign)NSInteger integer;
@property (nonatomic,strong)NSMutableArray *arrayIsselect;
@property (nonatomic,strong)ModelArray *modelArray;
@property (nonatomic,strong)UICollectionView *collectView;
@property (nonatomic,strong)UIView * viewTop;
/** 标记是否全选 */
@property (nonatomic ,assign)BOOL isAllSelected;
@end

@implementation AddmemberController

-(void)dealloc
{
    [self.modelArray removeObserver:self forKeyPath:@"selected"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //  NSMutableArray *array=[NSMutableArray arrayWithArray:[LVFmdbTool queryData:nil]];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[LVFmdbTool selectLately:[USER_DEFAULTS objectForKey:@"userid"]]];
    self.dataArray=[NSMutableArray arrayWithArray:[[array reverseObjectEnumerator] allObjects]];
    //    NSString *string = @"0";
    
    [self.ZJLXTable reloadData];
    
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary *dict = self.dataArray[i];
        [self.arrayName addObject:dict[@"name"]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
    NSLog(@"count = %lu",(unsigned long)self.modelArray.selected.count);
    if (self.modelArray.selected.count!=0) {
        [self.buttonSure setTitle:[NSString stringWithFormat:@"确定（%lu）",(unsigned long)self.modelArray.selected.count] forState:UIControlStateNormal];
        [self.buttonSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.buttonSure.userInteractionEnabled = YES;
    }
    else
    {
        [self.buttonSure setTitle:@"确定" forState:UIControlStateNormal];
        [self.buttonSure setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.buttonSure.userInteractionEnabled = NO;
    }
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
    self.navigationController.automaticallyAdjustsScrollViewInsets=NO;
    self.deleteArrarys = [NSMutableArray array];
    self.filterdArray = [NSMutableArray array];
    self.arrayResult = [NSMutableArray array];
    self.arraySearch = [NSMutableArray array];
    self.arrayName = [NSMutableArray array];
    self.arrayIsselect = [NSMutableArray array];
    
    self.integer = 0;
    self.isAllSelected = NO;
    
    self.modelArray = [[ModelArray alloc]init];
    self.modelArray.selected = [NSMutableArray array];
    [self.modelArray addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification

{
    
    //这样就拿到了键盘的位置大小信息frame，然后根据frame进行高度处理之类的信息
    
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, frame.origin.y-90, Scree_width, 30)];
    [self.ZJLXTable addSubview:self.viewTop];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width-60, 0, 40, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(allReady) forControlEvents:UIControlEventTouchUpInside];
    [self.viewTop addSubview:button];
}

/**
 
 *  键盘将要隐藏
 
 *
 
 *  @param notification 通知
 
 */

-(void)keyboardWillHidden:(NSNotification *)notification

{
    // CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.viewTop removeFromSuperview];
}

-(void)allReady
{
    [self.searchBar resignFirstResponder];
}

-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)UIBtn{
    
    //    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, 0, 40)];
    //    self.scrollView.bounces = NO;
    //    self.scrollView.scrollEnabled = YES;
    //    [self.view addSubview:self.scrollView];
    
    UIView *viewTop = [[UIView alloc]init];
    [self.view addSubview:viewTop];
    [viewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.mas_equalTo(40);
    }];
    
    LineLayout *layout = [[LineLayout alloc]init];
    self.collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 , 0, 40) collectionViewLayout:layout];
    self.collectView.delegate = self;
    self.collectView.dataSource =self;
    [self.collectView registerClass:[Cell class] forCellWithReuseIdentifier:@"MY_CELL"];
    self.collectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectView];
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.image = [UIImage imageNamed:@"seach"];
    [viewTop addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.collectView.mas_right).offset(13);
        //  make.top.mas_equalTo(viewTop.mas_top).offset(7);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
        make.centerY.mas_equalTo(viewTop.mas_centerY);
    }];
    
    self.labelDivision = [[UILabel alloc]init];
    self.labelDivision.backgroundColor = [UIColor lightGrayColor];
    [viewTop addSubview:self.labelDivision];
    [self.labelDivision mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageview.mas_right).offset(5);
        make.centerY.mas_equalTo(viewTop.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(1);
    }];
    self.searchBar  = [[UISearchBar alloc]init];
    self.searchBar.placeholder = @"";
    //  [self.searchBar setImage:[UIImage imageNamed:@""] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.searchBar.delegate = self;
    //去除放大镜
    UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
    [txfSearchField setLeftViewMode:UITextFieldViewModeNever];
    //设置背景颜色
    self.searchBar.tintColor = [UIColor whiteColor];
    [self.searchBar setBackgroundColor:[UIColor whiteColor]];
    self.searchBar.barTintColor = [UIColor whiteColor];
    [viewTop addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.labelDivision.mas_right).offset(5);
        make.top.mas_equalTo(viewTop.mas_top);
        make.bottom.mas_equalTo(viewTop.mas_bottom);
        make.right.mas_equalTo(viewTop.mas_right);
    }];
    
    //分割线
    self.view1 = [[UIView alloc]init];
    _view1.backgroundColor = [UIColor RGBview];
    [self.view addSubview:self.view1];
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(viewTop.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
    
    self.viewBack=[[UIView alloc]init];
    [self.view addSubview:self.viewBack];
    [self.viewBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view1.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(49);
    }];
    UITapGestureRecognizer *taposition = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SpotionTap:)];
    [self.viewBack addGestureRecognizer:taposition];
    
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10,10 ,100, 29)];
    label.text=@"按职位选择";
    [self.viewBack addSubview:label];
    
    UIImageView *imageArrow=[[UIImageView alloc]initWithFrame:CGRectMake(Scree_width-35,15,19,19)];
    imageArrow.image = [UIImage imageNamed:@"jiantou_03"];
    [self.viewBack addSubview:imageArrow];
    
    self.view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 150, Scree_width, 1)];
    self.view2.backgroundColor = [UIColor RGBview];
    [self.view addSubview:self.view2];
    
    //    _lxLabel = [[UILabel alloc]init];
    //    _lxLabel.text= @"最近联系人";
    //    _lxLabel.backgroundColor = [UIColor whiteColor];
    //    _lxLabel.textColor = [UIColor RGBview];
    //    _lxLabel.font = [UIFont systemFontOfSize:15];
    //    [self.view addSubview:_lxLabel];
    //    [_lxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.view.mas_left).offset(10);
    //        make.top.mas_equalTo(self.view2.mas_bottom).offset(5);
    //        make.right.mas_equalTo(self.view.mas_right);
    //        make.height.mas_equalTo(20);
    //    }];
    
    self.view3 = [[UIView alloc]init];
    self.view3.backgroundColor = [UIColor RGBview];
    [self.view addSubview:self.view3];
    [self.view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.viewBack.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    //_ZJLXTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 180, Scree_width, Scree_height-80)];
    _ZJLXTable = [[UITableView alloc]init];
    _ZJLXTable.backgroundColor = [UIColor whiteColor];
    _ZJLXTable.delegate = self;
    _ZJLXTable.dataSource = self;
    [self.view addSubview:_ZJLXTable];
    [_ZJLXTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view3.mas_bottom).offset(-1);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-40);
    }];
    
    /*=========================至关重要============================*/
    _ZJLXTable.allowsMultipleSelectionDuringEditing = YES;
    //去除多余的cell线
    [ZXDNetworking setExtraCellLineHidden:_ZJLXTable];
    [_ZJLXTable registerClass:NSClassFromString(@"SelectCell") forCellReuseIdentifier:@"cell"];
    
    
    self.buttonAll = [UIButton buttonWithType:UIButtonTypeSystem];
    self.buttonAll.frame = CGRectMake(0, Scree_height-40, Scree_width/2, 40);
    [self.buttonAll setTitle:@"全选" forState:UIControlStateNormal];
    [self.buttonAll setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.buttonAll.layer setBorderColor:GetColor(192, 192, 192, 1).CGColor];
    [self.buttonAll.layer setBorderWidth:1.0f];
    [self.buttonAll addTarget:self action:@selector(allButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonAll];
    
    self.buttonSure = [UIButton buttonWithType:UIButtonTypeSystem];
    self.buttonSure.frame = CGRectMake(Scree_width/2, Scree_height-40, Scree_width/2, 40);
    [self.buttonSure setTitle:@"确定" forState:UIControlStateNormal];
    [self.buttonSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.buttonSure setBackgroundColor:[UIColor whiteColor]];
    [self.buttonSure.layer setBorderColor:GetColor(192, 192, 192, 1).CGColor];
    [self.buttonSure.layer setBorderWidth:1.0f];
    [self.buttonSure addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonSure];
    
    
}

#pragma -mark button
-(void)allButton
{
    if (self.modelArray.selected.count!=0) {
        for (int i = 0; i<self.dataArray.count; i++) {
            NSDictionary *dict = self.dataArray[i];
            for (int j=0; j<self.modelArray.selected.count; j++) {
                NSMutableDictionary *dic = [self.modelArray.selected[j]mutableCopy];
                if ([[NSString stringWithFormat:@"%@",dict[@"userId"]]isEqualToString:dic[@"userid"]]) {
                    [dict setValue:@"0" forKey:@"isSelect"];
                    [self.dataArray replaceObjectAtIndex:i withObject:dict];
                    [[self.modelArray mutableArrayValueForKey:@"selected"]addObject:dict];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    SelectCell *cell = [self.ZJLXTable cellForRowAtIndexPath:indexPath];
                    cell.selectImage.image = [UIImage imageNamed:@"xuanzhong"];
                    cell.isSelected = YES;
                    [[self.modelArray mutableArrayValueForKey:@"selected"]addObject:dic];
                }
            }
            
            
            //            NSDictionary *dict = self.dataArray[i];
            //            [dict setValue:@"0" forKey:@"isSelect"];
            //            [self.dataArray replaceObjectAtIndex:i withObject:dict];
            //            [[self.modelArray mutableArrayValueForKey:@"selected"]addObject:dict];
            //            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            //            SelectCell *cell = [self.ZJLXTable cellForRowAtIndexPath:indexPath];
            //            cell.selectImage.image = [UIImage imageNamed:@"xuanzhong"];
            //            cell.isSelected = YES;
            //            //  [self.ZJLXTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            //            [self.buttonSure setTitle:[NSString stringWithFormat:@"确定(%d)",i+1] forState:UIControlStateNormal];
        }
    }else
    {
        for (int i = 0; i<self.dataArray.count; i++) {
            NSDictionary *dict = self.dataArray[i];
            [dict setValue:@"0" forKey:@"isSelect"];
            [self.dataArray replaceObjectAtIndex:i withObject:dict];
            [[self.modelArray mutableArrayValueForKey:@"selected"]addObject:dict];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            SelectCell *cell = [self.ZJLXTable cellForRowAtIndexPath:indexPath];
            cell.selectImage.image = [UIImage imageNamed:@"xuanzhong"];
            cell.isSelected = YES;
            //  [self.ZJLXTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self.buttonSure setTitle:[NSString stringWithFormat:@"确定(%d)",i+1] forState:UIControlStateNormal];
        }
    }
    
}

-(void)sureButton
{
    NSMutableArray *arrUsersid = [NSMutableArray array];
    NSDictionary *dict = [NSDictionary dictionary];
    for (int i=0; i<self.modelArray.selected.count; i++) {
        dict = self.self.modelArray.selected[i];
        NSString *uuid = [NSString stringWithFormat:@"%@",dict[@"uuid"]];
        NSString *usersid = [NSString stringWithFormat:@"%@",dict[@"userid"]];
        NSMutableDictionary *listUersid = [NSMutableDictionary dictionary];
        [listUersid setValue:usersid forKey:@"id"];
        [listUersid setValue:uuid forKey:@"uuid"];
        [arrUsersid addObject:listUersid];
    }
    NSData *data=[NSJSONSerialization dataWithJSONObject:arrUsersid options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    //添加群成员（已有群）
    if (self.isHaveGroup) {
        NSString *urlStr =[NSString stringWithFormat:@"%@group/insertGroupMembers.action",KURLHeader];
        NSDictionary *dictInfo = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"groupinformationId":self.groupinformationId,@"list":jsonStr,@"groupNumber":self.groupID};
        
        [ZXDNetworking GET:urlStr parameters:dictInfo success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"] isEqualToString:@"0000"]) {
                //     [ELNAlerTool showAlertMassgeWithController:self andMessage:@"成功" andInterval:1.0];
                EaseEmotionManager *manager = [[ EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:5 emotions:[EaseEmoji allEmoji]];
                //    EaseMessageViewController *messageVC = [[ EaseMessageViewController alloc] initWithConversationChatter:@"8001" conversationType:EMConversationTypeChat];
                //    messageVC.title = @"8001";
                ChatViewController *messageVC = [[ ChatViewController alloc] initWithConversationChatter:self.groupID conversationType:EMConversationTypeGroupChat];
                //  messageVC.groupNmuber = dic[@"GroupNumber"];
                messageVC.hidesBottomBarWhenPushed = YES;
                messageVC.number = @"1";
                [messageVC.faceView setEmotionManagers:@[manager]];
                // UINavigationController *nc = [[ UINavigationController alloc] initWithRootViewController:messageVC];
                [self.navigationController pushViewController:messageVC animated:YES];
                return ;
            }
            if ([[responseObject valueForKey:@"status"] isEqualToString:@"4444"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
                return ;
            }
            if ([[responseObject valueForKey:@"status"] isEqualToString:@"1001"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请重新登录" andInterval:1.0];
                return ;
            }
            if ([[responseObject valueForKey:@"status"] isEqualToString:@"1111"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
                return ;
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
    }else //创建群时添加群成员
    {
        
        NSString *urlStr =[NSString stringWithFormat:@"%@group/insertGroup.action",KURLHeader];
        NSString *introduce = [NSString stringWithFormat:@"本群创建于%@",[NSDate date]];
        NSString *name = self.textStr;
        NSString *compid=[USER_DEFAULTS objectForKey:@"companyinfoid"];
        NSString *uuid = [USER_DEFAULTS objectForKey:@"uuid"];
        NSData *pictureData = UIImagePNGRepresentation(self.goursIamge);
        //     NSData *pictureData = UIImageJPEGRepresentation(self.imageGroup, 1);
        NSDictionary *dictInfo = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Introduce":introduce,@"Name":name,@"CompanyInfoId":compid,@"uuid":uuid,@"ListUsersId":jsonStr};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"image/gif",@"image/tiff",@"application/octet-stream",@"text/json",nil];
        [manager POST:urlStr parameters:dictInfo constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyMMddHHmm";
            NSString *fileName = [formatter stringFromDate:[NSDate date]];
            NSString *nameStr = @"file";
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [formData appendPartWithFileData:pictureData name:nameStr fileName:[NSString stringWithFormat:@"%@.png", fileName] mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView: self.view animated:NO];
            NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
            NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSUTF8StringEncoding error:nil];
            NSString *status =  [NSString stringWithFormat:@"%@",[dic valueForKey:@"status"]];
            if ([status isEqualToString:@"0000"]) {
                EaseEmotionManager *manager = [[ EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:5 emotions:[EaseEmoji allEmoji]];
                //    EaseMessageViewController *messageVC = [[ EaseMessageViewController alloc] initWithConversationChatter:@"8001" conversationType:EMConversationTypeChat];
                //    messageVC.title = @"8001";
                ChatViewController *messageVC = [[ ChatViewController alloc] initWithConversationChatter:name conversationType:EMConversationTypeGroupChat];
                messageVC.groupNmuber = dic[@"GroupNumber"];
                messageVC.hidesBottomBarWhenPushed = YES;
                messageVC.number = @"1";
                [messageVC.faceView setEmotionManagers:@[manager]];
                // UINavigationController *nc = [[ UINavigationController alloc] initWithRootViewController:messageVC];
                [self.navigationController pushViewController:messageVC animated:YES];
            }
            if ([status isEqualToString:@"4444"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
                return ;
            }
            if ([status isEqualToString:@"1001"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时请重新登录" andInterval:1.0];
                return ;
            }
            if ([status isEqualToString:@"1111"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"创建失败" andInterval:1.0];
                return ;
            }
            if ([status isEqualToString:@"2000"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"名称已存在" andInterval:1.0];
                return ;
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error = %@",error.localizedDescription);
        }];
    }
}

#pragma -mark searchBar
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.searchBar.text!=nil&& ![self.searchBar.text isEqualToString:@""]) {
        self.viewBack.hidden = YES;
        [self.viewBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(0);
            make.top.equalTo(_view1.mas_bottom);
            make.right.equalTo(self.view.mas_right).offset(Scree_width);
            make.height.mas_equalTo(49);
        }];
        self.view2.frame = CGRectMake(0, 100, Scree_width, 1);
        _ZJLXTable.frame = CGRectMake(0, 130, Scree_width, Scree_height-80);
        
    }else
    {
        self.viewBack.hidden = NO;
        //self.viewBack.height = 49;
        [self.viewBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(0);
            make.top.equalTo(_view1.mas_bottom);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.height.mas_equalTo(49);
        }];
        self.view2.frame = CGRectMake(0, 150, Scree_width, 1);
        _ZJLXTable.frame = CGRectMake(0, 180, Scree_width, Scree_height-80);
    }
    NSDictionary *dict = [NSDictionary dictionary];
    [self.arraySearch removeAllObjects];
    for (int i=0;i<self.arrayName.count;i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", searchText];
        
        self.filterdArray = [self.arrayName filteredArrayUsingPredicate:predicate];
        
        //        [self.arraySearch addObjectsFromArray:self.filterdArray];
    }
    for (int i=0; i<self.filterdArray.count; i++) {
        for (int j=0; j<self.dataArray.count; j++) {
            dict = self.dataArray[j];
            if ([self.filterdArray[i]isEqualToString:dict[@"name"]]) {
                [self.arraySearch addObject:dict];
            }
        }
    }
    [self.ZJLXTable reloadData];
    
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar isFirstResponder] ;
    [self.ZJLXTable reloadData];
    return YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self searchBarTextDidEndEditing:self.searchBar];
    [self.ZJLXTable reloadData];
    
}

#pragma -mark collectionView
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return self.modelArray.selected.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *dict = self.modelArray.selected[indexPath.row];
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    //    cell.label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    //    cell.label.backgroundColor = [UIColor whiteColor];
    cell.imageViweH.backgroundColor = [UIColor whiteColor];
    //    if (dict[@"image"]==nil) {
    //        cell.imageViweH.image = [UIImage imageNamed:@"banben100"];
    //    }else
    //    {
    //        cell.imageViweH.image = [UIImage imageNamed:dict[@"image"]];
    //    }
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@",KURLHeader,dict[@"image"]];
    [cell.imageViweH sd_setImageWithURL:[NSURL URLWithString:stringUrl] placeholderImage:[UIImage imageNamed:@"banben100"]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int row = 0;
    NSDictionary *dictC = self.modelArray.selected[indexPath.row];
    row = [dictC[@"indexP"] intValue];
    // [self.arraySelect removeObject:dictC];
    [[self.modelArray mutableArrayValueForKey:@"selected"]removeObject:dictC];
    [self.collectView reloadData];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
    SelectCell *cell = [self.ZJLXTable cellForRowAtIndexPath:indexpath];
    cell.isSelected = NO;
    cell.selectImage.image = [UIImage imageNamed:@"weixuanzhong"];
    if (self.modelArray.selected.count>6) {
        self.collectView.frame = CGRectMake(0, 64, 245, 40);
        // self.collectView.contentSize = CGSizeMake(self.arraySelect.count*6+5, 40);
    }
    else
    {
        self.collectView.frame = CGRectMake(0, 64, self.modelArray.selected.count*40, 40);
    }
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma -mark tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArray[indexPath.row];
    SelectCell *cell = [self.ZJLXTable dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[SelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.selectImage.image = [UIImage imageNamed:@"weixuanzhong"];
    if ([self.searchBar isFirstResponder]&&self.searchBar.text.length!=0) {
        cell.tintColor = [UIColor RGBNav];
        cell.model = self.arraySearch[indexPath.row];
    }else
    {
        cell.tintColor = [UIColor RGBNav];
        cell.model = dict;
    }
    
    
    // [dict setValue:@"0" forKey:@"isSelect"];
    
    if ([[dict valueForKey:@"isSelect"]isEqualToString:@"1"]) {
        cell.selectImage.image = [UIImage imageNamed:@"xuanzhong.png"];
    }
    if ([[dict valueForKey:@"isSelect"]isEqualToString:@"2"]) {
        cell.selectImage.image = [UIImage imageNamed:@"weixuanzhong"];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.searchBar isFirstResponder]&&self.searchBar.text.length!=0) {
        return self.arraySearch.count;
    }
    return self.dataArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCell *cell = [self.ZJLXTable cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *dic = [self.dataArray[indexPath.row] mutableCopy];
    
    cell.isSelected = !cell.isSelected;
    if (cell.isSelected) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        cell.selectImage.image = [UIImage imageNamed:@"xuanzhong"];
        
        [dic setValue:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"indexP"];
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dic];
        
        // [dict setValue:image forKey:@"image"];
        [dict setValue:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"indexPath"];
        [[self.modelArray mutableArrayValueForKey:@"selected"] addObject:dic];;
        cell.isSelected = YES;
        
        if (self.modelArray.selected.count>6) {
            self.collectView.frame = CGRectMake(0, 64, 245, 40);
            // self.collectView.contentSize = CGSizeMake(self.arraySelect.count*6+5, 40);
        }
        else
        {
            self.collectView.frame = CGRectMake(0, 64, self.modelArray.selected.count*40+25, 40);
        }
        [self.collectView reloadData];
    }
    else
    {
        cell.selectImage.image = [UIImage imageNamed:@"weixuanzhong"];
        cell.isSelected = NO;
        int row = 0;
        for (int i=0;i<self.modelArray.selected.count;i++) {
            NSDictionary *dict = self.modelArray.selected[i];
            if ([dic[@"indexP"]isEqualToString:dict[@"indexPath"]]) {
                row=i;
                
            }
        }
        [[self.modelArray mutableArrayValueForKey:@"selected"] removeObjectAtIndex:row];
        self.collectView.frame = CGRectMake(0, 64, self.modelArray.selected.count*40, 40);
        
        [self.collectView reloadData];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    //[_deleteArrarys removeObject:[self.dataArray objectAtIndex:indexPath.row]];
    // [self.buttonSure setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[_deleteArrarys count]] forState:UIControlStateNormal];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
    
}

-(void)SpotionTap:(UITapGestureRecognizer*)sender{
    
    if (self.isCreateGroup) {
        ChoosePostionViewController *controller = [[ChoosePostionViewController alloc]init];
        controller.isCreateGroup = self.isCreateGroup;
        controller.stringGroup = self.textStr;
        controller.imageGroup = self.goursIamge;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (self.isHaveGroup)
    {
        ChoosePostionViewController *controller = [[ChoosePostionViewController alloc]init];
        controller.isHaveGroup = self.isHaveGroup;
        controller.stringGroup = self.textStr;
        controller.groupID = self.groupID;
        controller.groupinformationId = self.groupinformationId;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        JoblistController *controller = [[JoblistController alloc]init];
        
        controller.imageGroup = self.goursIamge;
        controller.stringGroup = self.textStr;
        controller.groupID = self.groupID;
        controller.groupinformationId = self.groupinformationId;
        [self.navigationController pushViewController:controller animated:YES];
    }
}




//上传群头像
-(void)dateimageGrouts:(EMGroup*)group{
    
    NSData *pictureData = UIImagePNGRepresentation(self.goursIamge);
    NSString *urlStr = [NSString stringWithFormat:@"%@upload/file.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"code":@"1"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"image/gif",@"image/tiff",@"application/octet-stream",@"text/json",nil];
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyMMddHHmm";
        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        NSString *nameStr = @"file";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [formData appendPartWithFileData:pictureData name:nameStr fileName:[NSString stringWithFormat:@"%@.png", fileName] mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView: self.view animated:NO];        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSUTF8StringEncoding error:nil];
        NSString *status =  [NSString stringWithFormat:@"%@",[dic valueForKey:@"status"]];
        if ([status isEqualToString:@"0000"]) {
            NSString *msgStr = [NSString stringWithFormat:@"%@%@",KURLHeader,[dic valueForKey:@"url"] ];
            [UserWebManager createUser:group.groupId nickName:self.textStr avatarUrl:msgStr];
        } else {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"头像上传失败" andInterval:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
