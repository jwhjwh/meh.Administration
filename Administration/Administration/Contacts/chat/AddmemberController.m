//
//  AddmemberController.m
//  Administration
//
//  Created by zhang on 2017/3/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AddmemberController.h"
#import "inftionxqController.h"
#import "ChatgrouController.h"
#import "LVModel.h"
#import "LVFmdbTool.h"
@interface AddmemberController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UIButton *sousuoBtn;//搜索框
@property (strong,nonatomic) UIView *view1;//第一条线
@property (strong,nonatomic) UILabel * lxLabel;//最近联系人Label
@property (strong,nonatomic) UITableView *ZJLXTable;//最近联系人列表
@property (nonatomic,strong)NSMutableArray *dataArray;//数据源
@property (nonatomic,strong)NSMutableArray *ImageAry;//各部门图片
@property (nonatomic,strong)UIButton *allDelButton;
@property (nonatomic,strong)UIButton *delButton;
@end

@implementation AddmemberController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableArray *array=[NSMutableArray arrayWithArray:[LVFmdbTool queryData:nil]];
    self.dataArray=[NSMutableArray arrayWithArray:[[array reverseObjectEnumerator] allObjects]];
    [self.ZJLXTable reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"添加群成员";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    [self UIBtn];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)UIBtn{
    //搜索按钮
    UIView *viewles=[[UIView alloc]init];
    [self.view addSubview:viewles];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SeachTap:)];
    [viewles addGestureRecognizer:tap];
    [viewles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.mas_equalTo(40);
    }];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"seach"] forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    button.frame=CGRectMake(13,7,30,30);
    //防止图片变灰
    [viewles addSubview:button];
    UILabel *labelSeach=[[UILabel alloc]initWithFrame:CGRectMake(50, 5, 80, 30)];
    labelSeach.text=@"搜索";
    [viewles addSubview:labelSeach];
    
    //分割线
    _view1 = [[UIView alloc]init];
    _view1.backgroundColor = [UIColor RGBview];
    [self.view addSubview:_view1];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(viewles.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
    UIView *view=[[UIView alloc]init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(_view1.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(49);
    }];
    UITapGestureRecognizer *taposition = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SpositionTap:)];
    [view addGestureRecognizer:taposition];
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setBackgroundImage:[UIImage imageNamed:@"archite"] forState:UIControlStateNormal];
    but.adjustsImageWhenHighlighted = NO;
    but.frame=CGRectMake(13,5, 39,39);
    //防止图片变灰
    [view addSubview:but];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(65,10 ,100, 29)];
    label.text=@"按职位选择";
    [view addSubview:label];
    UIButton *buton=[UIButton buttonWithType:UIButtonTypeCustom];
    [buton setBackgroundImage:[UIImage imageNamed:@"jiantou_03"] forState:UIControlStateNormal];
    buton.frame=CGRectMake(Scree_width-35,15,19,19);
    //防止图片变灰
    [view addSubview:buton];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor RGBview];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];
    //最近联系人
    _lxLabel = [[UILabel alloc]init];
    _lxLabel.text= @"最近联系人";
    _lxLabel.textColor = [UIColor RGBview];
    _lxLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_lxLabel];
    [_lxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.top.mas_equalTo(line.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor RGBview];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(_lxLabel.mas_bottom).offset(5);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];
    //最近联系人列表
    _ZJLXTable = [[UITableView alloc]init];
    _ZJLXTable.backgroundColor = [UIColor whiteColor];
    // _ZJLXTable.separatorStyle = UITableViewCellSelectionStyleNone;
    _ZJLXTable.delegate = self;
    _ZJLXTable.dataSource = self;
    [self.view addSubview:_ZJLXTable];
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr. minimumPressDuration=0.1f;
    [_ZJLXTable addGestureRecognizer:longPressGr];
    /*=========================至关重要============================*/
    _ZJLXTable.allowsMultipleSelectionDuringEditing = YES;
    //去除多余的cell线
    [ZXDNetworking setExtraCellLineHidden:_ZJLXTable];
    [_ZJLXTable registerNib:[UINib nibWithNibName:@"ZJLXRTableViewCell" bundle:nil] forCellReuseIdentifier:@"BASE"];
    [_ZJLXTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom).offset(5);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-49);
    }];
    UIView *loni=[[UIView alloc]initWithFrame:CGRectMake(0,Scree_height-49,Scree_width/2,1)];
    loni.backgroundColor=GetColor(230, 230, 230, 1);
    [self.view addSubview:loni];
    _allDelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _allDelButton.frame=CGRectMake(0,Scree_height-48,Scree_width/2,48);
    [_allDelButton setTitle:@"全选" forState:UIControlStateNormal];
    [_allDelButton setTitleColor:GetColor(7, 138, 249, 1) forState:UIControlStateNormal];
    [_allDelButton addTarget:self action:@selector(allDelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_allDelButton];
    
    _delButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _delButton.frame=CGRectMake(Scree_width/2,Scree_height-49,Scree_width/2, 49);
    [_delButton setTitle:@"确定(2)" forState:UIControlStateNormal];
    [_delButton setBackgroundColor:GetColor(204, 174, 212, 1)];
    [_delButton addTarget:self action:@selector(deltButn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_delButton];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJLXRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BASE"forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:0];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.model=self.dataArray[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture {
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        _ZJLXTable.editing = !_ZJLXTable.editing;
        
    }
}
//所点选的按钮
-(void)deleteArr
{
    
    NSMutableArray *deleteArrarys = [NSMutableArray array];
    for (NSIndexPath *indexPath in _ZJLXTable.indexPathsForSelectedRows) {
        [deleteArrarys addObject:self.dataArray[indexPath.row]];
    }
    
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
    
}
-(void)deltButn{
    ChatgrouController *chatGrVC=[[ChatgrouController alloc]init];
    [self.navigationController pushViewController:chatGrVC animated:YES];
}


@end
