//
//  VCAllShop.m
//  Administration
//
//  Created by zhang on 2017/12/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCAllShop.h"
#import "ZXDChineseString.h"
#import "ManagerShopinfo.h"
@interface VCAllShop ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,strong)NSMutableArray *arrayPinyin;

@end

@implementation VCAllShop

#pragma -mark custem
-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@stores/querystore.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict;
    if ([[ShareModel shareModel].roleID isEqualToString:@"2"]||[[ShareModel shareModel].roleID isEqualToString:@"6"]) {
        dict = @{@"appkey":appKeyStr,
                 @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                 @"CompanyInfoId":compid,
                 @"DepartmentId":[ShareModel shareModel].departmentID,
                 @"RoleId":[ShareModel shareModel].roleID,
                 @"code":self.code};
    }else
    {
        dict = @{@"appkey":appKeyStr,
                 @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                 @"CompanyInfoId":compid,
                 @"DepartmentId":[ShareModel shareModel].departmentID,
                 @"RoleId":[ShareModel shareModel].roleID,
                 };
    }
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            NSMutableArray *array = [[responseObject valueForKey:@"list"]mutableCopy];
            
            NSMutableArray *arrayName = [NSMutableArray array];
            
            for (NSDictionary *dictName in array) {
                [arrayName addObject:dictName[@"storeName"]];
            }
            //返回的数据按照店名首字母重新排序
            for (int i=0;i<array.count;i++) {
                NSDictionary *dict1 = array[i];
                NSMutableString *mutableString = [NSMutableString stringWithString:dict1[@"storeName"]];
                //将汉字转换为拼音(带音标)
                CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformMandarinLatin, NO);
                //去掉拼音的音标
                CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
                NSString *pinYin1 = [[mutableString capitalizedString]substringToIndex:1];
                for (int j=0; j<i; j++) {
                    NSDictionary *dict2 = array[j];
                    NSMutableString *mutableString = [NSMutableString stringWithString:dict2[@"storeName"]];
                    //将汉字转换为拼音(带音标)
                    CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformMandarinLatin, NO);
                    //去掉拼音的音标
                    CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
                    NSString *pinYin2 = [[mutableString capitalizedString]substringToIndex:1];
                    if ([pinYin1  compare:pinYin2]==NSOrderedAscending) {
                        [array exchangeObjectAtIndex:i withObjectAtIndex:j];
                    }
                }
                
            }
            
            //名字首字母相同的放在一起
            NSString *stringtemp;
            NSDictionary *dictInfo = [NSDictionary dictionary];
            NSMutableArray *arrNew2;
            NSMutableArray *arrayPincin = [NSMutableArray array];
            
            for (int i=0;i<array.count;i++) {
                dictInfo = array[i];
                
                NSMutableString *mutableString = [NSMutableString stringWithString:dictInfo[@"storeName"]];
                //将汉字转换为拼音(带音标)
                CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformMandarinLatin, NO);
                NSLog(@"%@", mutableString);
                
                //去掉拼音的音标
                CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
                NSLog(@"%@", mutableString);
                
                
                NSString *pinYin = [[mutableString capitalizedString]substringToIndex:1];
                
                if (![stringtemp isEqualToString:pinYin]) {
                    arrNew2 = [NSMutableArray array];
                    [arrNew2 addObject:dictInfo];
                    [self.arrayData addObject:arrNew2];
                    [self.arrayPinyin addObject:pinYin];
                    //遍历
                    stringtemp = pinYin;
                }
                
                else
                {
                    [arrNew2 addObject:dictInfo];
                    [arrayPincin addObject:pinYin];
                }
                
            }
            
            
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

-(void)setUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


#pragma -mark tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayData[section]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = self.arrayData[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[@"storeName"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayData[indexPath.section][indexPath.row];
    ManagerShopinfo *vc = [[ManagerShopinfo alloc]init];
    
    [ShareModel shareModel].shopID = [NSString stringWithFormat:@"%@",dict[@"id"]];
    if ([dict[@"code"]intValue]==1) {
        [ShareModel shareModel].showRightItem = YES;
    }
    else
    {
        [ShareModel shareModel].showRightItem = NO;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.arrayPinyin[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arrayIndex = [NSMutableArray array];
    
    for (int i=65; i<90; i++) {
        NSString *string = [NSString stringWithFormat:@"%c",i];
        [arrayIndex addObject:string];
    }
    return arrayIndex;
}


#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.arrayData removeAllObjects];
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"店家管理";
    [self setUI];
    
    self.arrayData = [NSMutableArray array];
    self.arrayPinyin = [NSMutableArray array];
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
