//
//  TargetTableViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/10/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TargetTableViewController.h"
#import "TargetModel.h"
#import "CLZoomPickerView.h"
@interface TargetTableViewController ()<UITableViewDelegate,UITableViewDataSource,CLZoomPickerViewDelegate, CLZoomPickerViewDataSource>
@property (nonatomic,strong)CLZoomPickerView *pickerView;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic ,retain)NSArray *nameArrs;
@property (nonatomic ,retain)NSArray *placeholdernameArrs;
@property (nonatomic ,retain)NSArray *tagnameArrs;
@property (nonatomic ,retain)NSMutableArray* InterNameAry;
@property (strong,nonatomic) NSIndexPath *index;
@property (strong,nonatomic) NSArray *timeArray;

//控件
@property (strong,nonatomic)UILabel *bfcslabel;
@end

@implementation TargetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"目标客户确立表";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"···" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    _nameArrs = @[@[@"签到"],@[@"拜访日期",@"拜访时间段",@"拜访次数"],@[@"店名",@"地址",@"负责人",@"职务",@"固话/手机",@"微信号"],@[@"店规模",@"床位",@"美容师人数",@"开店年限",@"主要经营品牌",@"关注品牌"],@[@"目前了解信息"],@[@"店家问题简述",@"品牌介入策略及跟进规划",@"店家要求事项及解决办法",@"同事协助须知"],@[@"店家预合作时间",@"执行方案",@"合约金额"],@[@"打款方式"]];
    _placeholdernameArrs = @[@[],@[@"选择日期",@"如:10:00点-12:30分",@"选择拜访次数"],@[@"填写店名",@"填写店铺地址",@"填写负责人",@"填写职务",@"填写联系方式",@"填写微信号"],@[@"选择店规模",@"选择床位",@"选择美容师人数",@"选择开店年限",@"填写主要经营品牌",@"填写关注品牌"]];
    _tagnameArrs =@[@[],@[@"",@"12",@""],@[@"21",@"22",@"23",@"24",@"25",@"26"],@[@"31",@"32",@"33",@"34",@"35",@"36"]];
    [self targettableui];
    [self selectTargetVisit];
    NSMutableArray *array=[NSMutableArray array];
    for (int i=1; i<101; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _timeArray=[NSArray arrayWithArray:array];
}
-(void)targettableui{
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _index=indexPath;
    TargetModel *model=[[TargetModel alloc]init];
    model = _InterNameAry[0];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section ==0) {
        UIImageView *qdimage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-30, 10, 30, 30)];
        qdimage.image = [UIImage imageNamed:@"qd_ico"];
        [cell addSubview:qdimage];
        
        UILabel *qdlabel = [[UILabel alloc]initWithFrame:CGRectMake(((self.view.frame.size.width/2)-30)+30, 10, 50, 30)];
        qdlabel.text = _nameArrs[indexPath.section][indexPath.row];
        [cell addSubview:qdlabel];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }else if(indexPath.section == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 30)];
        tlelabel.text = _nameArrs[indexPath.section][indexPath.row];
        [cell addSubview:tlelabel];
        if (indexPath.row==0) {
            UILabel *rqlabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, cell.width-130, 30)];
            if (model.Time ==nil) {
                rqlabel.text = _placeholdernameArrs[indexPath.section][indexPath.row];
                rqlabel.textColor = [UIColor lightGrayColor];
            }else{
                NSString *xxsj =  [[NSString alloc]initWithFormat:@"%@", [model.Time substringWithRange:NSMakeRange(0, 10)]];
                rqlabel.text = xxsj;
            }
            
            [cell addSubview:rqlabel];
        }else if (indexPath.row == 1){
            UITextField *sjduan = [[UITextField alloc]initWithFrame:CGRectMake(130, 10, cell.width-130, 30)];
             [sjduan addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            sjduan.placeholder = _placeholdernameArrs[indexPath.section][indexPath.row];
            NSInteger k = [_tagnameArrs[indexPath.section][indexPath.row] integerValue];
            sjduan.tag = k;
            [cell addSubview:sjduan];
        }else{
            _bfcslabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, cell.width-130, 30)];
            _bfcslabel.text = _placeholdernameArrs[indexPath.section][indexPath.row];
            _bfcslabel.textColor = [UIColor lightGrayColor];
            [cell addSubview:_bfcslabel];
        }
       
    }else if(indexPath.section == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 30)];
        tlelabel.text = _nameArrs[indexPath.section][indexPath.row];
        [cell addSubview:tlelabel];
        UITextField *section2 = [[UITextField alloc]initWithFrame:CGRectMake(130, 10, cell.width-130, 30)];
        section2.placeholder = _placeholdernameArrs[indexPath.section][indexPath.row];
        [cell addSubview:section2];
        if (indexPath.row ==0) {
            section2.enabled=NO;
        }else if(indexPath.row==1){
            section2.enabled=NO;
        }else{
            section2.enabled=YES;
        }
        
    }else if(indexPath.section == 3){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 30)];
        tlelabel.text = _nameArrs[indexPath.section][indexPath.row];
        [cell addSubview:tlelabel];
        UITextField *section3 = [[UITextField alloc]initWithFrame:CGRectMake(130, 10, cell.width-130, 30)];
        section3.placeholder = _placeholdernameArrs[indexPath.section][indexPath.row];
        [cell addSubview:section3];
        
    }else if(indexPath.section == 4){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 30)];
        tlelabel.text = _nameArrs[indexPath.section][indexPath.row];
        [cell addSubview:tlelabel];
        
    }else if(indexPath.section == 5){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, cell.width, 30)];
        tlelabel.text = _nameArrs[indexPath.section][indexPath.row];
        [cell addSubview:tlelabel];
        
    }else if(indexPath.section == 6){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, cell.width, 30)];
        tlelabel.text = _nameArrs[indexPath.section][indexPath.row];
        [cell addSubview:tlelabel];
        
    }else if(indexPath.section == 7){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, cell.width, 30)];
        tlelabel.text = _nameArrs[indexPath.section][indexPath.row];
        [cell addSubview:tlelabel];
        
    }
    return cell;
}
-(void)FieldText:(UITextField *)textfield{
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1) {
        if (indexPath.row==2) {
            [self lodapickerView];
        }
    }
    
}
-(void)rightItemAction:(UIBarButtonItem*)sender{
    //点击右上角
}


