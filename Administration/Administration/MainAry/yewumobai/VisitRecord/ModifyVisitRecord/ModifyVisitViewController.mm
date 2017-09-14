//
//  ModifyVisitViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/9/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ModifyVisitViewController.h"
#import "SmallStoreViewController.h"
#import "SmallInputViewController.h"
#import "FillTableViewCell.h"
#import "inftionTableViewCell.h"
#import "XFDaterView.h"
#import "CityChoose.h"
#import "SelectAlert.h"
#import "ModifyVisitModel.h"
#import "SiginViewController.h"


@interface ModifyVisitViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,XFDaterViewDelegate>
{
    
   
    XFDaterView*dater;
    BOOL Modify;
}
@property (nonatomic,retain)UITableView *infonTableview;
@property (nonatomic, strong) CityChoose *cityChoose;/** 城市选择 */
@property (strong,nonatomic) NSString *modifybetween;

@property (strong,nonatomic) NSMutableArray *InterNameAry;
@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,retain)NSString *storepersonnel;//人员
@property (nonatomic,retain)NSString *storedate;//日期

@property (nonatomic,retain)NSIndexPath *Index;

@property (nonatomic,retain)NSString *sigincity;
@property (nonatomic,strong)NSString *animdd;

@property (nonatomic,strong)NSString *shopid;

//------------------

@property (nonatomic,retain)NSString *storeregion;//地区
@property (nonatomic,retain)NSString *storename;//店名
@property (nonatomic,retain)NSString *storeaddree;//地址
@property (nonatomic,retain)NSString *storehead;//负责人
@property (nonatomic,retain)NSString *storephone;//手机
@property (nonatomic,retain)NSString *storewxphone;//微信
@property (nonatomic,retain)NSString *storebrand;//品牌
@property (nonatomic,retain)NSString *clascation;//分类
@property (nonatomic,retain)NSString *stotrType;//门店类型
@property (nonatomic,retain)NSString *Abrief;//简要
@property (nonatomic,retain)NSString *instructions;//说明
@property (nonatomic,retain)NSString *note;//备注
@property (nonatomic,retain)NSString *brandBusin;//美容师人数
@property (nonatomic,retain)NSString *planDur;//经营年限
@property (nonatomic,retain)NSString *Berths;//床位

@end

@implementation ModifyVisitViewController

