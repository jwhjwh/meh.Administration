//
//  CityChooseViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/1.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CityChooseViewController.h"
#import "CityChoose.h"
#import "DateEditViewController.h"
@interface CityChooseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    
}
@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,strong) UILabel *CityLabel;       /** 显示地址 */
@property (nonatomic, strong) CityChoose *cityChoose;/** 城市选择 */
@property (nonatomic, strong) UITextField *cityField;

@property(nonatomic, copy) NSString * provinceStr;
@property(nonatomic, copy) NSString * cityStr;
@property(nonatomic, copy) NSString * areaStr;
@property (nonatomic,copy) NSString *cityyyyyy;

@end

@implementation CityChooseViewController
- (void)viewWillDisappear:(BOOL)animated {
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"编辑地址";
    [self InterTableUI];
    self.view.backgroundColor =GetColor(216, 216, 216, 1);
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"完成"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(masgegeClick)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)returnText:(ReturnTextBlock)block {
    
    
    
        self.returnTextBlock = block;
    
}



-(void)InterTableUI
{
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height+64) style:UITableViewStylePlain];

    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];


}
-(void)masgegeClick{
    NSMutableString  *CityStr = [NSMutableString stringWithFormat:@"%@%@",_CityLabel.text,_cityField.text];
    NSString *newStr = [CityStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    _cityyyyyy = [[NSString alloc]init];
    if ([_CityLabel.text isEqualToString:@"所在区域"]) {
        if (_cityField.text !=nil) {
            NSString *nnewStr = [newStr stringByReplacingOccurrencesOfString:@"所在区域" withString:@""];
            if([_isfoyou isEqualToString:@"1"]){
                self.selectedBlock(_provinceStr, _cityStr, _areaStr, nnewStr);
            }else{
                self.returnTextBlock(nnewStr);
            }
        }
    }else{
        if([_isfoyou isEqualToString:@"1"]){
            self.selectedBlock(_provinceStr, _cityStr, _areaStr, newStr);
        }else{
            self.returnTextBlock(newStr);
        }
        
//        _cityyyyyy = newStr;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{ 
    return 10;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        CGRect labelRect2 = CGRectMake(20, 0, self.view.bounds.size.width-170, 50);
        _CityLabel = [[UILabel alloc]initWithFrame:labelRect2];
        
        _CityLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
        if ([_storesssss isEqualToString:@"1"]) {
            _CityLabel.text = [NSString stringWithFormat:@"%@-%@-%@",_storespoince,_storescity,_storesCount];
        }else{
             _CityLabel.text = @"所在区域";
        }
       
         [cell addSubview:_CityLabel];
    }else if(indexPath.row == 1) {
        CGRect labelRect2 = CGRectMake(20, 0, self.view.bounds.size.width, 50);
        _cityField =[[UITextField alloc]initWithFrame:labelRect2];
        _cityField.backgroundColor=[UIColor whiteColor];
        _cityField.font = [UIFont boldSystemFontOfSize:13.0f];
        _cityField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _cityField.adjustsFontSizeToFitWidth = YES;
       
        if ([_storesssss isEqualToString:@"1"]) {
            _cityField.text = [NSString stringWithFormat:@"%@",_storesaddes];
        }else{
             _cityField.placeholder =@"详细地址";
        }
        
        
         placeholder(_cityField);
        [cell addSubview:_cityField];

    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.cityChoose = [[CityChoose alloc] init];
        __weak typeof(self) weakSelf = self;
        self.cityChoose.config = ^(NSString *province, NSString *city, NSString *town){
            _provinceStr = province;
            _cityStr = city;
            _areaStr = town;
            if ([province isEqualToString:city]) {
                weakSelf.CityLabel.text = [NSString stringWithFormat:@"%@-%@",city,town];
            }else{
                weakSelf.CityLabel.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,town];
                
            }
            
        };
        [self.view addSubview:self.cityChoose];
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
