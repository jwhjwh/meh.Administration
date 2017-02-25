//
//  EditDataViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "EditDataViewController.h"
#import "EditModel.h"


@interface EditDataViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
}
@property (strong,nonatomic) NSMutableArray *InterNameAry;

@property (nonatomic,retain)UIButton *masgeButton; //编辑提交按钮

@property (nonatomic,strong) UITextField *text1;//编辑

@property (nonnull,strong)NSString *Role;

@property (nonatomic,assign) BOOL hide;
@property (nonatomic,assign) BOOL Open;

@end

@implementation EditDataViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_masgeButton removeFromSuperview];
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"编辑资料";
     _Open = NO;
    [self InterTableUI];
    [self loadDataFromServer];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setExtraCellLineHidden:tableview];
    // Do any additional setup after loading the view.
}
-(void)InterTableUI
{
    _masgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _masgeButton.frame = CGRectMake(Scree_width - 12-36,4,40,36);
    _masgeButton.tag=1;
    [_masgeButton addTarget:self action:@selector(masgeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_masgeButton setTitle:@"编辑" forState:UIControlStateNormal];
   
    [self.navigationController.navigationBar addSubview:_masgeButton];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height+64) style:UITableViewStylePlain];
    tableview.scrollEnabled =YES;
    tableview.dataSource=self;
    tableview.delegate =self;
    [self.view addSubview:tableview];
    
    
}
-(void)masgeClick:(UIButton*)sender{
    
    
    if (sender.tag==2) {
        sender.tag=1;
        [_masgeButton setTitle:@"编辑" forState:UIControlStateNormal];
        _Open = NO;
        
        _text1.userInteractionEnabled  = NO;
        NSLog(@"🐷🐷🐷🐷伟昊");
    }else{
        sender.tag=2;
        [_masgeButton setTitle:@"完成" forState:UIControlStateNormal];
        
        _Open = YES;
          _text1.userInteractionEnabled  = YES;
        NSLog(@"🐷伟昊");
    }
}

-(void)loadDataFromServer{
    NSString *uStr =[NSString stringWithFormat:@"%@user/queryUserInfo.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        NSLog(@"+++++++++++%@",responseObject);
        _InterNameAry=[NSMutableArray array];
      if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
              EditModel *model = [[EditModel alloc]init];
              [model setValuesForKeysWithDictionary:responseObject[@"userInfo"]];
          model.birthday = [model.birthday substringToIndex:10];
           _Role = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"roleId"]];
          NSLog(@"role::%@",_Role);
         int roleId = [_Role intValue];
          switch (roleId) {
              case 0:
                  model.rname = @"老板";
                  break;
              case 2:
                  model.rname = @"市场美导";
                  break;
              case 3:
                  model.rname = @"内勤";
                  break;
              case 4:
                  model.rname = @"物流";
                  break;
              case 5:
                  model.rname = @"业务人员";
                  break;
              case 6:
                  model.rname = @"品牌经理";
                  break;
              case 7:
                  model.rname = @"行政";
                  break;
              case 8:
                  model.rname = @"业务经理";
                  break;
                  
              default:
                  break;
          }
          if ([model.roleId isEqualToString:@"6"]||[model.roleId isEqualToString:@"2"]) {
              NSArray *arr=@[model.account,model.rname,model.brandName,];
              NSArray *arr1=@[model.name,model.birthday,model.age,model.idNo,model.address];
              NSArray *arr2=@[model.account,model.wcode,model.qcode];
              NSArray *arr3=@[model.interests,model.sdasd];
              _InterNameAry = [[NSMutableArray alloc]initWithObjects:arr,arr1,arr2,arr3,nil];
          }else{
              NSArray *arr=@[model.account,model.rname];
              NSArray *arr1=@[model.name,model.birthday,model.age,model.idNo,model.address];
              NSArray *arr2=@[model.account,model.wcode,model.qcode];
              NSArray *arr3=@[model.interests,model.sdasd];
              _InterNameAry = [[NSMutableArray alloc]initWithObjects:arr,arr1,arr2,arr3,nil];
          }
          [tableview reloadData];
       } else {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"网络错误" andInterval:1.0];
       }
    }
               failure:^(NSError *error) {
              }
                 view:self.view MBPro:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _InterNameAry.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if ([_Role isEqualToString:@"6"]||[_Role isEqualToString:@"2"]) {
                return 3;
            }else{
            return 2;
            }
            
            break;
        case 2:
            return 5;
            break;
        case 3:
            return 3;
            break;
        case 4:
            return 2;
            break;
            
        default:
            break;
    }
    return section;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (0 == indexPath.section) {
        cell.textLabel.text = @"头像";
         }else if (1 == indexPath.section){
             if (0 == indexPath.row) {
                cell.textLabel.text = @"账号";
                
                 }else if (1 == indexPath.row){
                    cell.textLabel.text = @"职位";
                    
                 }else if (2 == indexPath.row){
                     cell.textLabel.text = @"所属品牌";
                 }
            }else if (2 == indexPath.section){
                if (0 == indexPath.row) {
                    cell.textLabel.text = @"真实姓名";
                    
                } else if (1 == indexPath.row) {
                    cell.textLabel.text = @"出生日期";
                    
                }else if (2 == indexPath.row){
                    cell.textLabel.text = @"年龄";
                   
                }else if (3 == indexPath.row){
                    cell.textLabel.text = @"身份证号";
                    
                }else if (4 == indexPath.row){
                    cell.textLabel.text = @"现住地址";
                    
                }
            }else if (3 == indexPath.section){
                if (0 == indexPath.row) {
                    cell.textLabel.text = @"手机号";
                    
                }else if (1 == indexPath.row){
                    cell.textLabel.text = @"微信号";
                                   }else {
                    cell.textLabel.text = @"QQ号";
                                    }
            }else{
                if (0 == indexPath.row) {
                    cell.textLabel.text =@"兴趣爱好";
                   
                }else{
                    cell.textLabel.text  = @"个性签名";
                    
                }
            }
