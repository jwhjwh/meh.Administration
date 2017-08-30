//
//  BJZWViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/8/24.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BJZWViewController.h"
#import "EditModel.h"
#import "depmtCell.h"
#import "YUFoldingSectionHeader.h"
#import "SelectAlert.h"
@interface BJZWViewController ()<UITableViewDataSource,UITableViewDelegate,YUFoldingSectionHeaderDelegate>
{
    UITableView *infonTableview;
}
@property (strong,nonatomic)  UITableViewCell *infoncell;

//控件
@property (strong,nonatomic)UITableView *noEdit;//不可编辑列表
@property (strong,nonatomic)UIButton *ZWbutton;//职位
@property (strong,nonatomic)UIButton *ZWLBbutton;//职位类别
@property (strong,nonatomic)UIView *view1;//线
@property (strong,nonatomic) UILabel *BMLabel;//部门
@property (strong,nonatomic)UIButton *scBtnnnnn;//删除部门按钮
@property (strong,nonatomic)UIButton *tjBtn;//添加职位按钮
@property (strong,nonatomic)UIButton *scBtn;//删除职位按钮
@property (strong,nonatomic)UIButton *bjbtn;//编辑职位按钮
@property (strong,nonatomic)UIButton *SSBMbutt;//选择部门按钮
//数据源
@property (nonatomic, strong) EditModel *model;//个人信息model
@property (strong,nonatomic) NSMutableArray *ZWnameAry;//职位名字
@property (strong,nonatomic) NSMutableArray *ZWidAry;//职位ID
@property (strong,nonatomic) NSMutableArray *ZWLBnameAry;//职位类别名字
@property (strong,nonatomic) NSMutableArray *ZWLBidAry;//职位类别id
@property (strong,nonatomic) NSMutableArray *BMnameAry;//部门名字
@property (strong,nonatomic) NSMutableArray *BMidAry;//部门id
//修改之前的id
@property (nonatomic, strong) NSMutableArray *oldZWID;
@property (nonatomic, strong) NSMutableArray *oldBMID;
@property (nonatomic, strong) NSMutableArray *oldJBID;

@property (nonatomic, strong) NSMutableArray *uuidary;

//控件数组
@property (nonatomic, strong) NSMutableArray *bjbtnname;//编辑按钮名字
@property (nonatomic, strong) NSMutableArray *bjbuttonAry;//编辑按钮
@property (nonatomic, strong) NSMutableArray *bjBtnAry;//编辑按钮id
@property (strong,nonatomic)NSMutableArray *codeAry;//左侧标签名字

@property (strong,nonatomic)NSMutableArray *ZWbtnAry;//职位按钮数组
@property (strong,nonatomic)NSMutableArray *viweAry;//隔断数组
@property (strong,nonatomic)NSMutableArray *ZWLBary;// 职位类别数组数组
@property (strong,nonatomic)NSMutableArray *BMbtnAry;//部门按钮数组
@property (strong,nonatomic)NSMutableArray *SCbtnAry;//删除部门按钮数组

//-------
@property (nonatomic, strong) NSMutableArray *statusArray;
@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;

@end

