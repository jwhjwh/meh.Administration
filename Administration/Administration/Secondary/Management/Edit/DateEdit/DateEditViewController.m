//
//  DateEditViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/28.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DateEditViewController.h"
#import "PW_DatePickerView.h"

@interface DateEditViewController ()<UITableViewDataSource,UITableViewDelegate,PW_DatePickerViewDelegate>
{
    UITableView *infonTableview;
}
@property (nonatomic,strong) PW_DatePickerView *PWpickerView;

@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,strong) UITextField *text1;//编辑
@property (nonatomic,strong) UILabel *DayLabel;//编辑
@end

@implementation DateEditViewController

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
   //提交数据
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
    if (indexPath.section >=1) {
        CGRect labelRect2 = CGRectMake(150, 0, self.view.bounds.size.width-170, 50);
        if (indexPath.row<0) {
            _DayLabel = [[UILabel alloc]initWithFrame:labelRect2];
            _DayLabel.text = [NSString stringWithFormat:@"%@",_InterNameAry[indexPath.section-1][indexPath.row-7]];
            [infonTableview addSubview:_DayLabel];
        }
        
        _text1 = [[UITextField alloc] initWithFrame:labelRect2];
        _text1.backgroundColor=[UIColor whiteColor];
        _text1.font = [UIFont boldSystemFontOfSize:13.0f];
        _text1.clearButtonMode = UITextFieldViewModeWhileEditing;
        _text1.adjustsFontSizeToFitWidth = YES;
        _text1.text = [NSString stringWithFormat:@"%@",_InterNameAry[indexPath.section-1][indexPath.row]];
        [cell addSubview:_text1];
        if (indexPath.section == 1) {
            if (indexPath.row <1) {
                 _text1.userInteractionEnabled =  NO;
                
            }else if (indexPath.row == 3){
                _text1.userInteractionEnabled =  NO;
               
            }
        }
       
    }
    if ([cell.textLabel.text isEqualToString:@"身份证号"]){
        _text1.placeholder =@"必填";
    }


    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row <1) {
            NSLog(@"点的出生日期");
            self.PWpickerView = [[PW_DatePickerView alloc] initDatePickerWithDefaultDate:nil andDatePickerMode:UIDatePickerModeDate];
            self.PWpickerView.delegate = self;
            [self.PWpickerView show];
            
        }else if (indexPath.row == 3){
            NSLog(@"点的现住地址");
        }
    }
}
- (void)pickerView:(PW_DatePickerView *)pickerView didSelectDateString:(NSString *)dateString
{
    _DayLabel.text  = dateString;
    
    
    NSLog(@"%@",dateString);
    NSLog(@"%@",_DayLabel.text);
    
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
