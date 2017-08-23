//
//  BJZWViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/6/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BJZWViewController.h"
#import "inftionTableViewCell.h"
#import "SelectAlert.h"
#import "EditModel.h"
#import "depmtCell.h"
#import "YUFoldingSectionHeader.h"
@interface BJZWViewController ()<UITableViewDataSource,UITableViewDelegate,YUFoldingSectionHeaderDelegate>

{
    UITableView *infonTableview;
    
    NSArray *arr;
    UIView *blockView;
    inftionTableViewCell *cell;
    NSMutableArray *titles;
    NSMutableArray *numBS;
    int b;
}
@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;
@property (strong,nonatomic)UITableView *noEdit;
@property (strong,nonatomic)UIButton *ZWbutton;//职位
@property (strong,nonatomic)UIButton *ZWLBbutton;//职位类别
@property (strong,nonatomic)UIView *view1;//线

@property (strong,nonatomic) UILabel *BMLabel;//部门
@property (strong,nonatomic)UIButton *scBtnnnnn;//删除部门按钮
@property (strong,nonatomic) NSMutableArray *scBtnAry;//删除部门按钮数组1
@property (strong,nonatomic) NSMutableArray *scBtnAry2;//删除部门按钮数组2

@property (strong,nonatomic) NSMutableArray *bjBtnAry;//编辑部门按钮数组

@property (strong,nonatomic) NSMutableArray *sctagAry;//编辑部门tag按钮数组
@property (strong,nonatomic) NSMutableArray *sctagAry2;//编辑部门tag按钮数组




@property (strong,nonatomic)UIButton *tjBtn;//添加职位按钮
@property (strong,nonatomic)UIButton *scBtn;//删除职位按钮
@property (strong,nonatomic)UIButton *bjbtn;//编辑职位按钮
@property (strong,nonatomic)UIButton *SSBMbutt;//选择部门按钮

@property (strong,nonatomic) NSMutableArray *ZWbtnAry;//职位按钮数组
@property (strong,nonatomic) NSMutableArray *ViewbtnAry;//分割线数组
@property (strong,nonatomic) NSMutableArray *ZWLBbtnAry;//职位按钮数组
@property (strong,nonatomic)NSMutableArray *SSBMbtnAry;//选择部门按钮数组


@property(strong,nonatomic) NSMutableArray*ZW;//职位
@property (strong,nonatomic) NSMutableArray*Numm;//职位id
@property(strong,nonatomic) NSMutableArray*ZWLB;//职位类别
@property (strong,nonatomic) NSMutableArray*lbNum;//职位类别id
@property(strong,nonatomic) NSMutableArray*gxbmAry;//部门数组
@property(strong,nonatomic) NSMutableArray*gxbmidAry;//部门id数组

@property(strong,nonatomic)NSMutableArray *codeAry;

@property (nonatomic, strong) NSMutableArray *statusArray;
@property (nonatomic, strong) EditModel *model;


@property (nonatomic, strong) NSMutableArray *bjbuttonAry;
@property (nonatomic, strong) NSMutableArray *uuidary;

@property (nonatomic, strong) NSMutableArray *bjbtnname;

@property (nonatomic, strong) NSMutableArray *useridAry;
@end

@implementation BJZWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"编辑职位";
    b=0;
    [self setExtraCellLineHidden:infonTableview];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStyleGrouped];
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    NSLog(@"%@%@",_twocodeAry,_noEditAry);
    [self addalloc];
    [self tableViewUI];
    [self loadData];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeStatusBarOrientationNotification:)  name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}
-(void)onChangeStatusBarOrientationNotification:(NSNotification *)notification
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_noEdit reloadData];
    });
}
-(void)addalloc{
    _ZW = [NSMutableArray array];
    _Numm = [NSMutableArray array];
     _ZWLB = [NSMutableArray array];
     _lbNum = [NSMutableArray array];
     _gxbmAry = [NSMutableArray array];
     _gxbmidAry = [NSMutableArray array];
     _codeAry = [NSMutableArray array];
    
    _scBtnAry = [[NSMutableArray alloc]init];
    _bjBtnAry = [[NSMutableArray alloc]init];
    _scBtnAry2 = [[NSMutableArray alloc]init];
    _sctagAry = [[NSMutableArray alloc]init];
    _sctagAry2 = [[NSMutableArray alloc]init];
    _ZWbtnAry = [[NSMutableArray alloc]init];
    _ViewbtnAry = [[NSMutableArray alloc]init];
    _ZWLBbtnAry = [[NSMutableArray alloc]init];
    _SSBMbtnAry= [[NSMutableArray alloc]init];
    _bjbuttonAry = [[NSMutableArray alloc]init];
}
#pragma mark  请求角色
-(void)ZwNetWork:(UIButton*)btn{
    NSString *urlStr = [NSString stringWithFormat:@"%@user/queryUserCreate.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *RoleId=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"roleId"]];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"RoleId":RoleId};
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"])
        {
            NSArray *arr= [responseObject valueForKey:@"list"];
            titles = [[NSMutableArray alloc]init];
            numBS = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arr) {
                NSString *strr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"num"]];
                if ([strr isEqualToString:@"1"]) {
                }else{
                    [numBS  addObject:[dic valueForKey:@"num"]];
                    [titles addObject:[dic valueForKey:@"newName"]];
                }
            }
            [self showAlert:titles button:btn];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            [USER_DEFAULTS  setObject:@"" forKey:@"token"];
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时，请重新登录" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"0003"]){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您没有权限更改职位" andInterval:1.0];
        }else{
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"网络超时" andInterval:1.0];
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}