-(void)viewWillAppear:(BOOL)animated{
    if ([_animdd isEqualToString:@"2"]) {
        [_infonTableview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(0);
            make.left.mas_equalTo(self.view.mas_left).offset(0);
            make.right.mas_equalTo(self.view.mas_right).offset(0);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        }];
    }
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"陌拜记录";
    _animdd = [[NSString alloc]init];
    Modify = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"···" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    [self selectworsh];
    _InterNameAry = [[NSMutableArray alloc]init];
    _arr=@[@"日期",@"业务人员",@"地区",@"店名",@"店铺地址",@"负责人",@"手机",@"微信",@"主要经营品牌",@"店面评估档次分类",@"店面情况简介",@"关注项目及所需信息简要",@"会谈起止时间概要说明(必填)",@"备注"];
    _infonTableview= [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _infonTableview.dataSource=self;
    _infonTableview.delegate =self;
    [self.view addSubview:_infonTableview];
    [_infonTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
    
    [ZXDNetworking setExtraCellLineHidden:_infonTableview];
}
-(void)nssstringalloc{
    _storephone = [[NSString alloc]init];
    _storewxphone = [[NSString alloc]init];
    _storebrand =  [[NSString alloc]init];
    _clascation = [[NSString alloc]init];
    _stotrType = [[NSString alloc]init];
    _Abrief = [[NSString alloc]init];
    _instructions = [[NSString alloc]init];
    _note = [[NSString alloc]init];
    _brandBusin = [[NSString alloc]init];
    _planDur = [[NSString alloc]init];
    _Berths = [[NSString alloc]init];
}


-(void)selectworsh{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectWorshipRecord.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"WorshipRecordId":self.ModifyId};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
             NSArray *arry=[responseObject valueForKey:@"recordInfo"];
            for (NSDictionary *dic in arry) {
                ModifyVisitModel *model=[[ModifyVisitModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                _shopid = [[NSString alloc]initWithFormat:@"%@",model.ShopId];//店铺id
                _sigincity = [[NSString alloc]initWithFormat:@"%@%@%@%@",model.Province,model.City,model.County,model.Address];
                [_InterNameAry addObject:model.Dates];//日期
                [_InterNameAry addObject:@"业务人员"];
                [_InterNameAry addObject:[NSString stringWithFormat:@"%@%@%@",model.Province,model.City,model.County]];//省市县
                [_InterNameAry addObject:model.StoreName]; //店名
                [_InterNameAry addObject:model.Address];//门店地址
                [_InterNameAry addObject:model.ShopName];//店铺负责人姓名

                if (model.Iphone ==nil) {
                    //手机
                    _storephone = @"";
                     [_InterNameAry addObject:_storephone];
                }else{
                    _storephone = model.Iphone;
                    [_InterNameAry addObject:_storephone];
                    
                }
                if (model.Wcode ==nil) {
                    //微信
                     _storewxphone = @"";
                    [_InterNameAry addObject:_storewxphone];
                    
                }else{
                    _storewxphone = model.Wcode;
                    [_InterNameAry addObject:_storewxphone];
                }
                
                if (model.BrandBusiness ==nil) {
                    //经营品牌
                    _storebrand = @"";
                    [_InterNameAry addObject:_storebrand];
                    
                }else{
                    _storebrand =model.BrandBusiness;
                    [_InterNameAry addObject:_storebrand];
                    
                }
                
                if (model.StoreLevel ==nil) {
                    //门店档次分类
                    _clascation = @"";
                    [_InterNameAry addObject:_clascation];
                    
                }else{
                    _clascation = model.StoreLevel;
                    [_InterNameAry addObject:_clascation];
                    
                }
                
                NSMutableArray *dianmianAry = [[NSMutableArray alloc]init];
                if (model.StoreType == nil) {
                    //门店类型
                    _stotrType = @"";
                    [dianmianAry addObject:_stotrType];
                }else{
                    _stotrType = model.StoreType;
                    [dianmianAry addObject:_stotrType];
                }
                if (model.PlantingDuration==nil) {
                    //经营年限
                    _planDur = @"";
                    [dianmianAry addObject:_planDur];
                }else{
                    _planDur = model.PlantingDuration;
                    [dianmianAry addObject:_planDur];
                }
                if (model.BeauticianNU==nil) {
                    //美容师人数
                    _brandBusin = @"";
                    [dianmianAry addObject:_brandBusin];
                }else{
                    _brandBusin = model.BeauticianNU;
                    [dianmianAry addObject: _brandBusin];
                }
                if (model.Berths == nil) {
                    //床位数
                    _Berths = @"";
                    [dianmianAry addObject:_Berths];
                }else{
                    _Berths = model.Berths;
                    [dianmianAry addObject:_Berths];
                }
                [_InterNameAry addObject:dianmianAry];
                
                if (model.ProjectBrief == nil) {
                    //关注项目及所需要信息简要
                    _Abrief = @"";
                    [_InterNameAry addObject:_Abrief];
                }else{
                    _Abrief = model.ProjectBrief;
                    [_InterNameAry addObject:_instructions];
                }
                if (model.MeetingTime==nil) {
                    //会谈时间
                    _instructions = @"";
                    [_InterNameAry addObject:_instructions];
                }else{
                    _instructions = model.MeetingTime;
                    [_InterNameAry addObject:model.MeetingTime];
                }
                if (model.Modified == nil) {
                    //备注
                    _note = @"";
                    [_InterNameAry addObject:_note];
                }else{
                    _Abrief = model.Modified;
                [_InterNameAry addObject:_note];
                }
            }
            [_infonTableview reloadData];
        }
    } failure:^(NSError *error){
        
    } view:self.view MBPro:YES];
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModifyVisitModel *model=[[ModifyVisitModel alloc]init];
    if (_InterNameAry.count>0) {
        model = _InterNameAry[0];
    }
    CGRect labelRect2 = CGRectMake(120, 1, self.view.bounds.size.width-170, 48);
    if(indexPath.row<8){
        inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        if (cell ==nil)
        {
            cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        
        UIImageView *SiginImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-30, 10, 30, 30)];
        SiginImage.image = [UIImage imageNamed:@"qd_ico"];
        [cell addSubview:SiginImage];
        UILabel *SiginLabel = [[UILabel alloc]initWithFrame:CGRectMake(((self.view.frame.size.width/2)-30)+30, 10, 50, 30)];
        SiginLabel.text = @"签到";
        [cell addSubview:SiginLabel];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
        
    }
        
    if (indexPath.section ==1) {
        if (indexPath.row == 2) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
            cell.userInteractionEnabled = Modify;
        }
        cell.mingLabel.text=_arr[indexPath.row];
        if (indexPath.row>2) {
            for(_textField in cell.subviews){
                if([_textField isKindOfClass:[UITextField class]])
                {
                    [_textField removeFromSuperview];
                }
            }
            
            _textField=[[UITextField alloc]initWithFrame:labelRect2];
            _textField.font = [UIFont boldSystemFontOfSize:14.0f];
            [_textField addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            _textField.tag = indexPath.row;
            if (_InterNameAry.count>0) {
                _textField.placeholder=@"";
                _textField.text=_InterNameAry[indexPath.row];
            }else{
               _textField.placeholder=@"必填";
            }
            [cell addSubview:_textField];
            cell.userInteractionEnabled = Modify;
            
        }else{
            if(indexPath.row==1){
                cell.xingLabel.text=[USER_DEFAULTS objectForKey:@"name"];
                _storepersonnel=[USER_DEFAULTS objectForKey:@"name"];
                cell.userInteractionEnabled = Modify;
            }else{
                cell.userInteractionEnabled = Modify;
                if (_InterNameAry.count>0) {
                    cell.xingLabel.textColor=[UIColor blackColor];
                    cell.xingLabel.text=_InterNameAry[indexPath.row];
                }else{
                    cell.xingLabel.textColor=[UIColor lightGrayColor];
                    cell.xingLabel.text = @"必填";
                }
                
            }
            if (indexPath.row==0&&!(_storedate==nil)) {
                NSString *xxsj =  [[NSString alloc]initWithFormat:@"%@", [model.Dates substringWithRange:NSMakeRange(0, 10)]];
                cell.xingLabel.text = xxsj;
                cell.userInteractionEnabled = Modify;
                
            }
        }
        
     
    }
    return cell;
    }else{
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
                cell.userInteractionEnabled = Modify;
            }
            //
        }
        cell.mingLabel.text=_arr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}












