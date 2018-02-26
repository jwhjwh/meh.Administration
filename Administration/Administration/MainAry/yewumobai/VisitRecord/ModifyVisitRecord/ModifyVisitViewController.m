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
#import "InterestedTabelViewController.h"
#import "FillinfoViewController.h"//填写新的纪录
#import "TargetTableViewController.h"
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
@property (nonatomic,retain)NSString *CreatorId;//记录创建人id

@property (nonatomic,strong)NSString *visiId;


@property (nonatomic,strong)NSString *strea;

@property BOOL qiandao;
@property (nonatomic,strong)NSString *UserId;//共享人(后台赋值)
@property (nonatomic,strong)NSString *DepartmentId;//提交的部门
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
    _qiandao = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    _arr=@[@"日期",@"业务人员",@"地区",@"店名",@"店铺地址",@"负责人",@"手机",@"微信",@"主要经营品牌",@"店面评估档次分类",@"店面情况简介",@"关注项目及所需信息简要",@"会谈起止时间概要说明(必填)",@"备注"];
    [self selectworsh];
    
   
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
    _CreatorId =[[NSString alloc]init];
    _storepersonnel = [[NSString alloc]init];
    _strea = [[NSString alloc]init];
    
    _DepartmentId= [[NSString alloc]init];//提交的部门
    _UserId= [[NSString alloc]init];//共享人(后台赋值)
   
}


