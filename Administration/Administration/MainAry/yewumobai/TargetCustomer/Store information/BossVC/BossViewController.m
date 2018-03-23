//
//  BossViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BossViewController.h"
#import "ZZYPhotoHelper.h"
#import "DPYJViewController.h"
#import "BossHome.h"
#import "DongImage.h"
@interface BossViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,strong) NSString *logImage;//头像地址

@property (nonatomic,strong)NSMutableArray *leftary;
@property (nonatomic,strong)NSMutableArray *ligary;
@property (nonatomic,strong)NSMutableArray *texttagary;
@property (nonatomic,strong)NSString *Name;//名字
@property (nonatomic,strong)NSString *Phone;//电话
@property (nonatomic,strong)NSString *QCode;//qq
@property (nonatomic,strong)NSString *WCode;//微信
@property (nonatomic,strong)NSString *Age;//年龄
@property (nonatomic,strong)NSString *SolarBirthday;//阳历
@property (nonatomic,strong)NSString *LunarBirthday;//阴历
@property (nonatomic,strong)NSString *flag;//1阴历 2 阳历
@property (nonatomic,strong)NSString *Hobby;//爱好
@property (nonatomic,strong)NSString *ReviewsProposal;//点评建议
@property (nonatomic,strong)UIImageView *TXImage;

@property (nonatomic,strong)NSMutableArray *InfonAry;

@property (nonatomic,strong)NSMutableArray *iphoneAry;

@property (nonatomic,strong) NSString *BossId;//boosid