#pragma mark 编辑--完成
-(void)button1BackGroundNormal:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"编辑"]) {
        for (int i = 0; i<_bjbuttonAry.count-1; i++) {
            _bjbtn = _bjbuttonAry[i];
            _bjbtn.enabled = NO;
            [_bjbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        btn.enabled = YES;
        [btn setTitleColor:GetColor(0, 129, 238, 1) forState:UIControlStateNormal];
         [btn setTitle:@"完成" forState:UIControlStateNormal];
        
        NSSet *set = [NSSet setWithArray:_bjBtnAry];
        for (int u = 0; u<set.count; u++) {
            NSString *stt = [NSString stringWithFormat:@"%ld",(long)btn.tag];
            if ([stt isEqualToString: _bjBtnAry[u]]) {
                 [_bjbtnname replaceObjectAtIndex:u withObject:@"完成"];
                _ZWbutton = _ZWbtnAry[u];
                if (_ZWbutton.tag == 5 ||_ZWbutton.tag == 2||_ZWbutton.tag == 3||_ZWbutton.tag == 4||_ZWbutton.tag == 14||_ZWbutton.tag == 16||_ZWbutton.tag == 17) {
                    _ZWLBbutton = _ZWLBbtnAry[u];
                    _ZWLBbutton.enabled = YES;
                }
                _ZWbutton.enabled = YES;
                
                if ([stt isEqualToString:@"0"]) {
                    
                }else{
                    _SSBMbutt = _SSBMbtnAry[u];
                    _SSBMbutt.enabled= YES;
                    NSArray *scbtnary = _scBtnAry[u];
                    if (scbtnary.count>0){
                        for (int a = 0; a<scbtnary.count; a++) {
                            _scBtnnnnn = scbtnary[a];
                            _scBtnnnnn.enabled = YES;
                            [_scBtnnnnn setImage:[UIImage imageNamed:@"xx_ico01"] forState:UIControlStateNormal];
                            [_scBtnnnnn setImage:[UIImage imageNamed:@"xx_ico02"] forState:UIControlStateSelected];
                        }
                        
                    }
                }
                [_tjBtn setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
                [_tjBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                _tjBtn.enabled = NO;
                
                [_scBtn setImage:[UIImage imageNamed:@"sc_ico02"] forState:UIControlStateNormal];
                [_scBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                _scBtn.enabled = NO;
            }
        }
    }else if([btn.titleLabel.text isEqualToString:@"完成"]){
        for (int i = 0; i<_bjbuttonAry.count-1; i++) {
            _bjbtn = _bjbuttonAry[i];
            _bjbtn.enabled = YES;
            [_bjbtn setTitleColor:GetColor(0, 129, 238, 1) forState:UIControlStateNormal];
        }
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        NSSet *set = [NSSet setWithArray:_bjBtnAry];
        for (int u = 0; u<set.count; u++) {
            NSString *stt = [NSString stringWithFormat:@"%ld",(long)btn.tag];
            
          
            if ([stt isEqualToString: _bjBtnAry[u]]) {
                [_bjbtnname replaceObjectAtIndex:u withObject:@"编辑"];
                _ZWbutton = _ZWbtnAry[u];
                _ZWbutton.enabled = NO;
                _ZWLBbutton = _ZWLBbtnAry[u];
                _ZWLBbutton.enabled = NO;
                
                if ([stt isEqualToString:@"0"]) {
                    
                }else{
                    _SSBMbutt = _SSBMbtnAry[u];
                    _SSBMbutt.enabled= NO;
                    NSArray *scbtnary = _scBtnAry[u];
                    if (scbtnary.count>0){
                        for (int a = 0; a<scbtnary.count; a++) {
                            _scBtnnnnn = scbtnary[a];
                            _scBtnnnnn.enabled = NO;
                            [_scBtnnnnn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                            [_scBtnnnnn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
                        }
                    }
                }
            }
        }
        NSString *str = @"选择职位";
        NSMutableArray *zwbool = [NSMutableArray array];
        for (int i = 0 ; i<_ZW.count; i++) {
            NSArray *zwary = _ZW[i];
            BOOL isbool = [zwary containsObject: str];
            if (isbool  == 1) {
                [zwbool addObject:@"1"];
            }
        }
        bool isboolzw = [zwbool containsObject:@"1"];
        if (isboolzw == 1) {
            [_tjBtn setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
            [_tjBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _tjBtn.enabled = NO;
            
            [_scBtn setImage:[UIImage imageNamed:@"sc_ico02"] forState:UIControlStateNormal];
            [_scBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _scBtn.enabled = NO;
        }else{
            [_tjBtn setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
            [_tjBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _tjBtn.enabled = YES;
            
            [_scBtn setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
            [_scBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _scBtn.enabled = YES;
        }
    }else if([btn.titleLabel.text isEqualToString:@"上传"]){
        //[btn setTitle:@"编辑" forState:UIControlStateNormal];
        NSString *stt = [NSString stringWithFormat:@"%ld",(long)btn.tag];
        NSSet *set = [NSSet setWithArray:_bjBtnAry];
        for (int u = 0; u<set.count; u++) {
            if ([stt isEqualToString: _bjBtnAry[u]]) {
                [_bjbtnname replaceObjectAtIndex:u withObject:@"编辑"];
                [self complete:btn zwidary:_Numm[u] zwlbid:_lbNum[u] deparid:_gxbmidAry[u] userid:_useridAry[0] uuid:_uuidary[0]];
            }
            
        }
        
    }else {
        
        //删除职位
        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要删除此项内容" sureBtn:@"确认" cancleBtn:@"取消"];
        alertView.resultIndex = ^(NSInteger index){
            if (index == 2) {
                NSString *stt = [NSString stringWithFormat:@"%ld",(long)btn.tag];
                for (int u = 0; u<_bjBtnAry.count; u++) {
                    if ([stt isEqualToString: _bjBtnAry[u]]) {
                        //删除职位  RoleId  DepartmentID
                        
                        [self dimissZW:_Numm[u] departid:_gxbmidAry[u] uuid:_uuidary[u] rowsect:u];
                    }
                }

            }
            
        };
        [alertView showMKPAlertView];
    }
}
#pragma mark 添加用户职位
-(void)complete:(UIButton *)bbttn zwidary:(NSArray *)zwidary zwlbid:(NSArray *)zwlbidary deparid:(NSArray *)Deparid userid:(NSString *)userid uuid:(NSString *)uuid{
    //添加用户职位 :user/addUserPosition.action
    /*
     _bjbtn = _bjbuttonAry[u];
     _bjbtn.enabled = YES;
     [_bjbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     */
    //usersid uuid 
    NSString *addurlStr = [NSString stringWithFormat:@"%@user/addUserPosition.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *string1 = [NSString stringWithFormat:@"(%@)",[Deparid componentsJoinedByString:@","]];
    
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"id":userid,@"uuid":uuid,@"RoleId":zwidary[0],@"DepartmentID":string1,@"LevelID":zwlbidary[0]};
    [ZXDNetworking GET:addurlStr parameters:dic success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}
#pragma mark 修改用户职位 ---------------------------------------两个网络请求数据

-(void)updateuserposition :(NSString *)uuid usersid:(NSString *)usersid{
    //修改用户职位: user/updateUserPosition.action
    NSString *addurlStr = [NSString stringWithFormat:@"%@user/updateUserPosition.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"uuid":uuid,@"id":usersid};
    NSDictionary *update = [[NSDictionary alloc]init];
    NSMutableArray *updatee = [[NSMutableArray alloc]init];
    //update = @{@"id":};
    //update -- id,departmentid,roleid,levelid
    //uuid
    // id
    [ZXDNetworking GET:addurlStr parameters:dic success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

#pragma mark 删除职位请求
-(void)dimissZW:(NSArray *)roled departid:(NSArray *)departid  uuid:(NSString *)uuuuid rowsect:(NSUInteger )rowsectt{
    NSString *urlStr = [NSString stringWithFormat:@"%@user/delUserPosition.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *string = [roled componentsJoinedByString:@","];
    NSString *string1 = [NSString stringWithFormat:@"(%@)",[departid componentsJoinedByString:@","]];
    
    if ([string1 isEqualToString:@"(0)"]) {
        dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"uuid":uuuuid,@"RoleId":string,@"id":_model.usersid};
    }else{
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"uuid":uuuuid,@"RoleId":string,@"DepartmentID":string1,@"id":_model.usersid};
    }
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"0000"]) {
            [_Numm removeObjectAtIndex:rowsectt];
            [_gxbmidAry removeObjectAtIndex:rowsectt];
            [_ZW removeObjectAtIndex:rowsectt];
            [_ViewbtnAry removeObjectAtIndex:rowsectt];
            [_ZWLB removeObjectAtIndex:rowsectt];
            [_lbNum removeObjectAtIndex:rowsectt];
            
            
            NSIndexSet *idxSet = [[NSIndexSet alloc] initWithIndex: rowsectt];
            
            [infonTableview beginUpdates];
            [infonTableview deleteSections:idxSet withRowAnimation:UITableViewRowAnimationFade];
            [infonTableview endUpdates];
        }else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除失败" andInterval:1.0];
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

    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
#pragma mark 添加职位
-(void)tjaction_button:(UIButton *)btn{
    
    [_ZW addObject:[[NSMutableArray alloc]initWithObjects:@"选择职位", nil]];
    [_ZWLB addObject:[[NSMutableArray alloc]initWithObjects:@"未分配", nil]];
    [_lbNum addObject:[[NSMutableArray alloc]initWithObjects:@"0", nil]];
    [_Numm addObject:[[NSMutableArray alloc]initWithObjects:@"0", nil]];
    [_gxbmAry addObject:[NSMutableArray array]];
    [_gxbmidAry addObject:[NSMutableArray  array]];
    [_bjbtnname addObject:@"上传"];
    [_codeAry addObject:[[NSMutableArray  alloc]initWithObjects:@"职位", nil]];
   // [infonTableview reloadData];
    
    
    NSIndexSet *indexSet1 = [[NSIndexSet alloc] initWithIndex: _ZW.count-1];
    [infonTableview beginUpdates];
    [infonTableview insertSections:indexSet1 withRowAnimation:UITableViewRowAnimationLeft];
    [infonTableview endUpdates];
    
    [_tjBtn setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
    [_tjBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _tjBtn.enabled = NO;
    
    [_scBtn setImage:[UIImage imageNamed:@"sc_ico02"] forState:UIControlStateNormal];
    [_scBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _scBtn.enabled = NO;
    
    _ZWbutton = _ZWbtnAry[_ZW.count-1];
    _ZWbutton.enabled = YES;
    for (int i = 0; i<_bjbuttonAry.count-1; i++) {
        _bjbtn = _bjbuttonAry[i];
        _bjbtn.enabled = NO;
        [_bjbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}
#pragma mark 删除职位
-(void)scaction_button:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"删除职位"]) {
        [btn setTitle:@"取消删除" forState:UIControlStateNormal];
        for (int i = 0; i<_bjBtnAry.count; i++) {
            _bjbtn = _bjbuttonAry[i];
            NSString *bjbtn = @"删除";
            [_bjbtnname replaceObjectAtIndex:i withObject:bjbtn];
            [_bjbtn setTitle:@"删除" forState:UIControlStateNormal];
        }
    }else{
        [btn setTitle:@"删除职位" forState:UIControlStateNormal];
        for (int i = 0; i<_bjBtnAry.count; i++) {
            _bjbtn = _bjbuttonAry[i];
            NSString *bjbtn = @"编辑";
            [_bjbtnname replaceObjectAtIndex:i withObject:bjbtn];
            [_bjbtn setTitle:@"编辑" forState:UIControlStateNormal];
        }

    }
}
#pragma mark 删除部门
-(void)scbmbtn:(UIButton *)btn{

    
    inftionTableViewCell *cellu = (inftionTableViewCell *)[btn superview];
    NSIndexPath *insd = [infonTableview indexPathForCell:cellu];
    NSLog(@"%ld,%ld",(long)insd.section,(long)insd.row);
    NSMutableArray *dimissbm = _gxbmAry[insd.section];
    [dimissbm removeObjectAtIndex:insd.row-2];
    NSMutableArray *dimissid = _gxbmidAry[insd.section];
    [dimissid removeObjectAtIndex:insd.row-2];
    
    [_gxbmAry replaceObjectAtIndex:insd.section withObject:dimissbm];
    [self dimissTabelCellZWUI:insd.row secct:insd.section];
    
    
}

#pragma mark 职位按钮
-(void)JsButtonbtn:(UIButton*)btn{
    [self ZwNetWork:btn];
}
-(void)showAlert :(NSArray *)arrr button:(UIButton*)bbtn{
    NSLog(@"%@-%@",arrr,numBS);
    NSMutableArray *isbol = [[NSMutableArray alloc]init];
    [SelectAlert showWithTitle:@"选择职位" titles:arrr selectIndex:^(NSInteger selectIndex) {
         NSLog(@"选择了第%ld个",(long)selectIndex);
        NSString *tagg = numBS[selectIndex];
        
        
        for (int i = 0; i<_Numm.count; i++) {
            NSArray *num = _Numm[i];
            BOOL isbool = [num containsObject: tagg];
            if (isbool == 1) {
                [isbol addObject:@"1"];
            }
        }
        BOOL yesor = [isbol containsObject:@"1"];
        if (yesor == 1) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"不能重复选择职位哦" andInterval:1.0];
        }else{
            NSArray *numary = [[NSArray alloc]initWithObjects:tagg, nil];
              for (int i = 0; i<_Numm.count; i++) {
                  NSArray *zebun = _Numm[i];
                  for (int y = 0; y<zebun.count; y++) {
                      int zwnumm = [zebun[y] intValue];
                      if (zwnumm == bbtn.tag) {
                           int taa = [tagg intValue];
                          NSMutableArray *cooode = _codeAry[i];
                          if ( taa == 2|| taa == 5||taa ==3||taa ==4||taa ==14||taa ==16||taa ==17 ) {
                              
                              _ZWLBbutton = _ZWLBbtnAry[i];
                              _view1 = _ViewbtnAry[i];
                              [_ZWLBbutton setTitleColor:GetColor(199, 199, 205, 1) forState:UIControlStateNormal];
                              _view1.backgroundColor = [UIColor lightGrayColor];
                              [_ZWLBbutton setTitle:@"未分配" forState:UIControlStateNormal];
                              _ZWLBbutton.enabled = YES;
                              if (cooode.count>1) {
                                  cooode[1] = @"所属部门";
                                [_codeAry replaceObjectAtIndex:i withObject:cooode];
                                  NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:i];
                                  [infonTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                              }else{
                                [cooode addObject:@"所属部门"];
                                [_codeAry replaceObjectAtIndex:i withObject:cooode];
                                  [self addtableViewCellZWUI:1 secct:i];
                              }
                          }else{
                             
                              
                              _ZWLBbutton = _ZWLBbtnAry[i];
                              _view1 = _ViewbtnAry[i];
                              [_ZWLBbutton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
                              _view1.backgroundColor = [UIColor whiteColor];
                              [_ZWLBbutton setTitle:@"未分配" forState:UIControlStateNormal];
                              _ZWLBbutton.enabled = NO;
                              
                              if (cooode.count>1) {
                                  cooode[1] = @"管辖部门";
                                  //_SSBMbtnAry
                                  
                                  [_codeAry replaceObjectAtIndex:i withObject:cooode];
                                  NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:i];
                                 [infonTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                                  
                              }else{
                                  [cooode addObject:@"管辖部门"];
                                  
                                  [_codeAry replaceObjectAtIndex:i withObject:cooode];
                                  [self addtableViewCellZWUI:1 secct:i];
                                  
                              }
                              
                              
                          }
                          [_Numm replaceObjectAtIndex:i withObject:numary];
                          NSMutableArray *scbmary = [[NSMutableArray alloc]initWithArray:_gxbmAry[i]];
                          NSMutableArray *scbmidary = [[NSMutableArray alloc]initWithArray:_gxbmAry[i]];
                          _ZWLBbutton.tag = taa;
                          bbtn.tag = taa;
                          for (int t = 0; t<scbmary.count;) {
                              [scbmary removeObjectAtIndex:t];
                              [scbmidary removeObjectAtIndex:t];
                              [_gxbmAry replaceObjectAtIndex:i withObject:scbmary];
                              [_gxbmidAry replaceObjectAtIndex:i withObject:scbmidary];
                              [self dimissTabelCellZWUI:t+2 secct:i];
                              
                          }
                         
                      }
                  }
              }
            
            
            
        } 
    } selectValue:^(NSString *selectValue) {
        BOOL yesor = [isbol containsObject:@"1"];
        if (yesor == 0) {
            NSArray *zwary = [[NSArray alloc]initWithObjects:selectValue, nil];
            for (int i = 0; i<_ZW.count; i++) {
                NSArray *zw = _ZW[i];
                for (int y = 0; y<zw.count; y++) {
                    NSString *zww = zw[y];
                    if (zww == bbtn.titleLabel.text) {
                        [_ZW replaceObjectAtIndex:i withObject:zwary];
                        [bbtn setTitle:selectValue forState:UIControlStateNormal];
                        
                    }
                }
            }

        }
    } showCloseButton:NO];
    
}
-(void)addtableViewCellZWUI:(NSUInteger )rroow secct:(NSUInteger )secct{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rroow inSection:secct];
    [indexPaths addObject: indexPath];
    [infonTableview beginUpdates];
    [infonTableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    [infonTableview endUpdates];
    
}

-(void)dimissTabelCellZWUI:(NSUInteger )rroow secct:(NSUInteger )secct{
    NSArray *_tempIndexPathArr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:rroow inSection:secct]];
    [infonTableview beginUpdates];
    [infonTableview deleteRowsAtIndexPaths:_tempIndexPathArr withRowAnimation:UITableViewRowAnimationFade];
    [infonTableview endUpdates];
}
#pragma mark 职位类别按钮
-(void)JsLBButtonbtn:(UIButton*)btn{
    NSLog(@"职位类别按钮");//manager/queryPositionLevel.action
    NSString *jsid = [[NSString alloc]init];
    NSString *lbnum = [[NSString alloc]init];

    for (int i = 0; i<_Numm.count; i++) {
        NSArray *zw = _Numm[i];
        for (int y = 0; y<zw.count; y++) {
            
            NSString *zwnum = [NSString stringWithFormat:@"%@",zw[y]];
             NSString *stringInt = [NSString stringWithFormat:@"%ld",(long)btn.tag];
            if ([zwnum isEqual: stringInt]) {
                jsid = zwnum;
                if ([jsid isEqualToString:@"5"]) {
                    lbnum = @"2";
                }else if([jsid isEqualToString:@"2"]){
                    lbnum = @"1";
                }else if ([jsid isEqualToString:@"16"]){
                    lbnum = @"3";
                }else if ([jsid isEqualToString:@"3"]){
                    lbnum = @"4";
                }else {
                    lbnum = @"5";
                }
            }
        }
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@manager/queryPositionLevel.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"RoleId":jsid,@"Num":lbnum};
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"0000"]) {
            NSLog(@"%@",responseObject);
            //id = 31;
//            levelName = 4444444;
            NSArray *arrt= [responseObject valueForKey:@"list"];
            NSMutableArray *zwlbid = [[NSMutableArray alloc]init];
            NSMutableArray *zwlbname = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arrt) {
                [zwlbid  addObject:[dic valueForKey:@"id"]];
                [zwlbname addObject:[dic valueForKey:@"levelName"]];
            }
            //[SelectAlert showWithTitle:@"选择部门" titles:gxbmAry selectIndex:^(NSInteger selectIndex) {
            [SelectAlert showWithTitle:@"选择职位类别" titles:zwlbname selectIndex:^(NSInteger selectIndex) {
                
            } selectValue:^(NSString *selectValue) {
                
            } showCloseButton:NO];
        }else if([[responseObject valueForKey:@"status"] isEqualToString:@"5000"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"贵公司没有设置该职业类别哦" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            [USER_DEFAULTS  setObject:@"" forKey:@"token"];
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时，请重新登录" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"0003"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您没有权限更改职位" andInterval:1.0];
        }else{
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"网络超时" andInterval:1.0];
        }

    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
    
}
#pragma mark 点击所属部门
-(void)SSButtonbtn:(UIButton*)btn{
    NSLog(@"%@%ld",btn.titleLabel.text,(long)btn.tag);
    NSString *jsid = [NSString stringWithFormat:@"%d",[_Numm[btn.tag][0] intValue]];
    NSString *urlStr = [NSString stringWithFormat:@"%@manager/queryDepartment.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"RoleId":jsid};
    NSMutableArray* gxbmNum = [[NSMutableArray alloc]init];
    NSMutableArray* gxbmAry = [[NSMutableArray alloc]init];
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"])
        {
            NSArray *arrt= [responseObject valueForKey:@"list"];
            
            if (arrt.count == 0) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您的公司没有创建部门 " andInterval:1.0];
            }else{
                for (NSDictionary *dic in arrt) {
                    [gxbmNum  addObject:[dic valueForKey:@"id"]];
                    [gxbmAry addObject:[dic valueForKey:@"departmentName"]];
                }
                
                
                [SelectAlert showWithTitle:@"选择部门" titles:gxbmAry selectIndex:^(NSInteger selectIndex) {
                    NSLog(@"%@/n%@",gxbmAry,gxbmNum);//gxbmNum[selectindex]
               
                    NSString *tagg = gxbmNum[selectIndex];
                    NSArray *bmid = _gxbmidAry[btn.tag];
                    BOOL yesor = [bmid containsObject: tagg];
                    if (yesor == 1) {
                        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"不能重复选择部门哦" andInterval:1.0];
                    }else{
                        if ([btn.titleLabel.text isEqualToString: @"添加所属部门"]) {
                        _gxbmidAry[btn.tag][0] = tagg;
                        }else{
                        [_gxbmidAry[btn.tag] addObject:tagg];
                        }
                      }
                } selectValue:^(NSString *selectValue) {
                    NSString *bmtext = selectValue;
                    NSArray *bmtextary = _gxbmAry[btn.tag];
                    BOOL yesor = [bmtextary containsObject:bmtext];
                    if (yesor == 1) {
                        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"不能重复选择部门哦" andInterval:1.0];
                    }else{
                        if ([btn.titleLabel.text isEqualToString: @"添加所属部门"]) {
                        NSMutableArray*ssbmary = [[NSMutableArray alloc]initWithObjects:selectValue, nil];
                            
                            if ([_gxbmAry[btn.tag]count] ==1) {
                                [_gxbmAry replaceObjectAtIndex:btn.tag withObject:ssbmary];
                                NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:[_codeAry[btn.tag]count]+[_gxbmAry[btn.tag]count]-1 inSection:btn.tag]; //刷新第0段第2行
                                [infonTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
                                _scBtnnnnn = _scBtnAry[btn.tag][0];
                                _scBtnnnnn.enabled = YES;
                                [_scBtnnnnn setImage:[UIImage imageNamed:@"xx_ico01"] forState:UIControlStateNormal];
                                [_scBtnnnnn setImage:[UIImage imageNamed:@"xx_ico02"] forState:UIControlStateSelected];
                            }else{
                                [_gxbmAry replaceObjectAtIndex:btn.tag withObject:ssbmary];
                            [self addtableViewCellZWUI:[_codeAry[btn.tag]count]+[_gxbmAry[btn.tag]count]-1 secct:btn.tag];
                                _scBtnnnnn = _scBtnAry[btn.tag][0];
                                _scBtnnnnn.enabled = YES;
                                [_scBtnnnnn setImage:[UIImage imageNamed:@"xx_ico01"] forState:UIControlStateNormal];
                                [_scBtnnnnn setImage:[UIImage imageNamed:@"xx_ico02"] forState:UIControlStateSelected];
                            }
                            
                        }else{
                            [_gxbmAry[btn.tag] addObject:selectValue];
                            [self addtableViewCellZWUI:[_codeAry[btn.tag]count]+[_gxbmAry[btn.tag]count]-1 secct:btn.tag];
                            _scBtnnnnn = _scBtnAry[btn.tag][0];
                            _scBtnnnnn.enabled = YES;
                            [_scBtnnnnn setImage:[UIImage imageNamed:@"xx_ico01"] forState:UIControlStateNormal];
                            [_scBtnnnnn setImage:[UIImage imageNamed:@"xx_ico02"] forState:UIControlStateSelected];
                        }
                      //  NSUInteger seccct = btn.tag;
                  // [infonTableview reloadData]; 5*2+5+50=1767-1994
                       
                        
                        
                    }
                } showCloseButton:NO];

        }
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}
#pragma mark cell 点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:infonTableview]) {
    cell = [[inftionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"bcCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int tag = 0;
    if (indexPath.row == 0) {
        cell.textLabel.text = _codeAry[indexPath.section][indexPath.row];
        for(_ZWbutton in cell.subviews){
            if([_ZWbutton isMemberOfClass:[UIButton class]])
            {
                [_ZWbutton removeFromSuperview];
            }
        }
        _ZWbutton = [[UIButton alloc]init];
        _ZWbutton.frame = CGRectMake(120, 1, (self.view.bounds.size.width-120)/2
                                     , 38);
       
        [_ZWbutton setTitle:_ZW[indexPath.section][indexPath.row] forState:UIControlStateNormal];
        _ZWbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _ZWbutton.font = [UIFont boldSystemFontOfSize:kWidth*25];
        [_ZWbutton addTarget:self action:@selector(JsButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_ZWbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if ([_Numm[indexPath.section]count] == 0) {
            
        }else{
            NSString*zwtag = _Numm[indexPath.section][indexPath.row];
            tag = [zwtag intValue];
            _ZWbutton.tag = tag;
        }
        NSString *bjname =_bjbtnname[indexPath.section];
        if ([bjname isEqualToString:@"完成"]||[bjname isEqualToString:@"上传"]) {
            _ZWbutton.enabled = YES;
        }else{
            _ZWbutton.enabled = NO;
        }
    
        [cell addSubview:_ZWbutton];
        if (_ZWbtnAry.count == _ZW.count) {
            NSInteger tagstr = [_Numm[indexPath.section][indexPath.row] intValue];
            for (int i = 0; i<_ZWbtnAry.count; i++) {
                UIButton *zebtn = _ZWbtnAry[i];
                if (zebtn.tag == tagstr) {
                    [_ZWbtnAry replaceObjectAtIndex:i withObject:_ZWbutton];
                }
            }
        }else{
            [_ZWbtnAry addObject:_ZWbutton];
        }
        _view1 = [[UIView alloc]init];
        _view1.frame = CGRectMake(120+(self.view.bounds.size.width-120)/2, 6, 1, 30);
        
        _ZWLBbutton = [[UIButton alloc]initWithFrame:CGRectMake(121+(self.view.bounds.size.width-120)/2, 1, self.view.bounds.size.width-(self.view.bounds.size.width/2+31), 38)];
        _ZWLBbutton.font = [UIFont boldSystemFontOfSize:kWidth*30];
        
        [_ZWLBbutton addTarget:self action:@selector(JsLBButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if (tag == 2|| tag == 5||tag ==3||tag ==4||tag ==14||tag ==16||tag ==17) {
            [_ZWLBbutton setTitleColor:GetColor(199, 199, 205, 1) forState:UIControlStateNormal];
            _view1.backgroundColor = [UIColor lightGrayColor];
            [_ZWLBbutton setTitle:_ZWLB[indexPath.section][indexPath.row] forState:UIControlStateNormal];
            if ([bjname isEqualToString:@"完成"]||[bjname isEqualToString:@"上传"]) {
                _ZWLBbutton.enabled = YES;
            }else{
                _ZWLBbutton.enabled = NO;
            }
            
        }else{
            [_ZWLBbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _view1.backgroundColor = [UIColor whiteColor];
            _ZWLBbutton.enabled = NO;
        }
        if ([_Numm[indexPath.section]count] == 0) {
            
        }else{
            _ZWLBbutton.tag = [_Numm[indexPath.section][0] intValue];
        }
        if (_ZWLBbtnAry.count == _ZW.count) {
            NSInteger tagstr = [_Numm[indexPath.section][0] intValue];
            for (int i = 0; i<_ZWLBbtnAry.count; i++) {
                UIButton *zebtn = _ZWLBbtnAry[i];
                if (zebtn.tag == tagstr) {
                    [_ZWLBbtnAry replaceObjectAtIndex:i withObject:_ZWLBbutton];
                    [_ViewbtnAry replaceObjectAtIndex:i withObject:_view1];

                }
            }
        }else{
            [_ZWLBbtnAry addObject:_ZWLBbutton];
            [_ViewbtnAry addObject:_view1];
        }
        
        [cell addSubview:_view1];
        [cell addSubview:_ZWLBbutton];
    }else if(indexPath.row ==1){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
        cell.textLabel.text = _codeAry[indexPath.section][indexPath.row];
            _SSBMbutt = [[UIButton alloc]init];
            _SSBMbutt.frame = CGRectMake(120, 1, self.view.bounds.size.width-100, 38);
            [_SSBMbutt setTitle:[NSString stringWithFormat:@"添加%@",cell.textLabel.text] forState:UIControlStateNormal];
            _SSBMbutt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _SSBMbutt.font = [UIFont boldSystemFontOfSize:kWidth*30];
            [_SSBMbutt addTarget:self action:@selector(SSButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
            [_SSBMbutt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            //NSInteger section  = indexPath.section;
             _SSBMbutt.tag= indexPath.section;
        NSString *bjname =_bjbtnname[indexPath.section];
        if ([bjname isEqualToString:@"完成"]||[bjname isEqualToString:@"上传"]) {
            _SSBMbutt.enabled = YES;
        }else{
            _SSBMbutt.enabled = NO;
        }
        
            [cell addSubview:_SSBMbutt];
        if ([_Numm[indexPath.section]count] == 0) {
            
        }else{
            _SSBMbutt.tag= indexPath.section;
           
        }
        if (_SSBMbtnAry.count == _ZW.count) {
            NSInteger tagstr = [_Numm[indexPath.section][0] intValue];
            for (int i = 0; i<_SSBMbtnAry.count; i++) {
                UIButton *zebtn = _SSBMbtnAry[i];
                if (zebtn.tag == tagstr) {
                    [_SSBMbtnAry replaceObjectAtIndex:i withObject:_SSBMbutt];
                }
            }
        }else{
            [_SSBMbtnAry addObject:_SSBMbutt];
        }
    }else{
        UILabel *XBTLabel  = [[UILabel alloc]initWithFrame:CGRectMake(120, 1, self.view.bounds.size.width-160, 38)];
        XBTLabel.text = _gxbmAry[indexPath.section][indexPath.row-2];
        XBTLabel.font = [UIFont boldSystemFontOfSize:kWidth*30];
        [cell addSubview:XBTLabel];
        
        _scBtnnnnn= [[UIButton alloc]initWithFrame:CGRectMake(120+self.view.bounds.size.width-160, 1, 40, 38)];
        [cell addSubview:_scBtnnnnn];
        [_scBtnnnnn addTarget:self action:@selector(scbmbtn:) forControlEvents:UIControlEventTouchUpInside];
        if ([_bjbtnname[indexPath.section] isEqualToString:@"完成"]) {
            _scBtnnnnn.enabled = YES;
            [_scBtnnnnn setImage:[UIImage imageNamed:@"xx_ico01"] forState:UIControlStateNormal];
            [_scBtnnnnn setImage:[UIImage imageNamed:@"xx_ico02"] forState:UIControlStateSelected];
        }else{
            _scBtnnnnn.enabled = NO;
            [_scBtnnnnn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_scBtnnnnn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        }
        NSString*zwtag = _Numm[indexPath.section][0];
        tag = [zwtag intValue];
        
        if (tag == 2|| tag == 5||tag ==3||tag ==4||tag ==14||tag ==16||tag ==17) {
            //所属部门
            if (_scBtnAry.count == _gxbmAry.count) {
                
            }else{
                if (_scBtnAry.count == _gxbmAry.count) {
                    _scBtnAry2 = [[NSMutableArray alloc]init];
                    [_scBtnAry2 addObject:_scBtnnnnn];
                    [_scBtnAry replaceObjectAtIndex:indexPath.section withObject:_scBtnAry2];
                }else{
                    _scBtnAry2 = [[NSMutableArray alloc]init];
                    [_scBtnAry2 addObject:_scBtnnnnn];
                    [_scBtnAry addObject:[[NSMutableArray alloc]init]];
                    [_scBtnAry insertObject:_scBtnAry2 atIndex:indexPath.section];
                }

            }
                }else{
            //管辖部门
            if (_scBtnAry.count == _gxbmAry.count) {
                
            }else{
                [_scBtnAry addObject:[[NSMutableArray alloc]init]];
                if ([_scBtnAry[indexPath.section]count] == [_gxbmAry[indexPath.section]count]) {
                    //替换
                    NSMutableArray *linbm = [[NSMutableArray alloc]init];
                    linbm = _scBtnAry[indexPath.section];
                    [linbm replaceObjectAtIndex:indexPath.row-2 withObject:_scBtnnnnn];
                    [_scBtnAry replaceObjectAtIndex:indexPath.section withObject:linbm];
                }else{
                    //直接加
                    [_scBtnAry2 addObject:_scBtnnnnn];
                    [_scBtnAry insertObject:_scBtnAry2 atIndex:indexPath.section];
                }
            }
            

           
            
            
            
        }

        
    }
        return cell;
    }else{
     UITableViewCell*   ccell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"bcCelll"];
        ccell.selectionStyle = UITableViewCellSelectionStyleNone;
        ccell.textLabel.textColor = [UIColor lightGrayColor];
        ccell.textLabel.text = _twocodeAry[indexPath.row];
        ccell.textLabel.textColor = [UIColor lightGrayColor];
        
           
            UILabel *bmlabel = [[UILabel alloc]init];
            bmlabel.frame = CGRectMake(120, 10, self.view.frame.size.width-120, 30);
        bmlabel.textColor = [UIColor lightGrayColor];
            id obj = _noEditAry[indexPath.row];
            if([obj isKindOfClass:[NSString class]]){
                //此元素是字符串
                bmlabel.text=[NSString stringWithFormat:@"%@",_noEditAry[indexPath.row]];
                [ccell addSubview:bmlabel];
            }else{//不是字符串
                depmtCell *celled=[[depmtCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"depmCell" arr:_noEditAry[indexPath.row] numcode:1];
                celled.mLabel.textColor = [UIColor lightGrayColor];
                celled.mLabel.text=_twocodeAry[indexPath.row];
                celled.selectionStyle = UITableViewCellSeparatorStyleNone;
                [celled setNeedsUpdateConstraints];
                [celled updateConstraintsIfNeeded];
                return celled;
            
        }
        return ccell;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ([tableView isEqual:infonTableview]) {
        UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Scree_width, 30)];
        headV.backgroundColor = GetColor(238, 238, 238, 1);
        _bjbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bjbtn.frame =CGRectMake(Scree_width-60,0,50,30);//0 129 238
        [_bjbtn setTitle:_bjbtnname[section] forState:UIControlStateNormal];
        [_bjbtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
        [_bjbtn setTitleColor:GetColor(0, 129, 238, 1) forState:UIControlStateNormal];
        _bjbtn.font = [UIFont boldSystemFontOfSize:kWidth*30];
        NSString *tar = _Numm[section][0];
        int w = [tar intValue];
        _bjbtn.tag = w;
        [headV addSubview:_bjbtn];
        NSString *sttt = [NSString stringWithFormat:@"%ld",(long)_bjbtn.tag];
        NSLog(@"编辑按钮的tag=%ld",(long)_bjbtn.tag);
        if (_bjBtnAry.count == _ZW.count) {
            for (int y = 0; y<_bjBtnAry.count; y++) {
                NSString *bjtag =_bjBtnAry[y];
                if ([bjtag isEqualToString:sttt]) {
                    [_bjBtnAry replaceObjectAtIndex:y withObject:sttt];
                    [_bjbuttonAry replaceObjectAtIndex:y withObject:_bjbtn];
                }
            }
        }else{
            [_bjBtnAry addObject:sttt];
            [_bjbuttonAry addObject:_bjbtn];
        }
        
        return headV;

    }else{
        if (_twocodeAry.count>0) {
            YUFoldingSectionHeader *sectionHeaderView = [[YUFoldingSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,30)  withTag:section];
            [sectionHeaderView setupWithBackgroundColor:GetColor(238, 238, 238, 1)
                                            titleString:[NSString stringWithFormat:@"其他职位(所在其他部门)"]
                                             titleColor:[UIColor lightGrayColor]
                                              titleFont:[UIFont systemFontOfSize:13]
                                      descriptionString:[NSString string]
                                       descriptionColor:[UIColor whiteColor]
                                        descriptionFont:[UIFont systemFontOfSize:13]
                                             arrowImage:[UIImage imageNamed:@"jiantou_03"]
                                          arrowPosition:[self perferedArrowPosition]
                                           sectionState:((NSNumber *)self.statusArray[section]).integerValue];
            
            sectionHeaderView.tapDelegate = self;
            
            return sectionHeaderView;
        } 
    }
    return nil;
}
#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
// 返回箭头的位置
-(YUFoldingSectionHeaderArrowPosition )perferedArrowPosition
{
    // 没有赋值，默认箭头在左
    NSUInteger intger=1;
    self.arrowPosition=intger;
    return self.arrowPosition ? :YUFoldingSectionHeaderArrowPositionLeft;
}


#pragma mark UI
-(void)tableViewUI{
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = GetColor(201, 201, 201, 1);
    [infonTableview addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.bottom.equalTo(infonTableview.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
    
    UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 80+(_noEditAry.count*50))];
    fotView.backgroundColor = [UIColor whiteColor];
    infonTableview.tableFooterView=fotView;
    
    UIView *toppView = [[UIView alloc]init];
    toppView.backgroundColor = GetColor(238, 238, 238, 1);
    [fotView addSubview:toppView];
    [toppView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fotView.mas_left).offset(0);
        make.right.mas_equalTo(fotView.mas_right).offset(0);
        make.top.mas_equalTo(fotView.mas_top).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    
    _tjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tjBtn setTitle:@"添加职位" forState:UIControlStateNormal];
    [_tjBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_tjBtn addTarget:self action:@selector(tjaction_button:) forControlEvents:UIControlEventTouchUpInside];
    [_tjBtn setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
    _tjBtn.imageEdgeInsets =  UIEdgeInsetsMake(5,30,5,_tjBtn.titleLabel.left+40);
    [fotView addSubview:_tjBtn];
    [_tjBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fotView.mas_left).offset(10);
        make.right.mas_equalTo(fotView.mas_centerX).offset(-2);
        make.top.mas_equalTo(fotView.mas_top).offset(23);
        make.height.mas_equalTo(50);
    }];
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = GetColor(201, 201, 201, 1);
    [fotView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(_tjBtn.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
    UIView *view3 = [[UIView alloc]init];
    view3.backgroundColor = [UIColor lightGrayColor];
    [fotView addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tjBtn.mas_right).offset(2);
        make.top.equalTo(fotView.mas_top).offset(30);
        make.bottom.equalTo(view2.mas_top).offset(-10);
        make.width.offset(1);
    }];
    
    _scBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scBtn setTitle:@"删除职位" forState:UIControlStateNormal];
    [_scBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_scBtn addTarget:self action:@selector(scaction_button:) forControlEvents:UIControlEventTouchUpInside];
    [_scBtn setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
    _scBtn.imageEdgeInsets =  UIEdgeInsetsMake(5,30,5,_scBtn.titleLabel.left+30);
    [fotView addSubview:_scBtn];
    [_scBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view3.mas_right).offset(2);
        make.right.mas_equalTo(fotView.mas_right).offset(-2);
        make.top.mas_equalTo(fotView.mas_top).offset(23);
        make.height.mas_equalTo(50);
    }];
    
    
    
    _noEdit= [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _noEdit.dataSource=self;
    _noEdit.delegate =self;
    [fotView addSubview:_noEdit];
    [_noEdit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scBtn.mas_bottom).offset(5);
        make.left.mas_equalTo(fotView.mas_left).offset(0);
        make.right.mas_equalTo(fotView.mas_right).offset(0);
        make.bottom.mas_equalTo(fotView.mas_bottom).offset(0);
    }];
    [_noEdit reloadData];
    
    
     [infonTableview reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if([tableView isEqual:infonTableview]){
        return _ZW.count;
    }else{
     
        return 1;
    }
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:infonTableview]) {
        if ([_gxbmAry[section]count] == 0) {
            return [_codeAry[section]count];
        }else{
            return [_codeAry[section]count]+[_gxbmAry[section]count];
        }
        
    }else{
        if(_noEditAry.count>0){
            if (((NSNumber *)self.statusArray[section]).integerValue == YUFoldingSectionStateShow) {
                return _twocodeAry.count;
            }
            
        }
        
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_noEdit]) {
        return 30;
    }else
    {
        return 30;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([tableView isEqual:infonTableview]) {
        return 0.001;
    }
     return 0.001;//不能为0，否则为默认高度
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:infonTableview]) {
    return 40.0;
   
    }else{
        id obj = _noEditAry[indexPath.row];
        if([obj isKindOfClass:[NSString class]]){
            return 50;
        }else{//不是字符串
            return 50+30*([_noEditAry[indexPath.row]count]-1)-5;
        }
    }
    return 40.0;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void)buttonLiftItem{

    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([infonTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [infonTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([infonTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [infonTableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
#pragma mark - 网络请求
-(void)loadData{
    NSString *uStr =[NSString stringWithFormat:@"%@user/queryUserBasicInfo.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"id":_uresID};
    //[ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            _model = [[EditModel alloc]init];
            _uuidary = [[NSMutableArray alloc]init];
            _bjbtnname = [[NSMutableArray alloc]init];
            _useridAry = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"list2"]) {
                NSMutableArray *array2=[NSMutableArray array];
               
                NSMutableArray *zwlbary = [NSMutableArray array];//职位类别
                NSMutableArray *zwlbnumary = [NSMutableArray array];//职位类别id
                NSMutableArray *zwary = [NSMutableArray array];//职位
                NSMutableArray *zwnumary = [NSMutableArray array];//职位id
                NSMutableArray *bmnumary = [NSMutableArray array];//部门id
                NSMutableArray *bmary = [NSMutableArray array];//部门
                [_model setValuesForKeysWithDictionary:[NSDictionary changeType:dic]];
                
                NSString *string = [[NSString alloc] initWithFormat:@"%@",_model.roleId];
                NSString *isper = [[NSString alloc]initWithFormat:@"%@",_model.isPermission];
                [array2 addObject:@"职位"];
                [_uuidary addObject:_model.uuid];
                [_useridAry addObject:_model.usersid];
                
                NSArray *aryt = [[NSArray alloc]init];
                aryt = @[@"编辑"];
                [_bjbtnname addObject:@"编辑"];
            if ([isper isEqualToString:@"1"]) {//有权限
                if ([string isEqualToString:@"2"]||[string isEqualToString:@"5"]||[string isEqualToString:@"3"]||[string isEqualToString:@"4"]||[string isEqualToString:@"14"]||[string isEqualToString:@"16"]||[string isEqualToString:@"17"]) {
                    [array2 addObject:@"所属部门"];
                }else{
                    [array2 addObject:@"管理部门"];
                }
                if ([_model.LevelName isEqualToString:@""]) {
                    [zwlbary addObject:@"未分配"];//职位类别
                    [zwlbnumary addObject:@"0"];//职位类别id
                    
                    [zwary addObject:_model.NewName];//职位
                    [zwnumary addObject:_model.roleId];//职位id
                    
                    [_ZW addObject:zwary];
                    [_Numm addObject:zwnumary];
                    [_ZWLB addObject:zwlbary];//职位类别
                    [_lbNum addObject:zwlbnumary];//职位类别id
                    
                }else{
                    [zwary addObject:_model.NewName];//职位
                    [zwnumary addObject:_model.roleId];//职位id
                    
                    [_ZW addObject:zwary];
                    [_Numm addObject:zwnumary];
                    
                    [_ZWLB addObject:_model.LevelName];//职位类别
                    [_lbNum addObject:_model.levelID];//职位类别id
                    //82d1a9c1be2341a3984aa6e2e1bd565
                    
                }
                if ([_model.departmentName isEqualToString:@""]) {
                    _model.departmentName=@"未分配";
                    [bmary addObject:_model.departmentName];
                    [_gxbmAry addObject:bmary];//部门
                    [bmnumary addObject:@"0"];
                    [_gxbmidAry addObject:bmnumary];//部门id
                }else if([_model.departmentName containsString:@","]){
                    NSArray* array = [_model.departmentName componentsSeparatedByString:@","];
                    NSArray* numarray = [_model.departmentID componentsSeparatedByString:@","];
                    [_gxbmAry addObject:array];//部门
                    [_gxbmidAry addObject:numarray];//部门id
                }else{
                    [bmary addObject:_model.departmentName];
                    [_gxbmAry addObject:bmary];//部门
                    [bmnumary addObject:_model.departmentID];
                    [_gxbmidAry addObject:bmnumary];//部门id
                }
                  [_codeAry addObject:array2];
                
            }
                
            }
            
        }
        [infonTableview reloadData];
        [_noEdit reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(NSMutableArray *)statusArray
{
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    if (_statusArray.count) {
        if (_statusArray.count > _twocodeAry.count) {
            [_statusArray removeObjectsInRange:NSMakeRange(_twocodeAry.count - 1, _statusArray.count - _twocodeAry.count)];
        }else if (_statusArray.count < _twocodeAry.count) {
            for (NSInteger i = _twocodeAry.count - _statusArray.count; i < _twocodeAry.count; i++) {
                [_statusArray addObject:[NSNumber numberWithInteger:YUFoldingSectionStateFlod]];
            }
        }
    }else{
        for (NSInteger i = 0; i <_twocodeAry .count; i++) {
            [_statusArray addObject:[NSNumber numberWithInteger:YUFoldingSectionStateFlod]];
        }
    }
    return _statusArray;
}
-(void)yuFoldingSectionHeaderTappedAtIndex:(NSInteger)index
{
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[index]).boolValue;
    
    [self.statusArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!currentIsOpen]];
    
    NSInteger numberOfRow = _twocodeAry.count;
    NSMutableArray *rowArray = [NSMutableArray array];
    if (numberOfRow) {
        for (NSInteger i = 0; i < numberOfRow; i++) {
            [rowArray addObject:[NSIndexPath indexPathForRow:i inSection:index]];
        }
    }
    if (rowArray.count) {
        if (currentIsOpen) {
            [_noEdit deleteRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }else{
            [_noEdit insertRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
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
