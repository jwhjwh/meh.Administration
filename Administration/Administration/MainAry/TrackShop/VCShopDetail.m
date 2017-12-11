//
//  VCShopDetail.m
//  Administration
//
//  Created by zhang on 2017/12/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCShopDetail.h"
#import "VCShopInfo.h"
#import "VCBossInfo.h"
#import "VCPersonInfo.h"
#import "VCCustemInfo.h"
@interface VCShopDetail ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;
@end

@implementation VCShopDetail

#pragma -mark custem

-(void)setUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.arrayData[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        VCShopInfo *vc = [[VCShopInfo alloc]init];
        vc.shopID = self.shopID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row==1)
    {
        VCBossInfo *vc = [[VCBossInfo alloc]init];
        vc.shopID = self.shopID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==2)
    {
        VCPersonInfo *vc = [[VCPersonInfo alloc]init];
        vc.shopID = self.shopID;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        VCCustemInfo *vc = [[VCCustemInfo alloc]init];
        vc.shopID = self.shopID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    [self setUI];
    
    self.arrayData = @[@"门店信息",@"老板信息",@"店员信息",@"顾客信息"];
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