@end
BOOL isend;
@implementation BossViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"老板信息";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    _leftary = [[NSMutableArray alloc]initWithObjects:@[@"照片"],@[@"老板姓名",@"老板电话",@"QQ",@"微信",@"年龄",@"生日",@"家庭情况",@"爱好",@"点评建议"], nil];
    _ligary = [[NSMutableArray alloc]initWithObjects:@[@""],@[@"填写老板姓名",@"",@"填写QQ号",@"填写微信",@"填写年龄",@"选择生日",@"",@"填写爱好",@""], nil];
    _texttagary = [[NSMutableArray alloc]initWithObjects:@[@""],@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"], nil];
    [self AFnetworking];
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
    if ([self.shopname isEqualToString:@"1"]) {
        
    }else{
        if (isend ==YES) {
            UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
            [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = rightitem;
        }else{
            UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
            [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = rightitem;
        }
        
        
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    UILabel *tlelabel = [[UILabel alloc]init];
    if (indexPath.section == 0) {
        tlelabel.frame = CGRectMake(10, 25, 50, 30);
    }else{
         tlelabel.frame = CGRectMake(10, 10, 110, 30);
    }
    tlelabel.text = _leftary[indexPath.section][indexPath.row];
    tlelabel.font = [UIFont systemFontOfSize:15.0f];
    [cell addSubview:tlelabel];
    
    if (indexPath.section == 0) {
        _TXImage = [[UIImageView alloc]initWithFrame:CGRectMake(120, 15, 50, 50)];
        if (_logImage.length<1) {
            if (isend==YES) {
                _TXImage.image = [UIImage imageNamed:@"tjtx"];
            }else{
                _TXImage.image = [UIImage imageNamed:@"tx100"];
            }
            
        }else{
            [_TXImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,_logImage]] placeholderImage:[UIImage  imageNamed:@"tx100"]];
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
        if (indexPath.row == 0) {
            //老板姓名
            UITextField *bossname = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
            bossname.placeholder = _ligary[indexPath.section][indexPath.row];
            bossname.font = [UIFont systemFontOfSize:14.0f];
            placeholder(bossname);
            bossname.tag = 1;
            bossname.delegate = self;
            [bossname addTarget:self action:@selector(PersonFieldText:) forControlEvents:UIControlEventEditingChanged];
            bossname.enabled = isend;
            bossname.text = _Name;
            [cell addSubview:bossname];
        }else if (indexPath.row == 1){
            
            if (_iphoneAry.count>1) {
                for (int i= 0; i<_iphoneAry.count; i++) {
                    UILabel *iphonelabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5+(i*21), Scree_width-120-80, 19)];
                    iphonelabel.text = [NSString stringWithFormat:@"电话%d     %@",i+1,_iphoneAry[i]];
                    iphonelabel.font = [UIFont systemFontOfSize:14];
                    [cell addSubview:iphonelabel];
                    UIView *whiview =[[UIView alloc]initWithFrame:CGRectMake(120, 5+(i*20), Scree_width-120-100, 1)];
                    whiview.backgroundColor = [UIColor lightGrayColor];
                    if (i>0) {
                         [cell addSubview:whiview];
                    }
                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width-80, 5+(i*20), 19, 19)];
                    [button setImage:[UIImage imageNamed:@"xx_ico01"] forState:UIControlStateNormal];
                     [button addTarget: self action: @selector(deleiphone) forControlEvents: UIControlEventTouchUpInside];
                    button.enabled = isend;
                    button.hidden = isend;
                    [cell.contentView addSubview:button];
                }
            }else{
                if (_iphoneAry.count ==0) {
                    
                }else{
                    UILabel *iphonelabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, cell.width-120-80,30)];
                    if ([_iphoneAry[0]isEqualToString:@""]) {
                        
                    }else{
                        iphonelabel.text = [NSString stringWithFormat:@"电话 %@",_iphoneAry[0]];
                    }
                    
                    iphonelabel.font = [UIFont systemFontOfSize:14];
                    [cell addSubview:iphonelabel];
                    
                }
            }
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40, (cell.height/2)-7.5, 15, 15)];
            [btn setImage:[UIImage imageNamed:@"tjdh"] forState:UIControlStateNormal];
            
            [btn addTarget: self action: @selector(addiphone) forControlEvents: UIControlEventTouchUpInside];
            btn.enabled = isend;
            [cell addSubview:btn];
        }else if(indexPath.row<6){
            
            UITextField *bossname = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
            bossname.placeholder = _ligary[indexPath.section][indexPath.row];
            bossname.font = [UIFont systemFontOfSize:14.0f];
            placeholder(bossname);
            NSInteger k = [_texttagary[indexPath.section][indexPath.row] integerValue];
            bossname.tag = k;
            bossname.delegate = self;
            [bossname addTarget:self action:@selector(PersonFieldText:) forControlEvents:UIControlEventEditingChanged];
            bossname.enabled = isend;
           
            [cell addSubview:bossname];
            if (indexPath.row ==5) {
                //生日提醒
            }else if(indexPath.row ==2){
                //qq
                bossname.text = _QCode;
            }else if(indexPath.row ==3){
                //微信
                bossname.text = _WCode;
            }else if(indexPath.row ==4){
                //年龄
                bossname.text = _Age;
            }
        }else if (indexPath.row ==7){
            //老板爱好
            UITextField *bossname = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
            bossname.placeholder = _ligary[indexPath.section][indexPath.row];
            bossname.font = [UIFont systemFontOfSize:14.0f];
            placeholder(bossname);
            NSInteger k = [_texttagary[indexPath.section][indexPath.row] integerValue];
            bossname.tag = k;
            bossname.delegate = self;
            [bossname addTarget:self action:@selector(PersonFieldText:) forControlEvents:UIControlEventEditingChanged];
            bossname.enabled = isend;
            bossname.text = _Hobby;
            [cell addSubview:bossname];

        }else{
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
        }
    }
    return cell;
}
-(void)deleiphone{
    //删除电话
}
-(void)addiphone{
    UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"添加老板电话" message:nil
                                                     delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alerView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        UITextField *textF = [alertView textFieldAtIndex:0];
        if (textF.text.length==0) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"输入内容不能为空" andInterval:1.0];
            return;
        }else
        {
            [_iphoneAry addObject:textF.text];
            //刷新cell
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:1];
            [self.tableView beginUpdates];
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
 
        }
    }
}
- (void)PersonFieldText:(UITextField *)textField{
    switch (textField.tag) {
        case 1:
            _Name = textField.text;
            _InfonAry[2][textField.tag] = _Name;
            break;
        case 2:
            _QCode =textField.text;
             NSLog(@"_QCode:%@",_QCode);
            _InfonAry[2][textField.tag] = _QCode;
            break;
        case 3:
            _WCode =textField.text;
             _InfonAry[2][textField.tag] = _WCode;
            break;
        case 4:
            _Age = textField.text;
             _InfonAry[2][textField.tag] = _Age;
            break;
        case 7:
            _Hobby = textField.text;
             _InfonAry[2][textField.tag] = _Hobby;
            break;
        
        default:
            break;
    }
}

