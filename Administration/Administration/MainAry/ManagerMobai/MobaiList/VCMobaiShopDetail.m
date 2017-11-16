//
//  VCMobaiShopDetail.m
//  Administration
//
//  Created by zhang on 2017/11/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCMobaiShopDetail.h"
#import "CellMobaiDetail.h"
@interface VCMobaiShopDetail ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSArray *arrayContent;
@property (nonatomic,weak)UITableView *tableView;
@end

@implementation VCMobaiShopDetail

#pragma -mark custem

-(void)setUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CellMobaiDetail class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellMobaiDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellMobaiDetail alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.labelTitle.text = self.arrayTitle[indexPath.row];
    cell.labelContent.text = self.arrayContent[indexPath.row];
    return cell;
}

#pragma -mark system
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.arrayTitle = @[@"类型",@"经营年限",@"美容师人数",@"床位"];
    self.arrayContent = @[self.stringType,self.stringLimit,self.stringPerson,self.stringBed];
    
    
    self.title = self.stringTitle;
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
