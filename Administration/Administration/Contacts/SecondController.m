//
//  SecondController.m
//  Segmente-Deno
//
//  Created by 郭军 on 2016/11/24.
//  Copyright © 2016年 JUN. All rights reserved.
//

#import "SecondController.h"
#import "GuideTableViewCell.h"
#import "inftionxqController.h"
#import "ZJLXRTableViewCell.h"
#import "DepalistController.h"
#import "JoblistController.h"
#import "LVModel.h"
#import "LVFmdbTool.h"
@interface SecondController () <UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UIButton *sousuoBtn;//搜索框

@property (nonatomic,retain)NSArray *indexArray;
@property (nonatomic ,retain)NSArray *gameArrs;
@property (nonatomic ,retain)NSArray *nameArrs;
@property (nonatomic,strong)NSMutableArray *dataArray;//数据源
@end

@implementation SecondController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableArray *array=[NSMutableArray arrayWithArray:[LVFmdbTool selectLately:[USER_DEFAULTS objectForKey:@"userid"]]];
    self.dataArray=[NSMutableArray arrayWithArray:[[array reverseObjectEnumerator] allObjects]];
    [self.tableView reloadData];
//    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _indexArray=@[@"最近联系人"];
    _nameArrs = @[@"按职位查看",@"按部门查看"];
    _gameArrs =@[@"yggl_02",@"yggl_03"];
    [self addViewremind];
}
-(void)addViewremind{
    _sousuoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sousuoBtn.frame=CGRectMake(10, 74, Scree_width-20, 40);
    [_sousuoBtn setBackgroundImage:[UIImage imageNamed:@"ss_ico01"] forState:UIControlStateNormal];
    //防止图片变灰
    _sousuoBtn.adjustsImageWhenHighlighted = NO;
    _sousuoBtn.layer.masksToBounds = YES;
    _sousuoBtn.layer.cornerRadius = 8.0;
    [_sousuoBtn addTarget:self action:@selector(Touchsearch)forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_sousuoBtn];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0,_sousuoBtn.bottom+9,self.view.bounds.size.width,1)];
    line1.backgroundColor = GetColor(230,230,230,1);
    [self.view addSubview:line1];
    self.tableView= [[UITableView alloc]initWithFrame:CGRectMake(0,_sousuoBtn.bottom+10,self.view.bounds.size.width,self.view.frame.size.height-173) style:UITableViewStylePlain];
    self.tableView.dataSource=self;
    self.tableView.delegate =self;
    //滑动条去掉
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
     return 50.0f;
}else{
     return 70.0f;
}
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return _nameArrs.count;
    }
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = GetColor(230,230,230,1);
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor grayColor];
    header.textLabel.font = [UIFont systemFontOfSize:14.0f];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        NSString * str = [NSString stringWithFormat:@"  %@",_indexArray[0]];
        return str;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.gameArrs.count>0) {
        if(section==1){
            return 30;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  单元格的选中类型一定不能设置为 UITableViewCellSelectionStyleNone，如果加上这一句，全选勾选不出来
     */
    if (indexPath.section==0) {
        static NSString *identifi = @"gameCell";
        GuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
        if (!cell) {
            cell = [[GuideTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = _nameArrs[indexPath.row];
        cell.image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@", _gameArrs[indexPath.row]]];
        cell.backgroundColor = [UIColor clearColor];
          return cell;
    }else{
        ZJLXRTableViewCell *celled = [[ZJLXRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        if (celled == nil) {
            celled = [[ZJLXRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        }
        celled.dict = self.dataArray[indexPath.row];
          return celled;
    }
  
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row ==0) {
            //职位
            JoblistController *Joblist=[[JoblistController alloc]init];
            Joblist.Num=1;
            [self.navigationController pushViewController:Joblist animated:YES];
            
        }else{
            //部门
            DepalistController *DepVC=[[DepalistController alloc]init];
             DepVC.Num=1;
            DepVC.roid = @"0";
            [self.navigationController pushViewController:DepVC animated:YES];
        }
    }else{
        //详情
        ZJLXRTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSDictionary *dict = self.dataArray[indexPath.row];
        inftionxqController *imftionVC=[[inftionxqController alloc]init];
        cell.dict = dict;
        imftionVC.IDStr=dict[@"userid"];
        [self.navigationController pushViewController:imftionVC animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)Touchsearch{
    SearchViewController *SearchVC = [[SearchViewController alloc]init];
    [self.navigationController showViewController:SearchVC sender:nil];
}

@end