-(void)tapPage3:(UITapGestureRecognizer*)sender
{
    if (isend==NO) {
        NSLog(@"头像放大");
        [DongImage showImage:_TXImage];
    }else{
        [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
            _TXImage.image = (UIImage *)data;
        }];
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        if (indexPath.row ==5) {
            //生日
        }else if (indexPath.row ==6) {
            BossHome *bhvc = [[BossHome alloc]init];
            bhvc.bossid = _BossId;
            bhvc.strId = self.strId;
            bhvc.shopname = self.shopname;
            [self.navigationController pushViewController:bhvc animated:YES];
        }else if (indexPath.row==8){
            DPYJViewController *targetVC=[[DPYJViewController alloc]init];
            targetVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
           targetVC.dateStr = _ReviewsProposal; //点评建议
            targetVC.modifi = isend;//可否编辑
            targetVC.blcokStr=^(NSString *content,int num){
                if (num==8) {
                    if (isend == YES) {
                        _ReviewsProposal = content;
                    }
                    //同事协助须知
                    
                }
            };
            [self.navigationController pushViewController:targetVC animated:YES];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80.0f;
    }else{
        if(indexPath.row ==1){
            if (_iphoneAry.count==0) {
                return 50.0f;
            }else if(_iphoneAry.count>1){
              return 25*_iphoneAry.count;
            }else{
                return 50.0f;
            }
        }else{
            return 50.0f;
        }
        
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_leftary[section]count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _leftary.count;
}
-(void)rightItemAction:(UIBarButtonItem*)sender{
    if (isend==YES) {
        if (_BossId==nil) {
            //添加老板信息
            [self addupdateBoss:sender];
        }else{
            //修改老板信息
            [self updeteBoss:sender];
        }
        
        
    }else{
        isend = YES;
        [sender setTitle:@"完成"];
        [self.tableView reloadData];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    view.tintColor = GetColor(230,230,230,1);
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor grayColor];
    header.textLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
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
-(void)AFnetworking{
    //storeid 门店id  store 2
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectstore.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.Storeid,@"store":@"2"};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            //NSArray *array=[responseObject valueForKey:@"Boss"];
            _InfonAry = [NSMutableArray array];
            NSArray *image =[[NSArray alloc]init];
            [_InfonAry addObject:image];
            
            _Name = [[NSString alloc]init];
            _Phone = [[NSString alloc]init];
            _QCode = [[NSString alloc]init];
            _WCode = [[NSString alloc]init];
            _Age = [[NSString alloc]init];
            _SolarBirthday = [[NSString alloc]init];
            _LunarBirthday = [[NSString alloc]init];
            _logImage = [[NSString alloc]init];
            _flag = [[NSString alloc]init];
            _Hobby = [[NSString alloc]init];
            _ReviewsProposal = [[NSString alloc]init];
            _BossId = [[NSString alloc]init];
            _iphoneAry = [[NSMutableArray alloc]init];
            
          NSDictionary *dict =[responseObject valueForKey:@"Boss"];
            NSMutableArray *infr= [NSMutableArray array];
            
            
            _BossId = [dict valueForKey:@"id"];
            
                _logImage        = [dict valueForKey:@"photo"];
            
                _Name            = [dict valueForKey:@"name"];
          
            if (_Name ==nil) {
                [infr addObject:@""];
                _Name = @"";
            }else{
                [infr addObject:_Name];
            }
            
            
            
//----------------------------------------
                _Phone           = [dict valueForKey:@"Phone"];
            if (_Phone ==nil) {
                _Phone = @"";
                [infr addObject:@""];
            }else{
                [infr addObject:_Phone];
            }
            NSArray *array = [[NSArray alloc]init];
            array =[_Phone componentsSeparatedByString:@","];
            
            for (int i = 0; i<array.count; i++) {
                [_iphoneAry addObject:array[i]];
            }
            
//------------
            
                _QCode           =[dict valueForKey:@"qcode"];
            if ([_QCode isKindOfClass:[NSNull class]]) {
                [infr addObject:@""];
            }else{
                NSString * str = [dict[@"qcode"] description];
                [infr addObject:str ];
            }
            
                _WCode           = [dict valueForKey:@"wcode"];
           
            if ([_WCode isKindOfClass:[NSNull class]]) {
                [infr addObject:@""];
                _WCode = @"";
            }else{
                [infr addObject:_WCode];
            }
                _Age             = [dict valueForKey:@"age"];
            
            if ([_Age isKindOfClass:[NSNull class]]) {
                [infr addObject:@""];
            }else{
                NSString * str = [dict[@"age"] description];
                [infr addObject:str];
            }
            
             _flag            = [dict valueForKey:@"flag"];
            if ([_ReviewsProposal isKindOfClass:[NSNull class]]) {
                _flag = @"";
            }
            _SolarBirthday   =  [dict valueForKey:@"solarBirthday"];
            _LunarBirthday   = [dict valueForKey:@"lunarBirthday"];
            if ([_flag isKindOfClass:[NSNull class]] ) {
                _flag = @"";
                [infr addObject:@""];
            }else{
                if ([_flag isEqualToString:@"1"]) {
                   
                    if (_LunarBirthday ==nil) {
                        [infr addObject:@""];
                    }else{
                        [infr addObject:_LunarBirthday];
                    }
                }else{
                    
                    if (_SolarBirthday ==nil) {
                        [infr addObject:@""];
                    }else{
                        [infr addObject:_SolarBirthday];
                    }
                }
            }
            
            [infr addObject:@""];
                _Hobby           = [dict valueForKey:@"hobby"];
           
            if (_Hobby ==nil) {
                [infr addObject:@""];
            }else{
                [infr addObject:_Hobby];
            }
                _ReviewsProposal = [dict valueForKey:@"reviewsProposal"];
            
            if ([_ReviewsProposal isKindOfClass:[NSNull class]]) {
                _ReviewsProposal = @"";
                [infr addObject:_ReviewsProposal];
            }else{
                [infr addObject:_ReviewsProposal];
            }
            
            [_InfonAry addObject:infr];
            isend = NO;
            [self addViewremind];
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
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
            if ([self.shopname isEqualToString:@"1"]) {
                 isend = NO;
            }else{
                isend = YES;
            }
           
            [self addViewremind];
            _Name = [[NSString alloc]init];
            _Name = @"";
            _Phone = [[NSString alloc]init];
            _QCode = [[NSString alloc]init];
            _WCode = [[NSString alloc]init];
            _Age = [[NSString alloc]init];
            _SolarBirthday = [[NSString alloc]init];
            _LunarBirthday = [[NSString alloc]init];
            _logImage = [[NSString alloc]init];
            _flag = [[NSString alloc]init];
            _Hobby = [[NSString alloc]init];
            _ReviewsProposal = [[NSString alloc]init];
            _BossId = [[NSString alloc]init];
            _iphoneAry = [[NSMutableArray alloc]init];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}
-(void)addupdateBoss:(UIBarButtonItem*)sender{
    //添加老板信息
    NSString *uStr =[NSString stringWithFormat:@"%@shop/insertStoreBoss.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Name":_Name,@"Phone":_Phone,@"QCode":_QCode,@"Wcode":_WCode,@"Age":_Age,@"SolarBirthday":_SolarBirthday,@"LunarBirthday":_LunarBirthday,@"flag":_flag,@"Hobby":_Hobby,@"ReviewsProposal":_ReviewsProposal,@"Storeid":self.Storeid};
    NSData *pictureData = UIImagePNGRepresentation(self.TXImage.image);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"image/gif",@"image/tiff",@"application/octet-stream",@"text/json",nil];
    [manager POST:uStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
            isend = NO; 
           [sender setTitle:@"编辑"];
            _BossId =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"storeBossid"]];
            
            [self.tableView reloadData];
           
        } else {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"图片上传失败" andInterval:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}
