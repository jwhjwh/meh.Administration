//
//  VCEditTable.m
//  Administration
//
//  Created by zhang on 2017/9/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCEditTable.h"
#import "CellEditTable.h"
@interface VCEditTable ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *arrayDate;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSString *stringDate;
@property (nonatomic,strong)NSString *stringDescribe;
@property (nonatomic,strong)NSMutableDictionary *dictionary;
@end

@implementation VCEditTable

-(void)getData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryDayPlanInfo",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS valueForKey:@"userid"],@"CompanyInfoId":compid,@"id":self.dayPlabID,@"RoleId":[ShareModel shareModel].roleID};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.stringDate = [[responseObject valueForKey:@"date"] substringToIndex:10];
            self.stringDescribe = [responseObject valueForKey:@"describe"];
            
           self.dictionary =  [[responseObject valueForKey:@"lists"]mutableCopy];
            [self.dictionary setValue:@"1" forKey:@"canEdit"];
            
            for (NSDictionary *dict in [[self.dictionary valueForKey:@"lists"]mutableCopy]) {
                [dict setValue:@"1" forKey:@"canEdit"];
                [self.arrayDate addObject:dict];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    
    UIView *viewBotttom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 40)];
    viewBotttom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewBotttom];

    UIButton *buttonAdd = [[UIButton alloc]initWithFrame:CGRectMake(-1, 0, viewBotttom.frame.size.width/2, 40)];
    buttonAdd.tag = 100;
    [buttonAdd setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
    [buttonAdd setTitle:@"添加一项" forState:UIControlStateNormal];
    [buttonAdd setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [viewBotttom addSubview:buttonAdd];
 
    UIButton *buttonDel = [[UIButton alloc]initWithFrame:CGRectMake(viewBotttom.frame.size.width/2, 0, viewBotttom.frame.size.width/2, 40)];
    buttonAdd.tag = 200;
    [buttonDel setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
    [buttonDel setTitle:@"删除一项" forState:UIControlStateNormal];
    [buttonDel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [viewBotttom addSubview:buttonDel];

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.tableFooterView = viewBotttom;
    [tableView registerClass:[CellEditTable class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)editContent:(UIButton *)button
{
    NSUInteger index = button.tag;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:index -10];
    NSMutableDictionary *dict = [self.arrayDate[index-10]mutableCopy];
    
    
    
    
    
}
#pragma -mark tableviw
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayDate.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }else
    {
        return 4;
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellEditTable *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        cell = [[CellEditTable alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        
        if ([self.dictionary[@"canEdit"]isEqualToString:@"1"]) {
            cell.textView.scrollEnabled = NO;
            cell.textView.userInteractionEnabled = NO;
        }else
        {
            cell.textView.scrollEnabled = YES;
            cell.textView.userInteractionEnabled = YES;
        }
        
        if (indexPath.row==0) {
            cell.labelTitle.text = @"日期";
            cell.textView.text = self.stringDate;
        }
        if (indexPath.row==1) {
            cell.labelTitle.text = @"概要描述";
            cell.textView.text = self.stringDescribe;
        }
    }else
    {
        NSDictionary *dict = self.arrayDate[indexPath.section-1];
        cell.labelTitle.text = self.arrayTitle[indexPath.row];
        if ([dict[@"canEdit"] isEqualToString:@"1"]) {
            cell.textView.scrollEnabled = NO;
            cell.textView.userInteractionEnabled = NO;
        }else
        {
            cell.textView.scrollEnabled = YES;
            cell.textView.userInteractionEnabled = YES;
        }
        if (indexPath.row==0) {
            cell.textView.text = dict[@"others"];
        }
        if (indexPath.row==1) {
            cell.textView.text = dict[@"jobAim"];
        }
        if (indexPath.row==2) {
            cell.textView.text = dict[@"detailMethod"];
        }
        if (indexPath.row==3) {
            cell.textView.text = dict[@"helped"];
        }
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 30)];
    view.backgroundColor = GetColor(237, 238, 239, 1);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 6, 100, 15)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor lightGrayColor];
    if (section==0) {
        label.text = @"其他";
    }else
    {
        label.text = @"详细事项";
    }
    [view addSubview:label];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width-90, 6, 100, 20)];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = section+10;
    [view addSubview:button];
    return view;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
    
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"日计划";
    
    self.arrayTitle = @[@"事项",@"工作目标",@"具体方法思路",@"需要协调与帮助"];
    self.arrayDate = [NSMutableArray array];
    self.dictionary = [NSMutableDictionary dictionary];
    [self setUI];
    
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
