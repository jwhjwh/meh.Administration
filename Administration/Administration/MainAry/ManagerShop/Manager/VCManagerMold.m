//
//  VCManagerMold.m
//  Administration
//
//  Created by zhang on 2017/12/21.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCManagerMold.h"
#import "newCooperation.h"
#import "VCPartnerMold.h"
#import "quasiCooperation.h"
@interface VCManagerMold ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (strong,nonatomic)NSArray *arrayData;
@end
@implementation VCManagerMold

#pragma -mark custem
-(void)setUI
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    
}
#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.arrayData[indexPath.row];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            //跳转合作客户
        {
            VCPartnerMold *vc = [[VCPartnerMold alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            //跳转新合作客户
            newCooperation *newVC = [[newCooperation alloc]init];
            [self.navigationController pushViewController:newVC animated:YES];
        }break;
        case 2:{
                //跳转准合作客户
                quasiCooperation *quasiVC = [[quasiCooperation alloc]init];
                [self.navigationController pushViewController:quasiVC animated:YES];
            }
            break;
            
        default:
            break;
    }
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.arrayData = @[@"合作客户",@"新合作客户",@"准客户"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