-(void)updeteBoss:(UIBarButtonItem*)sender{
    //修改老板信息
    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"内容已修改，提交将覆盖是否提交？" sureBtn:@"确认" cancleBtn:@"取消"];
    alertView.resultIndex = ^(NSInteger index){
        if (index ==2) {
            NSString *uStr =[NSString stringWithFormat:@"%@shop/updateStoreBoss1.action",KURLHeader];
            NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
            NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
            NSDictionary *dic = [[NSDictionary alloc]init];
            dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.Storeid,@"store":@"2",@"Name":_Name,@"Phone":_Phone,@"QCode":_QCode,@"Wcode":_WCode,@"Age":_Age,@"SolarBirthday":_SolarBirthday,@"LunarBirthday":_LunarBirthday,@"flag":_flag,@"Hobby":_Hobby,@"ReviewsProposal":_ReviewsProposal,@"id":_BossId};
            NSData *pictureData = UIImagePNGRepresentation(self.TXImage.image);
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"image/gif",@"image/tiff",@"application/octet-stream",@"text/json",nil];
            [manager POST:uStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
                    isend = NO;
                    [sender setTitle:@"编辑"];
                    
                    [self.tableView reloadData];
                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改成功" andInterval:1.0];
                    
                    
                } else {
                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"图片上传失败" andInterval:1.0];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
    };
    [alertView showMKPAlertView];
    
    
}
@end
