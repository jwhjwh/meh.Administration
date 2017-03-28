//
//  TrackingViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TrackingViewController.h"
#import "PW_DatePickerView.h"
#import "CItyViewController.h"
@interface TrackingViewController ()<UITableViewDataSource,UITableViewDelegate,PW_DatePickerViewDelegate>
{
    UITableView *infonTableview;
    
}

@property (strong,nonatomic) NSArray *dateAry;
@property (strong,nonatomic) UIButton *qishiBtn;
@property (strong,nonatomic) UIButton *jieshuBtn;
@property (strong,nonatomic) UILabel* zhiLabel;
@property (nonatomic,strong) PW_DatePickerView *PWpickerView;
@property (nonatomic,strong) NSString *qishiStr;
@property (nonatomic,strong) NSString *jieshuStr;
@property (strong,nonatomic) UILabel* dateLabel;
@property (nonatomic,strong) UITextField *codeField;
@property (nonatomic,strong) UILabel *cityLaebl;



@property (nonatomic,strong) NSString *zxrStr;//执行人
@property (nonatomic,strong) NSString *zxppStr;
@property (nonatomic,strong) NSString *zxqyStr;
@property (nonatomic,strong) NSString *jtsjStr;
@property (nonatomic,strong) NSString *yqdcStr;
@property (nonatomic,strong) NSString *ydwtStr;
@property (nonatomic,strong) NSString *xsyjStr;
@property (nonatomic,strong) NSString *tsqkStr;
@property (nonatomic,strong) NSString *zjjlStr;


@end

