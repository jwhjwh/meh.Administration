//
//  inftionxqController.m
//  Administration
//
//  Created by zhang on 2017/2/25.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "inftionxqController.h"
#import "EaseMessageViewController.h"
#import "ChatViewController.h"
#import "inftionTableViewCell.h"
#import "AlertViewExtension.h"
#import "EditModel.h"
#import "GBAlertView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LVFmdbTool.h"
#import "SJABHelper.h"
#import "DongImage.h"
#define Is_up_Ios_9             [[UIDevice currentDevice].systemVersion floatValue] >= 9.0
@interface inftionxqController ()<UITableViewDelegate,UITableViewDataSource,alertviewExtensionDelegate,ABNewPersonViewControllerDelegate>
{
     AlertViewExtension *alert;
    UIScrollView *_scrollView;
}
@property (nonatomic,retain)UITableView *infonTableview;
@property (nonatomic,retain)NSMutableArray *infoArray;
@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,retain)NSString *logImage;//头像
@property (nonatomic,retain)NSString *callNum;//电话
@property (nonatomic,retain)NSString *callName;//姓名
@property (nonatomic,retain)UIImageView *TXImage;
@property (nonatomic,strong)NSDictionary *dicinfo;
@property (nonatomic,retain)UIButton *buton;
@property (nonatomic,strong)EaseUserModel *userModel;
@end

