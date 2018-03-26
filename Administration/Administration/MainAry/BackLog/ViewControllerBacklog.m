//
//  ViewControllerBacklog.m
//  Administration
//
//  Created by zhang on 2017/10/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerBacklog.h"
#import "CellBacklog.h"
#import "ViewChooseState.h"
#import "ViewControllerStateBacklog.h"
#import "VCBacklogDetail.h"
#import "VCAddBacklog.h"
@interface ViewControllerBacklog ()<UITableViewDelegate,UITableViewDataSource,ViewChooseStateDelegate>
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)ViewChooseState *viewState;
@end

@implementation ViewControllerBacklog

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@matters/SelectMatters.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"Matterstype":@"0",
                           };
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.arrayData = [[responseObject valueForKey:@"list"]mutableCopy];
            
            if (self.arrayData.count==0) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, Scree_width, 20)];
                label.text = @"暂无添加待办事项";
                label.font = [UIFont systemFontOfSize:17];
                [self.view addSubview:label];
            }else
            {
                [self.tableView reloadData];
            }
            
            return ;
            
        }
        
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
            [self.tableView reloadData];
            return;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            [self.tableView reloadData];
            return;
        }
        if ([code isEqualToString:@"5000"]) {
//            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            UINoResultView *resultView = [[UINoResultView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height-104) Title:@"暂无数据"];
            [self.view addSubview:resultView];
            [self.tableView reloadData];
            return;
        }
        
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    
    UIView *viewT = [[UIView alloc]init];
    viewT.layer.borderColor = [UIColor lightGrayColor].CGColor;
    viewT.layer.borderWidth = 1.0f;
    [self.view addSubview:viewT];
    [viewT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.right.mas_equalTo(self.view.mas_right).offset(1);
        make.top.mas_equalTo(self.view.mas_top).offset(kTopHeight);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    button.adjustsImageWhenHighlighted = NO;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitle:@"全部待办事项" forState:UIControlStateNormal];
    [button setBackgroundColor:GetColor(236,237,238,1)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showDateBacklog) forControlEvents:UIControlEventTouchUpInside];
    [viewT addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewT.mas_top).offset(5);
        make.left.mas_equalTo(viewT.mas_left).offset(10);
        make.right.mas_equalTo(viewT.mas_right).offset(-10);
        make.bottom.mas_equalTo(viewT.mas_bottom).offset(-5);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"jiantou_03"];
    [button addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(button.mas_right).offset(-5);
        make.centerY.mas_equalTo(button.mas_centerY);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(15);
    }];
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [tableView registerClass:[CellBacklog class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(viewT.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView = tableView;
    
    
}

-(void)showDateBacklog
{
    ViewChooseState *viewState = [[ViewChooseState alloc]initWithFrame:self.view.frame];
    viewState.delegate =self;
    [self.view addSubview:viewState];
    self.viewState = viewState;
    
}

-(void)gotoAddBacklog
{
    VCAddBacklog *vc = [[VCAddBacklog alloc]init];
    vc.isSelect = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark ViewChooseStateDelegate

-(void)getClickIndex
{
    ViewControllerStateBacklog *vc = [[ViewControllerStateBacklog alloc]init];
    NSIndexPath *indexPath = [self.viewState.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.viewState.tableView cellForRowAtIndexPath:indexPath];
    vc.state = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    vc.stringTitle = cell.textLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -make tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellBacklog *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellBacklog alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.dict = self.arrayData[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayData[indexPath.row];
    VCBacklogDetail *vc = [[VCBacklogDetail alloc]init];
    vc.backlogID = [NSString stringWithFormat:@"%@",dict[@"id"]];
    vc.matterstype = [NSString stringWithFormat:@"%@",dict[@"matterstype"]];
    [self.navigationController pushViewController:vc animated:YES];
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
    self.title = @"全部待办事项";
    self.arrayData = [NSMutableArray array];
    [self setUI];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:30],NSFontAttributeName ,nil];
 //   NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"+" style:(UIBarButtonItemStyleDone) target:self action:@selector(gotoAddBacklog)];
    [rightitem setTitleTextAttributes:dictionary forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
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
