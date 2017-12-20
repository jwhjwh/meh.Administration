
//
//  VCActList.m
//  Administration
//
//  Created by zhang on 2017/12/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCActListManager.h"
#import "CellTrack1.h"
#import "VCActDetailManager.h"
#import "UIViewStateChoose.h"
@interface VCActListManager ()<UITableViewDelegate,UITableViewDataSource,UIViewStateChooseDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UIViewStateChoose *chooseView;
@property (nonatomic)BOOL isDelete;
@property (nonatomic,strong)NSMutableArray *arraySelect;
@property (nonatomic,weak)UIView *viewBottom;
@end

@implementation VCActListManager
#pragma -mark custem
-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/selectSummary.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"SummaryTypeid":self.actID,
                           @"Storeid":[ShareModel shareModel].shopID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            
            NSArray *arrya = [responseObject valueForKey:@"list"];
            for (int i=0; i<arrya.count; i++) {
                NSMutableDictionary *dict = [arrya[i]mutableCopy];
                [dict setValue:@"1" forKey:@"isSelect"];
                [self.arrayData addObject:dict];
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

-(void)showChooseView
{
    UIViewStateChoose *chooseView = [[UIViewStateChoose alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    chooseView.delegate = self;
    [self.view addSubview:chooseView];
    self.chooseView = chooseView;
}

-(void)setUI
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"..." style:UIBarButtonItemStyleDone target:self action:@selector(showChooseView)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    if ([ShareModel shareModel].showRightItem) {
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    
    UITableView *tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate=  self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, Scree_height, Scree_width, 44)];
    [self.view addSubview:viewBottom];
    self.viewBottom  = viewBottom;
    
    UIButton *buttonAll = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Scree_width/2, 44)];
    [buttonAll setTitle:@"全选" forState:UIControlStateNormal];
    [buttonAll setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonAll addTarget:self action:@selector(buttonAll) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:buttonAll];
    
    UIButton *buttonDelete = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width/2, 0, Scree_width/2, 44)];
    [buttonDelete setTitle:@"确定" forState:UIControlStateNormal];
    [buttonDelete setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonDelete addTarget:self action:@selector(buttonDelete) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:buttonDelete];
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

-(void)buttonDelete
{
    [self deleteAct];
}

-(void)deleteAct
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/updateSummary.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSMutableArray *arrayid = [NSMutableArray array];
    for (NSDictionary *dict in self.arraySelect) {
        [arrayid addObject:[NSString stringWithFormat:@"%@",dict[@"id"]]];
    }
    
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"SummaryTypeid":self.actID,
                           @"Storeid":[ShareModel shareModel].shopID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"Summaryid":[arrayid componentsJoinedByString:@","]
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
        if ([code isEqualToString:@"0003"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
#pragma -mark chooseView

-(void)getClickRow:(UITableView *)tableview
{
    NSIndexPath *indexPath = [tableview indexPathForSelectedRow];
    if (indexPath.row==0) {
        VCActDetailManager *vc = [[VCActDetailManager alloc]init];
        vc.actID = self.actID;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        self.isDelete = YES;
        self.tableView.frame = CGRectMake(0, 0, Scree_width, Scree_height-44);
        self.viewBottom.frame = CGRectMake(0, Scree_height-44, Scree_width, 44);
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
    CellTrack1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellTrack1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dict = self.arrayData[indexPath.row];
    cell.labelTitle.text = dict[@"summarys"];
    cell.textView.text = [dict[@"dates"]substringWithRange:NSMakeRange(5, 11)];
    cell.textView.textAlignment = NSTextAlignmentRight;
    cell.textView.userInteractionEnabled = NO;
    if (self.isDelete) {
        [cell.imageViewSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView.mas_left).offset(8);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        
        if ([dict[@"isSelect"]isEqualToString:@"1"]) {
            cell.imageViewSelect.image = [UIImage imageNamed:@"djq_ico"];
        }else
        {
            cell.imageViewSelect.image = [UIImage imageNamed:@"djh_ico"];
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [self.arrayData[indexPath.row]mutableCopy];
    if (self.isDelete) {
        
        if ([dict[@"isSelect"]isEqualToString:@"1"]) {
            [dict setValue:@"2" forKey:@"isSelect"];
            [self.arrayData replaceObjectAtIndex:indexPath.row withObject:dict];
            [self.arraySelect addObject:dict];
        }else
        {
            [dict setValue:@"1" forKey:@"isSelect"];
            [self.arrayData replaceObjectAtIndex:indexPath.row withObject:dict];
            [self.arraySelect removeObject:dict];
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }else
    {
    VCActDetailManager *vc = [[VCActDetailManager alloc]init];
    vc.content = dict[@"summarys"];
        vc.actID = [NSString stringWithFormat:@"%@",dict[@"summaryTypeid"]];
    [self.navigationController pushViewController:vc animated:YES];
    }
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
    
    self.arrayData = [NSMutableArray array];
    [self setUI];
    self.isDelete = NO;
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
