//
//  StoreprofileController.m
//  Administration
//
//  Created by zhang on 2017/3/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "StoreprofileController.h"
#import "inftionTableViewCell.h"
#import "SelectAlert.h"
@interface StoreprofileController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
}
@property (strong,nonatomic) NSArray *InterNameAry;
@property (strong,nonatomic) NSArray *numAry;
@end

@implementation StoreprofileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"陌拜记录表";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    _InterNameAry = @[@"类型",@"经营年限",@"美容师人数",@"床位"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,83,self.view.bounds.size.width,1)];
    view.backgroundColor=GetColor(216, 216, 216, 1);
    [self.view addSubview:view];
    infonTableview =[[UITableView alloc]initWithFrame:CGRectMake(0,84, kScreenWidth, kScreenHeight-64)];
    //分割线无
    //    infonTableview.separatorStyle= UITableViewCellSeparatorStyleNone;
    //不让滚动
    infonTableview.scrollEnabled = NO;
    infonTableview.showsVerticalScrollIndicator = NO;
    infonTableview.delegate = self;
    infonTableview.dataSource = self;
    [self.view addSubview: infonTableview];
    [ZXDNetworking setExtraCellLineHidden:infonTableview];
    NSMutableArray *array=[NSMutableArray array];
    for (int i=1; i<101; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
     _numAry=[NSArray arrayWithArray:array];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _InterNameAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell ==nil)
    {
        cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    if (indexPath.row==0) {
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.mingLabel.text = _InterNameAry[indexPath.row];
    return cell;
}

-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            [SelectAlert showWithTitle:@"类型" titles:@[@"美容院",@"综合店",@"前店后院",@"其他"] selectIndex:^(NSInteger selectIndex) {
                  
              } selectValue:^(NSString *selectValue) {
                  inftionTableViewCell *cell = [infonTableview cellForRowAtIndexPath:indexPath];
                  cell.xingLabel.text=selectValue;
              } showCloseButton:NO];
        }
            
            break;
        case 2:{
     
        }
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
