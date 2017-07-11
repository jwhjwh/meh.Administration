//
//  DepmentController.m
//  Administration
//
//  Created by zhang on 2017/5/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ChoosePostionViewController.h"
#import "ZJLXRTableViewCell.h"
#import "DirtmsnaModel.h"
#import "SelectCell.h"
#import "ChatViewController.h"
@interface ChoosePostionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UIButton *allButton;
@property (nonatomic,strong)UIButton *sureButton;
@property (nonatomic,strong)NSMutableArray *selectArray;
@property (nonatomic,strong)UIImageView *loni;
@property (nonatomic,assign)NSIndexPath *selectIndex;
@property (nonatomic,strong)NSMutableArray *indexArray;
@end

@implementation ChoosePostionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加群成员";
    
    self.selectArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    //
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.tableView registerClass:NSClassFromString(@"SelectCell") forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    if (_Num==1) {
        [self datalade];
    }else{
        [self checkPositionUsers];
    }
    [self loadBottonView];
}

-(void)loadBottonView
{
    UIView *viewBottom = [[UIView alloc]init];
    viewBottom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewBottom];
    [viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(48);
    }];
    
    self.allButton = [[UIButton alloc]init];
    [self.allButton setTitle:@"全选" forState:UIControlStateNormal];
    [self.allButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.allButton addTarget:self action:@selector(buttonAll:) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:self.allButton];
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewBottom.mas_left);
        make.top.mas_equalTo(viewBottom.mas_top);
        make.bottom.mas_equalTo(viewBottom.mas_bottom);
        make.right.mas_equalTo(viewBottom.mas_centerX);
    }];
    
    self.sureButton = [[UIButton alloc]init];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(buttonSure:) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(viewBottom.mas_right);
        make.top.mas_equalTo(viewBottom.mas_top);
        make.bottom.mas_equalTo(viewBottom.mas_bottom);
        make.left.mas_equalTo(viewBottom.mas_centerX);
    }];
    if (self.selectArray.count==0) {
        [self.sureButton setBackgroundColor:[UIColor grayColor]];
        self.sureButton.userInteractionEnabled = NO;
    }
    else
    {
        [self.sureButton setBackgroundColor:GetColor(204, 174, 212, 1)];
        self.sureButton.userInteractionEnabled = YES;
    }
   
}

-(void)buttonAll:(UIButton *)button
{
    for (int i = 0; i<self.dataArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        SelectCell *cell = (SelectCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.selectImage.image = [UIImage imageNamed:@"xuanzhong"];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self.sureButton setTitle:[NSString stringWithFormat:@"确定(%d)",i+1] forState:UIControlStateNormal];
        [self.sureButton setBackgroundColor:GetColor(204, 174, 212, 1)];
        self.sureButton.userInteractionEnabled = YES;
        
    }
}

#pragma -mark 创建群或添加群成员
-(void)buttonSure:(UIButton *)button
{
    NSMutableArray *arrUsersid = [NSMutableArray array];
    for (int i=0; i<self.selectArray.count; i++) {
        DirtmsnaModel *model = self.selectArray[i];
        NSString *uuid = [NSString stringWithFormat:@"%@",model.uuid];
        NSString *usersid = [NSString stringWithFormat:@"%@",model.usersid];
        NSMutableDictionary *listUersid = [NSMutableDictionary dictionary];
        [listUersid setValue:usersid forKey:@"usersid"];
        [listUersid setValue:uuid forKey:@"uuid"];
        [arrUsersid addObject:listUersid];
    }
    
    
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:arrUsersid options:NSJSONWritingPrettyPrinted error:nil];    
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    if (self.isAddMenber) {
        NSString *urlStr =[NSString stringWithFormat:@"%@group/insertGroupMembers.action",KURLHeader];
        NSDictionary *dictInfo = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"groupinformationId":self.groupinformationId,@"list":jsonStr,@"groupNumber":self.groupID};
        
        [ZXDNetworking GET:urlStr parameters:dictInfo success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"] isEqualToString:@"0000"]) {
                NSLog(@"成功");
                return ;
            }
            if ([[responseObject valueForKey:@"status"] isEqualToString:@"4444"]) {
                NSLog(@"非法请求");
                return ;
            }
            if ([[responseObject valueForKey:@"status"] isEqualToString:@"0000"]) {
                NSLog(@"请重新登录");
                return ;
            }
            if ([[responseObject valueForKey:@"status"] isEqualToString:@"1111"]) {
                NSLog(@"失败");
                return ;
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
    }else
    {
        
    NSString *urlStr =[NSString stringWithFormat:@"%@group/insertGroup.action",KURLHeader];
    NSString *introduce = [NSString stringWithFormat:@"本群创建于%@",[NSDate date]];
    NSString *name = self.stringGroup;
    NSString *compid=[USER_DEFAULTS objectForKey:@"companyinfoid"];
    NSString *uuid = [USER_DEFAULTS objectForKey:@"uuid"];
    NSData *pictureData = UIImagePNGRepresentation(self.imageGroup);
    
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
            NSLog(@"创建成功");
            EaseEmotionManager *manager = [[ EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:5 emotions:[EaseEmoji allEmoji]];
            //    EaseMessageViewController *messageVC = [[ EaseMessageViewController alloc] initWithConversationChatter:@"8001" conversationType:EMConversationTypeChat];
            //    messageVC.title = @"8001";
            ChatViewController *messageVC = [[ ChatViewController alloc] initWithConversationChatter:name conversationType:EMConversationTypeGroupChat];
            messageVC.hidesBottomBarWhenPushed = YES;
            messageVC.number = @"1";
            [messageVC.faceView setEmotionManagers:@[manager]];
            // UINavigationController *nc = [[ UINavigationController alloc] initWithRootViewController:messageVC];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
        if ([status isEqualToString:@"4444"]) {
            NSLog(@"非法请求");
            return ;
        }
        if ([status isEqualToString:@"1001"]) {
            NSLog(@"超时请重新登录");
            return ;
        }
        if ([status isEqualToString:@"1111"]) {
            NSLog(@"创建失败");
            return ;
        }
        if ([status isEqualToString:@"2000"]) {
            NSLog(@"名称已存在");
            return ;
        }
            
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    }
}