-(void)selectTargetVisit{
    //数据请求
    if (self.isofyou ==NO) {
        NSString *uStr =[NSString stringWithFormat:@"%@shop/selectTargetVisit.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"TargetVisitId":self.TargetVisitId,@"RoleId":self.strId};
        [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                NSArray *array=[responseObject valueForKey:@"list"];
                _InterNameAry = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in array) {
                    TargetModel *model=[[TargetModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_InterNameAry addObject:model];
                }
                [_tableView reloadData];
            }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
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
                [_tableView addEmptyViewWithImageName:@"" title:@"网络出错了!" Size:20.0];
                _tableView.emptyView.hidden = NO;
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
    }
}
-(void)lodapickerView{
    self.pickerView=[[CLZoomPickerView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.labelStr=@"提示";
    self.pickerView.topRowCount = 1;
    self.pickerView.bottomRowCount = 1;
    self.pickerView.selectedRow = 1;
    self.pickerView.rowHeight = 40;
    self.pickerView.selectedRowFont = [UIFont fontWithName:@"DIN Condensed" size:35];
    self.pickerView.textColor = [UIColor lightGrayColor];
    self.pickerView.unselectedRowScale = 0.5;
    [self.view addSubview:self.pickerView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_nameArrs[section]count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _nameArrs.count;
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
// CLZoomPickerView 代理，当前项改变后调用此方法
- (void)pickerView:(CLZoomPickerView *)pickerView changedIndex:(NSUInteger)indexPath
{
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:_index];
    //cell.xingLabel.text=_timeArray[indexPath];
    switch (_index.section) {
        case 1:
            _bfcslabel.text=_timeArray[indexPath];
            break;
        case 3:
           
            
            break;
        default:
            break;
    }
}


// CLZoomPickerView 代理，返回数据行数
- (NSInteger)pickerView:(CLZoomPickerView *)pickerView
{
    return _timeArray.count;
}

// CLZoomPickerView 代理，返回指定行显示的字符串
- (NSString *)pickerView:(CLZoomPickerView *)pickerView titleForRow:(NSUInteger)indexPath
{
    return _timeArray[indexPath];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UIEdgeInsets UIEgde = UIEdgeInsetsMake(0, 15, 0, 15);
        [cell setSeparatorInset:UIEgde];
    }else{
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }
}
@end
