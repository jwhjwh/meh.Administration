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
#import "inftionTableViewCell.h"
#import "SelectAlert.h"
#import "targetTextField.h"
@interface TargetTableViewController ()<UITableViewDelegate,UITableViewDataSource,CLZoomPickerViewDelegate, CLZoomPickerViewDataSource>

@property (nonatomic,strong)CLZoomPickerView *pickerView;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic ,retain)NSArray *nameArrs;
@property (nonatomic ,retain)NSArray *placeholdernameArrs;
@property (nonatomic ,retain)NSArray *tagnameArrs;
@property (nonatomic ,retain)NSMutableArray* InterNameAry;
@property (strong,nonatomic) NSIndexPath *index;
@property (strong,nonatomic) NSArray *timeArray;

//数据源
@property(strong,nonatomic)NSString *time;//拜访日期
@property(strong,nonatomic)NSString *meettime;//拜访时间段
@property(strong,nonatomic)NSString *num;//拜访次数
@property(strong,nonatomic)NSString *principal;//店铺负责人
@property(strong,nonatomic)NSString *post;//职务
@property(strong,nonatomic)NSString *iphone;//联系方式
@property(strong,nonatomic)NSString *qcode;//微信
@property(strong,nonatomic)NSString *storelevel;//店规模
@property(strong,nonatomic)NSString *berths;//床位数
@property(strong,nonatomic)NSString *beautician;//美容师人数
@property(strong,nonatomic)NSString *plantingduration;//开店年限
@property(strong,nonatomic)NSString *brandbusiness;//主要经营品牌
@property(strong,nonatomic)NSString *followbrand;//关注品牌
@property(strong,nonatomic)NSString *customernum;//终端顾客总数量
@property(strong,nonatomic)NSString *validnum;//有质量顾客数量
@property(strong,nonatomic)NSString *brandpos;//品牌定位
@property(strong,nonatomic)NSString *otherpos;//品牌定位的其他
@property(strong,nonatomic)NSString *singleprice;// 单品价格
@property(strong,nonatomic)NSString *boxprice;//套盒价格
@property(strong,nonatomic)NSString *cardprice;//卡项价格
@property(strong,nonatomic)NSString *packprice;// 项目套餐
@property(strong,nonatomic)NSString *flag;//本年是否做过大量收现活动
@property(strong,nonatomic)NSString *activename;//活动名称
@property(strong,nonatomic)NSString *dealmoney;//成交金额
@property(strong,nonatomic)NSString *leastmoney;//下限
@property(strong,nonatomic)NSString *dealrate;//成交率
@property(strong,nonatomic)NSString *demand;//运营协助需求
@property(strong,nonatomic)NSString *shopquestion;//店家问题简述
@property(strong,nonatomic)NSString *plans;//品牌介入策略及跟进规划
@property(strong,nonatomic)NSString *requirement;//店家要求事项及解决办法
@property(strong,nonatomic)NSString *notic;//同事协助须知
@property(strong,nonatomic)NSString *partnertime;//店家预定合作时间
@property(strong,nonatomic)NSString *scheme;//执行方案
@property(strong,nonatomic)NSString *amount;//合约金额
@property(strong,nonatomic)NSString *payway;//大款方式
@property(strong,nonatomic)NSString *written;//填表人
@property(strong,nonatomic)NSString *manager;//经理
@property(strong,nonatomic)NSString *shopid;//店铺id
@property(strong,nonatomic)NSString *StoreName;//店名
@property(strong,nonatomic)NSString *targetVisitId;//目标客户id
@property(strong,nonatomic)NSString *Address;//店铺地址

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
    
    TargetModel *model=[[TargetModel alloc]init];
    model = _InterNameAry[0];
    if(indexPath.section <4){
        inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        if (cell ==nil)
        {
            cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        }
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
            
            cell.mingLabel.text =_nameArrs[indexPath.section][indexPath.row];
            if (indexPath.row==0) {
                
                if (model.Time ==nil) {
                    
                    cell.xingLabel.textColor = [UIColor lightGrayColor];
                    cell.xingLabel.text =_placeholdernameArrs[indexPath.section][indexPath.row];
                }else{
                    NSString *xxsj =  [[NSString alloc]initWithFormat:@"%@", [model.Time substringWithRange:NSMakeRange(0, 10)]];
                    cell.xingLabel.text = xxsj;
                }
                
                
            }else if (indexPath.row == 1){
                UITextField *sjduan = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
                //----------------------------------------------
                [sjduan addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
                sjduan.placeholder = _placeholdernameArrs[indexPath.section][indexPath.row];
                NSInteger k = [_tagnameArrs[indexPath.section][indexPath.row] integerValue];
                sjduan.tag = k;
                if (![_meettime isEqualToString:@""]) {
                    sjduan.text = _meettime;
                }
                [cell addSubview:sjduan];
            }else{
                if ([_num isEqualToString:@""]) {
                    cell.xingLabel.textColor = [UIColor lightGrayColor];
                    cell.xingLabel.text =_placeholdernameArrs[indexPath.section][indexPath.row];
                }else{
                    cell.xingLabel.textColor = [UIColor blackColor];
                    cell.xingLabel.text =_num;
                }
                
            }
            
        }else if(indexPath.section == 2){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.mingLabel.text =_nameArrs[indexPath.section][indexPath.row];
            UITextField *section2 = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
         [section2 addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            section2.placeholder = _placeholdernameArrs[indexPath.section][indexPath.row];
            NSInteger k = [_tagnameArrs[indexPath.section][indexPath.row] integerValue];
            section2.tag = k;
            if (indexPath.row == 0) {
                //店名StoreName
                section2.text = _StoreName;
            }else if (indexPath.row == 1) {
                //店铺地址
                section2.text = _Address;
            }else if (indexPath.row == 2) {
                //负责人
                if (![_principal isEqualToString:@""]) {
                    section2.text = _principal;
                }
            }else if (indexPath.row == 3) {
                //职务
                if (![_post isEqualToString:@""]) {
                    section2.text = _post;
                }
            }else if (indexPath.row == 4) {
                //联系方式
                if (![_iphone isEqualToString:@""]) {
                    section2.text = _iphone;
                }
            }else if (indexPath.row == 5) {
                //微信
                if (![_qcode isEqualToString:@""]) {
                    section2.text = _qcode;
                }
            }
            
            [cell addSubview:section2];
            
            
        }else if(indexPath.section == 3){
            //_storelevel。规模   _berths 床位  _beautician 美容  _plantingduration 开店
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.mingLabel.text =_nameArrs[indexPath.section][indexPath.row];
            if (indexPath.row==4) {
                cell.mingLabel.font = [UIFont systemFontOfSize:14];
            }
            if (indexPath.row == 0) {
                if (![_storelevel isEqualToString:@""]) {
                    cell.xingLabel.text = _storelevel;
                }else{
                    cell.xingLabel.text =_placeholdernameArrs[indexPath.section][indexPath.row];
                    cell.xingLabel.textColor = [UIColor lightGrayColor];
                }
            }else if(indexPath.row==1){
                if (![_berths isEqualToString:@""]) {
                    cell.xingLabel.text = _berths;
                }else{
                    cell.xingLabel.text =_placeholdernameArrs[indexPath.section][indexPath.row];
                    cell.xingLabel.textColor = [UIColor lightGrayColor];
                }
            }else if(indexPath.row==2){
                if (![_beautician isEqualToString:@""]) {
                    cell.xingLabel.text = _beautician;
                }else{
                    cell.xingLabel.text =_placeholdernameArrs[indexPath.section][indexPath.row];
                    cell.xingLabel.textColor = [UIColor lightGrayColor];
                }
            }else if(indexPath.row==3){
                if (![_plantingduration isEqualToString:@""]) {
                    cell.xingLabel.text = _plantingduration;
                }else{
                    cell.xingLabel.text =_placeholdernameArrs[indexPath.section][indexPath.row];
                    cell.xingLabel.textColor = [UIColor lightGrayColor];
                }
            }else{
                UITextField *section3 = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
             [section3 addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
                section3.placeholder = _placeholdernameArrs[indexPath.section][indexPath.row];
                NSInteger k = [_tagnameArrs[indexPath.section][indexPath.row] integerValue];
                section3.tag = k;
                
                if (indexPath.row ==4) {
                    if (![_brandbusiness isEqualToString:@""]) {
                        section3.text = _brandbusiness;
                    }
                }else if (indexPath.row ==5){
                    if (![_followbrand isEqualToString:@""]) {
                        section3.text = _followbrand;
                    }
                }
                [cell addSubview:section3];
            }
        }
         return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        if (cell ==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.section == 4){
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
    
    
   
}
-(void)FieldText:(UITextField *)textfield{
    switch (textfield.tag) {
        case 12:
            _meettime = textfield.text;
            
            break;
        case 23:
            NSLog(@"负责人");
             _principal=textfield.text;
            break;
        case 24:
            NSLog(@"职务");
            _post = textfield.text;
            break;
        case 25:
            NSLog(@"联系方式");
            _iphone = textfield.text;
            break;
        case 26:
            NSLog(@"微信号");
            _qcode = textfield.text;
            break;
        case 35:
            NSLog(@"经营品牌");
            _brandbusiness = textfield.text;//主要经营品牌
            break;
        case 36:
            NSLog(@"关注品牌");
            _followbrand = textfield.text;//关注品牌
            break;
        default:
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1) {
        if (indexPath.row==2) {
            _index=indexPath;
            [self lodapickerView:@"拜访次数"];
        }
    }else if(indexPath.section==3){
        if (indexPath.row==0) {
                [SelectAlert showWithTitle:@"选择店规模" titles:@[@"高",@"中",@"低"] selectIndex:^(NSInteger selectIndex) {
                    
                } selectValue:^(NSString *selectValue) {
                    
                    inftionTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                    cell.xingLabel.text=selectValue;
                    cell.xingLabel.textColor = [UIColor blackColor];
                    _storelevel = selectValue;
                    
                } showCloseButton:NO];
        }else if (indexPath.row==1){
            _index = indexPath;
            [self lodapickerView:@"选择床位"];
        }else if (indexPath.row==2){
            _index = indexPath;
            [self lodapickerView:@"选择美容师人数"];
        }else if (indexPath.row==3){
            _index = indexPath;
            [self lodapickerView:@"选择开店年限"];
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
                    
                    [self nstingallocinit:model];
                    
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
-(void)lodapickerView:(NSString *)labelstr{
    self.pickerView=[[CLZoomPickerView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.labelStr=labelstr;
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
    if (indexPath.section==4) {
        return 180;
    }else{
        return 50.0f;
    }
    
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
    
    inftionTableViewCell *cell = [_tableView cellForRowAtIndexPath:_index];
    cell.xingLabel.text=_timeArray[indexPath];
    NSLog(@"%@,%@",_timeArray[indexPath],cell.xingLabel.text);
    cell.xingLabel.textColor = [UIColor blackColor];
   
    switch (_index.section) {
        case 1:
            switch (_index.row) {
                case 2:
                    _num =_timeArray[indexPath];
                    NSLog(@"%@---%@",_timeArray[indexPath],_num)
                    break;
                    
                default:
                    break;
            }
            break;
        case 3:
            switch (_index.row) {
                case 1:
                    _berths = _timeArray[indexPath];
                    NSLog(@"%@---%@",_timeArray[indexPath],_berths)
                    break;
                case 2:
                    _beautician = _timeArray[indexPath];
                    NSLog(@"%@---%@",_timeArray[indexPath],_beautician)
                    break;
                case 3:
                    _plantingduration = _timeArray[indexPath];
                    NSLog(@"%@---%@",_timeArray[indexPath],_plantingduration)
                    break;
                default:
                    break;
            }
            
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
-(void)nstingallocinit:(TargetModel*)model{
    _time= [[NSString alloc]init];//拜访日期
    _time = model.Time;
    _Address = [[NSString alloc]init];
    _Address = model.Address;//店铺地址
    _meettime= [[NSString alloc]init];//拜访时间段
    if (model.MeetTime == nil) {
        _meettime = @"";
    }else{
        _meettime = model.MeetTime;
    }
    _num= [[NSString alloc]init];//拜访次数
    if (model.Num == nil) {
        _num = @"";
    }else{
        _num = model.Num;
    }
    _principal= [[NSString alloc]init];//店铺负责人
    if (model.Principal == nil) {
        _principal = @"";
    }else{
        _principal = model.Principal;
    }
    _post= [[NSString alloc]init];//职务
    if (model.Post == nil) {
        _post = @"";
        
    }else{
        _post = model.Post;
    }
    _iphone= [[NSString alloc]init];//联系方式
    if (model.Iphone == nil) {
        _iphone = @"";
    }else{
        _iphone = model.Iphone;
    }
    _qcode= [[NSString alloc]init];//微信
    if (model.Qcode == nil) {
        _qcode = @"";
    }else{
        _qcode = model.Qcode;
    }
    _storelevel= [[NSString alloc]init];//店规模
    if (model.StoreLevel == nil) {
        _storelevel = @"";
    }else{
        _storelevel = model.StoreLevel;
    }
    _berths= [[NSString alloc]init];//床位数
    if (model.Berths == nil) {
        _berths = @""; //
    }else{
        _berths = model.Berths;
    }
    _beautician= [[NSString alloc]init];//美容师人数
    if (model.Beautician == nil) {
        _beautician = @"";
    }else{
        _beautician = model.Beautician;
    }
    _plantingduration= [[NSString alloc]init];//开店年限
    if (model.PlantingDuration == nil) {
        _plantingduration = @"";
    }else{
        _plantingduration = model.PlantingDuration;
    }
    _brandbusiness= [[NSString alloc]init];//主要经营品牌
    if (model.BrandBusiness == nil) {
        _brandbusiness = @"";
    }else{
        _brandbusiness = model.BrandBusiness;
    }
    _followbrand= [[NSString alloc]init];//关注品牌
    if (model.FollowBrand == nil) {
        _followbrand = @"";
    }else{
        _followbrand = model.FollowBrand;
    }
    _customernum= [[NSString alloc]init];//终端顾客总数量
    if (model.CustomerNum == nil) {
        _customernum = @"";
    }else{
        _customernum = model.CustomerNum;
    }
    _validnum= [[NSString alloc]init];//有质量顾客数量
    if (model.ValidNum == nil) {
        _validnum = @"";
    }else{
        _validnum = model.ValidNum;
    }
    _brandpos= [[NSString alloc]init];//品牌定位
    if (model.BrandPos == nil) {
        _brandpos = @"";
    }else{
        _brandpos = model.BrandPos;
    }
    _otherpos= [[NSString alloc]init];//品牌定位的其他
    if (model.OtherPos == nil) {
        _otherpos = @"";
    }else{
        _otherpos = model.OtherPos;
    }
    _singleprice= [[NSString alloc]init];// 单品价格
    if (model.SinglePrice == nil) {
        _singleprice = @"";
    }else{
        _singleprice = model.SinglePrice;
    }
    _boxprice= [[NSString alloc]init];//套盒价格
    if (model.BoxPrice == nil) {
        _boxprice = @"";
    }else{
        _boxprice = model.BoxPrice;
    }
    _cardprice= [[NSString alloc]init];//卡项价格
    if (model.CardPrice == nil) {
        _cardprice = @"";
    }else{
        _cardprice = model.CardPrice;
    }
    _packprice= [[NSString alloc]init];// 项目套餐
    if (model.PackPrice == nil) {
        _packprice = @"";
    }else{
        _packprice = model.PackPrice;
    }
    _flag= [[NSString alloc]init];//本年是否做过大量收现活动
    if (model.Flag == nil) {
        _flag = @"";
    }else{
        _flag = model.Flag;
    }
    _activename= [[NSString alloc]init];//活动名称
    if (model.ActiveName == nil) {
        _activename = @"";
    }else{
        _activename = model.ActiveName;
    }
    _dealmoney= [[NSString alloc]init];//成交金额
    if (model.DealMoney == nil) {
        _dealmoney = @"";
    }else{
        _dealmoney = model.DealMoney;
    }
    _leastmoney= [[NSString alloc]init];//下限
    if (model.LeastMoney == nil) {
        _leastmoney = @"";
    }else{
        _leastmoney = model.LeastMoney;
    }
    _dealrate= [[NSString alloc]init];//成交率
    if (model.DealRate == nil) {
        _dealrate = @"";
    }else{
        _dealrate = model.DealRate;
    }
    _demand= [[NSString alloc]init];//运营协助需求
    if (model.Demand == nil) {
        _demand = @"";
    }else{
        _demand = model.Demand;
    }
    _shopquestion= [[NSString alloc]init];//店家问题简述
    if (model.ShopQuestion == nil) {
        _shopquestion = @"";
    }else{
        _shopquestion = model.ShopQuestion;
    }
    _plans= [[NSString alloc]init];//品牌介入策略及跟进规划
    if (model.Plans == nil) {
        _plans = @"";
    }else{
        _plans = model.Plans;
    }
    _requirement= [[NSString alloc]init];//店家要求事项及解决办法
    if (model.Requirement == nil) {
        _requirement = @"";
    }else{
        _requirement = model.Requirement;
    }
    _notic= [[NSString alloc]init];//同事协助须知
    if (model.Notic == nil) {
        _notic = @"";
    }else{
        _notic = model.Notic;
    }
    _partnertime= [[NSString alloc]init];//店家预定合作时间
    if (model.PartnerTime == nil) {
        _partnertime = @"";
    }else{
        _partnertime = model.PartnerTime;
    }
    _scheme= [[NSString alloc]init];//执行方案
    if (model.Scheme == nil) {
        _scheme = @"";
    }else{
        _scheme = model.Scheme;
    }
    _amount= [[NSString alloc]init];//合约金额
    if (model.Amount == nil) {
        _amount = @"";
    }else{
        _amount = model.Amount;
    }
    _payway= [[NSString alloc]init];//大款方式
    if (model.PayWay == nil) {
        _payway = @"";
    }else{
        _payway = model.PayWay;
    }
    _written= [[NSString alloc]init];//填表人
    if (model.Written == nil) {
        _written = @"";
    }else{
        _written = model.Written;
    }
    _manager= [[NSString alloc]init];//经理
    if (model.Manager == nil) {
        _manager = @"";
    }else{
        _manager = model.Manager;
    }
    _shopid= [[NSString alloc]init];//店铺id
    if (model.ShopId == nil) {
        _shopid = @"";
    }else{
        _shopid = model.ShopId;
    }
    _StoreName= [[NSString alloc]init];//店名
    if (model.StoreName == nil) {
        _StoreName = @"";
    }else{
        _StoreName = model.StoreName;
    }
    _targetVisitId= [[NSString alloc]init];//目标客户id
    if (model.Id == nil) {
        _targetVisitId = @"";
    }else{
        _targetVisitId = model.Id;
    }
}
@end
