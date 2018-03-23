//
//  AddAssistant.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/28.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AddAssistant.h"
#import "ZZYPhotoHelper.h"
#import "DongImage.h"
#import "UIViewDatePicker.h"
#import "DPYJViewController.h"
#import "specialty.h"
@interface AddAssistant()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIViewDatePickerDelegate>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic ,retain)NSMutableArray *nameArrs;

@property (nonatomic,strong)UIImageView *TXImage;
@property (nonatomic,strong) NSString *logImage;//头像地址
@property (nonatomic,strong) UILabel *DayLabel;//出生日期
@property (nonatomic,strong)NSMutableArray *ligary;
@property (nonatomic,strong)NSMutableArray *texttagary;
@property (nonatomic,strong)NSMutableArray *nsmuary;

@property (nonatomic,strong) NSString *namestr;//姓名
@property (nonatomic,strong) NSString *agestr;//年龄

@property (nonatomic,strong) NSString *HobbyStr;//爱好
@property (nonatomic,strong) NSString *FeatureStr;//性格
@property (nonatomic,strong) NSString *iphonestr;//电话
@property (nonatomic,strong) NSString *Specialty;//特长
@property (nonatomic,strong) NSString *OverallMerit;//评价
@property (nonatomic,strong) NSString *flaig;//阴--阳---历

@property (nonatomic,strong) NSString *SolarBirthday;
@property (nonatomic,strong) NSString *LunarBirthday;

@end

