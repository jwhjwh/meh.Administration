//
//  GroupMenberController.m
//  Administration
//
//  Created by zhang on 2017/7/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GroupMenberController.h"
#import "GroupMenberCell.h"
#import "ZXDChineseString.h"
typedef void (^detail)(id result);
@interface GroupMenberController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (nonatomic,strong)UITableView *tableViewMenber;
@property (nonatomic,strong)NSMutableArray *arrayMenber;
@property (nonatomic,strong)NSMutableArray *arrayIndex;
@end

@implementation GroupMenberController

#pragma -mark callback



- (NSMutableArray *)dataArray
{
    if (self.arrayMenber == nil) {
        self.arrayMenber = [NSMutableArray array];
    }
    
    return self.arrayMenber;
}

-(void)getGroupMenbers
{
    NSString *urlStr =[NSString stringWithFormat:@"%@group/selectGroupMembers.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *userid = [USER_DEFAULTS objectForKey:@"userid"];
    NSDictionary *dictInfo = @{@"appkey":appKeyStr,@"usersid":userid,@"groupinformationId":self.groupinformation[@"id"]};
    
    [ZXDNetworking GET:urlStr parameters:dictInfo success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.arrayMenber = [responseObject valueForKey:@"list"];
            NSMutableArray *arrName = [NSMutableArray array];
            NSDictionary *dict = [NSDictionary dictionary];
            for (int i=0; i<self.arrayMenber.count; i++) {
                dict = self.arrayMenber[i];
                [arrName addObject:dict[@"name"]];
                
            }
            self.arrayIndex = [ZXDChineseString IndexArray:arrName];
            [self.tableViewMenber reloadData];
        }
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
            return ;
        }
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请重新登录" andInterval:1.0];
            return ;
        }
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"1111"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return ;
        }

        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

-(void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看群成员位置",@"邀请群成员",@"删除群成员",@"退出该群", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSLog(@"1");
    }else if (buttonIndex==1)
    {
        NSLog(@"2");
    }else if (buttonIndex==2)
    {
        NSLog(@"3");
    }else
        NSLog(@"4");
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    if (section==0)
        return @"群主（1人）";
    
//    else
//        return self.arrayIndex[section];
    
}

-(NSArray *)tableViewAtIndexes:(NSIndexSet *)indexes
{
    return self.arrayIndex;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupMenberCell *cell = [[GroupMenberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[GroupMenberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = self.arrayMenber[indexPath.row];
    NSString *logoImage=[NSString stringWithFormat:@"%@%@",KURLHeader,dict[@"img"]];
    [cell.TXImage sd_setImageWithURL:[NSURL URLWithString:logoImage] placeholderImage:[UIImage imageNamed:@"banben100"]];
    
    cell.nameLabel.text = dict[@"name"];
    cell.TelLabel.text = dict[@"account"];
    cell.dict = dict;
    if ([dict[@"userId"]isEqualToString:[USER_DEFAULTS valueForKey:@"userid"]]) {
        cell.zhiLabel.text = @"我";
    }
    else
    {
        cell.zhiLabel.text = @"";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"dddd");
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"群成员";
    self.arrayMenber = [NSMutableArray array];
    self.arrayIndex = [[NSMutableArray alloc]init];
    self.tableViewMenber = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    self.tableViewMenber.delegate = self;
    self.tableViewMenber.dataSource = self;
    [self.tableViewMenber registerClass:NSClassFromString(@"GroupMenberCell") forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableViewMenber];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"点击" style:UIBarButtonItemStyleDone target:self action:@selector(showActionSheet)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.arrayIndex = [NSMutableArray array];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getGroupMenbers];
    
    
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
