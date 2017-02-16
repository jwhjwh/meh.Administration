//
//  IntercalateController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "IntercalateController.h"
#define MAINLABEL_TAG 1
#define SECONDLABEL_TAG 2
#define PHOTO_TAG 3

@interface IntercalateController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
}
@property (strong,nonatomic) UITableView *InterTable;
@property (strong,nonatomic) UITableViewCell *InterCell;
@property (strong,nonatomic) NSArray *InterImageAry;
@property (strong,nonatomic) NSArray *InterNameAry;


@end

@implementation IntercalateController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"设置";
    [self InterTableUI];
    _InterNameAry = [[NSArray alloc]initWithObjects:@"账号管理",@"账号安全",@"定位",@"关于软件与帮助",@"意见反馈",nil];
    _InterImageAry = [[NSArray alloc]initWithObjects:@"zhanghaoguanli",@"zhanghaoanquan",@"dingwei",@"gunyubangzhu",@"yijianliuyan",nil];
    
}
-(void)InterTableUI
{
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 20,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
     tableview.dataSource=self;
    tableview.delegate =self;
     [self.view addSubview:tableview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //定义个静态字符串为了防止与其他类的tableivew重复
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [tableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = _InterNameAry[indexPath.row];
   
    //cell.imageView.image = _InterImageAry[indexPath.row];
    UIImage *image1 = [UIImage imageNamed:@"zhanghaoguanli"];
    cell.imageView.image = image1;
   
    
    
    
    
    return cell;
    
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
