//
//  CItyViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/25.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CItyViewController.h"
#import "CityChoose.h"
#import "SpreadDropMenu.h"

NSUInteger roooow;
NSUInteger roossw;
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
@property (nonatomic,strong) NSMutableArray *SArry;

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
    _sQArry = [[NSMutableArray alloc]initWithObjects:@"所在区域", nil];
    _sSArry = [[NSMutableArray alloc]initWithObjects:@"", nil];
    _SArry  = [[NSMutableArray alloc]initWithObjects:@"", nil];
    
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
//    NSMutableString  *CityStr = [NSMutableString stringWithFormat:@"%@%@",_CityLabel.text,_cityField.text];
//    NSString *newStr = [CityStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    
//    if ([_CityLabel.text isEqualToString:@"所在区域"]) {
//        if (_cityField.text !=nil) {
//            NSString *nnewStr = [newStr stringByReplacingOccurrencesOfString:@"所在区域" withString:@""];
//            self.returnTextBlock(nnewStr);
//            
//        }
//    }else{
//        self.returnTextBlock(newStr);
//    }
    
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
        if (_sSLabel.text.length>11) {
            if(_sQLabel.text.length>13){
                CGRect rect = [_sQArry[indexPath.row] boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-200, MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
                NSLog(@"%lu",_sQLabel.text.length);
                return rect.size.height + 5 + 5;
            }else{
                CGRect rect = [_sSLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-270, MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
                NSLog(@"%lu",_sSLabel.text.length);
                return rect.size.height + 5 + 5;
            }
        }else if(_sQLabel.text.length>13){
            CGRect rect = [_sQArry[indexPath.row] boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-200, MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
           // NSLog(@"%lu",_sQLabel.text.length);
            return rect.size.height + 5 + 5;
        }else{
            return 50;
        }
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
        UIImageView *cityImage = [[UIImageView alloc]init];
        cityImage.image = [UIImage imageNamed:@"zx_ico"];
        [cell addSubview:cityImage];
        [cityImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY).offset(0);
            make.left.mas_equalTo(cell.mas_left).offset(15);
            make.width.mas_offset(20);
            make.height.mas_offset(30);
        }];
        _sSLabel = [[UILabel alloc]init];
        _sSLabel.font = [UIFont systemFontOfSize:14.0f];
        if (_sSArry.count == 0) {
            _sSLabel.text = @"";
        }else{
            
        _sSLabel.text = [NSString stringWithFormat:@"%@  %@",_sSArry[indexPath.row],_SArry[indexPath.row]];
        }
        _sSLabel.numberOfLines = 2;
        _sSLabel.textColor = GetColor(91, 91, 91, 1);
        [cell addSubview:_sSLabel];
        [_sSLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.mas_top).offset(0);
            make.left.mas_equalTo(cityImage.mas_right).offset(5);
            make.bottom.mas_equalTo(cell.mas_bottom).offset(-5);
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
    if (indexPath.row == 0) {
        SpreadDropMenu *menu = [[SpreadDropMenu alloc]initWithShowFrame:CGRectMake(0,105, [UIScreen mainScreen].bounds.size.width, 300) ShowStyle:MYPresentedViewShowStyleFromTopSpreadStyle  callback:^(id callback) {
            NSString *string = [callback componentsJoinedByString:@"/"];
            [_sQArry addObject:string];
           NSLog(@"-----------------区:%@",_sQArry);
            
            for (int i = 0;i<_sQArry.count;i++)
            {
                if ([_sQArry[i]isEqualToString:string]){
                    
                    roooow = i;
                    break;//一定要有break，否则会出错的。
                    
                }
            }
            [self addtableViewCellZWUI];
        } shengback:^(NSString *shengback) {
            
            [_sSArry addObject:shengback];
            NSLog(@"-----------------省:%@",_SArry);
            
        } SHIleBack:^(NSString *shiback) {
            [_SArry addObject:shiback];
            NSLog(@"-----------------市:%@",_SArry);
        }];
        //菜单展示
        [self presentViewController:menu animated:YES completion:nil];
    }
    
}
-(void)addtableViewCellZWUI{
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:roooow inSection:0];
    [indexPaths addObject: indexPath];
    [infonTableview beginUpdates];
    [infonTableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    [infonTableview endUpdates];
}

-(void)dimissTabelCellZWUI{
    NSArray *_tempIndexPathArr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:roossw inSection:0]];
    [infonTableview beginUpdates];
    [infonTableview deleteRowsAtIndexPaths:_tempIndexPathArr withRowAnimation:UITableViewRowAnimationFade];
    [infonTableview endUpdates];
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
