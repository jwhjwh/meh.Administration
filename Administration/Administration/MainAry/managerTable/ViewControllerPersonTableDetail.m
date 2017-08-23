//
//  ViewControllerPersonTableDetail.m
//  Administration
//
//  Created by zhang on 2017/8/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerPersonTableDetail.h"
#import "CellTabelDetail.h"
#import "ViewControllerPostil.h"
#import "ZXYAlertView.h"
@interface ViewControllerPersonTableDetail ()<UITableViewDelegate,UITableViewDataSource,ZXYAlertViewDelegate,UIAlertViewDelegate>
@property (nonatomic,weak)UIView *viewHeader;
@property (nonatomic,weak)UILabel *labelDate;
@property (nonatomic,weak)UILabel *labeAdress;
@property (nonatomic,weak)UILabel *labelPosition;
@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSArray *arrContent;
@property (nonatomic,strong)UIAlertView *alertView;
@end

@implementation ViewControllerPersonTableDetail
#pragma -mark custem
-(void)getData
{
}

-(void)checkTable:(UIButton *)button
{
    ZXYAlertView *alt = [ZXYAlertView alertViewDefault];
    alt.title = @"审核";
    alt.buttonArray = @[@"通过",@"不通过"];
    [alt.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    alt.delegate = self;
    [alt show];
}

-(void)editContent:(UIButton *)button
{
    CellTabelDetail *cell = (CellTabelDetail *)[[button superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ViewControllerPostil *vc = [[ViewControllerPostil alloc]init];
    vc.stringName = self.arrayTitle[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)initView
{
    UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Scree_width, 112)];
    viewHeader.backgroundColor = GetColor(200, 200, 200, 1);
    [self.view addSubview:viewHeader];
    self.viewHeader = viewHeader;
    
    NSArray *array = @[@"    日期",@"    陌拜地址",@"    职位",@"    姓名"];
    for(int i=0;i<4;i++)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, i*28, 120, 27)];
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = [UIColor whiteColor];
        label.text = array[i];
        [viewHeader addSubview:label];
    }
    
    UILabel *labelDate = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, Scree_width-120, 27)];
    labelDate.textColor = [UIColor lightGrayColor];
    labelDate.backgroundColor = [UIColor whiteColor];
    [viewHeader addSubview:labelDate];
    self.labelDate = labelDate;
    
    UILabel *labelAdress = [[UILabel alloc]initWithFrame:CGRectMake(120, 28, Scree_width-120, 27)];
    labelAdress.textColor = [UIColor lightGrayColor];
    labelAdress.backgroundColor = [UIColor whiteColor];
    [viewHeader addSubview:labelAdress];
    self.labeAdress = labelAdress;
    
    UILabel *labelPosition = [[UILabel alloc]initWithFrame:CGRectMake(120, 56, Scree_width-120, 27)];
    labelPosition.textColor = [UIColor lightGrayColor];
    labelPosition.backgroundColor = [UIColor whiteColor];
    [viewHeader addSubview:labelPosition];
    self.labelPosition = labelPosition;
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(120, 84, Scree_width-120, 27)];
    labelName.textColor = [UIColor lightGrayColor];
    labelName.backgroundColor = [UIColor whiteColor];
    [viewHeader addSubview:labelName];
    self.labelName = labelName;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:[CellTabelDetail class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewHeader.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView = tableView;
    
}

#pragma -mark alertView
-(void)alertView:(ZXYAlertView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        self.alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否将次内容审核为通过？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.alertView.tag = 200;
        [self.alertView show];
        
    }else
    {
        self.alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否将次内容审核为不通过？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.alertView.tag = 300;
        [self.alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        //审核接口
    }
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTabelDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellTabelDetail alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.button addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
    cell.labelTitle.text = self.arrayTitle[indexPath.row];
    cell.labelContent.text = @"哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
    
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CellTabelDetail *cell = [tableView cellForRowAtIndexPath:indexPath];
//    CGSize size = [cell.labelContent.text boundingRectWithSize:CGSizeMake(Scree_width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//    
//    return size.height+27;
//}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    [self initView];
    
    self.arrayTitle = @[@"今日目标及工作详细内容",@"自我状态评估",@"自我打分",@"原因",@"感悟分享及心得",@"明日计划安排"];
    self.arrContent = [NSArray array];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"审核" style:(UIBarButtonItemStyleDone) target:self action:@selector(checkTable:)];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
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
