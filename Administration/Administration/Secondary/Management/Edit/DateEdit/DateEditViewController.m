//
//  DateEditViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/28.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DateEditViewController.h"
#import "PW_DatePickerView.h"
#import "CityChooseViewController.h"

@interface DateEditViewController ()<UITableViewDataSource,UITableViewDelegate,PW_DatePickerViewDelegate>
{
    UITableView *infonTableview;
}
@property (nonatomic,strong) PW_DatePickerView *PWpickerView;

@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,strong) UITextField *text1;//编辑
@property (nonatomic,strong) UILabel *DayLabel;//出生日期
@property (nonatomic,strong) UILabel *AddLabel;//现住地址

@property (nonatomic,strong) NSString *Age;
@property (nonatomic,strong) NSString *IdNo;

@property (nonatomic,strong) NSString *Wcode;
@property (nonatomic,strong) NSString *Qcode;
@property (nonatomic,strong) NSString *Interests;
@property (nonatomic,strong) NSString *SDASD;
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
    _arr=@[@[@"头像"],@[@"出生日期",@"年龄",@"身份证号",@"现住地址"],@[@"手机号",@"微信号",@"QQ号"],@[@"兴趣爱好",@"个人签名"]];
    // Do any additional setup after loading the view.
}

-(void)InterTableUI
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"完成"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(masgegeClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height+64) style:UITableViewStylePlain];
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
}
-(void)masgegeClick{

    NSString *uStr =[NSString stringWithFormat:@"%@user/addUserInfo.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSLog(@"%@%@%@%@",_DayLabel.text,_Age,_IdNo,_AddLabel.text);
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"Birthday":_DayLabel.text,@"Age":_Age,@"IdNo":_IdNo,@"Address":_AddLabel.text,@"Wcode":_Wcode,@"Qcode":_Qcode,@"Interests":_Interests,@"SDASD":_SDASD};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改成功" andInterval:1.0];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
        }else{
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1.0];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
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
    }
   
    cell.textLabel.text = _arr[indexPath.section][indexPath.row];
    if ([cell.textLabel.text isEqualToString:@"出生日期"]) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }else if ([cell.textLabel.text isEqualToString:@"现住地址"]) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    if ([cell.textLabel.text  isEqualToString: @"头像"]) {
        NSString *logoStr = [USER_DEFAULTS  objectForKey:@"logoImage"];
        
        UIImageView *TXImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80, 20, 40, 40)];
        [TXImage sd_setImageWithURL:[NSURL URLWithString:logoStr] placeholderImage:[UIImage  imageNamed:@"tx23"]];
        TXImage.backgroundColor = [UIColor whiteColor];
        TXImage.layer.masksToBounds = YES;
        TXImage.layer.cornerRadius = 20.0;//设置圆角
        [infonTableview addSubview:TXImage];
        
    };
    CGRect labelRect2 = CGRectMake(150, 1, self.view.bounds.size.width-170, 48);
    if (indexPath.section ==1) {
        if (indexPath.row == 0) {
            _DayLabel = [[UILabel alloc]initWithFrame:labelRect2];
            _DayLabel.text = [NSString stringWithFormat:@"%@",_InterNameAry[indexPath.section-1][indexPath.row]];
            _DayLabel.font = [UIFont boldSystemFontOfSize:13.0f];
            [cell addSubview:_DayLabel];
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
            UITextField *idNoField =[[UITextField alloc]initWithFrame:labelRect2];
            idNoField.backgroundColor=[UIColor whiteColor];
            idNoField.font = [UIFont boldSystemFontOfSize:13.0f];
            idNoField.clearButtonMode = UITextFieldViewModeWhileEditing;
            idNoField.adjustsFontSizeToFitWidth = YES;
            idNoField.placeholder =@"必填";
            idNoField.text = [NSString stringWithFormat:@"%@",_InterNameAry[indexPath.section-1][indexPath.row]];
            _IdNo = idNoField.text;
            [idNoField addTarget:self action:@selector(idNoFieldText:) forControlEvents:UIControlEventEditingChanged];
            [cell addSubview:idNoField];
        }else if (indexPath.row == 3){
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
                break;
            case 1:
                self.Wcode = codeField.text;
                NSLog(@"Age:%@,%@",self.Age,codeField.text);
                break;
            case 2:
                self.Qcode = codeField.text;
                NSLog(@"IdNo:%@,%@",self.IdNo,codeField.text);
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
    
    if (indexPath.section == 1) {
        if (indexPath.row <1) {
            self.PWpickerView = [[PW_DatePickerView alloc] initDatePickerWithDefaultDate:nil andDatePickerMode:UIDatePickerModeDate];
            self.PWpickerView.delegate = self;
            [self.PWpickerView show];
            
        }else if (indexPath.row == 3){

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
- (void)pickerView:(PW_DatePickerView *)pickerView didSelectDateString:(NSString *)dateString type:(DateType)type;
{
    _DayLabel.text  = dateString;
}
- (void)ageFieldText:(UITextField *)textField{
    self.Age = textField.text;
}
- (void)idNoFieldText:(UITextField *)textField{
    self.IdNo = textField.text;
}
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            break;
        case 1:
            self.Wcode = textField.text;
            NSLog(@"Age:%@,%@",self.Age,textField.text);
            break;
        case 2:
            self.Qcode = textField.text;
            NSLog(@"IdNo:%@,%@",self.IdNo,textField.text);
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
