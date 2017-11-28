//
//  StoreinforViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/10/31.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "StoreinforViewController.h"
#import "StoresViewController.h"
#import "BossViewController.h"
#import "shopAssistantViewController.h"
@interface StoreinforViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *tableView;

@property (nonatomic ,retain)NSArray *nameArrs;


@end

@implementation StoreinforViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleName;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    _nameArrs = @[@"门店信息",@"老板信息",@"店员信息",@"顾客信息"];
    
    [self addViewremind];
}
-(void)addViewremind{
    self.tableView= [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    NSString* phoneModel = [UIDevice devicePlatForm];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        self.tableView.frame =CGRectMake(0,88,self.view.bounds.size.width,self.view.bounds.size.height-50);
    }else{
        self.tableView.frame =CGRectMake(0,65,self.view.bounds.size.width,self.view.bounds.size.height-50);
    }
    self.tableView.dataSource=self;
    self.tableView.delegate =self;
    self.tableView.scrollEnabled =NO; //设置tableview 不能滚动
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameArrs.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"gameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    /**
     *  单元格的选中类型一定不能设置为 UITableViewCellSelectionStyleNone，如果加上这一句，全选勾选不出来
     */
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, cell.width, 30)];
    tlelabel.text = _nameArrs[indexPath.row];
    [cell addSubview:tlelabel];

    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0) {
        NSString *storeid = [ShareModel shareModel].StoreId;
        if (_isend ==NO) {
            //合作客户---->可以进
             NSLog(@"asdsa1");
            switch (indexPath.row) {
                case 1:{
                    //老板信息
                    BossViewController *bossVC = [[BossViewController alloc]init];
                    bossVC.strId = self.strId;
                    bossVC.Storeid = self.shopId;
                    [self.navigationController pushViewController:bossVC animated:YES];
                }
                    break;
                case 2:{
                    //店员信息
                    shopAssistantViewController *SAVC = [[shopAssistantViewController alloc]init];
                     [self.navigationController pushViewController:SAVC animated:YES];
                }break;
                case 3:
                    //顾客信息
                    break;
                default:
                    break;
            }
        }else {
            //目标升级合作--->未提交不可进
            if (storeid ==nil){
                // 提示先提交门店信息
            }else{
                NSLog(@"asdsa3");
                switch (indexPath.row) {
                    case 1:{
                        //老板信息
                        BossViewController *bossVC = [[BossViewController alloc]init];
                        bossVC.strId = self.strId;
                        bossVC.Storeid = self.shopId;
                        [self.navigationController pushViewController:bossVC animated:YES];
                    }
                        break;
                    case 2:
                        //店员信息
                    {
                        //店员信息
                        shopAssistantViewController *SAVC = [[shopAssistantViewController alloc]init];
                        [self.navigationController pushViewController:SAVC animated:YES];
                    }
                        break;
                    case 3:
                        //顾客信息
                        break;
                    default:
                        break;
                }
            }
        }
    }else{
        switch (indexPath.row) {
            case 0:{
                //门店信息
                 NSString *storeid = [ShareModel shareModel].StoreId;
                StoresViewController *storesVC = [[StoresViewController alloc]init];
                storesVC.isend = self.isend;
                storesVC.shopId = self.shopId;
                storesVC.strId = self.strId;
                if (_isend == NO) {
                    storesVC.isofyou = @"1";
                }else{
                    if (storeid==nil) {
                         storesVC.isofyou = @"1";
                    }else{
                         storesVC.isofyou = @"2";
                    }
                   
                }
                
                [self.navigationController pushViewController:storesVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
    
    
}


-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
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
