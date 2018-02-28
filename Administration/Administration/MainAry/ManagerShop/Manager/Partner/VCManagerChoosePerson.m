//
//  VCManagerChoosePerson.m
//  Administration
//
//  Created by zhang on 2017/12/21.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCManagerChoosePerson.h"
#import "CellChargeManager.h"
@interface VCManagerChoosePerson ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arraySelect;
@end

@implementation VCManagerChoosePerson

#pragma -mark custem
-(void)getHttpData
{
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSString *urlStr;
    NSDictionary *dict;
    if ([self.stringCode isEqualToString:@"2"]) {
        urlStr = [NSString stringWithFormat:@"%@manager/checkPositionUsers.action",KURLHeader];
        dict = @{@"appkey":appKeyStr,
                 @"usersid":[USER_DEFAULTS  objectForKey:@"userid"],
                 @"CompanyInfoId":compid,
                 @"Num":self.postionID,
                 @"roleIds":[ShareModel shareModel].roleID
                 };
    }else
    {
        urlStr = [NSString stringWithFormat:@"%@stores/selectstoretype.action",KURLHeader];
        dict = @{@"appkey":appKeyStr,
                 @"usersid":[USER_DEFAULTS  objectForKey:@"userid"],
                 @"CompanyInfoId":compid,
                 @"DepartmentId":[ShareModel shareModel].departmentID,
                 @"RoleId":[ShareModel shareModel].roleID,
                 @"type":@"1",
                 };
    }
    
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            NSArray *array;
            if ([self.stringCode isEqualToString:@"2"]) {
                array = [responseObject valueForKey:@"list"];
            }else
            {
                array = [responseObject valueForKey:@"lists"];
            }
            
            for (int i=0; i<array.count; i++) {
                NSMutableDictionary *dictinfo = [array[i]mutableCopy];
                [dictinfo setValue:@"1" forKey:@"isSelect"];
                [self.arrayData addObject:dictinfo];
            }
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)addPerson
{
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *urlStr = [NSString stringWithFormat:@"%@stores/addStoreusersid.action",KURLHeader];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dictID in self.arraySelect) {
        NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];
        [dictJson setValue:[NSString stringWithFormat:@"%@",dictID[@"roleId"]] forKey:@"RoleId"];
        [dictJson setValue:[NSString stringWithFormat:@"%@",dictID[@"usersid"]] forKey:@"usersid"];
        [array addObject:dictJson];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Storeid":[ShareModel shareModel].shopID,
                           @"CompanyInfoId":compid,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"UR":string,
                           @"code":self.stringCode,
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"成功" andInterval:1.0];
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
        if ([code isEqualToString:@"0003"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无权限" andInterval:1.0];
            return;
        }
        
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)buttonAll
{
    [self.arraySelect removeAllObjects];
    for (int i=0; i<self.arrayData.count; i++) {
        NSMutableDictionary *dict = [self.arrayData[i]mutableCopy];
        [dict setValue:@"2" forKey:@"isSelect"];
        [self.arrayData replaceObjectAtIndex:i withObject:dict];
        [self.arraySelect addObject:dict];
    }
    [self.tableView reloadData];
}

-(void)setUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height-kTabBarHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CellChargeManager class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIButton *buttonAll = [[UIButton alloc]initWithFrame:CGRectMake(-1, Scree_height-kTabBarHeight, Scree_width/2+1, kTabBarHeight)];
    buttonAll.layer.borderColor = GetColor(223, 223, 223, 1).CGColor;
    buttonAll.layer.borderWidth = 1.0f;
    [buttonAll setTitle:@"全选" forState:UIControlStateNormal];
    [buttonAll setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonAll addTarget:self action:@selector(buttonAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonAll];
    
    UIButton *buttonSure = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width/2+1, Scree_height-kTabBarHeight, Scree_width/2+1, kTabBarHeight)];
    buttonSure.layer.borderColor = GetColor(223, 223, 223, 1).CGColor;
    buttonSure.layer.borderWidth = 1.0f;
    [buttonSure setTitle:@"确定" forState:UIControlStateNormal];
    [buttonSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonSure addTarget:self action:@selector(addPerson) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSure];
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    CellChargeManager *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CellChargeManager alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dict = self.arrayData[indexPath.row];
    [cell.imageViewSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.contentView.mas_left).offset(8);
        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    cell.dict = dict;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [self.arrayData[indexPath.row]mutableCopy];
    if ([dict[@"isSelect"]isEqualToString:@"1"]) {
        [dict setValue:@"2" forKey:@"isSelect"];
        [self.arraySelect addObject:dict];
    }else
    {
        [dict setValue:@"1" forKey:@"isSelect"];
        [self.arraySelect removeObject:dict];
    }
    [self.arrayData replaceObjectAtIndex:indexPath.row withObject:dict];
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    self.title = self.stringTitle;
    
    [self setUI];
    self.arrayData = [NSMutableArray array];
    self.arraySelect = [NSMutableArray array];
   
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
