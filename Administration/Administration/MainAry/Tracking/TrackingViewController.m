//
//  TrackingViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TrackingViewController.h"
#import "PW_DatePickerView.h"
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

@end

@implementation TrackingViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"权限管理";
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
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight) style:UITableViewStylePlain];
    infonTableview.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    infonTableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
            [_jieshuBtn setTitle:dateString forState:UIControlStateNormal];
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
    cell.textLabel.text = _dateAry[indexPath.row];
    cell.textLabel.textColor = GetColor(96, 96, 96, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    if (indexPath.row == 0) {
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
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
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
