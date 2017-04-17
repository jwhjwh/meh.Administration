//
//  ChosebradController.m
//  Administration
//
//  Created by zhang on 2017/4/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ChosebradController.h"
#import "ChooseTableViewCell.h"
@interface ChosebradController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *branTableView;
/** 数据源 */
@property (nonatomic ,copy)NSMutableArray *gameArrs;
@property (nonatomic,strong)NSIndexPath *index;
@end

@implementation ChosebradController

-(NSMutableArray *)gameArrs
{
    
    if (!_gameArrs) {
        _gameArrs = [NSMutableArray arrayWithArray:@[@"列表1",@"列表2",@"列表3",@"列表4",@"列表5",@"列表6",@"列表7",@"列表8",@"列表9",@"列表10",@"列表11",@"列表12",@"列表13",@"列表14",@"列表15",@"列表16",@"列表17",@"列表18",@"列表19",@"列表20",@"列表21",@"列表22",@"列表23",@"列表24"]];
    }
    return _gameArrs;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"所选品牌";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    self.branTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
 
    self.branTableView.delegate = self;
    self.branTableView.dataSource = self;
    self.branTableView.tableFooterView = [[UIView alloc] init];
    self.branTableView.backgroundColor = [UIColor whiteColor];
    self.branTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.branTableView];
    /*=========================至关重要============================*/
    self.branTableView.allowsMultipleSelectionDuringEditing = YES;
    self.branTableView.editing =YES;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,Scree_height-49,Scree_width,1)];
    view.backgroundColor = [UIColor RGBview];
    [self.view addSubview:view];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor whiteColor];
    button.frame=CGRectMake(0,Scree_height-48,Scree_width,48);
    [button setTitle:@"确认" forState:UIControlStateNormal];
    [button setTitleColor:GetColor(7, 138, 249, 1) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(allDelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
   
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.gameArrs.count;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifi = @"gameCell";
    ChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    
    if (!cell) {
        cell = [[ChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    cell.tintColor = [UIColor RGBNav];
    
    /**
     *  单元格的选中类型一定不能设置为 UITableViewCellSelectionStyleNone，如果加上这一句，全选勾选不出来
     */
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.titleLabel.text = self.gameArrs[indexPath.row];
    [ cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,self.gameArrs[indexPath.row]]]placeholderImage:[UIImage imageNamed:@"banben100"]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70.0f;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!(_index.length==0)) {
         [tableView deselectRowAtIndexPath:_index animated:YES];//选中后的反显颜色即刻消失
    }
    _index=indexPath;
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([self.branTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.branTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.branTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.branTableView setLayoutMargins:UIEdgeInsetsZero];
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



@end
