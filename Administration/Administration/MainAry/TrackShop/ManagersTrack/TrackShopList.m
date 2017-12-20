//
//  TrackShopList.m
//  Administration
//
//  Created by zhang on 2017/12/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TrackShopList.h"
#import "CellShop.h"
#import "VCShopDetail.h"
@interface TrackShopList ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UISearchBar *searchBar;
@property (nonatomic,strong)NSMutableArray *arraySelect;
@property (nonatomic,strong)NSMutableArray *arrayName;
@property (nonatomic,strong)NSArray *arrayPre;
@end

@implementation TrackShopList

#pragma -mark custem

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@tracking/selectStoreid.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[ShareModel shareModel].arrayArea
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"string":string,
                           };
    [self.arrayData removeAllObjects];
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            NSArray *array = [responseObject valueForKey:@"list"];
            for (int i=0;i<array.count;i++) {
                NSMutableDictionary *dictinfo = [array[i]mutableCopy];
                [dictinfo setValue:@"1" forKey:@"isSelect"];
                [self.arrayData addObject:dictinfo];
            }
            
            for (NSDictionary *dictinfo in self.arrayData) {
                [self.arrayName addObject:dictinfo[@"storeName"]];
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

-(void)setUI
{
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, kTopHeight, Scree_width, 50)];
    searchBar.placeholder = @"搜索";
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    UIButton *buttonAll = [[UIButton alloc]initWithFrame:CGRectMake(-1, Scree_height-kTabBarHeight, Scree_width/2+1, kTabBarHeight)];
    buttonAll.layer.borderColor = GetColor(223, 224, 225, 1).CGColor;
    buttonAll.layer.borderWidth = 1.0f;
    [buttonAll setTitle:@"全选" forState:UIControlStateNormal];
    [buttonAll setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonAll addTarget:self action:@selector(buttonAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonAll];
    
    UIButton *buttonSure = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width/2, Scree_height-kTabBarHeight, Scree_width/2+2, kTabBarHeight)];
    buttonSure.layer.borderColor = GetColor(223, 224, 225, 1).CGColor;
    buttonSure.layer.borderWidth = 1.0f;
    [buttonSure setTitle:@"确定" forState:UIControlStateNormal];
    [buttonSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonSure addTarget:self action:@selector(buttonSure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSure];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight+50, Scree_width, Scree_height-50-kTabBarHeight-kTopHeight)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CellShop class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)buttonAll
{
    [[ShareModel shareModel].arrayData removeAllObjects];
    for (int i=0; i<self.arrayData.count; i++) {
        NSMutableDictionary *dict = [self.arrayData[i]mutableCopy];
        [dict setValue:@"2" forKey:@"isSelect"];
        [self.arrayData replaceObjectAtIndex:i withObject:dict];
        [[ShareModel shareModel].arrayData addObject:dict[@"name"]];
    }
    [self.tableView reloadData];
}

-(void)buttonSure
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gotoShopDetail:(UIButton *)button
{
    CellShop *cell = (CellShop *)[button superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = self.arrayData[indexPath.row];
    VCShopDetail *vc = [[VCShopDetail alloc]init];
    vc.stringTitle = dict[@"storeName"];
    vc.shopID = [NSString stringWithFormat:@"%@",dict[@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark searchbar
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSDictionary *dict = [NSDictionary dictionary];
    [self.arraySelect removeAllObjects];
    for (int i=0;i<self.arrayName.count;i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", searchText];
        
        self.arrayPre = [self.arrayName filteredArrayUsingPredicate:predicate];
    }
    
    for (NSString *name in self.arrayPre) {
        for (int i=0; i<self.arrayData.count; i++) {
            dict = self.arrayData[i];
            if ([name isEqualToString:dict[@"storeName"]]) {
                [self.arraySelect addObject:dict];
            }
        }
    }
    [self.tableView reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text =  @"";
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.searchBar isFirstResponder]) {
        return self.arraySelect.count;
    }else
    {
    return self.arrayData.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    CellShop *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CellShop alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.imageViewSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.contentView.mas_left).offset(8);
        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    NSDictionary *dict = [NSDictionary dictionary];
    if ([self.searchBar isFirstResponder]) {
        dict  = self.arraySelect[indexPath.row];
    }else
    {
        dict = self.arrayData[indexPath.row];
    }
    cell.dict = dict;
    [cell.buttonDetail addTarget:self action:@selector(gotoShopDetail:) forControlEvents:UIControlEventTouchUpInside];
    if ([dict[@"isSelect"]isEqualToString:@"1"]) {
        cell.imageViewSelect.image = [UIImage imageNamed:@"djq_ico"];
    }else
    {
        cell.imageViewSelect.image = [UIImage imageNamed:@"djh_ico"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.searchBar isFirstResponder]) {
        NSMutableDictionary *dict = [self.arraySelect[indexPath.row]mutableCopy];
        if ([dict[@"isSelect"]isEqualToString:@"1"]) {
            [dict setValue:@"2" forKey:@"isSelect"];
            [[ShareModel shareModel].arrayData addObject:dict[@"storeName"]];
        }else
        {
            [dict setValue:@"1" forKey:@"isSelect"];
            [[ShareModel shareModel].arrayData removeObject:dict[@"storeName"]];
        }
        [self.arraySelect replaceObjectAtIndex:indexPath.row withObject:dict];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else
    {
    NSMutableDictionary *dict = [self.arrayData[indexPath.row]mutableCopy];
    if ([dict[@"isSelect"]isEqualToString:@"1"]) {
        [dict setValue:@"2" forKey:@"isSelect"];
        [[ShareModel shareModel].arrayData addObject:dict[@"storeName"]];
    }else
    {
        [dict setValue:@"1" forKey:@"isSelect"];
        [[ShareModel shareModel].arrayData removeObject:dict[@"storeName"]];
    }
    [self.arrayData replaceObjectAtIndex:indexPath.row withObject:dict];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
    self.title = @"执行店家";
    [self setUI];
    self.arrayData = [NSMutableArray array];
    self.arraySelect = [NSMutableArray array];
    self.arrayName = [NSMutableArray array];
    self.arrayPre = [NSArray array];
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