-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return _arr.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 20;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _Index=indexPath;
     inftionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        //shopId  
        SiginViewController *siginVC = [[SiginViewController alloc]init];

        siginVC.shopid =_shopid;
        siginVC.Address = _sigincity;
        siginVC.Types = @"1";
        _animdd = @"2";
        [self.navigationController pushViewController:siginVC animated:YES];
    }else{
        switch (indexPath.row) {
            case 0:
                dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
                dater.delegate=self;
                [dater showInView:self.view animated:YES];
                break;
            case 2:{
                [self.view endEditing:YES];
                self.cityChoose = [[CityChoose alloc] init];
                self.cityChoose.config = ^(NSString *province, NSString *city, NSString *town){
                    cell.xingLabel.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,town];
                    cell.xingLabel.textColor=[UIColor blackColor];
                    if (Modify == YES) {
                        _storeregion=[NSString stringWithFormat:@"%@ %@ %@",province,city,town];
                    }
                    //
                };
                [self.view addSubview:self.cityChoose];
            }
                break;
            case 8:{
                SmallInputViewController *inputVC=[[SmallInputViewController alloc]init];
                inputVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
                inputVC.dateStr = _InterNameAry[indexPath.row];
                inputVC.modifi = Modify;
                inputVC.blcokStr=^(NSString *content,int num){
                    if (num==8) {
                        if (Modify == YES) {
                            _storebrand=content;
                        }
                      //
                        
                    }
                };
                _animdd = @"2";
                [self.navigationController pushViewController:inputVC animated:YES];
            }
                break;
            case 9:{
                
                [SelectAlert showWithTitle:@"类型" titles:@[@"A类",@"B类",@"C类"] selectIndex:^(NSInteger selectIndex) {
                    
                } selectValue:^(NSString *selectValue) {
                    FillTableViewCell *cell = [_infonTableview cellForRowAtIndexPath:_Index];
                    cell.xingLabel.text=selectValue;
                    if (Modify == YES) {
                        _clascation=selectValue;
                    }
                   //
                } showCloseButton:NO];
            }
                break;
            case 10:{
                SmallStoreViewController *stireVC=[[SmallStoreViewController alloc]init];
                stireVC.dateAry = _InterNameAry[indexPath.row];
                stireVC.modifi = Modify;
                stireVC.blcokString=^(NSString *type,NSString *year,NSString *perpon,NSString *beds){
                    if (Modify == YES) {
                         _stotrType=type;
                         _planDur=year;
                         _brandBusin=perpon;
                         _Berths=beds;
                    }
                 
                    
                };
                _animdd = @"2";
                [self.navigationController pushViewController:stireVC animated:YES];
            }
                break;
            case 11:{
                SmallInputViewController *inputVC=[[SmallInputViewController alloc]init];
                inputVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
                inputVC.dateStr = _InterNameAry[indexPath.row];
                inputVC.modifi = Modify;
                inputVC.blcokStr=^(NSString *content,int num){
                    if (Modify == YES) {
                        _Abrief=content;
                    }
                  
                    
                };
                _animdd = @"2";
                [self.navigationController pushViewController:inputVC animated:YES];
            }
                break;
            case 12:{
                SmallInputViewController *inputVC=[[SmallInputViewController alloc]init];
                inputVC.dateStr = _InterNameAry[indexPath.row];
                inputVC.modifi = Modify;
                inputVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
                inputVC.blcokStr=^(NSString *content,int num){
                    if (Modify == YES) {
                        _instructions=content;
                    }
                    
                    
                };
                _animdd = @"2";
                [self.navigationController pushViewController:inputVC animated:YES];
            }
                break;
            case 13 :{
                SmallInputViewController *inputVC=[[SmallInputViewController alloc]init];
                inputVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
                inputVC.dateStr = _InterNameAry[indexPath.row];
                inputVC.modifi = Modify;
                inputVC.blcokStr=^(NSString *content,int num){
                    if (Modify == YES) {
                        _note=content;
                    }
                    
                    
                };
                _animdd = @"2";
                [self.navigationController pushViewController:inputVC animated:YES];
            }
                break;
            default:
                break;
        }
    }


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemAction:(UIBarButtonItem*)sender{
    if (Modify == YES) {
        NSArray *zwlbAry = [[NSArray alloc]init];
        zwlbAry = @[@"提交",@"保存草稿箱"];
        [SelectAlert showWithTitle:nil titles:zwlbAry selectIndex:^(NSInteger selectIndex) {
            NSLog(@"选择了第%ld个",(long)selectIndex);
            if (selectIndex == 0) {
                [self UploadInformation];
            }
            
        } selectValue:^(NSString *selectValue) {
            
        } showCloseButton:NO];
    }else{
        NSArray *zwlbAry = [[NSArray alloc]init];
        zwlbAry = @[@"修改陌拜记录",@"填写记录",@"升级为意向客户",@"升级为目标客户",@"删除"];
        [SelectAlert showWithTitle:nil titles:zwlbAry selectIndex:^(NSInteger selectIndex) {
            NSLog(@"选择了第%ld个",(long)selectIndex);
            if (selectIndex == 0) {
                Modify = YES;
                [_infonTableview reloadData];
            }
            
        } selectValue:^(NSString *selectValue) {
            
        } showCloseButton:NO];
    }
}
-(void)UploadInformation{
    
        NSString *uStr =[NSString stringWithFormat:@"%@shop/insertShop.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSArray *array = [_storeregion componentsSeparatedByString:@" "];
        NSString *RoleId=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"roleId"]];
        NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
        NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"Dates":_storedate,@"Name":_storehead,@"Province":array[0],@"City":array[1],@"County":array[2],@"StoreName":_storename,@"Address":_storeaddree,@"Iphone":_storephone,@"Wcode":_storewxphone,@"BrandBusiness":_storebrand,@"StoreLevel":_clascation,@"StoreType":_stotrType,@"PlantingDuration":_planDur,@"BeauticianNU":_brandBusin,@"Berths":_Berths,@"ProjectBrief":_Abrief,@"MeetingTime":_instructions,@"Modified":_note,@"RoleId":RoleId,@"Draft":@"1",@"CompanyId":compid};
        [ZXDNetworking POST:uStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                
                Modify = NO;
                [_infonTableview reloadData];
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"提交成功" andInterval:1.0];
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
            
        } view:self.view];
    
}

- (void)daterViewDidClicked:(XFDaterView *)daterView{
    //NSLog(@"dateString=%@ timeString=%@",dater.dateString,dater.timeString);
    inftionTableViewCell *cell = [_infonTableview cellForRowAtIndexPath:_Index];
    cell.xingLabel.text=dater.dateString;
    _storedate=dater.dateString;
    cell.xingLabel.textColor=[UIColor blackColor];
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([_infonTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [_infonTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([_infonTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [_infonTableview setLayoutMargins:UIEdgeInsetsZero];
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
