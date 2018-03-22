//
//  DateEditViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/28.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DateEditViewController.h"
#import "GSPickerView.h"
#import "CityChooseViewController.h"
#import "ZZYPhotoHelper.h"
#import "UIViewDatePicker.h"
@interface DateEditViewController ()<UITableViewDataSource,UITableViewDelegate,UIViewDatePickerDelegate>
{
    UITableView *infonTableview;
    NSDictionary *dic;
}
@property (nonatomic,strong) GSPickerView *pickerView;

@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,strong) UITextField *text1;//编辑
@property (nonatomic,strong) UILabel *DayLabel;//出生日期
@property (nonatomic,strong) UILabel *AddLabel;//现住地址
@property (nonatomic,strong)UIImageView *TXImage;
@property (nonatomic,strong) NSString *Age;
@property (nonatomic,strong) NSString *IdNo;

@property (nonatomic,strong) NSString*phone;//手机号

@property (nonatomic,strong) NSString *Wcode;
@property (nonatomic,strong) NSString *Qcode;
@property (nonatomic,strong) NSString *Interests;
@property (nonatomic,strong) NSString *SDASD;
@property (nonatomic,weak) UIViewDatePicker *myDatePick;

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)NSString *string2;

@end

@implementation DateEditViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"编辑资料";
    [self InterTableUI];
    self.view.backgroundColor = [UIColor whiteColor];
    _arr=@[@[@"头像"],@[@"出生日期",@"年龄",@"现住地址"],@[@"手机号",@"微信号",@"QQ号"],@[@"兴趣爱好",@"个人签名"]];
    // Do any additional setup after loading the view.
}
- (GSPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[GSPickerView alloc]initWithFrame:self.view.bounds];
    }
    return _pickerView;
}
-(void)InterTableUI
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"完成"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(masgegeClick:)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    self.string1 = self.dictinfo[@"lunarBirthday"];
    self.string2 = self.dictinfo[@"solarBirthday"];
    
}
-(void)buttonLiftItem{
    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"退出后，已编辑的内容将会消失确定退出吗？？" sureBtn:@"确认" cancleBtn:@"取消"];
    alertView.resultIndex = ^(NSInteger index){
        if (index == 2) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    [alertView showMKPAlertView];
    
}

