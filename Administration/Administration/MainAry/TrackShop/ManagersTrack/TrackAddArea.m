//
//  TrackAddArea.m
//  Administration
//
//  Created by zhang on 2017/12/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TrackAddArea.h"
#import "UIChooseArea.h"
@interface TrackAddArea ()<UIChooseAreaDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UIImageView *imageView;
@property (nonatomic,weak)UIChooseArea *chooseArea;
@property (nonatomic,strong)NSMutableDictionary *dictArea;
@property (nonatomic,weak)UIBarButtonItem *rightItem;
@property (nonatomic)BOOL isClick;
@end

@implementation TrackAddArea

-(void)setUI
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, kTopHeight, Scree_width, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button setTitle:@"执行区域" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showArea) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //down
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(Scree_width-30, 10, 15, 15)];
    imageView.image = [UIImage imageNamed:@"jiantou_03"];
    [button addSubview:imageView];
    self.imageView = imageView;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(chooseAreaDone)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.rightItem = rightItem;
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight +44, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)chooseAreaDone
{
    self.isClick = NO;
    [self.chooseArea removeFromSuperview];
    self.imageView.image = [UIImage imageNamed:@"jiantou_03"];
    if ([self.dictArea[@"Province"] isEqualToString:@""]||
        [self.dictArea[@"City"] isEqualToString:@""]||
        [self.dictArea[@"County"] isEqualToString:@""]) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择区域" andInterval:1.0];
        return;
    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
        [[ShareModel shareModel].arrayArea addObject:self.dictArea];
        [self.tableView reloadData];
    }
}


-(void)showArea
{
    self.isClick = !self.isClick;
    if (self.isClick) {
        self.imageView.image = [UIImage imageNamed:@"down"];
        UIChooseArea *chooseArea = [[UIChooseArea alloc]initWithFrame:CGRectMake(0, kTopHeight+44, Scree_width, Scree_height-kTopHeight-44)];
        chooseArea.delegate = self;
        [self.view addSubview:chooseArea];
        self.chooseArea = chooseArea;
        self.navigationItem.rightBarButtonItem = self.rightItem;
    }else
    {
        self.imageView.image = [UIImage imageNamed:@"jiantou_03"];
        [self.chooseArea removeFromSuperview];
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

#pragma -mark UIChooseAreaDelegate

-(void)getChooseArea
{
    self.dictArea = [self.chooseArea.dictArea mutableCopy];
    [self.chooseArea.dictArea removeAllObjects];
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ShareModel shareModel].arrayArea.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *dict = [ShareModel shareModel].arrayArea[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"trackLocation"];
    
    NSString *string = [NSString stringWithFormat:@"%@ %@ %@",dict[@"Province"],dict[@"City"],dict[@"County"]];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:string];
    
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(string.length-[dict[@"Country"] length], [dict[@"Country"] length])];
    cell.textLabel.attributedText = text;
    
    return cell;
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"执行区域";
    [self setUI];
    
    self.isClick = NO;
    self.dictArea = [NSMutableDictionary dictionary];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.chooseArea removeFromSuperview];
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
