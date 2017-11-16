//
//  InterestedTabelViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/9/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "InterestedTabelViewController.h"
#import "InterestedModel.h"
#import "SelectAlert.h"
#import "InteredAlertView.h"//意向选择器
#import "inftionTableViewCell.h"
#import "FillTableViewCell.h"
#import "SiginViewController.h"//签到
#import "XFDaterView.h"//时间选择器
#import "CityChoose.h"// 地址选择器
#import "InterestedInputViewController.h"//主要经营品牌-简介-分析
#import "UpdateIntendedViewController.h"//意向客户提交到部门
#import "ShareColleagues.h"//分享同事
#import "TargetTableViewController.h"
#import "StoreinforViewController.h"
#import "businessViewController.h"
@interface InterestedTabelViewController ()<UITableViewDelegate,UITableViewDataSource,XFDaterViewDelegate>
{
    UITableView *infonTableview;
    BOOL isof;
    XFDaterView*dater;//时间选择器
}
@property (nonatomic,retain)NSArray *arr;
@property (strong,nonatomic) NSMutableArray *InterNameAry;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,retain)NSIndexPath *Index;
@property (nonatomic, strong) CityChoose *cityChoose;/** 城市选择 */
@property (nonatomic,strong) NSMutableArray *intentary;
//---------
@property (nonatomic,strong)NSString *Id; //意向客户id
@property (nonatomic,strong)NSString *Dates;//日期
@property (nonatomic,strong)NSString *Iphone;//手机
@property (nonatomic,strong)NSString *Wcode;//微信
@property (nonatomic,strong)NSString *BrandBusiness;//经营品牌
@property (nonatomic,strong)NSString *StoreLevel;//门店档次
@property (nonatomic,strong)NSString *IntentionId;//意向选择

@property (nonatomic,strong)NSString *StoreSituation;//店名情况简介

@property (nonatomic,strong)NSString *Comprehensive;//店家情况综合分析
@property (nonatomic,strong)NSString *DepartmentId;//提交的部门
@property (nonatomic,strong)NSString *UsersId;//创建人(后台赋值)
@property (nonatomic,strong)NSString *UserId;//共享人(后台赋值)
@property (nonatomic,strong)NSString *ShopId;//店铺id
@property (nonatomic,strong)NSString *Province;//省
@property (nonatomic,strong)NSString *City;//市
@property (nonatomic,strong)NSString *County;//县
@property (nonatomic,strong)NSString *StoreName;//店名
@property (nonatomic,strong)NSString *Address;//门店地址
@property (nonatomic,strong)NSString *ShopName;//店铺负责人姓名
@property (nonatomic,strong)NSString *UsersName;//业务人员名称

@property (nonatomic,strong)NSString *visiId;
//---------
@end