-(void)selectworsh{
   
    NSString *uStr = [[NSString alloc]init];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    if ([self.andisofyou isEqualToString:@"1"]) {
        uStr = [NSString stringWithFormat:@"%@shop/getShop.action",KURLHeader];
        dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"shopId":self.shopId,@"Types":@"1"};
    }else{
        uStr =[NSString stringWithFormat:@"%@shop/selectWorshipRecord.action",KURLHeader];
        dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"WorshipRecordId":self.ModifyId,@"RoleId":self.strId};
    }
    
    
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
             NSArray *arry=[responseObject valueForKey:@"recordInfo"];
            _InterNameAry = [[NSMutableArray alloc]init];
            
            for (NSDictionary *dic in arry) {
                ModifyVisitModel *model=[[ModifyVisitModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                _CreatorId = model.UsersId;
               
                _shopid = [[NSString alloc]initWithFormat:@"%@",model.ShopId];//店铺id
                _sigincity = [[NSString alloc]initWithFormat:@"%@%@%@%@",model.Province,model.City,model.County,model.Address];
                _storeregion= [[NSString alloc]initWithFormat:@"%@ %@ %@ %@",model.Province,model.City,model.County,model.Address];
                NSString *xxsj =  [[NSString alloc]initWithFormat:@"%@", [model.Dates substringWithRange:NSMakeRange(0, 10)]];
                [_InterNameAry addObject:xxsj];//日期
                _storedate = xxsj;
                [_InterNameAry addObject:model.UsersName];
                [_InterNameAry addObject:[NSString stringWithFormat:@"%@%@%@",model.Province,model.City,model.County]];//省市县
                [_InterNameAry addObject:model.StoreName]; //店名
                [_InterNameAry addObject:model.Address];//门店地址
                [_InterNameAry addObject:model.ShopName];//店铺负责人姓名
                _storehead = model.ShopName;
                _storename = model.StoreName;
                _storeaddree = model.Address;
                _UserId = model.userId;
                _strea = model.state;
                _DepartmentId = model.departmentId;
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
                    [_InterNameAry addObject:_Abrief];
                }
                if (model.MeetingTime==nil) {
                    //会谈时间
                    _instructions = @"";
                    [_InterNameAry addObject:_instructions];
                }else{
                    _instructions = model.MeetingTime;
                    [_InterNameAry addObject:_instructions];
                }
                if (model.Modified == nil) {
                    //备注
                    _note = @"";
                    [_InterNameAry addObject:_note];
                }else{
                    _note = model.Modified;
                [_InterNameAry addObject:_note];
                }
                if (model.userId==nil && model.state ==nil &&model.departmentId ==nil) {
                    
                }else{
                     _strea = model.state;
                    _arr=@[@"日期",@"业务人员",@"地区",@"店名",@"店铺地址",@"负责人",@"手机",@"微信",@"主要经营品牌",@"店面评估档次分类",@"店面情况简介",@"关注项目及所需信息简要",@"会谈起止时间概要说明(必填)",@"备注",@"当前状态:"];
                    
                }
            }
            _qiandao = YES;
            [_infonTableview reloadData];
            if ([self.andisofyou isEqualToString:@"1"]) {
                
            }else{
                UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"···" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
                NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
                [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItem = rightitem;
                
            }
        }
    } failure:^(NSError *error){
        
    } view:self.view MBPro:YES];
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect labelRect2 = CGRectMake(170, 1, self.view.bounds.size.width-170, 48);
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
                cell.xingLabel.text=_InterNameAry[indexPath.row];
                _storepersonnel=_InterNameAry[indexPath.row];
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
                
                cell.xingLabel.text = _storedate;
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
        if (indexPath.row==9) {
            
        }else if(indexPath.row==14){
            
        }else{
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
        }
        if (indexPath.row == 9) {
            if (_InterNameAry.count>0) {
                cell.xingLabel.text = _InterNameAry[indexPath.row];
                cell.userInteractionEnabled = Modify;
            }
            //
        }else if (indexPath.row==14){
            if (Modify ==NO) {
                UILabel *dangqian = [[UILabel alloc]init];
                UIImageView *tongs = [[UIImageView alloc]init];
                UILabel *fents = [[UILabel alloc]init];
                UIImageView *fenbm = [[UIImageView alloc]init];
                fenbm.image = [UIImage imageNamed:@"fx_icof"];
                [cell addSubview:fenbm];
                UILabel *fenbmlabel = [[UILabel alloc]init];
                fenbmlabel.text = @"已分享部门";
                fenbmlabel.font = [UIFont systemFontOfSize:11];
                fenbmlabel.textColor = GetColor(113, 180, 114, 1);
                [cell addSubview:fenbmlabel];
                UIImageView *yishengji = [[UIImageView alloc]init];
                UILabel *yisj = [[UILabel alloc]init];
                
                dangqian.text = _arr[indexPath.row];
                dangqian.font = [UIFont systemFontOfSize:12];
                [cell addSubview:dangqian];
                tongs.image = [UIImage imageNamed:@"fx_ico"];
                [cell addSubview:tongs];
                fents.text = @"已分享同事";
                fents.font = [UIFont systemFontOfSize:11];
                fents.textColor = GetColor(230, 165, 108, 1);
                [cell addSubview:fents];
                yishengji.image = [UIImage imageNamed:@"tj__ico01"];
                [cell addSubview:yishengji];
                yisj.text = @"以升级目标客户";
                switch ([_strea integerValue]) {
                    case 1:
                        break;
                    case 2:
                        yisj.text = @"已升级为意向客户";
                        yishengji.image = [UIImage imageNamed:@"tj__ico01"];
                        break;
                    case 3:
                        yisj.text = @"已升级为目标客户";
                        yishengji.image = [UIImage imageNamed:@"tj__ico02"];
                        break;
                    case 4:
                        yisj.text = @"已升级为合作客户";
                        yishengji.image = [UIImage imageNamed:@"tj_ico03"];
                        break;
                        
                    default:
                        break;
                }
                yisj.font = [UIFont systemFontOfSize:11];
                yisj.textColor =  GetColor(158, 91, 185, 1);
                [cell addSubview:yisj];
                if (_UserId ==nil) {
                    if (_DepartmentId   ==nil) {
                        if ([_strea integerValue]==1) {
                        }else{
                            dangqian.frame = CGRectMake(10, 10, 70, 30);
                            yishengji.frame =CGRectMake(80, 17.5, 15, 15);
                            yisj.frame = CGRectMake(100, 10, 90, 30);
                        }
                    }else{
                        dangqian.frame = CGRectMake(10, 10, 70, 30);
                        fenbm.frame = CGRectMake(80, 17.5, 15, 15);
                        fenbmlabel.frame = CGRectMake(100, 10, 70, 30);
                        if ([_strea integerValue]==1) {
                        }else{
                            yishengji.frame =CGRectMake(170, 17.5, 15, 15);
                            yisj.frame = CGRectMake(190, 10, 90, 30);
                        }
                    }
                }else{
                    dangqian.frame = CGRectMake(10, 10, 70, 30);
                    tongs.frame =CGRectMake(80, 17.5, 15, 15);
                    fents.frame = CGRectMake(100, 10, 70, 30);
                    if (_DepartmentId ==nil) {
                        if ([_strea integerValue]==1) {
                        }else{
                            yishengji.frame =CGRectMake(170, 17.5, 15, 15);
                            yisj.frame = CGRectMake(190, 10, 90, 30);
                        }
                    }else{
                        fenbm.frame = CGRectMake(170, 17.5, 15, 15);
                        fenbmlabel.frame = CGRectMake(190, 10, 70, 30);
                        if ([_strea integerValue]==1) {
                        }else{
                            yishengji.frame =CGRectMake(260, 17.5, 15, 15);
                            yisj.frame = CGRectMake(280, 10, 90, 30);
                        }
                    }
                }
        
            }
        }
        if (Modify == YES) {
            cell.mingLabel.text=_arr[indexPath.row];
        }else{
            if (indexPath.row<14) {
                cell.mingLabel.text=_arr[indexPath.row];
            }
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(void)FieldText:(UITextField *)textfield{

    switch (textfield.tag) {
        case 3:{
            _storename=textfield.text;
            
        }
            break;
        case 4:{
            _storeaddree=textfield.text;
            
        }
            break;
        case 5:{
            _storehead=textfield.text;
            
        }
            break;
        case 6:{
            _storephone=textfield.text;
            
        }
            break;
        case 7:{
            _storewxphone = textfield.text;
            NSLog(@"%@",textfield.text);
        } break;
        default:
            break;
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
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * str = [NSString stringWithFormat:@"  "];
    return str;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = GetColor(230,230,230,1);
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor grayColor];
    header.textLabel.font = [UIFont systemFontOfSize:14.0f];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _Index=indexPath;
     inftionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        //shopId
        if(_qiandao ==YES){
            SiginViewController *siginVC = [[SiginViewController alloc]init];
            
            siginVC.shopid =_shopid;
            siginVC.Address = _sigincity;
            siginVC.Types = @"1";
            _animdd = @"2";
            [self.navigationController pushViewController:siginVC animated:YES];
        }
        
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
                            _InterNameAry[indexPath.row]=_storebrand;
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
                        _InterNameAry[indexPath.row]=_clascation;
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
                        NSArray *arr =[NSArray arrayWithObjects:_stotrType,_planDur,_brandBusin,_Berths, nil];
                        _InterNameAry[indexPath.row]=arr;
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
                        _InterNameAry[indexPath.row]=_Abrief;
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
                         _InterNameAry[indexPath.row]=_instructions;
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
                        _InterNameAry[indexPath.row]=_note;
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
    
    if ([self.moandthe isEqualToString:@"1"]) {
        //草稿箱
        if (Modify == NO) {
            NSArray *zwlbAry = [[NSArray alloc]init];
            zwlbAry = @[@"编辑陌拜记录",@"填写记录",@"删除"];
            [SelectAlert showWithTitle:nil titles:zwlbAry selectIndex:^(NSInteger selectIndex) {
                NSLog(@"选择了第%ld个",(long)selectIndex);
                if (selectIndex == 0) {
                    Modify = YES;
                    self.moandthe = @"2";
                    
                    [_infonTableview reloadData];
                }else if(selectIndex == 1){
                    FillinfoViewController *fillVC = [[FillinfoViewController alloc]init];
                    fillVC.points = self.strId;
                    _animdd = @"2";
                    NSString *string = [[USER_DEFAULTS objectForKey:@"departmentID"] componentsJoinedByString:@","];
                    fillVC.depant =string;
                    [self.navigationController pushViewController:fillVC animated:YES];
                }else{
                    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要删除此项内容" sureBtn:@"确认" cancleBtn:@"取消"];
                    alertView.resultIndex = ^(NSInteger index) {
                        if (index == 2) {
                            NSString *uStr =[NSString stringWithFormat:@"%@shop/deleteShop.action",KURLHeader];
                            NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
                            NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
                            NSDictionary *dic= @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"id":self.ModifyId,@"Types":@"1",@"shopId":_shopid,@"Draft":@"2"};
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
                    };
                    [alertView showMKPAlertView];

                }
                
            } selectValue:^(NSString *selectValue) {
                
            } showCloseButton:NO];

        }
    }else{
        
        if (Modify == YES) {
            NSArray *zwlbAry = [[NSArray alloc]init];
            zwlbAry = @[@"提交",@"保存草稿箱"];
            [SelectAlert showWithTitle:nil titles:zwlbAry selectIndex:^(NSInteger selectIndex) {
                NSLog(@"选择了第%ld个",(long)selectIndex);
                if (selectIndex == 0) {
                    [self UploadInformation:@"1"];
                    
                }else{
                    [self UploadInformation:@"0"];
                }
                
            } selectValue:^(NSString *selectValue) {
                
            } showCloseButton:NO];
        }else{
            NSArray *zwlbAry = [[NSArray alloc]init];
           
                if ([_strea intValue] ==2) {
                    //意向
                    zwlbAry = @[@"填写记录",@"删除"];
                }else if([_strea intValue]==3){
                 // 目标
                    zwlbAry = @[@"填写记录",@"删除"];
                }else if([_strea intValue]==4){
                    // 合作
                    zwlbAry = @[@"填写记录",@"删除"];
                }else{
                    zwlbAry = @[@"修改陌拜记录",@"填写记录",@"升级为意向客户",@"升级为目标客户",@"删除"];
                }
            [SelectAlert showWithTitle:nil titles:zwlbAry selectIndex:^(NSInteger selectIndex) {
                if ([_strea intValue] ==1) {
                    if (selectIndex == 0) {
                        Modify = YES;
                        _arr=@[@"日期",@"业务人员",@"地区",@"店名",@"店铺地址",@"负责人",@"手机",@"微信",@"主要经营品牌",@"店面评估档次分类",@"店面情况简介",@"关注项目及所需信息简要",@"会谈起止时间概要说明(必填)",@"备注"];
                        [_infonTableview reloadData];
                    }else if (selectIndex == 1){
                        FillinfoViewController *fillVC = [[FillinfoViewController alloc]init];
                        fillVC.points = self.strId;
                        _animdd = @"2";
                        NSString *string = [[USER_DEFAULTS objectForKey:@"departmentID"] componentsJoinedByString:@","];
                        fillVC.depant =string;
                        
                        [self.navigationController pushViewController:fillVC animated:YES];
                    }else if(selectIndex == 2){
                        //升级意向客户
                        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"确定要升级该客户为意向客户吗?" sureBtn:@"确认" cancleBtn:@"取消"];
                        alertView.resultIndex = ^(NSInteger index) {
                            if (index == 2) {
                                //确定
                                [self InsertIntendedNetWorking];
                                
                            }
                        };
                        [alertView showMKPAlertView];
                    }else if(selectIndex == 3){
                        //升级为目标客户
                        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"确定要升级该客户为目标客户吗?" sureBtn:@"确认" cancleBtn:@"取消"];
                        alertView.resultIndex = ^(NSInteger index) {
                            if (index == 2) {
                                //确定
                                [self InsertTargetVisitNetWorking];
                                
                            }
                        };
                        [alertView showMKPAlertView];
                        
                    }else if(selectIndex == 4){
                        //删除
                        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要删除此项内容" sureBtn:@"确认" cancleBtn:@"取消"];
                        alertView.resultIndex = ^(NSInteger index) {
                            if (index == 2) {
                                NSString *uStr =[NSString stringWithFormat:@"%@shop/deleteShop.action",KURLHeader];
                                NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
                                NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
                                NSDictionary *dic= @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"id":self.ModifyId,@"Types":@"1",@"shopId":_shopid,@"Draft":@"2"};
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
                        };
                        [alertView showMKPAlertView];
                        
                    }
                }else {
                    //目标 意向 合作一样
                    if (selectIndex == 0) {
                        FillinfoViewController *fillVC = [[FillinfoViewController alloc]init];
                        fillVC.points = self.strId;
                        _animdd = @"2";
                        NSString *string = [[USER_DEFAULTS objectForKey:@"departmentID"] componentsJoinedByString:@","];
                        fillVC.depant =string;
                        [self.navigationController pushViewController:fillVC animated:YES];
                    }else{
                        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要删除此项内容" sureBtn:@"确认" cancleBtn:@"取消"];
                        alertView.resultIndex = ^(NSInteger index) {
                            if (index == 2) {
                                NSString *uStr =[NSString stringWithFormat:@"%@shop/deleteShop.action",KURLHeader];
                                NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
                                NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
                                NSDictionary *dic= @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"id":self.ModifyId,@"Types":@"1",@"shopId":_shopid,@"Draft":@"2"};
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
                        };
                        [alertView showMKPAlertView];
                        
                    }
                }
            } selectValue:^(NSString *selectValue) {
                
            } showCloseButton:NO];
        }

    }
    
    
}
-(void)UploadInformation :(NSString *)draft{
        NSString *uStr =[NSString stringWithFormat:@"%@shop/insertShop.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSArray *array = [_storeregion componentsSeparatedByString:@" "];
        NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"Dates":_storedate,@"Name":_storehead,@"Province":array[0],@"City":array[1],@"County":array[2],@"StoreName":_storename,@"Address":_storeaddree,@"Iphone":_storephone,@"Wcode":_storewxphone,@"BrandBusiness":_storebrand,@"StoreLevel":_clascation,@"StoreType":_stotrType,@"PlantingDuration":_planDur,@"BeauticianNU":_brandBusin,@"Berths":_Berths,@"ProjectBrief":_Abrief,@"MeetingTime":_instructions,@"Modified":_note,@"RoleId":self.strId,@"Draft":draft,@"CompanyId":compid,@"WorshipRecordId":self.ModifyId,@"ShopId":_shopid,@"CreatorId":_CreatorId};
        [ZXDNetworking POST:uStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                Modify = NO;
                _arr=@[@"日期",@"业务人员",@"地区",@"店名",@"店铺地址",@"负责人",@"手机",@"微信",@"主要经营品牌",@"店面评估档次分类",@"店面情况简介",@"关注项目及所需信息简要",@"会谈起止时间概要说明(必填)",@"备注",@"当前状态:"];
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
            }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0003"]) {
               [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有权限修改该记录" andInterval:1.0];
            }
        } failure:^(NSError *error) {
            
        } view:self.view];
    
}
-(void)InsertTargetVisitNetWorking{
//升级目标客户
    NSString *uStr =[NSString stringWithFormat:@"%@shop/InsertTargetVisit.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic= @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"shopId":_shopid,@"RoleId":self.strId,@"UsersName":_storepersonnel};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            _visiId = [[NSString alloc]init];
            _visiId =[responseObject valueForKey:@"TargetVisitId"];
            PWAlertView *yishengji = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"已升级,现在去填写目标客户表" sureBtn:@"以后再说" cancleBtn:@"现在就去"];
            yishengji.resultIndex = ^(NSInteger index) {
                if (index == 1) {
                 
                    TargetTableViewController *ttvc = [[TargetTableViewController alloc]init];
                    ttvc.OldTargetVisitId = _visiId;
                    ttvc.isofyou = NO;
                    ttvc.strId = self.strId;
                    ttvc.cellend = NO;
                    [self.navigationController pushViewController:ttvc animated:YES];

                }
            };
            [yishengji showMKPAlertView];
            
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
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1111"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"升级失败" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"店铺当前级别不能升级为目标客户" andInterval:1.0];
        }

    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)InsertIntendedNetWorking{
//升级意向客户
    NSString *uStr =[NSString stringWithFormat:@"%@shop/InsertIntended.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic= @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"shopId":_shopid,@"BrandBusiness":_brandBusin,@"StoreLevel":_clascation,@"RoleId":self.strId,@"UsersName":_storepersonnel};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            _visiId = [[NSString alloc]init];
            _visiId =[responseObject valueForKey:@"IntendedId"];
            PWAlertView *yishengji = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"已升级,现在去填写意向客户表" sureBtn:@"以后再说" cancleBtn:@"现在就去"];
            yishengji.resultIndex = ^(NSInteger index) {
                if (index == 1) {
                   
                    InterestedTabelViewController *intabel = [[InterestedTabelViewController alloc]init];
                    intabel.intentionId =_visiId;
                    intabel.strId = _strId;
                    NSLog(@"%@,%@",_visiId,_strId);
                    [self.navigationController pushViewController:intabel animated:YES];

                }
            };
            [yishengji showMKPAlertView];
            
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
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1111"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"升级失败" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"店铺当前级别不能升级为意向客户" andInterval:1.0];
        }  

        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
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
