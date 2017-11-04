//
//  StoresViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/1.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "StoresViewController.h"
#import "StoresModel.h"
#import "CLZoomPickerView.h"
#import "inftionTableViewCell.h"
#import "TargetViewController.h"
#import "CityChooseViewController.h"
#import "storesDepartment.h"
#import "storesActivity.h"
@interface StoresViewController ()<UITableViewDataSource,UITableViewDelegate,CLZoomPickerViewDelegate, CLZoomPickerViewDataSource,UITextFieldDelegate>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,strong)CLZoomPickerView *pickerView;
@property (strong,nonatomic) NSIndexPath *index;
@property (nonatomic ,retain)NSArray *nameArrs;
@property (nonatomic ,retain)NSArray *ligtextArrs;
@property (nonatomic ,retain)NSArray *TexttagArrs;
@property (strong,nonatomic) NSArray *timeArray;

@property (nonatomic,strong)NSString *StoreName;//店名称
@property (nonatomic,strong)NSString *Province;//省
@property (nonatomic,strong)NSString *City;//市
@property (nonatomic,strong)NSString *County;//县
@property (nonatomic,strong)NSString *Address;//详细地址
@property (nonatomic,strong)NSString *RideInfo;//乘车
@property (nonatomic,strong)NSString *Area;//面积
@property (nonatomic,strong)NSString *BrandBusiness;//其他品牌
@property (nonatomic,strong)NSString *IntentionBrand;//意向品牌
@property (nonatomic,strong)NSString *Berths;//床位数
@property (nonatomic,strong)NSString *ValidNumber;//有效顾客信息
@property (nonatomic,strong)NSString *StaffNumber;//员工人数
@property (nonatomic,strong)NSString *JobExpires;//员工从业年限
@property (nonatomic,strong)NSString *Problems;//存在的优势问题

@end

