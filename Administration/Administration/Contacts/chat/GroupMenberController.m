//
//  GroupMenberController.m
//  Administration
//
//  Created by zhang on 2017/7/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GroupMenberController.h"
#import "ZJLXRTableViewCell.h"
@interface GroupMenberController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arrayMenber;
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
    NSDictionary *dictInfo = @{@"appkey":appKeyStr,@"usersid":userid,@"groupinformationId":@190};
    
    [ZXDNetworking GET:urlStr parameters:dictInfo success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.arrayMenber = [NSMutableArray arrayWithObject:[responseObject valueForKey:@"list"]];
            return ;
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            
            return ;
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            return ;
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"1111"]) {
            return ;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
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
    if (section==0) {
        return @"群主（1人）";
    }else if (section>0&&section<27)
    {
        return @"dd";
    }else
        return @"#";
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJLXRTableViewCell *cell = [[ZJLXRTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[ZJLXRTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.model = self.arrayMenber[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"dddd");
}

-(NSArray *)tableViewAtIndexes:(NSIndexSet *)indexes
{
    return nil;
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"群成员";
    self.arrayMenber = [[NSMutableArray alloc]init];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:NSClassFromString(@"ZJLXRTableViewCell") forCellReuseIdentifier:@"cell"];
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