@implementation AddAssistant

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店员信息";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
      [self nsstringallocinit];
    if ([_shopname isEqualToString:@"1"]) {
        [self AFNetworking];
    }else{
        if (self.issssend == NO) {
            UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
            [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = rightitem;
            [self AFNetworking];
        }else{
            UIButton *rightitem = [UIButton buttonWithType:UIButtonTypeCustom];
            rightitem.frame =CGRectMake(self.view.frame.size.width-30, 0, 28,28);
            [rightitem setBackgroundImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
            [rightitem addTarget: self action: @selector(rightItemAction:) forControlEvents: UIControlEventTouchUpInside];
            UIBarButtonItem *rbuttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightitem];
            self.navigationItem.rightBarButtonItem = rbuttonItem;
        }
    }
    
    
   _nameArrs = [[NSMutableArray alloc]initWithObjects:@[@"照片"],@[@"姓名",@"年龄",@"生日",@"爱好",@"性格",@"电话",@"特长",@"综合研判"], nil];
    _ligary = [[NSMutableArray alloc]initWithObjects:@[@""],@[@"填写姓名",@"填写年龄",@"填写生日",@"填写爱好",@"填写性格",@"填写电话"], nil];
    _texttagary = [[NSMutableArray alloc]initWithObjects:@[@""],@[@"0",@"1",@"2",@"3",@"4",@"5"], nil];
    [self addViewremind];
  
}
-(void)AFNetworking{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectstore.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.shopid,@"store":@"3",@"StoreClerkId":self.StoreClerkId};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            
            NSArray *array=[responseObject valueForKey:@"list"];
           _nsmuary = [[NSMutableArray alloc]init];
            _logImage = [[NSString alloc]init];
            for (NSDictionary *dict in array) {
                [_nsmuary addObject:[dict valueForKey:@"name"]];
                _namestr = [dict valueForKey:@"name"];
                
                _agestr = [dict valueForKey:@"age"];
                if ([_agestr isEqual:[NSNull null]]) {
                    _agestr=@"";
                    [_nsmuary addObject:@""];
                }else{
                    [_nsmuary addObject:[dict valueForKey:@"age"]];
                }
                NSInteger k ;
                if ([[dict valueForKey:@"flag"]isEqual:[NSNull null]]) {
                    k=0;
                }else{
                    k=  [[dict valueForKey:@"flag"] integerValue];
                }
               
                NSString *stringInt = [NSString stringWithFormat:@"%ld",k];
                _flaig = stringInt;
                _LunarBirthday = [dict valueForKey:@"lunarBirthday"];
                _SolarBirthday = [dict valueForKey:@"solarBirthday"];
                if ([stringInt isEqualToString:@"1"]) {
                    [_nsmuary addObject:[dict valueForKey:@"lunarBirthday"]];
                }else if ([stringInt isEqualToString:@"0"]){
                     [_nsmuary addObject:@""];
                }else{
                    [_nsmuary addObject:[dict valueForKey:@"solarBirthday"]];
                }
                _logImage = [dict valueForKey:@"photo"];
                [_nsmuary addObject:[dict valueForKey:@"hobby"]];
                _HobbyStr = [dict valueForKey:@"hobby"];
                [_nsmuary addObject:[dict valueForKey:@"feature"]];
                _FeatureStr = [dict valueForKey:@"feature"];
                
                
                _iphonestr = [dict valueForKey:@"phone"];
                if ([_iphonestr isEqual:[NSNull null]]) {
                    _iphonestr=@"";
                    [_nsmuary addObject:@""];
                }else{
                    [_nsmuary addObject:[dict valueForKey:@"phone"]];
                }
                
                
                [_nsmuary addObject:[dict valueForKey:@"specialty"]];
                _Specialty = [dict valueForKey:@"specialty"];
                [_nsmuary addObject:[dict valueForKey:@"overallMerit"]];
                _OverallMerit =[dict valueForKey:@"overallMerit"];
            }
            [_tableView reloadData];
            NSLog(@"%@",_nsmuary);
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
-(void)nsstringallocinit{
    _namestr = [[NSString alloc]init];//姓名
    _agestr= [[NSString alloc]init];//年龄
    
    _logImage = [[NSString alloc]init];
    _HobbyStr= [[NSString alloc]init];//爱好
    _FeatureStr= [[NSString alloc]init];//性格
    _iphonestr= [[NSString alloc]init];//电话
    _Specialty= [[NSString alloc]init];//特长
    _OverallMerit= [[NSString alloc]init];//评价
    _flaig= [[NSString alloc]init];
    _SolarBirthday = [[NSString alloc]init];
    _LunarBirthday = [[NSString alloc]init];
    
}
-(void)addViewremind{
    self.tableView= [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    NSString* phoneModel = [UIDevice devicePlatForm];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        self.tableView.frame =CGRectMake(0,88,self.view.bounds.size.width,self.view.bounds.size.height-50);
    }else{
        self.tableView.frame =CGRectMake(0,65,self.view.bounds.size.width,self.view.bounds.size.height-50);
    }
    self.tableView.dataSource=self;
    self.tableView.delegate =self;
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
}
-(void)rightItemAction:(UIBarButtonItem *)btn{
    if ([btn.title isEqualToString:@"编辑"]) {
        btn.title = @"完成";
        self.issssend = YES;
        [self.tableView reloadData];
        NSLog(@"编辑");
    }else if ([btn.title isEqualToString:@"完成"]){
        NSLog(@"完成");
        [self updateStoreClerk1:btn];
    }else{
        NSLog(@"提交");
        [self insertStoreClerk:btn];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 2:
            
            //[self showDatePicker];
        {
            UIViewDatePicker *datePick = [[UIViewDatePicker alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
            datePick.delegate = self;
            [self.view endEditing:YES];
            [self.view.window addSubview:datePick];
            datePick.blcokStrrrr = ^(NSString *content, NSString *oldcontent, NSString *flag) {
                NSLog(@"222---%@----%@----%@",content,oldcontent,flag);
                _flaig = [[NSString alloc]init];
                _flaig = flag;
                _SolarBirthday = content;
                _LunarBirthday = oldcontent;
                if ([_flaig isEqualToString:@"1"]) {
                    //阴历 == 农历
                    _DayLabel.text = oldcontent;
                    
                }else{
                    //阳历 ==公历
                    _DayLabel.text = content;
                }
            };
            
        }
            break;
        case 6:{
            specialty *spVC = [[specialty alloc]init];
            spVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            spVC.modifi = _issssend;
            spVC.dateStr = _nsmuary[indexPath.row]; //特长
            spVC.blcokStr = ^(NSString *content,int num) {
                if (num == 6) {
                    if (_issssend==YES) {
                         _Specialty = content;
                    }
                   
                }
                
            };
            [self.navigationController pushViewController:spVC animated:YES];
        }
            break;
        case 7:
        {
            DPYJViewController *targetVC=[[DPYJViewController alloc]init];
            targetVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            targetVC.dateStr = _nsmuary[indexPath.row]; //点评建议
            targetVC.modifi = _issssend;//可否编辑
            targetVC.blcokStr=^(NSString *content,int num){
                if (num==7) {
                    if (_issssend == YES) {
                        _OverallMerit = content;
                    }
                    //同事协助须知
                    
                }
            };
            [self.navigationController pushViewController:targetVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)insertStoreClerk:(UIBarButtonItem *)btn{
    if ([_namestr isEqualToString:@""]) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写姓名" andInterval:1.0];
        
    }else{
        NSString *uStr =[NSString stringWithFormat:@"%@shop/insertStoreClerk.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSDictionary *dict=@{@"appkey":apKeyStr,
                             @"usersid":[USER_DEFAULTS  objectForKey:@"userid"],
                             @"flag":_flaig,
                             @"SolarBirthday":_SolarBirthday,
                             @"LunarBirthday":_LunarBirthday,
                             @"Storeid":self.shopid,
                             @"Name":_namestr,
                             @"Age":_agestr,
                             @"Hobby":_HobbyStr,
                             @"Feature":_FeatureStr,
                             @"Specialty":_Specialty,
                             @"OverallMerit":_OverallMerit,
                             @"Phone":_iphonestr};
        NSData *pictureData = UIImagePNGRepresentation(self.TXImage.image);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"image/gif",@"image/tiff",@"application/octet-stream",@"text/json",nil];
        [manager POST:uStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSUTF8StringEncoding error:nil];
            NSString *status =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"status"]];
            
            if ([status isEqualToString:@"0000"]) {
                
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"上传成功" andInterval:1.0];
                
                
                [self.tableView reloadData];
                
            } else {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"上传失败" andInterval:1.0];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80.0f;
    }else{
            return 50.0f;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nameArrs[section]count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 10;
    }
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _nameArrs.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"gameeCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifi];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *tlelabel = [[UILabel alloc]init];
    if (indexPath.section == 0) {
        tlelabel.frame = CGRectMake(10, 25, 50, 30);
    }else{
        tlelabel.frame = CGRectMake(10, 10, 110, 30);
    }
    tlelabel.text =  _nameArrs[indexPath.section][indexPath.row];
    tlelabel.font = [UIFont systemFontOfSize:15.0f];
    [cell addSubview:tlelabel];
    
    if (indexPath.section == 0) {
        
        _TXImage = [[UIImageView alloc]initWithFrame:CGRectMake(120, 15, 50, 50)];
        if (_logImage.length<1) {
            _TXImage.image = [UIImage imageNamed:@"tjtx"];
        }else{
            [_TXImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,_logImage]] placeholderImage:[UIImage  imageNamed:@"tjtx"]];
        }
        _TXImage.backgroundColor = [UIColor whiteColor];
        _TXImage.layer.masksToBounds = YES;
        _TXImage.layer.cornerRadius = 25.0;//设置圆角
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPage3:)];
        tapGesturRecognizer.numberOfTapsRequired = 1; //设置单击几次才触发方法
        [_TXImage addGestureRecognizer:tapGesturRecognizer];
        _TXImage.userInteractionEnabled = YES;
        [cell addSubview:_TXImage];
    }else{
        if (indexPath.row>5) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
        }else{
            cell.userInteractionEnabled = _issssend;
            if(indexPath.row==2){
                [_DayLabel removeFromSuperview];
                _DayLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 1, self.view.bounds.size.width-170, 48)];
                if (self.StoreClerkId ==nil) {
                    _DayLabel.text = [NSString stringWithFormat:@"%@",_ligary[indexPath.section][indexPath.row]];
                    _DayLabel.tintColor = [UIColor lightGrayColor];
                }else{
                     _DayLabel.text = _nsmuary[indexPath.row];
                }
                
                [cell addSubview:_DayLabel];
               
               
                _DayLabel.font = [UIFont boldSystemFontOfSize:13.0f];
            }else{
                //老板姓名
                UITextField *bossname = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
                bossname.placeholder = _ligary[indexPath.section][indexPath.row];
                bossname.font = [UIFont systemFontOfSize:14.0f];
                placeholder(bossname);
                NSInteger k = [_texttagary[indexPath.section][indexPath.row] integerValue];
                bossname.tag = k;
                bossname.delegate = self;
                [bossname addTarget:self action:@selector(PersonFieldText:) forControlEvents:UIControlEventEditingChanged];
                bossname.enabled = self.issssend;
                //bossname.text = _InfonAry[indexPath.section][indexPath.row];
                [cell addSubview:bossname];
                if (self.StoreClerkId ==nil) {
                   
                }else{
                    if (indexPath.row ==1) {
                        if ([_agestr isEqual:@""]) {
                            
                        }else{
                            NSInteger k = [_nsmuary[indexPath.row] integerValue];
                            NSString *stringInt = [NSString stringWithFormat:@"%ld",k];
                            bossname.text = stringInt;
                        }
                    }else if(indexPath.row==5){
                        if ([_iphonestr isEqual:@""]) {
                            
                        }else{
                            NSInteger k = [_nsmuary[indexPath.row] integerValue];
                            NSString *stringInt = [NSString stringWithFormat:@"%ld",k];
                            bossname.text = stringInt;
                        }
                        
                    }else{
                        bossname.text = _nsmuary[indexPath.row];
                    }
                    
                }
            }
        }
        
    }
    
    
    return cell;
}
-(void)updateStoreClerk1:(UIBarButtonItem *)btn{
    if ([_namestr isEqualToString:@""]) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写姓名" andInterval:1.0];
    }else{
        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"内容已修改，提交将覆盖是否提交？" sureBtn:@"确认" cancleBtn:@"取消"];
        alertView.resultIndex = ^(NSInteger index){
            if (index ==2) {
                NSString *uStr =[NSString stringWithFormat:@"%@shop/updateStoreClerk1.action",KURLHeader];
                NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
                NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
                NSDictionary *dict=@{@"appkey":apKeyStr,
                                     @"usersid":[USER_DEFAULTS  objectForKey:@"userid"],
                                     @"flag":_flaig,
                                     @"SolarBirthday":_SolarBirthday,
                                     @"LunarBirthday":_LunarBirthday,
                                     @"Storeid":self.shopid,
                                     @"Name":_namestr,
                                     @"Age":_agestr,
                                     @"Hobby":_HobbyStr,
                                     @"Feature":_FeatureStr,
                                     @"Specialty":_Specialty,
                                     @"OverallMerit":_OverallMerit,
                                     @"Phone":_iphonestr,
                                     @"RoleId":self.strId,
                                     @"id":self.StoreClerkId
                                     };
                NSData *pictureData = UIImagePNGRepresentation(self.TXImage.image);
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"image/gif",@"image/tiff",@"application/octet-stream",@"text/json",nil];
                [manager POST:uStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
                    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSUTF8StringEncoding error:nil];
                    NSString *status =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"status"]];
                    
                    if ([status isEqualToString:@"0000"]) {
                        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"修改成功" sureBtn:@"确认" cancleBtn:nil];
                        alertView.resultIndex = ^(NSInteger index){
                            btn.title =@"编辑";
                            self.issssend = NO;
                            [self.tableView reloadData];
                        };
                        [alertView showMKPAlertView];
                    } else {
                        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改失败" andInterval:1.0];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
            }
        };
        [alertView showMKPAlertView];
        
        
    }
    
}
-(void)tapPage3:(UITapGestureRecognizer*)sender
{
        if (self.issssend==NO) {
            NSLog(@"头像放大");
            [DongImage showImage:_TXImage];
    }else{
        [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
        _TXImage.image = (UIImage *)data;
        }];
    }
    
}
- (void)PersonFieldText:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
            _namestr = textField.text;
            break;
        case 1:
            _agestr = textField.text;
            break;
        case 3:
            _HobbyStr = textField.text;
            break;
        case 4:
            _FeatureStr = textField.text;
            break;
        case 5:
            _iphonestr = textField.text;
            break;
        default:
            break;
    }
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
