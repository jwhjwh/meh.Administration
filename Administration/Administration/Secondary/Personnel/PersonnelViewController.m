//
//  PersonnelViewController.m
//  Administration
//  联系人->>各部门人员
//  Created by 九尾狐 on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "PersonnelViewController.h"
#import "PersonneTableViewCell.h"
#import "PersonModel.h"
@interface PersonnelViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (strong,nonatomic) NSMutableArray *InterNameAry;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation PersonnelViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    int a = _roleld.intValue;
    switch (a) {
        case 2:
            self.navigationItem.title=@"市场人员";
            break;
        case 5:
            self.navigationItem.title=@"业务人员";
            break;
        case 3:
            self.navigationItem.title=@"内勤人员";
            break;
        case 4:
            self.navigationItem.title=@"物流人员";
            break;
        default:
            break;
    }
    [self loadDataFromServer];
    [self ManafementUI];
    self.view.backgroundColor = [UIColor whiteColor];
   [self setExtraCellLineHidden:self.tableView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)ManafementUI{
    //
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,self.view.bounds.size.width,self.view.bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonneTableViewCell" bundle:nil] forCellReuseIdentifier:@"CARRY"];


}
-(void)loadDataFromServer{
    NSString *uStr =[NSString stringWithFormat:@"%@user/findAllUser.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"roleId":_roleld};
  
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        _InterNameAry=[NSMutableArray array];
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *resuAry = responseObject[@"userList"];
            for (NSDictionary *newDict in resuAry) {
                PersonModel *model = [[PersonModel alloc]init];
                [model setValuesForKeysWithDictionary:newDict];
                
                [self.InterNameAry addObject:model];
            }
            [self.tableView reloadData];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到联系人" andInterval:1.0];
        }

    }
     
        failure:^(NSError *error) {
        
    }
    view:self.view MBPro:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CARRY" forIndexPath:indexPath];
    PersonModel *model= _InterNameAry[indexPath.section];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    [cell loadDataFromModel:model];
   
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    return cell;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _InterNameAry.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.0;
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   PersonModel *model =self.InterNameAry[indexPath.row];
   UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.icon];

    NSLog(@"%@",model.icon);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
