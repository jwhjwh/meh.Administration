//
//  DetaStoresActivity.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DetaStoresActivity.h"
#import "ActiviTableViewCell.h"
#import "ViewChooseEdit.h"
#import "activity.h"
@interface DetaStoresActivity ()<UITableViewDelegate,UITableViewDataSource,ViewChooseEditDelegate>
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)ViewChooseEdit *chooseEdit;
@property (nonatomic,weak)UIButton *buttonAll;
@property (nonatomic,weak)UIButton *buttonDel;
@property (nonatomic,weak)UIView *viewBottom;
@property (nonatomic,strong)NSMutableArray *arraySelect;
@property (nonatomic) BOOL isDelete;

@end

@implementation DetaStoresActivity
-(void)getHttpData
{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectSummary.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.Storeid,@"SummaryTypeid":self.SummaryTypeid};

    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        [self.arrayData removeAllObjects];
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.arrayData = [[responseObject valueForKey:@"list"]mutableCopy];
            
            if (self.arrayData.count==0) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, Scree_width, 20)];
                label.text = @"暂无添加待办事项";
                label.font = [UIFont systemFontOfSize:17];
                [self.view addSubview:label];
            }else
            {
                [self.tableView reloadData];
            }
            
            return ;
            
        }
        if ([code isEqualToString:@"4444"]) {
            [self.tableView reloadData];
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"1001"]) {
            [self.tableView reloadData];
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"5000"]) {
            [self.tableView reloadData];
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return;
        }
        
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}



-(void)setUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate =self;
    tableView.dataSource = self;
    [tableView registerClass:[ActiviTableViewCell class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(-1, Scree_height, Scree_width+2, 40)];
    [self.view addSubview:viewBottom];
    self.viewBottom = viewBottom;
    
    UIButton *buttonAll = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, viewBottom.frame.size.width/2, 40)];
    buttonAll.layer.borderColor = GetColor(213, 214, 215, 1).CGColor;
    buttonAll.layer.borderWidth = 0.5f;
    [buttonAll setTitle:@"全选" forState:UIControlStateNormal];
    [buttonAll setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonAll addTarget:self action:@selector(allChoose) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:buttonAll];
    self.buttonAll = self.buttonAll;
    
    UIButton *buttonDel = [[UIButton alloc]initWithFrame:CGRectMake(viewBottom.frame.size.width/2, 0, viewBottom.frame.size.width/2, 40)];
    buttonDel.layer.borderColor = GetColor(213, 214, 215, 1).CGColor;
    buttonDel.layer.borderWidth = 0.5f;
    [buttonDel setTitle:@"确定" forState:UIControlStateNormal];
    [buttonDel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonDel addTarget:self action:@selector(deleteChoose) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:buttonDel];
    self.buttonDel = buttonDel;
    
    
}

-(void)showEditView
{
    self.chooseEdit = [[ViewChooseEdit alloc]initWithFrame:self.view.frame];
    self.chooseEdit.arrayButton = @[@"添加",@"批量删除"];
    self.chooseEdit.delegate = self;
    [self.view.window addSubview:self.chooseEdit];
}

-(void)allChoose
{
    [self.arraySelect removeAllObjects];
    for (int i=0; i<self.arrayData.count; i++) {
        NSMutableDictionary *dict = [self.arrayData[i] mutableCopy];
        NSString *backlogID = [NSString stringWithFormat:@"%@",dict[@"id"]];
        [dict setValue:@"1" forKey:@"isSelect"];
        [self.arrayData replaceObjectAtIndex:i withObject:dict];
        [self.arraySelect addObject:backlogID];
    }
    [self.buttonDel setTitle:[NSString stringWithFormat:@"确定（%ld）",self.arraySelect.count] forState:UIControlStateNormal];
    [self.tableView reloadData];
}

-(void)deleteChoose
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/updateSummary.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *jsonString = [self.arraySelect componentsJoinedByString:@","];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           
                           @"Summaryid":jsonString,
                           @"SummaryTypeid":self.SummaryTypeid,
                           @"Storeid":self.Storeid,
                           @"RoleId":self.strId
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        self.viewBottom.frame = CGRectMake(-1, Scree_height, Scree_width+2, 40);
        self.tableView.frame = CGRectMake(0, 0, Scree_width, Scree_height);
        self.isDelete = NO;
        

        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
           
            [self getHttpData];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }

    } failure:^(NSError *error) {

    } view:self.view MBPro:YES];
    
}


