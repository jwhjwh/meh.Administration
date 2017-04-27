//
//  DepartController.m
//  Administration
//
//  Created by zhang on 2017/4/26.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DepartController.h"
#import "BrandsetController.h"
@interface DepartController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    
}
@property (nonatomic,retain)NSArray *arr;
@end

@implementation DepartController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"部门设置";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    [self InterTableUI];
    _arr = [[NSArray alloc]initWithObjects:@"品牌部设置",@"业务部设置",@"财务部设置",@"客服部设置",@"物流部设置",nil];
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)InterTableUI
{
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,20,self.view.bounds.size.width,self.view.bounds.size.height+29) style:UITableViewStylePlain];
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    infonTableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.view addSubview:infonTableview];
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = GetColor(201, 201, 201, 1);
    [infonTableview addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.bottom.equalTo(infonTableview.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arr.count;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    
    view.backgroundColor =GetColor(201, 201, 201, 1);
    
    
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _arr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            
        case 0:{
            //品牌部设置
            BrandsetController *brandVC=[[BrandsetController alloc]init];
            [self.navigationController pushViewController:brandVC animated:YES];
        
        }
            break;
        case 1:{
        
        }
            break;
        case 2:{
          
       
        }
            break;
            
        case 3:{
        

        }
            break;
        case 4:{
        
         
        }
            break;
        case 5:{
            
     
        }
            break;
        case 6:{
           
       
        }
            break;
        default:
            break;
    }
}


@end