@implementation TrackingViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"店家跟踪";
    
    self.view.backgroundColor = [UIColor whiteColor];
    _dateAry = [[NSArray alloc]initWithObjects:@"日期",@"执行人",@"执行品牌",@"执行区域",@"具体的时间规划",@"预期达成的时间",@"可能遇到的问题与困难",@"销售业绩",@"特殊情况",@"总结结论",nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"完成"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(masgegeClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
    // Do any additional setup after loading the view.
    [self TrackingVCUI];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)masgegeClick{
    
}
-(void)TrackingVCUI{
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 64,kScreenWidth,kScreenHeight) style:UITableViewStylePlain];
    infonTableview.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    infonTableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    infonTableview.scrollEnabled =NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    _qishiBtn = [[UIButton alloc]init];
    [_qishiBtn setTitle:@"起始日期" forState:UIControlStateNormal];
    _qishiBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_qishiBtn setTitleColor:GetColor(96, 96, 96, 1) forState:UIControlStateNormal];
    [_qishiBtn addTarget:self action:@selector(qishiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _jieshuBtn = [[UIButton alloc]init];
    [_jieshuBtn setTitle:@"结束日期" forState:UIControlStateNormal];
    _jieshuBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_jieshuBtn setTitleColor:GetColor(96, 96, 96, 1) forState:UIControlStateNormal];
    [_jieshuBtn addTarget:self action:@selector(jieshuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _zhiLabel = [[UILabel alloc]init];
    _zhiLabel.text = @"至";
    _zhiLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    _zhiLabel.textColor = GetColor(96, 96, 96, 1);
    
    _cityLaebl = [[UILabel alloc]init];
    _cityLaebl.font=[UIFont systemFontOfSize:14];
    _cityLaebl.text = @"请输入内容";
    _cityLaebl.textColor= GetColor(200, 200, 205, 1);
    
    
    [self setExtraCellLineHidden:infonTableview];
}
-(void)qishiBtnClick:(UIButton *)btn
{
    [self setupDateView:DateTypeOfStart];
    
}
-(void)jieshuBtnClick:(UIButton *)btn
{
    [self setupDateView:DateTypeOfEnd];
}
- (void)setupDateView:(DateType)type {
    
    self.PWpickerView = [[PW_DatePickerView alloc] initDatePickerWithDefaultDate:nil andDatePickerMode:UIDatePickerModeDate];
    self.PWpickerView.type = type;
    self.PWpickerView.delegate = self;
    [self.PWpickerView show];
}
- (void)pickerView:(PW_DatePickerView *)pickerView didSelectDateString:(NSString *)dateString type:(DateType)type
{
    switch (type) {
        case DateTypeOfStart:
            _qishiStr = dateString;
             [_qishiBtn setTitle:dateString forState:UIControlStateNormal];
            break;
        case DateTypeOfEnd:
            if ([_qishiStr compare:dateString options:NSNumericSearch] == NSOrderedDescending){
                
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择正确的时间" andInterval:1.0];
            }else
            {
                 [_jieshuBtn setTitle:dateString forState:UIControlStateNormal];
            }
            break;
        default:
            break;
    }

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dateAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 30;
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
        if (indexPath.row != 3) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
    }
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"日期";
         cell.textLabel.font=[UIFont systemFontOfSize:14];
         cell.textLabel.textColor = GetColor(96, 96, 96, 1);
        [cell addSubview:_zhiLabel];
        [_zhiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY).offset(0);
            make.centerX.mas_equalTo(cell.mas_centerX).offset(0);
            make.width.mas_offset(20);
            make.height.mas_offset(30);
        }];
        [cell addSubview:_qishiBtn];
        [_qishiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY).offset(0);
            make.left.mas_equalTo(cell.textLabel.mas_right).offset(10);
            make.right.mas_equalTo(_zhiLabel.mas_left).offset(-5);
            make.height.mas_offset(30);
        }];
        [cell addSubview:_jieshuBtn];
        [_jieshuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY).offset(0);
            make.width.mas_equalTo(_qishiBtn.mas_width).offset(0);
            make.left.mas_equalTo(_zhiLabel.mas_right).offset(5);
            make.height.mas_offset(30);
        }];
    }else{
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.font=[UIFont systemFontOfSize:14];
        _dateLabel.textColor = GetColor(96, 96, 96, 1);
        _dateLabel.text = _dateAry[indexPath.row];
        [cell addSubview:_dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(cell.mas_width).offset(-15);
            make.height.mas_offset(cell.frame.size.height/2);
            make.left.mas_equalTo(cell.mas_left).offset(15);
            make.top.mas_equalTo(cell.mas_top).offset(0);
        }];
        if (indexPath.row == 3) {
            
            [cell addSubview:_cityLaebl];
            [_cityLaebl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_dateLabel.mas_bottom).offset(0);
                make.left.mas_equalTo(cell.mas_left).offset(15);
                make.bottom.mas_equalTo(cell.mas_bottom).offset(-5);
                make.width.mas_equalTo(cell.mas_width).offset(-15);
            }];
        }else{
            _codeField =[[UITextField alloc]init];
            _codeField.backgroundColor=[UIColor whiteColor];
            _codeField.font = [UIFont boldSystemFontOfSize:13.0f];
            _codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _codeField.adjustsFontSizeToFitWidth = YES;
            [_codeField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            _codeField.tag = row;
            _codeField.placeholder =@"请输入内容";
            
            if (indexPath.row == 3) {
                _codeField.enabled = NO;
            }
            [cell addSubview:_codeField];
            [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_dateLabel.mas_bottom).offset(0);
                make.left.mas_equalTo(cell.mas_left).offset(15);
                make.bottom.mas_equalTo(cell.mas_bottom).offset(-5);
                make.width.mas_equalTo(cell.mas_width).offset(-15);
            }];

            }
        }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CItyViewController *cityVC = [[CItyViewController alloc]init];
        [cityVC returnText:^(NSString *showText) {
            NSLog(@"showtext:%@",showText);
            if (showText.length>0) {
                _cityLaebl.text = showText;
                _cityLaebl.textColor = [UIColor blackColor];
            }else{
                _cityLaebl.text = @"请输入内容";
                _cityLaebl.textColor= GetColor(200, 200, 205, 1);
            }
            
            
         
                        //代码块中没有第二个视图控制器，所以不会造成循环引用
        }];
         [self.navigationController showViewController:cityVC sender:nil];
    }

}
- (void)textFieldWithText:(UITextField *)textField
{
    NSLog(@"%ld",(long)textField.tag);
    switch (textField.tag) {
        case 1:
            if (textField.text.length>0) {
                _zxrStr = textField.text;
            }
            break;
        case 2:
            if (textField.text.length>0) {
                _zxppStr = textField.text;
            }
            break;
        case 4:
            if (textField.text.length>0) {
                _jtsjStr = textField.text;
            }
            break;
        case 5:
            if (textField.text.length>0) {
                _yqdcStr = textField.text;
            }
            break;
        case 6:
            if (textField.text.length>0) {
                _ydwtStr = textField.text;
            }
            break;
        case 7:
            if (textField.text.length>0) {
                _xsyjStr = textField.text;
            }
            break;
        case 8:
            if (textField.text.length>0) {
                _tsqkStr = textField.text;
            }
            break;
        case 9:
            if (textField.text.length>0) {
                _zjjlStr = textField.text;
            }
            break;
            
        default:
            break;
    }

}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
