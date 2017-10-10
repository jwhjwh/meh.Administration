//
//  VCNewPostil.m
//  Administration
//
//  Created by zhang on 2017/10/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCNewPostil.h"
#import "CellSummaryList.h"
#import "VCArtShopPostil.h"
#import "VCArtWeekPostil.h"
#import "VCArtWeekSummaryPostil.h"
#import "VCArtMonthPostil.h"
#import "VCArtMonthSummaryPostil.h"
#import "VCInsideShopPostil.h"
#import "VCInsideWeekPostil.h"
#import "VCInsideWeekSummaryPostil.h"
#import "VCInsideMonthPostil.h"
#import "VCInsideMonthSummaryPostil.h"
#import "VCBuessShopPostil.h"
#import "VCBuessWeekPostil.h"
#import "VCBuessWeekSummaryPostil.h"
@interface VCNewPostil ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSDictionary *remark;
@end

@implementation VCNewPostil


#pragma -mark custem



-(void)setUI
{
    UILabel *label = [[UILabel alloc]init];
    if (self.arrayData.count==0) {
        label.text = @"  新批注报表";
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1];
    }else
    {
        label.text = [NSString stringWithFormat:@"  新批注报表(%ld)",self.arrayData.count];
    }
    label.font = [UIFont systemFontOfSize:12];
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1.0f;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.top.mas_equalTo(self.view.mas_top).offset(kTopHeight);
        make.right.mas_equalTo(self.view.mas_right).offset(1);
        make.height.mas_equalTo(17);
    }];
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    [tableView registerClass:[CellSummaryList class] forCellReuseIdentifier:@"cell"];
    [tableView reloadData];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(label.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView = tableView;
}


#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellSummaryList *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellSummaryList alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = self.arrayData[indexPath.row];
    [self.remark enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:[NSString stringWithFormat:@"%@",dict[@"remark"]]]) {
            NSString *string = [NSString stringWithFormat:@"%@",obj];
            cell.labelMode.text = [string substringWithRange:NSMakeRange(2, 3)];
            *stop = YES;
        }
    }];
    
    NSString *state = [NSString stringWithFormat:@"%@",dict[@"state"]];
    
    NSString *stringDate;
    if (![dict[@"updateTime"] isKindOfClass:[NSNull class]])
    {
        stringDate = [dict[@"updateTime"]substringWithRange:NSMakeRange(5, 11)];
    }
    
    if ([state isEqualToString:@"0"]) {
        cell.labelState.text = @"待审核";
    }else if([state isEqualToString:@"1"])
    {
        cell.labelState.text = [NSString stringWithFormat:@"通过%@",stringDate];
    }else
    {
        cell.labelState.text = [NSString stringWithFormat:@"驳回%@",stringDate];
        cell.labelState.textColor = GetColor(240, 53, 68, 1);
    }
    
    
    if ([[ShareModel shareModel].sort isEqualToString:@"1"]) {
        if (dict[@"dateLine"]) {
            cell.labelTime.text = [dict[@"dateLine"] substringToIndex:10];
        }
        
        if (dict[@"dates"]) {
            cell.labelUpTime.text = [dict[@"dates"] substringWithRange:NSMakeRange(5, 11)];
        }
    }else if([[ShareModel shareModel].sort isEqualToString:@"2"])
    {
        NSString *startDate;
        NSString *endDate;
        if (![dict[@"startDate"] isKindOfClass:[NSNull class]]) {
            startDate = [dict[@"startDate"] substringToIndex:10];
        }
        if (![dict[@"endDate"] isKindOfClass:[NSNull class]]) {
            endDate = [dict[@"endDate"] substringToIndex:10];
        }
        cell.labelTime.text = [NSString stringWithFormat:@"%@至%@",startDate,endDate];
        cell.labelUpTime.text = [dict[@"dates"] substringWithRange:NSMakeRange(5, 11)];
    }else
    {
        cell.labelTime.text = [dict[@"months"]substringToIndex:7];
        cell.labelUpTime.text = [dict[@"dates"] substringWithRange:NSMakeRange(5, 11)];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayData[indexPath.row];
    NSString *remark = dict[@"remark"];
    NSString *tableID = dict[@"id"];
    NSString *roleID = [ShareModel shareModel].roleID;
    NSString *sort = [ShareModel shareModel].sort;
    NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
    
    if ([sort isEqualToString:@"1"]) {
        if ([roleID isEqualToString:@"2"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"10"]) {
            VCArtShopPostil  *vc = [[VCArtShopPostil alloc]init];
            vc.remark = remark;
            vc.tableID = tableID;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([roleID isEqualToString:@"5"]||[roleID isEqualToString:@"8"]||[roleID isEqualToString:@"9"]) {
            //跳转业务界面
            VCBuessShopPostil *vc = [[VCBuessShopPostil alloc]init];
            vc.remark = remark;
            vc.tableID = tableID;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            VCInsideShopPostil *vc = [[VCInsideShopPostil alloc]init];
            vc.remark = remark;
            vc.tableID = tableID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if ([sort isEqualToString:@"2"]) {
        if ([roleID isEqualToString:@"2"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"10"]) {
            if ([code isEqualToString:@"1"]) {
                VCArtWeekPostil *vc = [[VCArtWeekPostil alloc]init];
                vc.remark = remark;
                vc.isSelect = YES;
                vc.tableID = tableID;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCArtWeekSummaryPostil *vc = [[VCArtWeekSummaryPostil alloc]init];
                vc.isSelect = NO;
                vc.remark = remark;
                vc.tableID = tableID;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if ([roleID isEqualToString:@"5"]||[roleID isEqualToString:@"8"]||[roleID isEqualToString:@"9"]) {
            //跳转业务界面
            if ([code isEqualToString:@"1"]) {
                VCBuessWeekPostil *vc = [[VCBuessWeekPostil alloc]init];
                vc.isSelect= YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCBuessWeekSummaryPostil *vc = [[VCBuessWeekSummaryPostil alloc]init];
                vc.isSelect = NO;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else
        {
            if ([code isEqualToString:@"1"]) {
                VCInsideWeekPostil *vc = [[VCInsideWeekPostil alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCInsideWeekSummaryPostil *vc = [[VCInsideWeekSummaryPostil alloc]init];
                vc.isSelect = NO;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }
    if ([sort isEqualToString:@"3"]) {
        if ([roleID isEqualToString:@"2"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"10"]) {
            
            if ([code isEqualToString:@"1"]) {
                VCArtMonthPostil *vc = [[VCArtMonthPostil alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCArtMonthSummaryPostil *vc = [[VCArtMonthSummaryPostil alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else  {
            if ([code isEqualToString:@"1"]) {
                VCInsideMonthPostil *vc = [[VCInsideMonthPostil alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCInsideMonthSummaryPostil *vc = [[VCInsideMonthSummaryPostil alloc]init];
                vc.isSelect = NO;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }
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
    self.title = @"新批注";
    
    [self setUI];
    
    self.remark = @{@"1":@"业务日报表",
                    @"2":@"业务周计划",
                    @"3":@"业务周总结",
                    @"4":@"市场店报表",
                    @"5":@"市场周计划",
                    @"6":@"市场周总结",
                    @"7":@"市场月计划",
                    @"8":@"市场月总结",
                    @"9":@"内勤日报表",
                    @"10":@"内勤周计划",
                    @"11":@"内勤周总结",
                    @"12":@"内勤月计划",
                    @"13":@"内勤月总结"};

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
