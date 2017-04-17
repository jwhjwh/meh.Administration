//
//  multiController.m
//  Administration
//
//  Created by zhang on 2017/4/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "multiController.h"
#import "ChooseTableViewCell.h"
@interface multiController ()
<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *branTableView;
@property (nonatomic,strong)UIView *view1;
/** 数据源 */
@property (nonatomic ,copy)NSMutableArray *gameArrs;
@property (nonatomic,strong) NSMutableArray *deleteArrarys;//选中的数据
@property (nonatomic,strong)NSIndexPath *index;
@property (nonatomic,strong)UIButton *allDelButton;
@property (nonatomic,strong)UIButton *delButton;
/** 标记是否全选 */
@property (nonatomic ,assign)BOOL isAllSelected;
@end

@implementation multiController
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

    _delButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _delButton.backgroundColor =[UIColor whiteColor];
    _delButton.frame=CGRectMake(Scree_width/2,Scree_height-48,Scree_width/2,48);
    [_delButton setTitle:@"确认" forState:UIControlStateNormal];
    [_delButton setTitleColor:GetColor(7, 138, 249, 1) forState:UIControlStateNormal];
    [_delButton addTarget:self action:@selector(deltButn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_delButton];
    UIButton *butt=[UIButton buttonWithType:UIButtonTypeCustom];
    butt.backgroundColor =[UIColor whiteColor];
    butt.frame=CGRectMake(0,Scree_height-48,Scree_width/2,48);
    [butt setTitle:@"全选" forState:UIControlStateNormal];
    [butt setTitleColor:GetColor(7, 138, 249, 1) forState:UIControlStateNormal];
    [butt addTarget:self action:@selector(allDelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butt];
    _view1=[[UIView alloc]initWithFrame:CGRectMake(Scree_width/2-0.5,Scree_height-44,1,39)];
    _view1.backgroundColor = [UIColor RGBview];
    [self.view addSubview:_view1];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _deleteArrarys = [NSMutableArray array];
    for (NSIndexPath *indexPath in _branTableView.indexPathsForSelectedRows) {
        [_deleteArrarys addObject:self.gameArrs[indexPath.row]];
    }
      _delButton.backgroundColor=GetColor(206, 175,219 ,1);
    [_delButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[_deleteArrarys count]] forState:UIControlStateNormal];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    [_deleteArrarys removeObject:[self.gameArrs objectAtIndex:indexPath.row]];
    if (_deleteArrarys.count==0) {
        _delButton.backgroundColor=[UIColor whiteColor];
    }
   
    [_delButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[_deleteArrarys count]] forState:UIControlStateNormal];
}
-(void)allDelBtn{
    
    self.isAllSelected = !self.isAllSelected;
    
    for (int i = 0; i<self.gameArrs.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        if (self.isAllSelected) {
            [self.branTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [_delButton setTitle:[NSString stringWithFormat:@"确定(%d)",i+1] forState:UIControlStateNormal];
            _delButton.backgroundColor=GetColor(206, 175,219 ,1);
            
        }else{//反选
            _delButton.backgroundColor =[UIColor whiteColor];
            [_delButton setTitle:@"确定(0)" forState:UIControlStateNormal];
            [self.branTableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }
    }
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