@implementation InterestedTabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意向客户表";
    isof = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    if ([_isofyou isEqualToString:@"1"]) {
        
    }else{
        UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"···" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightitem;
    }
    
    _InterNameAry = [[NSMutableArray alloc]init];
    _arr=@[@"日期",@"洽谈人",@"地区",@"店名",@"店铺地址",@"负责人",@"手机",@"微信",@"主要经营品牌",@"店面评估档次分类",@"意向选择",@"店面情况简介",@"店家情况综合分析"];
    infonTableview= [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    [infonTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];

    [ZXDNetworking setExtraCellLineHidden:infonTableview];
    [self selectworsh];
}
-(void)nsstingalloc{
    
    _intentary = [[NSMutableArray alloc]init];
    
    _Id = [[NSString alloc]init]; //意向客户id
    _Dates= [[NSString alloc]init];//日期
    _Iphone= [[NSString alloc]init];//手机
    _Wcode= [[NSString alloc]init];//微信
    _BrandBusiness= [[NSString alloc]init];//经营品牌
    _StoreLevel= [[NSString alloc]init];//门店档次
    _IntentionId= [[NSString alloc]init];//意向选择
    _StoreSituation= [[NSString alloc]init];//店名情况简介
    _Comprehensive= [[NSString alloc]init];//店家情况综合分析
    _DepartmentId= [[NSString alloc]init];//提交的部门
    _UsersId= [[NSString alloc]init];//创建人(后台赋值)
    _UserId= [[NSString alloc]init];//共享人(后台赋值)
    _ShopId= [[NSString alloc]init];//店铺id
    _Province= [[NSString alloc]init];//省
    _City= [[NSString alloc]init];//市
    _County= [[NSString alloc]init];//县
    _StoreName= [[NSString alloc]init];//店名
    _Address= [[NSString alloc]init];//门店地址
    _ShopName= [[NSString alloc]init];//店铺负责人姓名
    _UsersName= [[NSString alloc]init];//业务人员名称
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if(indexPath.row<8){
         inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
         if (cell ==nil)
         {
             cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
             
         }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.userInteractionEnabled = isof;
         if (isof ==YES) {
             if (indexPath.section == 0) {
                 UIImageView *SiginImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-30, 10, 30, 30)];
                 SiginImage.image = [UIImage imageNamed:@"qd_ico"];
                 [cell addSubview:SiginImage];
                 UILabel *SiginLabel = [[UILabel alloc]initWithFrame:CGRectMake(((self.view.frame.size.width/2)-30)+30, 10, 50, 30)];
                 SiginLabel.text = @"签到";
                 [cell addSubview:SiginLabel];
                 cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
             }else{
                 cell.mingLabel.text = _arr[indexPath.section][indexPath.row];
                 
                 if (indexPath.row==0) {
                     if (_InterNameAry.count != 0) {
                         cell.xingLabel.text = _InterNameAry[indexPath.row];
                     }
                 }else if (indexPath.row == 2) {
                     cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
                     cell.userInteractionEnabled = isof;
                     if (_InterNameAry.count != 0) {
                         cell.xingLabel.text = _InterNameAry[indexPath.row];
                     }
                     
                 }else{
                     for(_textField in cell.subviews){
                         if([_textField isKindOfClass:[UITextField class]])
                         {
                             [_textField removeFromSuperview];
                         }
                     }
                     _textField=[[UITextField alloc]initWithFrame: CGRectMake(120, 1, self.view.bounds.size.width-170, 48)];
                     _textField.font = [UIFont boldSystemFontOfSize:14.0f];
                     [_textField addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
                     _textField.tag = indexPath.row;
                     if (_InterNameAry.count>0) {
                         _textField.text = _InterNameAry[indexPath.row];
                     }
                     [cell addSubview:_textField];
                     cell.userInteractionEnabled = isof;
                     
                 }
             }
         }else{
             cell.mingLabel.text = _arr[indexPath.row];
             cell.mingLabel.textColor = [UIColor blackColor];
             if (_InterNameAry.count != 0) {
                 cell.xingLabel.text = _InterNameAry[indexPath.row];
             }
             if (indexPath.row == 2) {
                 cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
                 cell.userInteractionEnabled = isof;
                 
             }
            
         }
         return cell;
     }else
     {
         FillTableViewCell *cell = [[FillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FillTableCell"];
         if (cell == nil) {
             cell = [[FillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FillTableCell"];
         }
         if (!(indexPath.row==9)) {
             cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
         }
         if (indexPath.row == 9) {
             if (_InterNameAry.count>0) {
                 cell.xingLabel.text = _InterNameAry[indexPath.row];
                 cell.xingLabel.numberOfLines = 0;
                 cell.userInteractionEnabled = isof;
                 
             }
         }else if(indexPath.row ==10){
             if (_InterNameAry.count != 0) {
                 cell.xingLabel.text = _InterNameAry[indexPath.row];
                 cell.userInteractionEnabled = isof;
             }
         }
         if (isof == YES) {
              cell.mingLabel.text=_arr[indexPath.section][indexPath.row];
         }else{
              cell.mingLabel.text=_arr[indexPath.row];
         }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
     }
}
-(void)FieldText:(UITextField *)textfield{
    switch (textfield.tag) {
        case 1:{
            _UsersName= textfield.text;
        }
            break;
        case 3:{
            _StoreName=textfield.text;
        }
            break;
        case 4:{
            _Address=textfield.text;
        }
            break;
        case 5:{
            _ShopName=textfield.text;
        }
            break;
        case 6:{
            _Iphone=textfield.text;
        }
            break;
        case 7:{
            _Wcode = textfield.text;
            NSLog(@"%@",textfield.text);
        } break;
        default:
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _Index=indexPath;
    inftionTableViewCell *cella = [tableView cellForRowAtIndexPath:indexPath];

    
        if (indexPath.row == 0) {
            //shopId
            if (isof == YES) {
            SiginViewController *siginVC = [[SiginViewController alloc]init];
            
            siginVC.shopid =_ShopId;
            siginVC.Address = [NSString stringWithFormat:@"%@%@%@",_Province,_City,_County];
            siginVC.Types = @"2";
            
            [self.navigationController pushViewController:siginVC animated:YES];
            }else{
                dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
                dater.delegate=self;
                [dater showInView:self.view animated:YES];
            }
        }else{
            switch (indexPath.row) {
                case 2:{
                    [self.view endEditing:YES];
                    self.cityChoose = [[CityChoose alloc] init];
                    self.cityChoose.config = ^(NSString *province, NSString *city, NSString *town){
                        cella.xingLabel.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,town];
                        cella.xingLabel.textColor=[UIColor blackColor];
                        if (isof == YES) {
                            _Address=[NSString stringWithFormat:@"%@ %@ %@",province,city,town];
                        }
                        //
                    };
                    [self.view addSubview:self.cityChoose];
                }
                    break;
                case 8:{
                    InterestedInputViewController *inputVC=[[InterestedInputViewController alloc]init];
                    inputVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
                    inputVC.dateStr = _InterNameAry[indexPath.row];
                    inputVC.modifi = isof;
                    inputVC.blcokStr=^(NSString *content,int num){
                        if (num==8) {
                            if (isof == YES) {
                                _BrandBusiness=content;
                            }
                            //主要经营品牌
                            
                        }
                    };
                    [self.navigationController pushViewController:inputVC animated:YES];
                }
                    break;
                case 9:{
                    [SelectAlert showWithTitle:@"类型" titles:@[@"A类",@"B类",@"C类"] selectIndex:^(NSInteger selectIndex) {
                        
                    } selectValue:^(NSString *selectValue) {
                        FillTableViewCell *cell = [infonTableview cellForRowAtIndexPath:_Index];
                        cell.xingLabel.text=selectValue;
                        if (isof == YES) {
                            _StoreLevel=selectValue;
                        }
                        //
                    } showCloseButton:NO];
                }
                    break;
                case 10:{
                   
                    
                    
                    NSMutableArray *nsmuary = [[NSMutableArray alloc]initWithObjects:@"面部",@"身体",@"美白",@"教育",@"管理",@"拓客",@"模式", nil];
                    [InteredAlertView showWithTitle:@"选择意向" titles:nsmuary isof:_intentary selectIndex:^(NSString *selectIndex) {
                        FillTableViewCell *cell = [infonTableview cellForRowAtIndexPath:_Index];
//                        cell.xingLabel.text =[_intentary stringByReplacingOccurrencesOfString:@"," withString:@" "];
                         BOOL isbool = [_intentary containsObject: selectIndex];
                        if (isbool == 1) {
                            NSLog(@"删除了");
                            [_intentary removeObject:selectIndex];
                            NSString *string = [_intentary componentsJoinedByString:@","];
                            cell.xingLabel.text =[string stringByReplacingOccurrencesOfString:@"," withString:@" "];
                        }else{
                            [_intentary addObject:selectIndex];
                            NSLog(@"添加了");
                            NSString *string = [_intentary componentsJoinedByString:@","];
                            cell.xingLabel.text =[string stringByReplacingOccurrencesOfString:@"," withString:@" "];
                        }
                       
                    }];

                }
                    
                    break;
                case 11:{
                    InterestedInputViewController *inputVC=[[InterestedInputViewController alloc]init];
                    inputVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
                    inputVC.dateStr = _InterNameAry[indexPath.row];
                    inputVC.modifi = isof;
                    inputVC.blcokStr=^(NSString *content,int num){
                        if (num==11) {
                            if (isof == YES) {
                                _StoreSituation=content;
                            }
                            //店面情况简介
                            
                        }
                    };
                    [self.navigationController pushViewController:inputVC animated:YES];
                }
                    break;
                case 12:{
                    InterestedInputViewController *inputVC=[[InterestedInputViewController alloc]init];
                    inputVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
                    inputVC.dateStr = _InterNameAry[indexPath.row];
                    inputVC.modifi = isof;
                    inputVC.blcokStr=^(NSString *content,int num){
                        if (num==12) {
                            if (isof == YES) {
                                _Comprehensive=content;
                            }
                            //店面情况综合分析
                            
                        }
                    };
                    [self.navigationController pushViewController:inputVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
    
    
    
    
    NSLog(@"%ld",indexPath.row);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemAction:(UIBarButtonItem*)sender{
    if (isof == NO) {
        NSArray *zwlbAry = [[NSArray alloc]init];
        zwlbAry = @[@"编辑意向客户",@"升级为目标客户",@"确定合作",@"分享给同事",@"删除"];
        [SelectAlert showWithTitle:nil titles:zwlbAry selectIndex:^(NSInteger selectIndex) {
            if (selectIndex == 0) {
                isof = YES;
                _arr=@[@[@""],@[@"日期",@"洽谈人",@"地区",@"店名",@"店铺地址",@"负责人",@"手机",@"微信",@"主要经营品牌",@"店面评估档次分类",@"意向选择",@"店面情况简介",@"店家情况综合分析"]];
                [infonTableview reloadData];
            }else if(selectIndex == 1){
                PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"确定要升级该客户为目标客户么" sureBtn:@"确认" cancleBtn:@"取消"];
                alertView.resultIndex = ^(NSInteger index){
                    NSLog(@"%ld",index);
                    if(index == 2){
                        [self InsertTargetVisit];
                        
                    }
                };
                [alertView showMKPAlertView];
            }else if(selectIndex == 2){
                PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否确定为合作客户" sureBtn:@"确认" cancleBtn:@"取消"];
                alertView.resultIndex = ^(NSInteger index){
                    NSLog(@"%ld",index);
                    if(index == 2){
                       
                        StoreinforViewController *storeinforVC = [[StoreinforViewController  alloc]init];
                        storeinforVC.titleName = _StoreName;
                        storeinforVC.isend = YES;
                        storeinforVC.shopId = _ShopId;
                        [self.navigationController pushViewController:storeinforVC animated:YES];
                    }
                };
                [alertView showMKPAlertView];
            }else if(selectIndex == 3){
                
                ShareColleagues *SCVC = [[ShareColleagues alloc]init];
                SCVC.shopip = _ShopId;
                SCVC.yiandmu = @"2";
                SCVC.targetvisitid = _Id;
                  [self.navigationController pushViewController:SCVC animated:YES];
            }else {
                //删除
                [self deleteShop];
            }
        } selectValue:^(NSString *selectValue) {
            
        } showCloseButton:NO];
    }else{
        NSArray *zwlbAry = [[NSArray alloc]init];
        zwlbAry = @[@"提交到上级",@"提交到品牌部"];
        [SelectAlert showWithTitle:nil titles:zwlbAry selectIndex:^(NSInteger selectIndex) {
            if (selectIndex == 0) {
                //提交到上级
                [self updateIntended];
            }else{
                //提交到品牌部
                UpdateIntendedViewController *upadateBM = [[UpdateIntendedViewController alloc]init];
                upadateBM.shopId = self.ShopId;
                upadateBM.roid=self.strId;
                upadateBM.number = @"1";
                upadateBM.intendedId = _Id;
                [self.navigationController pushViewController:upadateBM animated:YES];
            }
        } selectValue:^(NSString *selectValue) {
            
        } showCloseButton:NO];
        
    }
}
-(void)deleteShop{
    //删除意向客户表
    NSString *uStr =[NSString stringWithFormat:@"%@shop/deleteShop.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"id":_Id,@"shopId":_ShopId,@"Types":@"2",@"Draft":@"2"};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"删除成功" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [self.navigationController popViewControllerAnimated:YES];
            };
            [alertView showMKPAlertView];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除失败" andInterval:1.0];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除失败" andInterval:1.0];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
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
-(void)InsertTargetVisit{
    //升级目标客户
    NSString *uStr =[NSString stringWithFormat:@"%@shop/InsertTargetVisit.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSString *username = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"name"]];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"shopId":_ShopId,@"RoleId":self.strId,@"UsersName":username};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            _visiId = [[NSString alloc]init];
            _visiId =[responseObject valueForKey:@"TargetVisitId"];
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"现在该客户已升级为目标客户,现在去填写目标客户确立表?" sureBtn:@"以后再说" cancleBtn:@"现在就去"];
            alertView.resultIndex = ^(NSInteger index){
                NSLog(@"%ld",index);
                if(index == 1){
                    //跳界面----------------------填写目标客户
                    TargetTableViewController *ttvc = [[TargetTableViewController alloc]init];
                    ttvc.OldTargetVisitId = _visiId;
                    ttvc.isofyou = NO;
                    ttvc.strId = self.strId;
                    ttvc.cellend = NO;
                    [self.navigationController pushViewController:ttvc animated:YES];
                    
                }
            };
            [alertView showMKPAlertView];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1111"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"升级失败" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"店铺当前级别不能升级为目标客户" andInterval:1.0];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)updateIntended{
    //修改意向客户
    NSString *uStr =[NSString stringWithFormat:@"%@shop/updateIntended.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *intentar = [_intentary componentsJoinedByString:@","];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"intendedId":self.intentionId,@"Iphone":_Iphone,@"Wcode":_Wcode,@"BrandBuiness":_BrandBusiness,@"StoreLevel":_StoreLevel,@"intentionName":intentar,@"StoreSituation":_StoreSituation,@"Comprehensive":_Comprehensive,@"RoleId":self.strId,@"Provice":_Province,@"City":_City,@"County":_County,@"Address":_Address,@"StoreName":_StoreName,@"Name":_ShopName,@"shopId":_ShopId};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
         if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
             PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"修改成功" sureBtn:@"确认" cancleBtn:nil];
             alertView.resultIndex = ^(NSInteger index){
                 isof = NO;
                 _arr=@[@"日期",@"洽谈人",@"地区",@"店名",@"店铺地址",@"负责人",@"手机",@"微信",@"主要经营品牌",@"店面评估档次分类",@"意向选择",@"店面情况简介",@"店家情况综合分析"];
                 [infonTableview reloadData];
             };
             [alertView showMKPAlertView];
         }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)selectworsh{
//数据请求
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectIntended.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    if ([_isofyou isEqualToString:@"1"]) {
        uStr = [NSString stringWithFormat:@"%@shop/getShop.action",KURLHeader];
        dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"shopId":self.shopId,@"Types":@"2"};
    }else{
   uStr = [NSString stringWithFormat:@"%@shop/selectIntended.action",KURLHeader];
        dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"IntendedId":self.intentionId,@"RoleId":self.strId};
    }
    
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *arry=[responseObject valueForKey:@"list"];
            _InterNameAry = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arry) {
                InterestedModel *model=[[InterestedModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                _Id = model.Id;
                _ShopId = model.shopId;
                _Dates =  [[NSString alloc]initWithFormat:@"%@", [model.dates substringWithRange:NSMakeRange(0, 10)]];
                [_InterNameAry addObject:_Dates];//
                if (model.usersName ==nil) {
                    _UsersName =@"";
                }else{
                    _UsersName =model.usersName;
                }
                [_InterNameAry addObject:_UsersName];//
                if (model.province ==nil) {
                    _Province =@"";
                }else{
                    _Province =model.province;
                }
                if (model.city ==nil) {
                    _City =@"";
                }else{
                    _City = model.city;
                }
                if (model.county ==nil) {
                    _County = @"";
                }else{
                    _County = model.county;
                }
                [_InterNameAry addObject:[NSString stringWithFormat:@"%@%@%@",_Province,_City,_County]];//
                if (model.storeName ==nil) {
                    _StoreName =@"";
                }else{
                    _StoreName = model.storeName;
                }
                [_InterNameAry addObject:_StoreName];//店名
                if (model.address ==nil) {
                    _Address = @"";
                }else{
                    _Address = model.address;
                }
                [_InterNameAry addObject:_Address];//店面地址
                if (model.shopName==nil) {
                    _ShopName =@"";
                }else{
                    _ShopName = model.shopName;
                }
                [_InterNameAry addObject:_ShopName];//负责人姓名
                if (model.iphone ==nil) {
                    _Iphone =@"";
                }else{
                    _Iphone = model.iphone;
                }
                [_InterNameAry addObject:_Iphone];//手机
                if (model.wcode ==nil) {
                    _Wcode =@"";
                }else{
                    _Wcode = model.wcode;
                }
                [_InterNameAry addObject:_Wcode];//微信
                if (model.brandBusiness == nil) {
                    _BrandBusiness = @"";
                }else{
                    _BrandBusiness = model.brandBusiness;
                }
                [_InterNameAry addObject:_BrandBusiness];//经营品牌
                if(model.storeLevel ==nil){
                    _StoreLevel = @"";
                }else{
                    _StoreLevel = model.storeLevel;
                }
                [_InterNameAry addObject:_StoreLevel];//档次
                if (model.intentionName ==nil) {//意向选择
                    _intentary = [[NSMutableArray alloc]init];
                    _IntentionId = @"";
                    [_InterNameAry addObject:_IntentionId];
                }else{
                    NSArray *ary = [model.intentionName componentsSeparatedByString:@","];
                     _intentary = [[NSMutableArray alloc]init];
                    [_intentary addObjectsFromArray:ary];
                    
                    
                     NSString *inidarray = [model.intentionName stringByReplacingOccurrencesOfString:@"," withString:@" "];
                    //NSLog(@"%@",inidarray);
                    [_InterNameAry addObject:inidarray];
                }
                if (model.storeSituation ==nil) {
                    _StoreSituation = @"";
                }else{
                    _StoreSituation = model.storeSituation;
                }
                [_InterNameAry addObject:_StoreSituation];//店面情况简介
                if (model.comprehensive ==nil) {
                    _Comprehensive = @"";
                }else{
                    _Comprehensive = model.comprehensive;
                }
                [_InterNameAry addObject:_Comprehensive];//店面情况综合分析
                
                
                
                
                
            }
            [infonTableview reloadData];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isof ==NO) {
        return _arr.count;
    }else{
      return [_arr[section]count];
    }
    
        

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        return 50;
   
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    if (isof ==NO) {
        return 1;
    }else{
        return 2;
    }
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
@end