-(void)datalade{
    NSString *urlStr =[NSString stringWithFormat:@"%@manager/queryDepartments.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":_Numstr,@"DepartmentID":_DepartmentID};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.dataArray = [NSMutableArray array];
            NSArray *array=[responseObject valueForKey:@"list"];
            
            for (NSDictionary *dic in array) {
                DirtmsnaModel *model=[[DirtmsnaModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                model.isdeles=@"";
                [self.dataArray addObject:model];
            }
            
            if (self.dataArray.count==0) {
                [_tableView addEmptyViewWithImageName:@"" title:@"暂无员工～～"  Size:20.0];
                _tableView.emptyView.hidden = NO;
            }
            [_tableView reloadData];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }
        if (self.dataArray.count==0) {
            [_tableView addEmptyViewWithImageName:@"" title:@"暂无员工" Size:20.0];
            _tableView.emptyView.hidden = NO;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
    
}
-(void)checkPositionUsers{
    NSString *urlStr =[NSString stringWithFormat:@"%@manager/checkPositionUsers.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":_Numstr};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.dataArray = [NSMutableArray array];
            NSArray *array=[responseObject valueForKey:@"list"];
            
            for (NSDictionary *dic in array) {
                DirtmsnaModel *model=[[DirtmsnaModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                model.isdeles=@"";
                [self.dataArray addObject:model];
            }
            
            if (self.dataArray.count==0) {
                [_tableView addEmptyViewWithImageName:@"" title:@"暂无员工～～"  Size:20.0];
                _tableView.emptyView.hidden = NO;
            }
            [_tableView reloadData];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }
        if (self.dataArray.count==0) {
            [_tableView addEmptyViewWithImageName:@"" title:@"暂无员工" Size:20.0];
            _tableView.emptyView.hidden = NO;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ZJLXRTableViewCell *cell = [[ZJLXRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
//    if (cell == nil) {
//        cell = [[ZJLXRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
//    }
    SelectCell *cell = [[SelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    
    for (NSIndexPath *index in self.indexArray) {
        if (index==indexPath) {
            cell.selectImage.image = [UIImage imageNamed:@"xuanzhong"];
            break;
        }
    }
    return cell;
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectCell *cell = (SelectCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.isSelected = !cell.isSelected;
    //选中
    if (cell.isSelected)
    {
        //勾选的图标
        cell.selectImage.image  = [UIImage imageNamed:@"xuanzhong"];
        [self.selectArray addObject:self.dataArray[indexPath.row]];
        [self.indexArray addObject:indexPath];
        [self.sureButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[self.selectArray count]] forState:UIControlStateNormal];
        cell.isSelected = YES;
    }
    //反选
    else
    {
        //反选的图标
        cell.selectImage.image  = [UIImage imageNamed:@"weixuanzhong"];
        [self.selectArray removeObject:self.dataArray[indexPath.row]];
        [self.indexArray removeObject:indexPath];
        [self.sureButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[self.selectArray count]] forState:UIControlStateNormal];
        cell.isSelected = NO;
    }

    if (self.selectArray.count==0) {
        [self.sureButton setBackgroundColor:[UIColor grayColor]];
        self.sureButton.userInteractionEnabled = NO;
    }
    else
    {
        [self.sureButton setBackgroundColor:GetColor(204, 174, 212, 1)];
        self.sureButton.userInteractionEnabled = YES;
    }

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
