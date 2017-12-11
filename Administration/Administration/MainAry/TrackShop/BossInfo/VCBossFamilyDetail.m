
//
//  VCBossFamilyDetail.m
//  Administration
//
//  Created by zhang on 2017/12/9.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCBossFamilyDetail.h"
#import "CellTrack1.h"
@interface VCBossFamilyDetail ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,strong)NSArray *arrayTitle;

@property (nonatomic,weak)UITableView *tableView;

@end

@implementation VCBossFamilyDetail

#pragma -mark custem

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/selectFamilienstand.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"StoreBossid":self.bossID,
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0f];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTrack1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellTrack1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = self.arrayData[indexPath.row];
    switch (indexPath.row) {
        case 0:
            cell.textView.text = dict[@"name"];
            break;
        case 1:
            cell.textView.text = dict[@"relationship"];
            break;
        case 2:
            cell.textView.text = [NSString stringWithFormat:@"%@",dict[@"age"]];
            break;
        case 3:
        {
            [cell.textView removeFromSuperview];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(170, 5, 60, 60)];
            imageView.layer.cornerRadius = 30;
            imageView.layer.masksToBounds = YES;
            [cell.contentView addSubview:imageView];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
    [self.arrayData removeAllObjects];
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"家庭情况";
    self.arrayData = [NSMutableArray array];
    self.arrayTitle = @[@"家属姓名",@"关系",@"年龄",@"照片"];
    
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
