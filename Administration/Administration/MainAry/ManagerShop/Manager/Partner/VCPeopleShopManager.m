//
//  VCPeopleShopManager.m
//  Administration
//
//  Created by zhang on 2017/12/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCPeopleShopManager.h"
#import "UIViewStateChoose.h"
#import "CellShopManager.h"
#import "VCAllotShopManager.h"
@interface VCPeopleShopManager ()<UITableViewDelegate,UITableViewDataSource,UIViewStateChooseDelegate>
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UIView *viewBottom;
@property (nonatomic,strong)NSMutableArray *arraySelect;
@property (nonatomic)BOOL isDelete;
@end

@implementation VCPeopleShopManager

#pragma -mark custem
-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@stores/selectUsersidStore.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"usersids":self.userID,
                           @"RoleIds":self.roleID,
                           @"code":self.stringCode
                           };
    [self.arrayData removeAllObjects];
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            for (int i=0; i<[[responseObject valueForKey:@"list"]count]; i++) {
                NSMutableDictionary *dictinfo = [[responseObject valueForKey:@"list"][i]mutableCopy];
                [dictinfo setValue:@"1" forKey:@"isSelect"];
                [self.arrayData addObject:dictinfo];
            }
            
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
        if ([code isEqualToString:@"0003"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无权限" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"..." style:UIBarButtonItemStyleDone target:self action:@selector(rightItem)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CellShopManager class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, Scree_height, Scree_width, kTabBarHeight)];
    viewBottom.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:viewBottom];
    self.viewBottom = viewBottom;
    
    UIButton *buttonAll = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Scree_width/2, kTabBarHeight)];
    [buttonAll setTitle:@"全选" forState:UIControlStateNormal];
    [buttonAll setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonAll setBackgroundColor:[UIColor whiteColor]];
    [buttonAll addTarget:self action:@selector(buttonAll) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:buttonAll];
    
    UIButton *buttonSure = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width/2+1, 0, Scree_width/2-1, kTabBarHeight)];
    [buttonSure setTitle:@"删除" forState:UIControlStateNormal];
    [buttonSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonSure setBackgroundColor:[UIColor whiteColor]];
    [buttonSure addTarget:self action:@selector(buttonSure) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:buttonSure];
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

-(void)buttonSure
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in self.arraySelect) {
        [array addObject:[NSString stringWithFormat:@"%@",dict[@"storeid"]]];
    }
    
    NSString *urlStr =[NSString stringWithFormat:@"%@stores/deleteUsersidstore.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"usersids":self.userID,
                           @"RoleIds":self.roleID,
                           @"code":self.stringCode,
                           @"st":[[array componentsJoinedByString:@","]stringByAppendingString:@","]
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
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
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)rightItem
{
    UIViewStateChoose *stateChoose = [[UIViewStateChoose alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    stateChoose.delegate = self;
    [self.view.window addSubview:stateChoose];
}
#pragma -mark UIViewStateChooseDelegate

-(void)getClickRow:(UITableView *)tableview
{
    NSIndexPath *indexPath = [tableview indexPathForSelectedRow];
    if (indexPath.row==0) {
        VCAllotShopManager *vc = [[VCAllotShopManager alloc]init];
        vc.userid = self.userID;
        vc.roleID = self.roleID;
        vc.stringCode = self.stringCode;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        self.isDelete = YES;
        self.tableView.frame = CGRectMake(0, 0, Scree_width, Scree_height-kTabBarHeight);
        self.viewBottom.frame = CGRectMake(0, Scree_height-kTabBarHeight, Scree_width, kTabBarHeight);
        [self.tableView reloadData];
    }
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    CellShopManager *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CellShopManager alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.dict = self.arrayData[indexPath.row];
    
    if (self.isDelete) {
        [cell.imageViewSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo (cell.contentView.mas_left).offset(8);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [self.arrayData[indexPath.row]mutableCopy];
    if (self.isDelete) {
        
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
}

#pragma -mark system
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getHttpData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    [self setUI];
    self.arraySelect = [NSMutableArray array];
    self.arrayData = [NSMutableArray array];
    self.isDelete = NO;
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
