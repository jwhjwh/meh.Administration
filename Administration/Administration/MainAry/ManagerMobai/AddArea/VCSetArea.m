//
//  VCSetArea.m
//  Administration
//
//  Created by zhang on 2017/11/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCSetArea.h"
#import "ViewChooseCity.h"

@interface VCSetArea ()<ViewChooseCityDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)ViewChooseCity *chooseCity;
@property (nonatomic,strong)NSMutableDictionary *dictProvince;
@property (nonatomic,strong)NSString *areaID;
@property (nonatomic)BOOL isChangeArea;
@end

@implementation VCSetArea

#pragma -mark custem

-(void)showCityView
{
    ViewChooseCity *city = [[ViewChooseCity alloc]initWithFrame:CGRectMake(0, kTopHeight+45, Scree_width, Scree_height)];
    city.delegate = self;
    [self.view addSubview:city];
    self.chooseCity = city;
}

-(void)setUI
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(submitData)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *buttonArea = [[UIButton alloc]initWithFrame:CGRectMake(-1, kTopHeight, Scree_width+2, 44)];
    buttonArea.layer.borderWidth = 1.0f;
    buttonArea.layer.borderColor = GetColor(239, 239, 244, 1).CGColor;
    buttonArea.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonArea.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [buttonArea setBackgroundColor:[UIColor whiteColor]];
    [buttonArea setTitle:@"负责区域" forState:UIControlStateNormal];
    [buttonArea setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonArea addTarget:self action:@selector(showCityView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonArea];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(buttonArea.frame.size.width-20, 15, 15, 10)];
    imageView.image = [UIImage imageNamed:@"down"];
    [buttonArea addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(-2, 200, Scree_width+4, 30)];
    label.layer.borderColor = GetColor(239, 239, 244, 1).CGColor;
    label.layer.borderWidth = 2.0f;
    label.text = @"   负责区域";
    label.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 231, Scree_width, Scree_height-231)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(void)submitData
{
    [self.chooseCity removeFromSuperview];
    
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSString *urlStr ;
    NSDictionary *dict;
    
   NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dictProvince options:NSJSONWritingPrettyPrinted error:nil];
   NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (self.isChangeArea) {
        urlStr =[NSString stringWithFormat:@"%@shop/updateRegion.action",KURLHeader];
        dict = @{@"appkey":appKeyStr,
                 @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                 @"CompanyInfoId":compid,
                 @"RoleId":[NSString stringWithFormat:@"%@",self.dictInfo[@"roleId"]],
                 @"DepartmentId":[ShareModel shareModel].departmentID,
                 @"Province":jsonString,
                 @"userid":[NSString stringWithFormat:@"%@",self.dictInfo[@"usersId"]],
                 @"id":self.areaID,
                 };
    }else
    {
        urlStr =[NSString stringWithFormat:@"%@shop/InsertRegion.action",KURLHeader];
        dict = @{@"appkey":appKeyStr,
                 @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                 @"CompanyInfoId":compid,
                 @"RoleId":[NSString stringWithFormat:@"%@",self.dictInfo[@"roleId"]],
                 @"DepartmentId":[ShareModel shareModel].departmentID,
                 @"Province":jsonString,
                 @"userid":[NSString stringWithFormat:@"%@",self.dictInfo[@"usersId"]]
                 };
    }
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0f];
            return;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0f];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view  MBPro:YES];
}

-(void)deleteArea:(NSIndexPath *)indexPath
{
    NSString *urlStr = [NSString stringWithFormat:@"%@shop/deleteRegion.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dictArea = self.arrayData[indexPath.row];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"CompanyInfoId":compid,
                           @"id":[NSString stringWithFormat:@"%@",dictArea[@"id"]],
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.arrayData removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

#pragma -mark viewChooseCityDelegate

-(void)getCity
{
    NSMutableArray *arrayProvince = [self.chooseCity.arrayProvince mutableCopy];
    NSMutableArray *arrayCity = [self.chooseCity.arrayCity mutableCopy];
    NSMutableArray *arrayCountry = [self.chooseCity.arrayCountry mutableCopy];
    
    for (int i=0; i<arrayCity.count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:arrayCity[i] forKey:@"cityName"];
        [dict setValue:arrayCountry forKey:@"countyList"];
        [arrayCity replaceObjectAtIndex:i withObject:dict];
    }
    
    for (int i=0; i<arrayProvince.count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:arrayProvince[i] forKey:@"provinceName"];
        [dict setValue:arrayCity forKey:@"cityList"];
        self.dictProvince = dict;
    }
    
    [self.tableView reloadData];
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.imageView.image = [UIImage imageNamed:@"location_ico"];
    cell.textLabel.numberOfLines = 0;
    NSDictionary *dict = self.arrayData[indexPath.row];
    NSData *jsonData = [dict[@"province"] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *province = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
    
    NSString * stringProvince = [NSString stringWithFormat:@"%@\\",province[@"provinceName"]];
    NSArray *arrayCity = province[@"cityList"];
    for (int i=0;i<arrayCity.count;i++) {
        
        NSDictionary *dictCity = arrayCity[i];
        if (i>0) {
            stringProvince = [stringProvince stringByAppendingFormat:@"\n        %@\\",dictCity[@"cityName"] ];
        }else
        {
            stringProvince = [stringProvince stringByAppendingFormat:@"%@\\",dictCity[@"cityName"] ];
        }
        
        NSArray *arrayCountry = dictCity[@"countyList"];
        stringProvince = [stringProvince stringByAppendingFormat:@"%@\\",[arrayCountry componentsJoinedByString:@"\\"]];
    }
    
    cell.textLabel.text = stringProvince;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayData[indexPath.row];
    self.areaID = [NSString stringWithFormat:@"%@",dict[@"id"]];
    self.isChangeArea = YES;
    ViewChooseCity *city = [[ViewChooseCity alloc]initWithFrame:CGRectMake(0, kTopHeight+45, Scree_width, Scree_height) ];
    city.delegate = self;
    [self.view addSubview:city];
    self.chooseCity = city;
    
}

//左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteArea:indexPath];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return @"删除";//默认文字为 Delete
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"负责区域";
    self.isChangeArea = NO;
    [self setUI];
    self.arrayData = [NSMutableArray array];
    NSDictionary *dict =self.dictInfo[@"lists"][0];
    if (![dict[@"province"]isKindOfClass:[NSNull class]]) {
        self.arrayData = [self.dictInfo[@"lists"]mutableCopy];
    }
    
    self.dictProvince = [NSMutableDictionary dictionary];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.chooseCity removeFromSuperview];
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
