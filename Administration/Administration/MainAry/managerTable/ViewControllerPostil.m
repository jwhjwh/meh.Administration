//
//  ViewControllerPostil.m
//  Administration
//
//  Created by zhang on 2017/8/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerPostil.h"
#import "CellPostil.h"
#import "ViewPostil.h"
@interface ViewControllerPostil ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSArray *array;
@property (nonatomic,strong)NSDictionary *dictPosition;
@end

@implementation ViewControllerPostil

#pragma -mark custem
-(void)initView
{
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Scree_width, 50)];
    viewTop.backgroundColor = GetColor(255, 252, 241, 1);
    [self.view addSubview:viewTop];
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Scree_width,47)];
    labelName.backgroundColor = GetColor(255, 249, 230, 1);
    labelName.text = [NSString stringWithFormat:@"    %@",self.stringName];
    [viewTop addSubview:labelName];
    self.labelName = labelName;
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 114, Scree_width, 1)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:viewLine];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 115, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = GetColor(255, 252, 241, 1);
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 200;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [tableView registerClass:[CellPostil class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellPostil *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellPostil alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = self.array[indexPath.row];
    cell.labelPosition.text = dict[@"position"];
    if ([dict[@"show"]isEqualToString:@"0"]) {
        NSLog(@"不显示");
    }else
    {
        NSLog(@"显示");
        
        ViewPostil *viewPostil = [[ViewPostil alloc]init];
        [cell.contentView addSubview:viewPostil];
        [viewPostil mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView.mas_left).offset(8);
            make.right.mas_equalTo(cell.contentView.mas_right).offset(-8);
            make.top.mas_equalTo(cell.contentView.mas_top).offset(30);
            make.height.mas_equalTo(150);
        }];
        
    }
    cell.contentView.backgroundColor = GetColor(255, 252, 241, 1);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        return 200;
    }
    return 50;
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"批注";
    [self initView];
    NSString *roleid = [USER_DEFAULTS valueForKey:@"roleId"];


    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:(UIBarButtonItemStyleDone) target:self action:@selector(checkTable:)];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    
    self.dictPosition = @{@"1":@"老板",
                           @"2":@"美导",
                           @"3":@"客服",
                           @"4":@"物流",
                           @"5":@"业务",
                           @"6":@"品牌经理",
                           @"7":@"行政管理",
                           @"8":@"业务经理",
                           @"9":@"业务总监",
                           @"10":@"市场总监",
                           @"11":@"财务总监",
                           @"12":@"客服经理",
                           @"13":@"物流经理",
                           @"14":@"仓库",
                           @"15":@"财务经理",
                           @"16":@"会计",
                           @"17":@"出纳"};
    
    [self.dictPosition enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([roleid isEqualToString:key]) {
            obj = self.dictPosition[roleid];
            NSLog(@"obj = %@",obj);
            NSString *stringObj = [NSString stringWithFormat:@"%@",obj];
            if ([stringObj containsString:@"老板"]) {
                self.array = @[@{@"position":@"经理批注",@"show":@"0"},@{@"position":@"行政批注",@"show":@"0"},@{@"position":@"老板批注",@"show":@"1"}];
            }else if([stringObj containsString:@"行政"])
            {
                self.array = @[@{@"position":@"经理批注",@"show":@"0"},@{@"position":@"行政批注",@"show":@"1"},@{@"position":@"老板批注",@"show":@"0"}];
            }else if([stringObj containsString:@"总监"])
            {
                self.array = @[@{@"position":@"总监批注",@"show":@"1"},@{@"position":@"行政批注",@"show":@"0"},@{@"position":@"老板批注",@"show":@"0"}];
            }else
            {
                self.array = @[@{@"position":@"经理批注",@"show":@"1"},@{@"position":@"行政批注",@"show":@"0"},@{@"position":@"老板批注",@"show":@"0"}];
            }
        }
    }];
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
