//
//  VCPartnerMold.m
//  Administration
//
//  Created by zhang on 2017/12/21.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCPartnerMold.h"
#import "VCAllShop.h"
#import "VCAllotPersonManager.h"
@interface VCPartnerMold ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;
@end

@implementation VCPartnerMold

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
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.arrayData[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VCAllShop *vc = [[VCAllShop alloc]init];
    switch (indexPath.row) {
        case 0:
            if ([[ShareModel shareModel].roleID isEqualToString:@"2"]) {
                vc.code = @"4";
            }else
            {
                vc.code = @"1";
            }
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case 1:
            vc.code = @"2";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case 2:
        {
            VCAllotPersonManager *vc = [[VCAllotPersonManager alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
    
    
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"合作客户";
    self.arrayData = @[@"所有店家",@"待分配店家",@"待分配人员",@"待审核"];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
