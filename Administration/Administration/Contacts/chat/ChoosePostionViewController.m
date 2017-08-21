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

@property (nonatomic,strong)UIButton *sureButton;
@property (nonatomic,strong)NSMutableArray *selectArray;
@property (nonatomic,assign)NSIndexPath *selectIndex;
@property (nonatomic,strong)NSMutableArray *indexArray;
@property (nonatomic,strong)NSMutableDictionary *openSectionDict;
@property (nonatomic,strong)NSMutableArray *arrayTitle;
@property (nonatomic,assign)NSInteger KTAG;
@end

@implementation ChoosePostionViewController
-(void)getAllMenbers
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@group/insertGroupMembersselect.action",KURLHeader];
    NSString *compid=[USER_DEFAULTS objectForKey:@"companyinfoid"];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *usersID = [USER_DEFAULTS objectForKey:@"userid"];
    NSDictionary *dict;
    if (self.isHaveGroup) {
        dict = @{@"appkey":appKeyStr,@"usersid":usersID,@"companyInfoId":compid,@"groupinformationId":self.groupinformationId};
    }
    else
    {
        dict = @{@"appkey":appKeyStr,@"usersid":usersID,@"companyInfoId":compid};
    }
    
    [ZXDNetworking GET:stringUrl parameters:dict success:^(id responseObject) {
        NSString *stringCode = [responseObject valueForKey:@"status"];
        if ([stringCode isEqualToString:@"0000"]) {
            self.dataArray = [[responseObject valueForKey:@"list"]mutableCopy];
            for (NSArray *inArr in self.dataArray) {
                NSDictionary *dict=inArr[0];
                    NSString *string = dict[@"newName"];
                    NSLog(@"%@", string);
                    [self.arrayTitle addObject: string];
            }
            NSLog(@"arrtitle = %@",self.arrayTitle);
            [self.tableView reloadData];
            
            return ;
        }
        if ([stringCode isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
            return;
        }
        if ([stringCode isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"token超时请重新登录" andInterval:1.0];
            return;
        }
        if ([stringCode isEqualToString:@"1111"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];

}

#pragma --mark system
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.dataArray removeAllObjects];
    [self getAllMenbers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加群成员";
    self.arrayTitle = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    self.openSectionDict = [NSMutableDictionary dictionary];
    //
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.tableView registerClass:NSClassFromString(@"SelectCell") forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStyleDone) target:self action:@selector(buttonSure:)];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    
   // [self loadBottonView];
}

-(void)loadBottonView
{
    self.sureButton = [[UIButton alloc]init];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(buttonSure:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right);
        //make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.height.mas_equalTo(48);
    }];
    if (self.selectArray.count==0) {
        [self.sureButton setBackgroundColor:[UIColor lightGrayColor]];
        self.sureButton.userInteractionEnabled = NO;
    }
    else
    {
        [self.sureButton setBackgroundColor:GetColor(204, 174, 212, 1)];
        self.sureButton.userInteractionEnabled = YES;
    }
   
}


#pragma -mark 创建群或添加群成员
-(void)buttonSure:(UIButton *)button
{
    NSMutableArray *arrUsersid = [NSMutableArray array];
    NSDictionary *dict = [NSDictionary dictionary];
    for (int i=0; i<self.selectArray.count; i++) {
        dict = self.selectArray[i];
        NSString *uuid = [NSString stringWithFormat:@"%@",dict[@"uuid"]];
        NSString *usersid = [NSString stringWithFormat:@"%@",dict[@"id"]];
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
                EaseEmotionManager *manager = [[ EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:5 emotions:[EaseEmoji allEmoji]];
                //    EaseMessageViewController *messageVC = [[ EaseMessageViewController alloc] initWithConversationChatter:@"8001" conversationType:EMConversationTypeChat];
                //    messageVC.title = @"8001";
                ChatViewController *messageVC = [[ ChatViewController alloc] initWithConversationChatter:self.stringGroup conversationType:EMConversationTypeGroupChat];
                messageVC.groupNmuber = self.groupID;
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
    NSString *name = self.stringGroup;
    NSString *compid=[USER_DEFAULTS objectForKey:@"companyinfoid"];
    NSString *uuid = [USER_DEFAULTS objectForKey:@"uuid"];
    NSData *pictureData = UIImagePNGRepresentation(self.imageGroup);
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
            ChatViewController *messageVC = [[ ChatViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%@",dic[@"GroupNumber"]] conversationType:EMConversationTypeGroupChat];
            messageVC.groupNmuber = dic[@"GroupNumber"];
            messageVC.hidesBottomBarWhenPushed = YES;
            messageVC.title = name;
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


    
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.openSectionDict valueForKey:[NSString stringWithFormat:@"%ld", section]] integerValue] == 0) { //根据记录的展开状态设置row的数量
        return 0;
    } else {
       return [self.dataArray[section] count];
    }
   // return [self.dataArray[section] count];
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return @"33";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = self.KTAG + section;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, view.bounds.size.width, view.bounds.size.height)];
    
    label.text = self.arrayTitle[section];
    [view addSubview:label];
    if ([[self.openSectionDict valueForKey:[NSString stringWithFormat:@"%ld", (long)section]] integerValue] == 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (view.bounds.size.height - 10) / 2, 7, 10)];
        imageView.image = [UIImage imageNamed:@"jiantou_03"]; // 三角形小图片
        [view addSubview:imageView];
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (view.bounds.size.height - 7) / 2, 10, 7)];
        imageView.image = [UIImage imageNamed:@"down"];
        [view addSubview:imageView];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collegeTaped:)];
    [view addGestureRecognizer:tap];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
#pragma mark - sectionHeader clicked
- (void)collegeTaped:(UITapGestureRecognizer *)sender {
    NSString *key = [NSString stringWithFormat:@"%ld", sender.view.tag - self.KTAG];
    // 给展开标识赋值
    if ([[self.openSectionDict objectForKey:key] integerValue] == 0) {
        [self.openSectionDict setObject:@"1" forKey:key];
    } else {
        [self.openSectionDict setObject:@"0" forKey:key];
    }
    NSUInteger index = sender.view.tag;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:index -self.KTAG];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SelectCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[SelectCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.section][indexPath.row];
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
        [self.selectArray addObject:self.dataArray[indexPath.section][indexPath.row]];
        [self.indexArray addObject:indexPath];
        [self.sureButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[self.selectArray count]] forState:UIControlStateNormal];
        cell.isSelected = YES;
    }
    //反选
    else
    {
        //反选的图标
        cell.selectImage.image  = [UIImage imageNamed:@"weixuanzhong"];
        [self.selectArray removeObject:self.dataArray[indexPath.section][indexPath.row]];
        [self.indexArray removeObject:indexPath];
        if (self.selectArray.count==0) {
            [self.sureButton setTitle:@"确定"forState:UIControlStateNormal];
        }else
        {
        [self.sureButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[self.selectArray count]] forState:UIControlStateNormal];
        }
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
