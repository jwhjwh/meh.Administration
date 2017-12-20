//
//  VCShopInfoManager.m
//  Administration
//
//  Created by zhang on 2017/12/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ManagerShopinfo.h"
#import "VCBossInfoManager.h"
#import "VCCustemInfoM.h"
#import "VCPersonInfoM.h"
#import "VCShopInfoManager.h"
@interface ManagerShopinfo ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *array;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation ManagerShopinfo

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
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.array[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            VCShopInfoManager *vc = [[VCShopInfoManager alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            VCBossInfoManager *vc = [[VCBossInfoManager alloc]init];
            vc.isEdit = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            VCPersonInfoM *vc = [[VCPersonInfoM alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            VCCustemInfoM *vc = [[VCCustemInfoM alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    [self setUI];
    
    self.array = @[@"门店信息",@"老板信息",@"店员信息",@"顾客信息"];
    
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