@implementation StoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店信息";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    UIButton *rightitem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightitem.frame =CGRectMake(self.view.frame.size.width-30, 0, 28,28);
    [rightitem setBackgroundImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
    [rightitem addTarget: self action: @selector(rightItemAction) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *rbuttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightitem];
    self.navigationItem.rightBarButtonItem = rbuttonItem;
     _nameArrs = @[@"店名",@"门店地址",@"乘车信息",@"面积",@"其他经营品牌",@"意向品牌",@"床位数",@"有效顾客",@"员工人数",@"员工从业年限",@"存在优势及问题",@"活动概要"];
    _ligtextArrs = @[@"填写店名",@"",@"填写乘车信息",@"填写面积",@"填写其他经营品牌",@"填写意向品牌",@"选择床位数",@"选择有效顾客数量",@"选择员工人数",@"选择员工从业年限"];
    _TexttagArrs = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    [self nsstingalloc];
    [self addViewremind];
    NSMutableArray *array=[NSMutableArray array];
    for (int i=1; i<101; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _timeArray=[NSArray arrayWithArray:array];
    
}
-(void)nsstingalloc{
    
    _StoreName = [[NSString alloc]init];//点名称
   _Province= [[NSString alloc]init];//省
   _City= [[NSString alloc]init];//市
   _County= [[NSString alloc]init];//县
   _Address= [[NSString alloc]init];//详细地址
   _RideInfo= [[NSString alloc]init];//乘车
   _Area= [[NSString alloc]init];//面积
   _BrandBusiness= [[NSString alloc]init];//其他品牌
   _IntentionBrand= [[NSString alloc]init];//意向品牌
   _Berths= [[NSString alloc]init];//床位数
   _ValidNumber= [[NSString alloc]init];//有效顾客信息
  _StaffNumber= [[NSString alloc]init];//员工人数
   _JobExpires= [[NSString alloc]init];//员工从业年限
   _Problems= [[NSString alloc]init];//存在的优势问题
    
    
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
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameArrs.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifi = @"gameCell";
    inftionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (!cell) {
        cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    /**
     *  单元格的选中类型一定不能设置为 UITableViewCellSelectionStyleNone，如果加上这一句，全选勾选不出来
     */
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 30)];
    tlelabel.text = _nameArrs[indexPath.row];
    tlelabel.font = [UIFont systemFontOfSize:14];
    [cell addSubview:tlelabel];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row<10) {
        if (indexPath.row<6) {
            if(indexPath.row ==1){
                 cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
            }else{
                UITextField *inforTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, self.view.frame.size.width-120, 30)];
                inforTextField.placeholder = _ligtextArrs[indexPath.row];
                inforTextField.font = [UIFont systemFontOfSize:14];
                NSInteger k = [_TexttagArrs[indexPath.row] integerValue];
                inforTextField.tag = k;
                [cell addSubview:inforTextField];
                [inforTextField addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            }
        }else{
            cell.xingLabel.text =_ligtextArrs[indexPath.row];
            cell.xingLabel.textColor =[UIColor lightGrayColor];
            
        }
        
    }else{
         cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    
    return cell;
}
-(void)FieldText:(UITextField *)textfield{
    switch (textfield.tag) {
        case 0:
            NSLog(@"填写点名");
            _StoreName = textfield.text;
            break;
        case 2:
            NSLog(@"填写乘车信息");
            _RideInfo = textfield.text;
            break;
        case 3:
            NSLog(@"填写面积");
            _Area = textfield.text;
            break;
        case 4:
            NSLog(@"填写其他经营品牌");
            _BrandBusiness = textfield.text;
            break;
        case 5:
            NSLog(@"填写意向品牌");
            _IntentionBrand = textfield.text;
            break;
        default:
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:{
            CityChooseViewController *CityVC = [[CityChooseViewController alloc]init];
//            [CityVC returnText:^(NSString *showText) {
//                NSLog(@"showtext:%@",showText);
//                _Address = showText;
//                //代码块中没有第二个视图控制器，所以不会造成循环引用
//            }];
            CityVC.isfoyou = @"1";
            CityVC.selectedBlock = ^(NSString *province, NSString *city, NSString *area, NSString *zhadd) {
                _Address = zhadd;
                _Province= province;//省
                _City= city;//市
                _County= area;//县
                NSLog(@"%@-%@-%@/n%@",_Province,_City,_County,_Address);
            };
            [self.navigationController showViewController:CityVC sender:nil];
        }
            break;
        case 6:
            _index = indexPath;
            [self lodapickerView:@"选择床位"];
            break;
        case 7:_index = indexPath;
            [self lodapickerView:@"选择有效顾客数量"];
            break;
        case 8:
            _index = indexPath;
            [self lodapickerView:@"选择员工人数"];
            break;
        case 9:
            _index = indexPath;
            [self lodapickerView:@"选择员工从业年限"];
            break;
        case 10:{
            TargetViewController *targetVC=[[TargetViewController alloc]init];
            targetVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            targetVC.dateStr = _Problems;
            targetVC.modifi = _isend;
            targetVC.blcokStr=^(NSString *content,int num){
                if (num==10) {
                    if(_isend == YES) {
                        _Problems = content;
                    }
                   
                }
            };
            [self.navigationController pushViewController:targetVC animated:YES];
        }
            
            //存在优势及问题
            break;
        case 11:{
            //活动概要
            //storesActivity *storeAVC = [[storesActivity alloc]init];
            
        }
            break;
        default:
            break;
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
- (void)pickerView:(CLZoomPickerView *)pickerView changedIndex:(NSUInteger)indexPath
{
    
    inftionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:_index];
        cell.xingLabel.text=_timeArray[indexPath];
        NSLog(@"%@,%@",_timeArray[indexPath],cell.xingLabel.text);
        cell.xingLabel.textColor = [UIColor blackColor];
    switch (_index.row) {
        case 6:
            _Berths =_timeArray[indexPath];
            break;
        case 7:
            _ValidNumber =_timeArray[indexPath];
            break;
        case 8:
            _StaffNumber =_timeArray[indexPath];
            break;
        case 9:
            _JobExpires =_timeArray[indexPath];
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemAction{
    storesDepartment *storesVC = [[storesDepartment alloc]init];
    
    [self.navigationController pushViewController:storesVC animated:YES];
    
}
- (NSInteger)pickerView:(CLZoomPickerView *)pickerView
{
    return _timeArray.count;
}

// CLZoomPickerView 代理，返回指定行显示的字符串
- (NSString *)pickerView:(CLZoomPickerView *)pickerView titleForRow:(NSUInteger)indexPath
{
    return _timeArray[indexPath];
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

@end
