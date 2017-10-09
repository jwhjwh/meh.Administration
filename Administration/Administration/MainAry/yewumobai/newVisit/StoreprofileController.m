//
//  StoreprofileController.m
//  Administration
//
//  Created by zhang on 2017/3/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "StoreprofileController.h"
#import "inftionTableViewCell.h"
#import "SelectAlert.h"
#import "CLZoomPickerView.h"
@interface StoreprofileController ()<UITableViewDataSource,UITableViewDelegate,CLZoomPickerViewDelegate, CLZoomPickerViewDataSource>
{
    UITableView *infonTableview;
}

@property (nonatomic,strong)CLZoomPickerView *pickerView;
@property (strong,nonatomic) NSArray *InterNameAry;
@property (strong,nonatomic) NSArray *timeArray;
@property (strong,nonatomic) NSIndexPath *index;

@property (strong,nonatomic)NSString *type;
@property (strong,nonatomic)NSString *year;
@property (strong,nonatomic)NSString *prepen;
@property (strong,nonatomic)NSString *beds;
@end

@implementation StoreprofileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"陌拜记录表";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    _InterNameAry = @[@"类型",@"经营年限",@"美容师人数",@"床位"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,83,self.view.bounds.size.width,1)];
    view.backgroundColor=GetColor(216, 216, 216, 1);
    [self.view addSubview:view];
    infonTableview =[[UITableView alloc]initWithFrame:CGRectMake(0,84, kScreenWidth, kScreenHeight-64)];
    //分割线无
    //    infonTableview.separatorStyle= UITableViewCellSeparatorStyleNone;
    //不让滚动
    infonTableview.scrollEnabled = NO;
    infonTableview.showsVerticalScrollIndicator = NO;
    infonTableview.delegate = self;
    infonTableview.dataSource = self;
    [self.view addSubview: infonTableview];
    [ZXDNetworking setExtraCellLineHidden:infonTableview];
    NSMutableArray *array=[NSMutableArray array];
    for (int i=1; i<101; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
     _timeArray=[NSArray arrayWithArray:array];
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _InterNameAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell ==nil)
    {
        cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    if (indexPath.row==0) {
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.mingLabel.text = _InterNameAry[indexPath.row];
    return cell;
}

-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    _index=indexPath;
    switch (indexPath.row) {
        case 0:{
            [SelectAlert showWithTitle:@"类型" titles:@[@"美容院",@"综合店",@"前店后院",@"其他"] selectIndex:^(NSInteger selectIndex) {
                  
              } selectValue:^(NSString *selectValue) {
                  inftionTableViewCell *cell = [infonTableview cellForRowAtIndexPath:indexPath];
                  cell.xingLabel.text=selectValue;
                  _type=selectValue;
              } showCloseButton:NO];
        }
            
            break;
        case 1:{
            [self lodapickerView];
        }
            
            break;
        case 2:
              [self lodapickerView];
            break;
        case 3:
              [self lodapickerView];
            break;
        default:
            break;
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
#pragma mark - CLZoomPickerView 代理

// CLZoomPickerView 代理，当前项改变后调用此方法
- (void)pickerView:(CLZoomPickerView *)pickerView changedIndex:(NSUInteger)indexPath
{
    inftionTableViewCell *cell = [infonTableview cellForRowAtIndexPath:_index];
    cell.xingLabel.text=_timeArray[indexPath];
    switch (_index.row) {
        case 1:
            _year=_timeArray[indexPath];
            break;
        case 2:
            _prepen=_timeArray[indexPath];

            break;
        case 3:
            _beds=_timeArray[indexPath];

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
    // Dispose of any resources that can be recreated.
}
-(void)rightItemAction{
    self.blcokString(_type,_year,_prepen,_beds);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([infonTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [infonTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([infonTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [infonTableview setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

@end