@implementation BJZWViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"编辑职位";
    
    
    
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
    [self addalloc];
    [self tableViewUI];
    [self loadData];
}
-(void)addalloc{
    _ZWnameAry = [[NSMutableArray alloc]init];//职位名字
    _ZWidAry = [[NSMutableArray alloc]init];//职位ID
    _ZWLBnameAry = [[NSMutableArray alloc]init];//职位类别名字
    _ZWLBidAry = [[NSMutableArray alloc]init];//职位类别id
    _BMnameAry = [[NSMutableArray alloc]init];//部门名字
    _BMidAry = [[NSMutableArray alloc]init];//部门id
    
    //未修改之前的id
    _oldZWID = [[NSMutableArray alloc]init];
    _oldJBID = [[NSMutableArray alloc]init];
    _oldBMID = [[NSMutableArray alloc]init];
    //按钮数组
    _bjbtnname = [[NSMutableArray alloc]init];//编辑按钮名字
    _codeAry = [[NSMutableArray alloc]init];//左侧标签名字
    _bjbuttonAry = [[NSMutableArray alloc]init];//编辑按钮
    _bjBtnAry = [[NSMutableArray alloc]init];//编辑按钮id
    
    _ZWbtnAry = [[NSMutableArray alloc]init];//职位按钮数组
    _viweAry  = [[NSMutableArray alloc]init];//隔断数组
    _ZWLBary  = [[NSMutableArray alloc]init];// 职位类别数组数组
    _BMbtnAry = [[NSMutableArray alloc]init];//部门按钮数组
    _SCbtnAry = [[NSMutableArray alloc]init];//删除部门按钮数组
    
}
#pragma mark 点击职位
-(void)JsButtonbtn:(UIButton *)btn{
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
           NSMutableArray* titles = [[NSMutableArray alloc]init];
          NSMutableArray*  numBS = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arr) {
                NSString *strr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"num"]];
                if ([strr isEqualToString:@"1"]) {
                }else{
                    [numBS  addObject:[dic valueForKey:@"num"]];
                    [titles addObject:[dic valueForKey:@"newName"]];
                }
            }
            [self showAlert:titles numary:numBS button:btn];
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
-(void)showAlert :(NSArray *)arrr numary:(NSArray *)numary button:(UIButton*)bbtn{
    NSMutableArray *isbol = [[NSMutableArray alloc]init];
    [SelectAlert showWithTitle:@"选择职位" titles:arrr selectIndex:^(NSInteger selectIndex) {
        NSString *tagg = numary[selectIndex];
        for (int i = 0; i<_ZWidAry.count; i++) {
            NSArray *num = _ZWidAry[i];
            BOOL isbool = [num containsObject: tagg];
            if (isbool == 1) {
                [isbol addObject:@"1"];
            }
        }
        BOOL yesor = [isbol containsObject:@"1"];
        if (yesor == 1) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"不能重复选择职位哦" andInterval:1.0];
        }else{
            
            int taa = [tagg intValue];
             if ( taa == 2|| taa == 5||taa ==3||taa ==4||taa ==14||taa ==16||taa ==17 ) {
                 UITableViewCell *cellu = (UITableViewCell *)[bbtn superview];
                 NSIndexPath *insd = [infonTableview indexPathForCell:cellu];
                 _ZWLBbutton = _ZWLBary[insd.section];
                 _view1 = _viweAry[insd.section];
                 [_ZWLBbutton setTitleColor:GetColor(199, 199, 205, 1) forState:UIControlStateNormal];
                 _view1.backgroundColor = [UIColor lightGrayColor];
                 [_ZWLBbutton setTitle:@"未分配" forState:UIControlStateNormal];
                 _ZWLBbutton.enabled = YES;
                 NSMutableArray *cooode = _codeAry[insd.section];
                 if (cooode.count>1) {
                     cooode[1] = @"所属部门";
                     [_codeAry replaceObjectAtIndex:insd.section withObject:cooode];
                     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:insd.section];
                     [infonTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                 }else{
                     [cooode addObject:@"所属部门"];
                     [_codeAry replaceObjectAtIndex:insd.section withObject:cooode];
                     [self addtableViewCellZWUI:1 secct:insd.section];
                 }
             }
             else{
                 UITableViewCell *cellu = (UITableViewCell *)[bbtn superview];
                 NSIndexPath *insd = [infonTableview indexPathForCell:cellu];
                 _ZWLBbutton = _ZWLBary[insd.section];
                 _view1 = _viweAry[insd.section];
                 [_ZWLBbutton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
                 _view1.backgroundColor = [UIColor whiteColor];
                 [_ZWLBbutton setTitle:@"未分配" forState:UIControlStateNormal];
                 _ZWLBbutton.enabled = NO;
                 NSMutableArray *cooode = _codeAry[insd.section];
                 if (cooode.count>1) {
                     cooode[1] = @"管辖部门";
                     [_codeAry replaceObjectAtIndex:insd.section withObject:cooode];
                     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:insd.section];
                     [infonTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                 }else{
                     [cooode addObject:@"管辖部门"];
                     [_codeAry replaceObjectAtIndex:insd.section withObject:cooode];
                     [self addtableViewCellZWUI:1 secct:insd.section];
                 }
            }
            UITableViewCell *cellu = (UITableViewCell *)[bbtn superview];
            NSIndexPath *insd = [infonTableview indexPathForCell:cellu];
            NSMutableArray *numary = [[NSMutableArray alloc]init];
            [numary addObject:tagg];
            [_ZWidAry replaceObjectAtIndex:insd.section withObject:numary];
            NSMutableArray *scbmary = [[NSMutableArray alloc]initWithArray:_BMnameAry[insd.section]];
            NSMutableArray *scbmidary = [[NSMutableArray alloc]initWithArray:_BMidAry[insd.section]];
            for (int t = 0; t<scbmary.count;) {
                [scbmary removeObjectAtIndex:t];
                [scbmidary removeObjectAtIndex:t];
                [_BMnameAry replaceObjectAtIndex:insd.section withObject:scbmary];
                [_BMidAry replaceObjectAtIndex:insd.section withObject:scbmidary];
                [self dimissTabelCellZWUI:t+2 secct:insd.section];
                
            }
        }

    } selectValue:^(NSString *selectValue) {
         BOOL yesor = [isbol containsObject:@"1"];
        if (yesor == 0) {
            NSArray *zwary = [[NSArray alloc]initWithObjects:selectValue, nil];
            for (int i = 0; i<_ZWnameAry.count; i++) {
                NSArray *zw = _ZWnameAry[i];
                for (int y = 0; y<zw.count; y++) {
                    NSString *zww = zw[y];
                    if (zww == bbtn.titleLabel.text) {
                        [_ZWnameAry replaceObjectAtIndex:i withObject:zwary];
                        [bbtn setTitle:selectValue forState:UIControlStateNormal];
                        
                    }
                }
            }
        }

    } showCloseButton:NO];
}
#pragma mark 点击职位类别
-(void)JsLBButtonbtn:(UIButton *)btn{
    NSString *jsid = [[NSString alloc]init];
    NSString *lbnum = [[NSString alloc]init];
    UITableViewCell *cellu = (UITableViewCell *)[btn superview];
    NSIndexPath *insd = [infonTableview indexPathForCell:cellu];
    NSArray *jsiid = _ZWidAry[insd.section];
    
    jsid = [NSString stringWithFormat:@"%@",jsiid[0]];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@manager/queryPositionLevel.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"RoleId":jsid,@"Num":lbnum};
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
         if ([[responseObject valueForKey:@"status"] isEqualToString:@"0000"]) {
             NSArray *arrt= [responseObject valueForKey:@"list"];
             NSMutableArray *zwlbidd = [[NSMutableArray alloc]init];
             NSMutableArray *zwlbname = [[NSMutableArray alloc]init];
             for (NSDictionary *dic in arrt) {
                 [zwlbidd  addObject:[dic valueForKey:@"id"]];
                 [zwlbname addObject:[dic valueForKey:@"levelName"]];
             }

             [SelectAlert showWithTitle:@"选择职位类别" titles:zwlbname selectIndex:^(NSInteger selectIndex) {
                 UITableViewCell *cellu = (UITableViewCell *)[btn superview];
                 NSIndexPath *insd = [infonTableview indexPathForCell:cellu];
                 NSMutableArray *zwlbid = [[NSMutableArray alloc]init];
                 [zwlbid addObject:zwlbidd[selectIndex]];
                 [_ZWLBidAry replaceObjectAtIndex:insd.section withObject:zwlbid];
                 
             } selectValue:^(NSString *selectValue) {
                 [btn setTitle:selectValue forState:UIControlStateNormal];
                 [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                 UITableViewCell *cellu = (UITableViewCell *)[btn superview];
                 NSIndexPath *insd = [infonTableview indexPathForCell:cellu];
                 NSMutableArray *zwlbname = [[NSMutableArray alloc]init];
                 [_ZWLBnameAry replaceObjectAtIndex:insd.section withObject:zwlbname];
                 
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
#pragma mark 点击部门
-(void)SSButtonbtn :(UIButton *)btn{
    UITableViewCell *cellu = (UITableViewCell *)[btn superview];
    NSIndexPath *insd = [infonTableview indexPathForCell:cellu];
    NSString *jsid = [NSString stringWithFormat:@"%d",[_ZWidAry[insd.section][0] intValue]];
    NSString *urlStr = [NSString stringWithFormat:@"%@manager/queryDepartment.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"RoleId":jsid};
    NSMutableArray* gxbmNum = [[NSMutableArray alloc]init];
    NSMutableArray* gxbmAry = [[NSMutableArray alloc]init];
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]){
            NSArray *arrt= [responseObject valueForKey:@"list"];
              if (arrt.count == 0) {
                  [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您的公司没有创建部门 " andInterval:1.0];
              }else{
                  for (NSDictionary *dic in arrt) {
                      [gxbmNum  addObject:[dic valueForKey:@"id"]];
                      [gxbmAry addObject:[dic valueForKey:@"departmentName"]];
                  }
#pragma mark ----------------选择部门
                [SelectAlert showWithTitle:@"选择部门" titles:gxbmAry selectIndex:^(NSInteger selectIndex) {
                    UITableViewCell *cellu = (UITableViewCell *)[btn superview];
                    NSIndexPath *insd = [infonTableview indexPathForCell:cellu];
                    NSString *tagg = gxbmNum[selectIndex];
                    NSArray *bmid = _BMidAry[insd.section];
                    BOOL yesor = [bmid containsObject: tagg];
                    if (yesor == 1) {
                        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"不能重复选择部门哦" andInterval:1.0];
                    }else{
                        if ([btn.titleLabel.text isEqualToString: @"添加所属部门"]) {
                            _BMidAry[insd.section][0] = tagg;
                        }else{
                            [_BMidAry[insd.section] addObject:tagg];
                        }
                    }
                } selectValue:^(NSString *selectValue) {
                    UITableViewCell *cellu = (UITableViewCell *)[btn superview];
                    NSIndexPath *insd = [infonTableview indexPathForCell:cellu];
                    NSString *bmtext = selectValue;
                    NSArray *bmtextary = _BMnameAry[insd.section];
                    BOOL yesor = [bmtextary containsObject:bmtext];
                    if (yesor == 0) {
                        if ([btn.titleLabel.text isEqualToString: @"添加所属部门"]) {
                            NSMutableArray *ssbm = [[NSMutableArray alloc]init];
                            [ssbm addObject:selectValue];
                            if ([_BMnameAry[insd.section]count] == 0) {
                                [_BMnameAry replaceObjectAtIndex:insd.section withObject:ssbm];
                                [self addtableViewCellZWUI:insd.row+[_BMnameAry[insd.section]count] secct:insd.section];
                            }else{
                                [_BMnameAry replaceObjectAtIndex:insd.section withObject:ssbm];
                                NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:insd.row+1 inSection:insd.section]; //刷新第0段第2行
                                [infonTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
                            }
                            
                        }else{
                        //添加管辖部门
                            [_BMnameAry[insd.section] addObject:selectValue];
                            [self addtableViewCellZWUI:insd.row+[_BMnameAry[insd.section]count] secct:insd.section];
                        }
                    }
                } showCloseButton:NO];
                
              }
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有职位" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请重新登录" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
        }

    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];

}
#pragma mark 点击删除部门
-(void)scbmbtn:(UIButton *)btn{
    UITableViewCell *cellu = (UITableViewCell *)[btn superview];
    NSIndexPath *insd = [infonTableview indexPathForCell:cellu];
    NSLog(@"%ld,%ld",(long)insd.section,(long)insd.row);
    NSMutableArray *dimissbm = _BMnameAry[insd.section];
    [dimissbm removeObjectAtIndex:insd.row-2];
    NSMutableArray *dimissid = _BMidAry[insd.section];
    [dimissid removeObjectAtIndex:insd.row-2];
    
    [_BMnameAry replaceObjectAtIndex:insd.section withObject:dimissbm];
    [self dimissTabelCellZWUI:insd.row secct:insd.section];

}

#pragma mark 点击添加职位
-(void)tjaction_button :(UIButton *)btn{
    [_ZWnameAry addObject:[[NSMutableArray alloc]initWithObjects:@"选择职位", nil]];
    [_ZWLBnameAry addObject:[[NSMutableArray alloc]initWithObjects:@"未分配", nil]];
    [_ZWLBidAry addObject:[[NSMutableArray alloc]initWithObjects:@"0", nil]];
    [_ZWidAry addObject:[[NSMutableArray alloc]initWithObjects:@"0", nil]];
    [_BMnameAry addObject:[NSMutableArray array]];
    [_BMidAry addObject:[NSMutableArray  array]];
    [_bjbtnname addObject:@"上传"];
    [_codeAry addObject:[[NSMutableArray  alloc]initWithObjects:@"职位", nil]];
    // [infonTableview reloadData];
    [_ZWbtnAry addObject:[[UIButton alloc]init]];
    [_viweAry addObject:[[UIView alloc]init]];
    [_ZWLBary addObject:[[UIButton alloc]init]];
    [_BMbtnAry addObject:[[UIButton alloc]init]];
    
    NSIndexSet *indexSet1 = [[NSIndexSet alloc] initWithIndex: _ZWnameAry.count-1];
    [infonTableview beginUpdates];
    [infonTableview insertSections:indexSet1 withRowAnimation:UITableViewRowAnimationLeft];
    [infonTableview endUpdates];
    
    [_tjBtn setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
    [_tjBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _tjBtn.enabled = NO;
    
    [_scBtn setImage:[UIImage imageNamed:@"sc_ico02"] forState:UIControlStateNormal];
    [_scBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _scBtn.enabled = NO;
    
    _ZWbutton = _ZWbtnAry[_ZWnameAry.count-1];
    _ZWbutton.enabled = YES;
    for (int i = 0; i<_bjbuttonAry.count-1; i++) {
        _bjbtn = _bjbuttonAry[i];
        _bjbtn.enabled = NO;
        [_bjbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}
#pragma mark 点击删除职位
-(void)scaction_button :(UIButton *)btn{
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
#pragma mark 编辑-完成-上传
-(void)button1BackGroundNormal:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"编辑"]) {
        for (int i = 0; i<_bjbuttonAry.count-1; i++) {
            _bjbtn = _bjbuttonAry[i];
            _bjbtn.enabled = NO;
            [_bjbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        NSString *bjbtn = @"完成";
        [_bjbtnname replaceObjectAtIndex:btn.tag withObject:bjbtn];
        
        btn.enabled = YES;
        [btn setTitleColor:GetColor(0, 129, 238, 1) forState:UIControlStateNormal];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        //btn.tag = section;
        _ZWbutton = _ZWbtnAry[btn.tag];
        _ZWbutton.enabled = YES;
        NSMutableArray *tagary = _ZWidAry[btn.tag];
        
        int ivalue = [tagary[0] intValue];
        _ZWLBbutton = _ZWLBary[btn.tag];
        if (ivalue == 5|| ivalue == 2 || ivalue == 3 || ivalue == 4 || ivalue == 14 || ivalue == 16 || ivalue == 17) {
            _ZWLBbutton.enabled = YES;
        }
        _SSBMbutt = _BMbtnAry[btn.tag];
        _SSBMbutt.enabled = YES;
        NSArray *scbtnary = _SCbtnAry[btn.tag];
        if (scbtnary.count>0){
            for (int a = 0; a<scbtnary.count; a++) {
                _scBtnnnnn = scbtnary[a];
                _scBtnnnnn.enabled = YES;
                [_scBtnnnnn setImage:[UIImage imageNamed:@"xx_ico01"] forState:UIControlStateNormal];
                [_scBtnnnnn setImage:[UIImage imageNamed:@"xx_ico02"] forState:UIControlStateSelected];
            }
            
        }
        [_tjBtn setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
        [_tjBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _tjBtn.enabled = NO;
        
        [_scBtn setImage:[UIImage imageNamed:@"sc_ico02"] forState:UIControlStateNormal];
        [_scBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _scBtn.enabled = NO;
    }else if ([btn.titleLabel.text isEqualToString:@"完成"]){
        //btn.tag = section;
        
        NSLog(@"oRoleId:%@\n oDepartmentID:%@\n oLeveID:%@\n nRoleId:%@\n nDepartmentId:%@ \n nLeveID:%@",_oldZWID[btn.tag],_oldBMID[btn.tag],_oldJBID[btn.tag],_ZWidAry[btn.tag],_BMidAry[btn.tag],_ZWLBidAry[btn.tag]);
    }else if ([btn.titleLabel.text isEqualToString:@"上传"]){
#pragma mark 上传用户职位 ---------------------------------------
        
        
    }else if ([btn.titleLabel.text isEqualToString:@"删除"]){
        //删除职位
        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要删除此项内容" sureBtn:@"确认" cancleBtn:@"取消"];
        alertView.resultIndex = ^(NSInteger index){
            if (index == 2) {
                NSString *stt = [NSString stringWithFormat:@"%ld",(long)btn.tag];
                for (int u = 0; u<_bjBtnAry.count; u++) {
                    if ([stt isEqualToString: _bjBtnAry[u]]) {
                        //删除职位  RoleId  DepartmentID
                        
                        [self dimissZW:_ZWidAry[u] departid:_BMidAry[u] uuid:_uuidary[u] rowsect:u];
                    }
                }
                
            }
            
        };
        [alertView showMKPAlertView];

    }
    

}
#pragma mark 修改用户职位 ---------------------------------------
-(void)updateuserposition:(UIButton*)bbtn uuid: (NSString *)uuid usersid:(NSString *)usersid update:(NSString*)update{
    NSString *updateurlStr = [NSString stringWithFormat:@"%@user/updateUserPosition.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"id":usersid,@"uuid":uuid,@"update":update};
    [ZXDNetworking GET:updateurlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改完成" andInterval:1.0];
        }else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改失败" andInterval:1.0];
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



#pragma mark 添加用户职位 ---------------------------------------
-(void)complete:(UIButton *)bbttn zwidary:(NSArray *)zwidary zwlbid:(NSArray *)zwlbidary deparid:(NSArray *)Deparid userid:(NSString *)userid uuid:(NSString *)uuid{
    NSString *addurlStr = [NSString stringWithFormat:@"%@user/addUserPosition.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *string1 = [NSString stringWithFormat:@"(%@)",[Deparid componentsJoinedByString:@","]];
    
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"id":userid,@"uuid":uuid,@"RoleId":zwidary[0],@"DepartmentID":string1,@"LevelID":zwlbidary[0]};
    [ZXDNetworking GET:addurlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"添加完成" andInterval:1.0];
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
            [_ZWidAry removeObjectAtIndex:rowsectt];
            [_BMidAry removeObjectAtIndex:rowsectt];
            [_ZWnameAry removeObjectAtIndex:rowsectt];
            [_viweAry removeObjectAtIndex:rowsectt];
            [_ZWLBary removeObjectAtIndex:rowsectt];
            [_ZWLBidAry removeObjectAtIndex:rowsectt];
            
            
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
                
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
#pragma mark TableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:infonTableview]) {
        _infoncell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"bcCell"];
        _infoncell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            //职位
            _infoncell.textLabel.text = _codeAry[indexPath.section][indexPath.row];
            for(_ZWbutton in _infoncell.subviews){
                if([_ZWbutton isMemberOfClass:[UIButton class]])
                {
                    [_ZWbutton removeFromSuperview];
                }
            }
            _ZWbutton = [[UIButton alloc]init];
            _ZWbutton = _ZWbtnAry[indexPath.section];
            _ZWbutton.frame = CGRectMake(120, 1, (self.view.bounds.size.width-120)/2, 38);
            [_ZWbutton setTitle:_ZWnameAry[indexPath.section][indexPath.row] forState:UIControlStateNormal];
            _ZWbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _ZWbutton.font = [UIFont boldSystemFontOfSize:kWidth*25];
            [_ZWbutton addTarget:self action:@selector(JsButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
            [_ZWbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            NSString *bjname =_bjbtnname[indexPath.section];
            if ([bjname isEqualToString:@"完成"]||[bjname isEqualToString:@"上传"]) {
                _ZWbutton.enabled = YES;
            }else{
                _ZWbutton.enabled = NO;
            }
            [_infoncell addSubview:_ZWbutton];
            
            _view1 = [[UIView alloc]init];
            _view1 = _viweAry[indexPath.section];
            _view1.frame = CGRectMake(120+(self.view.bounds.size.width-120)/2, 6, 1, 30);
            _ZWLBbutton = [[UIButton alloc]init];
            _ZWLBbutton = _ZWLBary[indexPath.section];
            _ZWLBbutton.frame =CGRectMake(121+(self.view.bounds.size.width-120)/2, 1, self.view.bounds.size.width-(self.view.bounds.size.width/2+31), 38);
            _ZWLBbutton.font = [UIFont boldSystemFontOfSize:kWidth*30];
            
            [_ZWLBbutton addTarget:self action:@selector(JsLBButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
            int tag = 0;
            NSString*zwtag = _ZWidAry[indexPath.section][indexPath.row];
            tag = [zwtag intValue];
            if (tag == 2|| tag == 5||tag ==3||tag ==4||tag ==14||tag ==16||tag ==17) {
                [_ZWLBbutton setTitleColor:GetColor(199, 199, 205, 1) forState:UIControlStateNormal];
                _view1.backgroundColor = [UIColor lightGrayColor];
                [_ZWLBbutton setTitle:_ZWLBnameAry[indexPath.section][indexPath.row] forState:UIControlStateNormal];
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
            [_infoncell addSubview:_view1];
            [_infoncell addSubview:_ZWLBbutton];
        }else if(indexPath.row == 1){
            //部门--（所属。管辖）
             _infoncell.textLabel.text = _codeAry[indexPath.section][indexPath.row];
             _infoncell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
            
            _SSBMbutt = [[UIButton alloc]init];
            _SSBMbutt = _BMbtnAry[indexPath.section];
            _SSBMbutt.frame = CGRectMake(120, 1, self.view.bounds.size.width-100, 38);
            [_SSBMbutt setTitle:[NSString stringWithFormat:@"添加%@",_infoncell.textLabel.text] forState:UIControlStateNormal];
            _SSBMbutt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _SSBMbutt.font = [UIFont boldSystemFontOfSize:kWidth*30];
            [_SSBMbutt addTarget:self action:@selector(SSButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
            [_SSBMbutt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            //NSInteger section  = indexPath.section;
            _SSBMbutt.tag= indexPath.section;

            NSString *bjname =_bjbtnname[indexPath.section];
            if ([bjname isEqualToString:@"完成"]||[bjname isEqualToString:@"上传"]) {
                _SSBMbutt.enabled = YES;

           
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
        [cell.contentView addSubview:XBTLabel];
        
        _scBtnnnnn= [[UIButton alloc]initWithFrame:CGRectMake(120+self.view.bounds.size.width-160, 1, 40, 38)];
        [cell.contentView addSubview:_scBtnnnnn];
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
                
>>>>>>> 906526bfca98375805ea4f33a10bb82208a39a1c
            }else{
                _SSBMbutt.enabled = NO;
            }
            
            [_infoncell addSubview:_SSBMbutt];

            
        }else{
            //具体部门
            UILabel *XBTLabel  = [[UILabel alloc]initWithFrame:CGRectMake(120, 1, self.view.bounds.size.width-160, 38)];
            XBTLabel.text = _BMnameAry[indexPath.section][indexPath.row-2];
            XBTLabel.font = [UIFont boldSystemFontOfSize:kWidth*30];
            [_infoncell addSubview:XBTLabel];
            
            _scBtnnnnn= [[UIButton alloc]initWithFrame:CGRectMake(120+self.view.bounds.size.width-160, 1, 40, 38)];
            [_infoncell addSubview:_scBtnnnnn];
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
            int tag ;
            NSString*zwtag = _ZWidAry[indexPath.section][0];
            tag = [zwtag intValue];
            if (tag == 2|| tag == 5||tag ==3||tag ==4||tag ==14||tag ==16||tag ==17) {
            //所属部门
                
                  NSMutableArray*  _scBtnAry2 = [[NSMutableArray alloc]init];
                    [_scBtnAry2 addObject:_scBtnnnnn];
                    [_SCbtnAry replaceObjectAtIndex:indexPath.section withObject:_scBtnAry2];
                

            }else{
                //管辖部门
                NSMutableArray *scbtn = [[NSMutableArray alloc]init];
                scbtn = _SCbtnAry[indexPath.section];
                [scbtn addObject:_scBtnnnnn];
                [_SCbtnAry replaceObjectAtIndex:indexPath.section withObject:scbtn];
            }
        }
        
        
        return _infoncell;
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
#pragma mark - 网络请求
-(void)loadData{
    NSString *uStr =[NSString stringWithFormat:@"%@user/queryUserBasicInfo.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"id":_uresID};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            _model = [[EditModel alloc]init];
            _uuidary = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"list2"]) {
            NSMutableArray *array2=[NSMutableArray array];
                NSMutableArray *zwlbary = [NSMutableArray array];//职位类别
                NSMutableArray *zwlbnumary = [NSMutableArray array];//职位类别id
                NSMutableArray *zwary = [NSMutableArray array];//职位
                NSMutableArray *zwnumary = [NSMutableArray array];//职位id
                NSMutableArray *bmnumary = [NSMutableArray array];//部门id
                NSMutableArray *bmary = [NSMutableArray array];//部门
                
            [array2 addObject:@"职位"];
            [_bjbtnname addObject:@"编辑"];
                UIButton *zwbtn = [[UIButton alloc]init];
               [_ZWbtnAry addObject:zwbtn];
                UIView *view1 = [[UIButton alloc]init];
                [_viweAry addObject:view1];
                UIButton *zwlb = [[UIButton alloc]init];
                [_ZWLBary addObject:zwlb];
                UIButton *bmbtn = [[UIButton alloc]init];
                [_BMbtnAry addObject:bmbtn];
                [_uuidary addObject:_model.uuid];
            [_model setValuesForKeysWithDictionary:[NSDictionary changeType:dic]];
            NSString *isper = [[NSString alloc]initWithFormat:@"%@",_model.isPermission];
            NSString *string = [[NSString alloc] initWithFormat:@"%@",_model.roleId];
                if ([isper isEqualToString:@"1"]) {//有权限
                    if ([string isEqualToString:@"2"]||[string isEqualToString:@"5"]||[string isEqualToString:@"3"]||[string isEqualToString:@"4"]||[string isEqualToString:@"14"]||[string isEqualToString:@"16"]||[string isEqualToString:@"17"]) {
                        [array2 addObject:@"所属部门"];
                    }else{
                        [array2 addObject:@"管理部门"];
                    }
                    if ([_model.LevelName isEqualToString:@""]) {//职位类别
                        [zwlbary addObject:@"未分配"];//职位类别
                        [zwlbnumary addObject:@"0"];//职位类别id
                        [zwary addObject:_model.NewName];//职位
                        [zwnumary addObject:_model.roleId];//职位id
                        [_ZWnameAry addObject:zwary];
                        [_ZWidAry addObject:zwnumary];
                        [_ZWLBnameAry addObject:zwlbary];
                        [_ZWLBidAry addObject:zwlbnumary];
                        [_oldJBID addObject:zwlbnumary];//职位类别id---
                        [_oldZWID addObject:_model.roleId];//职位id---
                    }else{
                        [zwary addObject:_model.NewName];//职位
                        [zwnumary addObject:_model.roleId];//职位id
                        
                        [_ZWnameAry addObject:zwary];
                        [_ZWidAry addObject:zwnumary];
                        
                        [_ZWLBnameAry addObject:zwlbary];
                        [_ZWLBidAry addObject:zwlbnumary];
    
                        [_oldJBID addObject:_model.levelID];//职位类别id---
                        [_oldZWID addObject:_model.roleId];//职位id---
                    }
                    if ([_model.departmentName isEqualToString:@""]) {//部门
                        _model.departmentName=@"未分配";
                        [bmary addObject:_model.departmentName];
                        [_BMnameAry addObject:bmary];//部门
                        [bmnumary addObject:@"0"];
                        [_BMidAry addObject:bmnumary];//部门id
                        
                        [_SCbtnAry addObject:[[NSMutableArray alloc]init]];
                        
                        [_oldBMID addObject:bmnumary];//部门id-----
                    }else if([_model.departmentName containsString:@","]){
                        NSArray* array = [_model.departmentName componentsSeparatedByString:@","];
                        NSArray* numarray = [_model.departmentID componentsSeparatedByString:@","];
                        [_BMnameAry addObject:array];//部门
                        [_BMidAry addObject:numarray];//部门id
                        
                        [_SCbtnAry addObject:[[NSMutableArray alloc]init]];
                        
                        [_oldBMID addObject:bmnumary];//部门id-----
                    }else{
                        [bmary addObject:_model.departmentName];
                        [_BMnameAry addObject:bmary];//部门
                        [bmnumary addObject:_model.departmentID];
                        [_BMidAry addObject:bmnumary];//部门id
                        
                        [_SCbtnAry addObject:[[NSMutableArray alloc]init]];
                        
                        [_oldBMID addObject:bmnumary];//部门id-----
                    }
                     [_codeAry addObject:array2];
                }else{//没权限修改职位
            
                }
            }
            [infonTableview reloadData];
            [_noEdit reloadData];
            NSLog(@"标签:%@\n 职位:%@\n 部门:%@\n职位类别id:%@",_codeAry,_ZWnameAry,_BMnameAry,_ZWLBidAry);
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有职位" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请重新登录" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:infonTableview]) {
        UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Scree_width, 30)];
        headV.backgroundColor = GetColor(238, 238, 238, 1);
        _bjbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bjbtn.frame =CGRectMake(Scree_width-60,0,50,30);//0 129 238
        
        [_bjbtn setTitle:_bjbtnname[section] forState:UIControlStateNormal];
        
        
        [_bjbtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
        NSString *bjname = @"完成";
        NSString *scbjname = @"上传";
        BOOL ifsc = [_bjbtnname containsObject:scbjname];
        BOOL yesor = [_bjbtnname containsObject: bjname];
        if (yesor == 1) {
            if ([_bjbtn.titleLabel.text isEqualToString:@"完成"]) {
                [_bjbtn setTitleColor:GetColor(0, 129, 238, 1) forState:UIControlStateNormal];
                _bjbtn.enabled = YES;
            }else{
                [_bjbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                _bjbtn.enabled = NO;
            }
        }else{
            if (ifsc ==1) {
                if([_bjbtn.titleLabel.text isEqualToString:@"上传"]){
                    [_bjbtn setTitleColor:GetColor(0, 129, 238, 1) forState:UIControlStateNormal];
                    _bjbtn.enabled = YES;
                }else{
                    [_bjbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    _bjbtn.enabled = NO;
                }
               
            }else{
              [_bjbtn setTitleColor:GetColor(0, 129, 238, 1) forState:UIControlStateNormal];
            }
           
        }
        
        
        
        
        
        _bjbtn.font = [UIFont boldSystemFontOfSize:kWidth*30];
        _bjbtn.tag = section;
        [headV addSubview:_bjbtn];
         NSString *sttt = [NSString stringWithFormat:@"%ld",(long)_bjbtn.tag];
        if (_bjBtnAry.count == _ZWnameAry.count) {
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
        return nil;
    }
    
}
-(YUFoldingSectionHeaderArrowPosition )perferedArrowPosition
{
    // 没有赋值，默认箭头在左
    NSUInteger intger=1;
    self.arrowPosition=intger;
    return self.arrowPosition ? :YUFoldingSectionHeaderArrowPositionLeft;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if([tableView isEqual:infonTableview]){
        return _ZWnameAry.count;
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:infonTableview]) {
        if ([_BMnameAry[section]count] == 0) {
            return [_codeAry[section]count];
        }else{
            return [_codeAry[section]count]+[_BMnameAry[section]count];
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
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([infonTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [infonTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([infonTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [infonTableview setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark -  不可编辑列表
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
@end