//    if ([_Role isEqualToString:@"6"]||[_Role isEqualToString:@"2"]) {
//        NSArray *ary1 = [[NSArray alloc]initWithObjects:@"头像",@"账号",@"职位",@"所属品牌",@"真实姓名",@"出生日期",@"年龄",@"身份证号",@"现住地址",@"手机号",@"微信号",@"QQ号",@"兴趣爱好",@"个性签名", nil];
//        cell.textLabel.text = ary1[indexPath.section][indexPath.row];
//    }else{
//        NSArray *ary2 =[[NSArray alloc]initWithObjects:@"头像",@"账号",@"职位",@"真实姓名",@"出生日期",@"年龄",@"身份证号",@"现住地址",@"手机号",@"微信号",@"QQ号",@"兴趣爱好",@"个性签名", nil];
//        
//        cell.textLabel.text = ary2[indexPath.section][indexPath.row];
//
//    
//    }
    
        if ([cell.textLabel.text  isEqual: @"头像"]) {
        NSString *logoStr = [USER_DEFAULTS  objectForKey:@"logoImage"];
        
        UIImageView *TXImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80, 20, 40, 40)];
        [TXImage sd_setImageWithURL:[NSURL URLWithString:logoStr] placeholderImage:[UIImage  imageNamed:@"tx23"]];
        TXImage.backgroundColor = [UIColor whiteColor];
        TXImage.layer.masksToBounds = YES;
        TXImage.layer.cornerRadius = 20.0;//设置圆角
        [tableview addSubview:TXImage];
        
    };
    if (indexPath.section >=1) {
        CGRect labelRect2 = CGRectMake(150, 0, self.view.bounds.size.width-150, 50);
        _text1 = [[UITextField alloc] initWithFrame:labelRect2];
        _text1.backgroundColor=[UIColor whiteColor];
        
        if (_Open == YES) {
            if ([cell.textLabel.text isEqual: @"身份证号"]) {
                _text1.placeholder =@"必填";
            }
        }
        
        _text1.font = [UIFont boldSystemFontOfSize:15.6f];
        _text1.clearButtonMode = UITextFieldViewModeWhileEditing;
        _text1.adjustsFontSizeToFitWidth = YES;
        _text1.text = [NSString stringWithFormat:@"%@",_InterNameAry[indexPath.section-1][indexPath.row]];
        [cell addSubview:_text1];
        //_text1.enabled = NO;
        _text1.userInteractionEnabled =  _Open;
        
        for (int a = 0;a<_InterNameAry.count;a++) {
            _text1.tag = a;
            
        }
       
    }
    
       return cell;

}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
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
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_Open == YES) {
        
        if (indexPath.section == 0) {
           
            NSLog(@"点的是第%ld组第%ld行",indexPath.section,(long)indexPath.row);
            
        }else if (indexPath.section == 2){
             NSLog(@"点的是第%ld组第%ld行",indexPath.section,(long)indexPath.row);
        }else if (indexPath.section == 3){
             NSLog(@"点的是第%ld组第%ld行",indexPath.section,(long)indexPath.row);
            
        }else if (indexPath.section == 4){
             NSLog(@"点的是第%ld组第%ld行",indexPath.section,(long)indexPath.row);
        }else{
             NSLog(@"点的是第%ld组第%ld行",indexPath.section,(long)indexPath.row);        }

        
    }else{
        
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == tableview)
    {
        CGFloat sectionHeaderHeight = 80;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