@implementation inftionxqController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"信息";
    self.dicinfo = [[NSDictionary alloc]init];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    _infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height-49) style:UITableViewStylePlain];
    _infonTableview.showsVerticalScrollIndicator = NO;
    _infonTableview.showsHorizontalScrollIndicator = NO;
    _infonTableview.dataSource=self;
    _infonTableview.delegate =self;
    [self.view addSubview:_infonTableview];
    
    [self loadDataFromServer];
  
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _arr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [_arr[section]count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{ if (section == 4 ){
    return 0;
}
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
        return 80;
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    if (indexPath.section==0) {
       _TXImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80, 20, 40, 40)];
        [_TXImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,_logImage]] placeholderImage:[UIImage  imageNamed:@"tx23"]];
        _TXImage.userInteractionEnabled=YES;
        _TXImage.backgroundColor = [UIColor whiteColor];
        _TXImage.layer.masksToBounds = YES;
        _TXImage.layer.cornerRadius = 20.0;//设置圆角
        [cell addSubview:_TXImage];
        UITapGestureRecognizer *tapSingleGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewGestureAction:)];//添加单击的手势
        tapSingleGR.numberOfTapsRequired = 1; //设置单击几次才触发方法
        [_TXImage addGestureRecognizer:tapSingleGR];
        
    }
    if (indexPath.section==3&&indexPath.row==0) {
        UIButton *TXImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [TXImage setImage:[UIImage imageNamed:@"phone"] forState: UIControlStateNormal];
        [TXImage addTarget:self action:@selector(callIphone:) forControlEvents:UIControlEventTouchUpInside];
        TXImage.frame=CGRectMake(self.view.bounds.size.width-50,5, 40, 40);
        [cell addSubview:TXImage];
//        UIButton *Image = [UIButton buttonWithType:UIButtonTypeCustom];
//        [Image setImage:[UIImage imageNamed:@"message"] forState: UIControlStateNormal];
//        [Image addTarget:self action:@selector(messagephone:) forControlEvents:UIControlEventTouchUpInside];
//        Image.frame=CGRectMake(self.view.bounds.size.width-100,5, 40, 37);
//        [cell addSubview:Image];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    cell.mingLabel.text=_arr[indexPath.section][indexPath.row];
    
    if (indexPath.section>0) {
        cell.xingLabel.text=[NSString stringWithFormat:@"%@",_infoArray[indexPath.section-1][indexPath.row]];
    }
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3&&indexPath.row==0) {
       
        NSArray *titles = @[@"呼叫",@"添加到手机通讯录"];
        
        [GBAlertView showWithtTtles:titles itemIndex:^(NSInteger itemIndex) {
            
            if (itemIndex==0) {
                NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",_callNum];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
            }else{
                if ([SJABHelper existPhone:_callNum] == ABHelperExistSpecificContact)
                {

                    [ELNAlerTool showAlertMassgeWithController:self andMessage:[NSString stringWithFormat:@"手机号码：%@已存在通讯录",_callNum] andInterval:1.0];
                }
                else
                {
                    
                    ABNewPersonViewController *newPersonViewController = [[ABNewPersonViewController alloc] init];
                    
                   
                    ABRecordRef newPerson = ABPersonCreate();
                   ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
                     CFErrorRef error = NULL;
                    NSString *phonestr = [NSString stringWithFormat:@"%@",_callNum];
                    multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                    ABMultiValueAddValueAndLabel(multiValue,(__bridge CFTypeRef)(phonestr), kABPersonPhoneMainLabel, NULL);
                    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiValue , &error);
                    
                     
                    
                    newPersonViewController.displayedPerson = newPerson;
                    
                    newPersonViewController.newPersonViewDelegate = self;
                    
                    UINavigationController *newNavigationController = [[UINavigationController alloc]initWithRootViewController:newPersonViewController];
                    
                    
                    [self presentModalViewController:newNavigationController animated:YES];
                }
                
            }
        }];
    }
} -(void) newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    
    [newPersonView dismissModalViewControllerAnimated:YES];
    
}
//打电话
-(void)callIphone:(UIButton*)sender{
    alert =[[AlertViewExtension alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    alert.delegate=self;
    [alert setbackviewframeWidth:300 Andheight:150];
    [alert settipeTitleStr:@"是否拨打电话?" Andfont:14];
    [self.view addSubview:alert];
}
-(void)clickBtnSelector:(UIButton *)btn
{
    if (btn.tag == 2000) {
        [alert removeFromSuperview];
    }else{
        NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",_callNum];
        //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadDataFromServer{
    
    
    NSString *uStr =[NSString stringWithFormat:@"%@user/queryUserInfo.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
      NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"id":_IDStr,@"CompanyInfoId":compid};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        _infoArray=[NSMutableArray array];
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            _buton= [UIButton buttonWithType:UIButtonTypeCustom];
            _buton.frame =CGRectMake(0,Scree_height-49,Scree_width,49);
            _buton.backgroundColor=GetColor(23, 137, 251, 1);
            [_buton setTitle:@"发消息" forState:UIControlStateNormal];
            [_buton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_buton addTarget: self action: @selector(iamsges) forControlEvents: UIControlEventTouchUpInside];
            [self.view addSubview:_buton];
            self.dicinfo  = [NSDictionary dictionaryWithDictionary:responseObject[@"userInfo"]];
            [UserCacheManager saveInfo:self.dicinfo[@"uuid"] imgUrl:self.dicinfo[@"icon"] nickName:self.dicinfo[@"name"]];
            EditModel *model = [[EditModel alloc]init];
            [model setValuesForKeysWithDictionary:[NSDictionary changeType:responseObject[@"userInfo"]]];
           // model.birthday = [model.birthday substringToIndex:10];
            if (model.birthday.length!=0) {
              model.birthday = [model.birthday substringToIndex:9];
            }
           // model.birthday = model.birthday;
             _logImage=model.icon;
            _callNum=[NSString stringWithFormat:@"%@",model.account];
            _callName=model.name;
            self.userModel = [[EaseUserModel alloc]initWithBuddy:self.dicinfo[@"uuid"]];
            self.userModel.nickname = self.dicinfo[@"name"];
            
            if (![model.LevelName isEqualToString:@""]) {
                _arr=@[@[@"头像"],@[@"账号",@"职位",@"类别",@"所属部门"],@[@"真实姓名",@"出生日期",@"年龄",@"现住地址"],@[@"手机号",@"微信号",@"QQ号"],@[@"兴趣爱好",@"个人签名"]];
                
                NSArray *arr=@[model.account,model.NewName,model.LevelName,model.departmentName];
                NSArray *arr1=@[model.name,model.birthday,model.age,model.address];
                NSArray *arr2=@[model.account,model.wcode,model.qcode];
                NSArray *arr3=@[model.interests,model.sdasd];
                _infoArray = [[NSMutableArray alloc]initWithObjects:arr,arr1,arr2,arr3,nil];
            }else{
                _arr=@[@[@"头像"],@[@"账号",@"职位",@"所属部门"],@[@"真实姓名",@"出生日期",@"年龄",@"现住地址"],@[@"手机号",@"微信号",@"QQ号"],@[@"兴趣爱好",@"个人签名"]];
                NSArray *arr=@[model.account,model.NewName,model.departmentName];
                NSArray *arr1=@[model.name,model.birthday,model.age,model.address];
                NSArray *arr2=@[model.account,model.wcode,model.qcode];
                NSArray *arr3=@[model.interests,model.sdasd];
                _infoArray = [[NSMutableArray alloc]initWithObjects:arr,arr1,arr2,arr3,nil];
            }
        
            [_infonTableview reloadData];
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }
        else if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"无员工信息" andInterval:1.0];
            _infonTableview.emptyView.hidden = NO;
        }
    }failure:^(NSError *error) {
               }
                  view:self.view MBPro:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)imageViewGestureAction:(UIGestureRecognizer *)tap{
   [DongImage showImage:_TXImage];
}
//-(void)messagephone:(UIButton *)sender{
//
//} 
-(void)iamsges{
    
    if (![LVFmdbTool isExist:[NSString stringWithFormat:@"%@",self.dicinfo[@"usersid"]] Current:[USER_DEFAULTS objectForKey:@"userid"]]) {
        [LVFmdbTool insertUser:[USER_DEFAULTS objectForKey:@"userid"] Userinfo:self.dicinfo];
    }else
    {
        [LVFmdbTool updateLatePerson:self.dicinfo userID:self.dicinfo[@"usersid"] currentUser:[USER_DEFAULTS objectForKey:@"userid"]];
    }
    EaseEmotionManager *manager = [[ EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:5 emotions:[EaseEmoji allEmoji]];
    ChatViewController *messageVC = [[ ChatViewController alloc] initWithConversationChatter:self.userModel.buddy conversationType:EMConversationTypeChat];
   // EaseMessageViewController *messageVC = [[EaseMessageViewController alloc]initWithConversationChatter:[NSString stringWithFormat:@"%@",self.model.name] conversationType:EMConversationTypeChat];
    messageVC.title =  _callName;
    messageVC.hidesBottomBarWhenPushed = YES;
    messageVC.dictInfo = self.dicinfo;
    [messageVC.faceView setEmotionManagers:@[manager]];
    [self.navigationController pushViewController:messageVC animated:YES];
}
@end