-(void)showDatePicker
{
    UIViewDatePicker *datePick = [[UIViewDatePicker alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    datePick.delegate = self;
    [self.view endEditing:YES];
    [self.view.window addSubview:datePick];
    self.myDatePick = datePick;
}

-(void)getChooseDate
{
    self.string1 = self.myDatePick.stringChinese;
    self.string2 = self.myDatePick.stringGregorian;
    self.flag = self.myDatePick.flagggg;
    [infonTableview reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)masgegeClick:(NSString *)flag{

    NSString *uStr =[NSString stringWithFormat:@"%@user/addUserInfo.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSLog(@"%@%@%@%@",_DayLabel.text,_Age,_IdNo,_AddLabel.text);
    
    if ([self.flag isEqualToString:@"<null>"]) {
        self.flag = @"0";
    }
    
    NSDictionary *dict=@{@"appkey":apKeyStr,
                         @"usersid":[USER_DEFAULTS  objectForKey:@"userid"],
                         @"flag":self.flag,
                         @"SolarBirthday":self.string2,
                         @"LunarBirthday":self.string1,
                         @"Age":_Age,
                         @"Address":_AddLabel.text,
                         @"Wcode":_Wcode,
                         @"Qcode":_Qcode,
                         @"Interests":_Interests,
                         @"sdasd":_SDASD,
                         @"phone":self.phone};
    [ZXDNetworking GET:uStr parameters:dict success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"修改成功" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                if (index == 2) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
            [alertView showMKPAlertView];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
        }else{
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1.0];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}
-(void)imageciew{
    NSData *pictureData = UIImagePNGRepresentation(_TXImage.image);
    NSString *urlStr = [NSString stringWithFormat:@"%@upload/file.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"code":@"1"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"image/gif",@"image/tiff",@"application/octet-stream",@"text/json",nil];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyMMddHHmm";
        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        NSString *nameStr = @"file";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [formData appendPartWithFileData:pictureData name:nameStr fileName:[NSString stringWithFormat:@"%@.png", fileName] mimeType:@"image/png"];
         } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView: self.view animated:NO];        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSUTF8StringEncoding error:nil];
        NSString *status =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"status"]];
        if ([status isEqualToString:@"0000"]) {
            //        self.blcokStr(self.goodPicture,_string,brandId);
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"添加成功" andInterval:1.0];
        } else {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"图片上传失败" andInterval:1.0];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
{ if (section == 0 ){
    return 10;
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
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
    cell.textLabel.text = _arr[indexPath.section][indexPath.row];
    if ([cell.textLabel.text isEqualToString:@"出生日期"]) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }else if ([cell.textLabel.text isEqualToString:@"现住地址"]) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    if ([cell.textLabel.text  isEqualToString: @"头像"]) {
        NSString *logoStr = [USER_DEFAULTS  objectForKey:@"logoImage"];
        
       _TXImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80, 20, 40, 40)];
        [_TXImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,logoStr]] placeholderImage:[UIImage  imageNamed:@"tx23"]];
        _TXImage.backgroundColor = [UIColor whiteColor];
        _TXImage.layer.masksToBounds = YES;
        _TXImage.layer.cornerRadius = 20.0;//设置圆角
        [infonTableview addSubview:_TXImage];
        
    };
    CGRect labelRect2 = CGRectMake(150, 1, self.view.bounds.size.width-170, 48);
    if (indexPath.section ==1) {
        if (indexPath.row == 0) {
            
            [_DayLabel removeFromSuperview];
            
            _DayLabel = [[UILabel alloc]initWithFrame:labelRect2];
            _DayLabel.text = @"";
            [cell addSubview:_DayLabel];
            if ([self.flag isEqualToString:@"1"]) {
                _DayLabel.text = self.string1;
            }else if([self.flag isEqualToString:@"2"])
            {
                _DayLabel.text = self.string2;
            }else
            {
            _DayLabel.text = [NSString stringWithFormat:@"%@",_InterNameAry[indexPath.section-1][indexPath.row]];
            }
            _DayLabel.font = [UIFont boldSystemFontOfSize:13.0f];
            
        }else if(indexPath.row == 1){
            UITextField *ageField =[[UITextField alloc]initWithFrame:labelRect2];
            ageField.backgroundColor=[UIColor whiteColor];
            ageField.font = [UIFont boldSystemFontOfSize:13.0f];
            ageField.clearButtonMode = UITextFieldViewModeWhileEditing;
            ageField.adjustsFontSizeToFitWidth = YES;
            ageField.text = [NSString stringWithFormat:@"%@",_InterNameAry[indexPath.section-1][indexPath.row]];
            _Age = ageField.text;
            [ageField addTarget:self action:@selector(ageFieldText:) forControlEvents:UIControlEventEditingChanged];
             [cell addSubview:ageField];
        }else if (indexPath.row == 2){
            _AddLabel = [[UILabel alloc]initWithFrame:labelRect2];
            _AddLabel.text = [NSString stringWithFormat:@"%@",_InterNameAry[indexPath.section-1][indexPath.row]];
            _AddLabel.font = [UIFont boldSystemFontOfSize:13.0f];
            [cell addSubview:_AddLabel];
        }
    }else if(indexPath.section == 2){
        UITextField *codeField =[[UITextField alloc]initWithFrame:labelRect2];
        codeField.backgroundColor=[UIColor whiteColor];
        codeField.font = [UIFont boldSystemFontOfSize:13.0f];
        codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        codeField.adjustsFontSizeToFitWidth = YES;
        codeField.text = [NSString stringWithFormat:@"%@",_InterNameAry[indexPath.section-1][indexPath.row]];
         [codeField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        codeField.tag = row;
        switch (codeField.tag) {
            case 0:
                self.phone = codeField.text;
                NSLog(@"手机号是 :%@",codeField.text);
                break;
            case 1:
                self.Wcode = codeField.text;
                NSLog(@"Age:%@,%@",self.Age,codeField.text);
                break;
            case 2:
                self.Qcode = codeField.text;
                NSLog(@"Qcode:%@,%@",self.Qcode,codeField.text);
                break;
            default:
                break;
        }

        [cell addSubview:codeField];
    }else if (indexPath.section == 3){
        UITextField *PersonField =[[UITextField alloc]initWithFrame:labelRect2];
        PersonField.backgroundColor=[UIColor whiteColor];
        PersonField.font = [UIFont boldSystemFontOfSize:13.0f];
        PersonField.clearButtonMode = UITextFieldViewModeWhileEditing;
        PersonField.adjustsFontSizeToFitWidth = YES;
        PersonField.text = [NSString stringWithFormat:@"%@",_InterNameAry[indexPath.section-1][indexPath.row]];
         [PersonField addTarget:self action:@selector(PersonFieldText:) forControlEvents:UIControlEventEditingChanged];
         PersonField.tag = row;
        switch (PersonField.tag) {
            case 0:
                self.Interests = PersonField.text;
                NSLog(@"Interests:%@,%@",self.Interests,PersonField.text);
                break;
            case 1:
                self.SDASD = PersonField.text;
                NSLog(@"Interests:%@,%@",self.Age,PersonField.text);
                break;
                
            default:
                break;
        }

        [cell addSubview:PersonField];

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
                _TXImage.image = (UIImage *)data;
                [self imageciew];
            }];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row <1) {

            self.indexPath = indexPath;
            [self showDatePicker];
            
        }else if (indexPath.row == 2){

            CityChooseViewController *CityVC = [[CityChooseViewController alloc]init];
            [CityVC returnText:^(NSString *showText) {
                NSLog(@"showtext:%@",showText);
                self.AddLabel.text = showText;
                //代码块中没有第二个视图控制器，所以不会造成循环引用
            }];
            

            [self.navigationController showViewController:CityVC sender:nil];
        }
    }
}

- (void)ageFieldText:(UITextField *)textField{
    self.Age = textField.text;
}
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            self.phone = textField.text;
            NSLog(@"手机号是 :%@",textField.text);
            break;
        case 1:
            self.Wcode = textField.text;
            NSLog(@"Age:%@,%@",self.Age,textField.text);
            break;
        case 2:
            self.Qcode = textField.text;
            NSLog(@"Qcode:%@,%@",self.Qcode,textField.text);
            break;
        default:
            break;
    }
}
- (void)PersonFieldText:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
            self.Interests = textField.text;
            NSLog(@"Interests:%@,%@",self.Interests,textField.text);
            break;
        case 1:
            self.SDASD = textField.text;
            NSLog(@"Interests:%@,%@",self.Age,textField.text);
            break;
        
        default:
            break;
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
