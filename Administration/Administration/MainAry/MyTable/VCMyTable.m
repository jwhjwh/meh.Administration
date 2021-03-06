//
//  VCMyTable.m
//  Administration
//
//  Created by zhang on 2017/9/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCMyTable.h"
#import "VCChooseDepartment.h"
#import "VCTableState.h"
#import "VCDepartmentDayPlan.h"
@interface VCMyTable ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *array;
@property (nonatomic,weak)UITableView *tableView;
@end

@implementation VCMyTable

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        VCDepartmentDayPlan *vc = [[VCDepartmentDayPlan alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        VCTableState *vc = [[VCTableState alloc]init];
        vc.stringTitle = self.array[indexPath.row];
        [ShareModel shareModel].sort = [NSString stringWithFormat:@"%ld",indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的报表";
    
    UILabel *label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"         %@",[ShareModel shareModel].postionName];
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1.0f;
    [self.view addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 2, 25, 25)];
    imageView.image = [UIImage imageNamed:@"zw_ico"];
    [label addSubview:imageView];
    
    UITableView *tabelView = [[UITableView alloc]init];
    tabelView.delegate = self;
    tabelView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tabelView];
    [self.view addSubview:tabelView];
    self.tableView = tabelView;
    
    NSString* phoneModel = [UIDevice devicePlatForm];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        label.frame =CGRectMake(-1, 88, Scree_width+1, 30);
        tabelView.frame =CGRectMake(0, 119, Scree_width, Scree_height);
    }else{
        label.frame =CGRectMake(-1, 64, Scree_width+1, 30);
        tabelView.frame =CGRectMake(0, 95, Scree_width, Scree_height);
    }
    
    
    
    NSString *roleID = [ShareModel shareModel].roleID;
    if ([roleID isEqualToString:@"5"]||[roleID isEqualToString:@"8"]||[roleID isEqualToString:@"9"]) {
        self.array = @[@"日计划",@"店报表",@"周报表"];
    }else
    {
        self.array = @[@"日计划",@"店报表",@"周报表",@"月报表"];
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
