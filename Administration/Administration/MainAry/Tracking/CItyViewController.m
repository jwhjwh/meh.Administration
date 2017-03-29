//
//  CItyViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/25.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CItyViewController.h"
#import "CityChoose.h"
@interface CItyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
}
@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,strong) UILabel *CityLabel;       /** 显示地址 */
@property (nonatomic, strong) CityChoose *cityChoose;/** 城市选择 */
@property (nonatomic, strong) UITextField *cityField;

@property (nonatomic,strong) UILabel * sSLabel; //显示省份 市的Label
@property (nonatomic,strong) NSMutableArray *sSArry;//选择省/市份数组

@property(nonatomic,strong)UILabel *sQLabel;//市区的Label
@property (nonatomic,strong) NSMutableArray *sQArry;//选择的区数组
@end

@implementation CItyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self InterTableUI];
    self.title=@"执行区域";
    self.view.backgroundColor =GetColor(216, 216, 216, 1);
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"完成"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(masgegeClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
    _sQArry = [[NSMutableArray alloc]initWithObjects:@"",@"长安区/桥西区/新华区/裕华区/高邑县/赵县/栾城县/鹿泉区/正定区/桥东区/辛集区/元氏区/",@"撒大",@"五个人过",@"阿斯顿娃如果",@"长安区/桥西区/新华区/裕华区/高邑县/赵县/栾城县/鹿泉区/正定区/桥东区/辛集区/元氏区/长安区/桥西区/新华区/裕华区/高邑县/赵县/栾城县/鹿泉区/正定区/桥东区/辛集区/元氏区/", nil];
    _sSArry = [[NSMutableArray alloc]initWithObjects:@"",@"河北省 石家庄市",@"内蒙古",@"啊是否为嘎",@"阿斯顿 啊实打实",@"asdfweh", nil];
    
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
    
    if ([_CityLabel.text isEqualToString:@"所在区域"]) {
        if (_cityField.text !=nil) {
            NSString *nnewStr = [newStr stringByReplacingOccurrencesOfString:@"所在区域" withString:@""];
            self.returnTextBlock(nnewStr);
            
        }
    }else{
        self.returnTextBlock(newStr);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _sQArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return 50;
    }else{
        CGRect rect = [_sQArry[indexPath.row] boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-200, MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        return rect.size.height + 5 + 5;
    }
    
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
    
    if (indexPath.row == 0) {
        CGRect labelRect2 = CGRectMake(20, 0, self.view.bounds.size.width-170, 50);
        _CityLabel = [[UILabel alloc]initWithFrame:labelRect2];
        _CityLabel.text = @"执行区域";
        _CityLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
        [cell addSubview:_CityLabel];
    }else  {
//        _cityField =[[UITextField alloc]initWithFrame:labelRect2];
//        _cityField.backgroundColor=[UIColor whiteColor];
//        _cityField.font = [UIFont boldSystemFontOfSize:13.0f];
//        _cityField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _cityField.adjustsFontSizeToFitWidth = YES;
//        _cityField.placeholder =@"详细地址";
//        [cell addSubview:_cityField];
        UIImageView *cityImage = [[UIImageView alloc]init];
        cityImage.image = [UIImage imageNamed:@"zx_ico"];
        [cell addSubview:cityImage];
        [cityImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.mas_top).offset(0);
            make.left.mas_equalTo(cell.mas_left).offset(15);
            make.width.mas_offset(20);
            make.height.mas_offset(30);
        }];
        _sSLabel = [[UILabel alloc]init];
        _sSLabel.font = [UIFont systemFontOfSize:14.0f];
        _sSLabel.text = _sSArry[indexPath.row];
        _sSLabel.textColor = GetColor(91, 91, 91, 1);
        [cell addSubview:_sSLabel];
        [_sSLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.mas_top).offset(0);
            make.left.mas_equalTo(cityImage.mas_right).offset(5);
            make.height.mas_offset(30);
            make.right.mas_equalTo(cell.mas_centerX).offset(0);
        }];
        _sQLabel = [[UILabel alloc]init];
        _sQLabel.font = [UIFont systemFontOfSize:14.0f];
        _sQLabel.text = _sQArry[indexPath.row];
        
        _sQLabel.numberOfLines = 0;//表示label可以多行显示
        _sQLabel.textColor = GetColor(63, 157, 246, 1);
        [cell addSubview:_sQLabel];
        [_sQLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.mas_top).offset(0);
            make.left.mas_equalTo(_sSLabel.mas_right).offset(5);
            make.right.mas_equalTo(cell.mas_right).offset(-5);
            make.bottom.mas_equalTo(cell.mas_bottom).offset(-5);
        }];
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        self.cityChoose = [[CityChoose alloc] init];
//        __weak typeof(self) weakSelf = self;
//        self.cityChoose.config = ^(NSString *province, NSString *city, NSString *town){
//           // weakSelf.CityLabel.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,town];
//        };
//        [self.view addSubview:self.cityChoose];
//    }
    
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
