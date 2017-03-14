//
//  StructureViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "StructureViewController.h"
#import "UIDevice+FEPlatForm.h"
@interface StructureViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSTimer *_timerrrrrrrr;
    int     count;
}
@property (nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)NSMutableArray *indesPaths;
@property (nonatomic,assign)int DatNum;
@property(nonatomic,strong) NSTimer * timer;

@end

@implementation StructureViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self timerMethodB];
    
    _imageView = [[UIImageView alloc]init];
    [self.view addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.right).offset(0);
        make.height.mas_offset(180);
    }];
    
    
    // Do any additional setup after loading the view.
}
- (void)timerMethodB
{
    _timerrrrrrrr = [NSTimer scheduledTimerWithTimeInterval:0.5f  //间隔时间
                                              target:self
                                            selector:@selector(methodBEvnet)
                                            userInfo:nil
                                             repeats:YES];
}
- (void)methodBEvnet
{
    count ++;
    NSString *filename = [NSString stringWithFormat:@"创建账号02_%d", count];
    NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:file];
    [self.imageView setImage:image];
    if (count >= 8) {
       
        [self tableviewpUi];
         [_timerrrrrrrr invalidate];
        self.DatNum = -1;
        NSMutableArray *indexPaths = @[].mutableCopy;
        self.indesPaths = indexPaths;
        self.timer =  [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(charusell) userInfo:nil repeats:YES];
        NSLog(@"-- end");
    }
}
-(void)tableviewpUi
{
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:self.tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imageView.mas_bottom).offset(0);
            make.right.mas_equalTo(self.view.mas_right).offset(0);
            make.left.mas_equalTo(self.view.mas_left).offset(0);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        }];

}
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"职位解析",
                     @"",
                     @"",
                     @"1.老板:管理所有员工拥有所有权限",
                     @"2.行政管理:1)管理公司内所有报表等文档的手机整理 2)协",
                     @"助老板管理 3)相当于一个老板的辅助管理账号.",
                     @"3.业务总监:1)负责业务方面开拓市场所有规划 2)管理下属",
                     @"业务经理",
                     @"4.业务经理:1)负责完成业务总监的计划任务 2)管理下属业",
                     @"务员",
                     @"5.业务:负责开拓新的合作客户",
                     @"6.美导总监:1)负责已合作客户的整体销售计划 2)任务管理",
                     @"下属各品牌经理",
                     @"7.品牌经理:1)负责该品牌客户的销售、服务、管理 2)管理",
                     @"下属品牌美导.",
                     @"8.美导:服务店家的美容导师.",
                     @"9.物流:1)负责公司向店家供货的物流服务 2)管理公司产品",
                     @"储存.",
                     @"10.内勤:包裹客服、会计、招聘人员等.",
                     ];
    }
    return _dataArr;
}

-(void)charusell{
    self.DatNum = self.DatNum +1;
    if (self.DatNum < self.dataArr.count) {
        [self.indesPaths addObject:[NSIndexPath indexPathForItem:self.DatNum inSection:0]];
        [self.tableView insertRowsAtIndexPaths:self.indesPaths withRowAnimation:UITableViewRowAnimationRight];
        [self.indesPaths removeAllObjects];
    }else{
        [self.timer invalidate];
        //记得当不用这个定时器的时候要销毁.
        self.timer = nil;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DatNum+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArr[indexPath.row];
   NSString *platform = [UIDevice devicePlatForm];
    if ([platform isEqualToString:@"iPhone 4"]||[platform isEqualToString:@"iPhone 4S"]) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    }else if ([platform isEqualToString:@"iPhone 5"]||[platform isEqualToString:@"iPhone 5S"]||[platform isEqualToString:@"iPhone SE"]||[platform isEqualToString:@"iPhone 5c"]){
        cell.textLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    }else if ([platform isEqualToString:@"iPhone 6"]||[platform isEqualToString:@"iPhone 7"]){
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    }else if ([platform isEqualToString:@"iPhone 6 Plus"]||[platform isEqualToString:@"iPhone 7 Plus"]){
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    }else{
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    }


    
    if (indexPath.row == 5 || indexPath.row ==7 ||indexPath.row == 9 || indexPath.row ==12 || indexPath.row ==14 ||indexPath.row == 17)
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
        NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setFirstLineHeadIndent:30.0];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [cell.textLabel.text length])];
        [cell.textLabel  setAttributedText:attributedString];
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 20;
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