#pragma -mark ViewChooseEditDelegate
-(void)getState
{
    NSIndexPath *indexPath = [self.chooseEdit.tableView indexPathForSelectedRow];
    if (indexPath.row==0) {
        //添加
        activity *actiVC = [[activity alloc]init];
        actiVC.modifi = YES;
        actiVC.StoreId = self.Storeid;
        actiVC.SummaryTypeid = self.SummaryTypeid;
        actiVC.strId = self.strId;
        [self.navigationController pushViewController:actiVC animated:YES];

    }else
    {
        self.isDelete = YES;
        self.tableView.frame = CGRectMake(0, 0, Scree_width, Scree_height-40);
        self.viewBottom.frame = CGRectMake(0, Scree_height-40, Scree_width, 40);
        self.buttonDel.userInteractionEnabled = YES;
        [self.tableView reloadData];
    }
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActiviTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[ActiviTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = self.arrayData[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.dict = dict;
    if (self.isDelete) {
        cell.imageView1.hidden = NO;
        [cell.imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView.mas_left).offset(8);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        if ([dict[@"isSelect"] isEqualToString:@"1"]) {
            cell.imageView1.image = [UIImage imageNamed:@"xuanzhong"];
            cell.isSelect = YES;
        }
        
    }else{
        cell.imageView1.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [self.arrayData[indexPath.row]mutableCopy];
    NSString *backlogID = [NSString stringWithFormat:@"%@",dict[@"id"]];
    
    if (self.isDelete) {
        ActiviTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([dict[@"isSelect"] isEqualToString:@"1"]) {
            [self.arraySelect removeObject:backlogID];
            cell.imageView1.image = [UIImage imageNamed:@"weixuanzhong"];
            [dict setValue:@"2" forKey:@"isSelect"];
        }else
        {
            [self.arraySelect addObject:backlogID];
            cell.imageView1.image = [UIImage imageNamed:@"xuanzhong"];
            [dict setValue:@"1" forKey:@"isSelect"];
        }
        if (self.arraySelect.count!=0) {
            [self.buttonDel setTitle:[NSString stringWithFormat:@"确定（%ld）",self.arraySelect.count] forState:UIControlStateNormal];
            [self.buttonDel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }else
        {
            [self.buttonDel setTitle:@"确定" forState:UIControlStateNormal];
            [self.buttonDel setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
            self.buttonDel.userInteractionEnabled = NO;
        }
        [self.arrayData replaceObjectAtIndex:indexPath.row withObject:dict];
        [self.tableView reloadData];
    }else
    {
        NSString *Inter = [NSString stringWithFormat:@"%@",dict[@"summarys"]];
        //跳转页面
        activity *actiVC = [[activity alloc]init];
        //Summarys    内容
        actiVC.dateStr = Inter;
        
        //Summaryid。活动概要id
        actiVC.Summaryid = backlogID ;
        
        //Storeid。 门店id
        actiVC.StoreId = self.Storeid;
        
        //SummaryTypeid。活动概要年份id
        actiVC.SummaryTypeid = self.SummaryTypeid;
        actiVC.strId = self.strId;
        actiVC.modifi = NO;
        if ([_shopInfor isEqualToString:@"1"]) {
            actiVC.shopname = @"1";
        }
        actiVC.strId = self.strId;
        [self.navigationController pushViewController:actiVC animated:YES];
       
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}



#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.arrayData removeAllObjects];
    [self getHttpData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.shopname;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.arrayData = [NSMutableArray array];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    if ([_shopInfor isEqualToString:@"1"]) {
        
    }else{
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"..." style:(UIBarButtonItemStyleDone) target:self action:@selector(showEditView)];
        [rightitem setTitleTextAttributes:dictionary forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightitem;
    }
    
    
    self.isDelete = NO;
    
    self.arraySelect = [NSMutableArray array];
    
    [self setUI];
    
   
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

