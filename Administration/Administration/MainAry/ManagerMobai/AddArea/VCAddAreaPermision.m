//
//  VCAddAreaPermision.m
//  Administration
//
//  Created by zhang on 2017/11/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCAddAreaPermision.h"
#import "CellChargePerson.h"
#import "VCSetArea.h"
#import "VCBuessPostion.h"
@interface VCAddAreaPermision ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UIButton *buttonAdd;
@property (nonatomic,weak)UIButton *buttonDelet;
@end

@implementation VCAddAreaPermision

-(void)setUI
{
    
    UIView *viewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 45)];
    viewFooter.backgroundColor = GetColor(192, 192, 192, 1);
    [self.view addSubview:viewFooter];
    
    UIButton *buttonAdd = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, viewFooter.frame.size.width, 44)];
    [buttonAdd setBackgroundColor:[UIColor whiteColor]];
    [buttonAdd setTitle:@"添加一项" forState:UIControlStateNormal];
    [buttonAdd setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonAdd setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
    [buttonAdd addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [viewFooter addSubview:buttonAdd];
    self.buttonAdd = buttonAdd;
    
    UIButton *buttonDelet = [[UIButton alloc]initWithFrame:CGRectMake(buttonAdd.frame.size.width,0,viewFooter.frame.size.width,44)];
    [buttonDelet setBackgroundColor:[UIColor whiteColor]];
    [buttonDelet setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
    [buttonDelet setTitle:@"删除一项" forState:UIControlStateNormal];
    [buttonDelet setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonDelet addTarget:self action:@selector(delet) forControlEvents:UIControlEventTouchUpInside];
    [viewFooter addSubview:self.buttonDelet];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = viewFooter;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(void)add
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"负责人员" forKey:@"charge"];
    [dict setValue:@"1" forKey:@"state"];
    [dict setValue:@"tj_ico01" forKey:@"icon"];
    [dict setValue:@"" forKey:@"name"];
    [array addObject:@"负责区域"];
    [array addObject:dict];
    [[ShareModel shareModel].arrayData insertObject:array atIndex:[ShareModel shareModel].arrayData.count];
    [self.tableView reloadData];
}

-(void)delet
{
    
}

-(void)submitData:(UIButton *)button
{
    
}

-(void)addPerson
{
    VCBuessPostion *vc = [[VCBuessPostion alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showDeletButton
{
    
}

#pragma -mark tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [ShareModel shareModel].arrayData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [ShareModel shareModel].arrayData[indexPath.section];
    if (indexPath.row==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = array[0];
        return cell;
    }else
    {
        CellChargePerson *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[CellChargePerson alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell.buttonAdd addTarget:self action:@selector(addPerson) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonDel addTarget:self action:@selector(showDeletButton) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonRed addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         NSDictionary *dcit = array[1];
        cell.dict = dcit;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        VCSetArea *vc = [[VCSetArea alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 44;
    }
    else
    {
        return 90;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    view.backgroundColor = GetColor(239,239,244, 1);
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width-40, 5, 40, 20)];
    button.tag = section+10;
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitData:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加负责区域权限";
    
    [ShareModel shareModel].arrayData = [NSMutableArray array];
    
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
