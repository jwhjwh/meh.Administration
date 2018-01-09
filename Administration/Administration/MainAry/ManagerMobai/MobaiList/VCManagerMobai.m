//
//  VCManagerMobai.m
//  Administration
//
//  Created by zhang on 2017/11/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCManagerMobai.h"
#import "VCDepartmentMobai.h"
#import "VCIntentionClientele.h"
#import "VCGoalClientel.h"
#import "VCAddAreaPermision.h"
#import "VCMobaiDepartMent.h"
@interface VCManagerMobai ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSArray *array;
@end

@implementation VCManagerMobai

#pragma -mark cutem
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[ShareModel shareModel].roleID isEqualToString:@"8"]) {
        return 1;
    }else
    {
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[ShareModel shareModel].roleID isEqualToString:@"8"]) {
        return self.array.count;
    }else
    {
        NSArray *array = self.array[section];
        return array.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([[ShareModel shareModel].roleID isEqualToString:@"8"]) {
        cell.textLabel.text = self.array[indexPath.row];
    }else
    {
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[ShareModel shareModel].roleID isEqualToString:@"8"]) {
        if (indexPath.row==0) {
            //跳转界面
            VCDepartmentMobai *vc = [[VCDepartmentMobai alloc]init];
            [ShareModel shareModel].state = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==1)
        {
            //跳转界面
            VCIntentionClientele *vc = [[VCIntentionClientele alloc]init];
            [ShareModel shareModel].state = @"2";
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            VCGoalClientel *vc = [[VCGoalClientel alloc]init];
            [ShareModel shareModel].state = @"3";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else
    {
        if (indexPath.section==0) {
            VCMobaiDepartMent *vc = [[VCMobaiDepartMent alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else
        {
            if (indexPath.row==0) {
                //跳转界面
                VCDepartmentMobai *vc = [[VCDepartmentMobai alloc]init];
                [ShareModel shareModel].state = @"1";
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row==1)
            {
                //跳转界面
                VCIntentionClientele *vc = [[VCIntentionClientele alloc]init];
                [ShareModel shareModel].state = @"2";
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCGoalClientel *vc = [[VCGoalClientel alloc]init];
                [ShareModel shareModel].state = @"3";
                [self.navigationController pushViewController:vc animated:YES];
                //跳转界面
            }
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([[ShareModel shareModel].roleID isEqualToString:@"8"]) {
        return 0;
    }else
    {
        if (section==0) {
            return 20;
        }else
        {
            return 0;
        }
    }
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"陌拜管理";
    
    [self  setUI];
    
    if ([[ShareModel shareModel].roleID isEqualToString:@"8"]) {
        self.array = @[@"陌拜记录",@"意向客户",@"目标客户"];
    }else
    {
        self.array = @[@[@"负责区域权限"],@[@"陌拜记录",@"意向客户",@"目标客户"]];
    }
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
