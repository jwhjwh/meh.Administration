//
//  MessagexqController.m
//  Administration
//
//  Created by zhang on 2017/2/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "MessagexqController.h"
#import "mesagexqCell.h"
#import "MessageView.h"
@interface MessagexqController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong)UITableView *SpecialTableView;
@property (nonatomic,strong)NSMutableArray *SpecialArray;
@property (nonatomic,strong)MessageView *messageView;
@end

@implementation MessagexqController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title =@"待批注";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    UIButton *rightn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightn.frame =CGRectMake(0, 0,35,28);
    [rightn setTitle:@"审核" forState: UIControlStateNormal ];
    [rightn addTarget: self action: @selector(butrightItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *rightnItem=[[UIBarButtonItem alloc]initWithCustomView:rightn];
    self.navigationItem.rightBarButtonItem=rightnItem;
     [self addSubViewS];
    
    NSString *urlStr =[NSString stringWithFormat:@"%@manager/bqueryallinfo.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"code":_codeStr,@"Sort":_sortStr,@"flag":_flagStr,@"id":_IdStr,@"remark":_remarkStr};
    NSLog(@"++==%@",info);
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
//        self.dataArray = [NSMutableArray array];
//        NSArray *array=[responseObject valueForKey:@"Sums"];
//        for (NSDictionary *dic in array) {
//            mesgeModel *model=[[mesgeModel alloc]init];
//            [model setValuesForKeysWithDictionary:dic];
//            [self.dataArray addObject:model];
//        }
        
//        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addSubViewS{
    
    self.SpecialTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.SpecialTableView.delegate = self;
    self.SpecialTableView.dataSource = self;
    [self.view addSubview: self.SpecialTableView];
    
    UIView * View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    UIView *viewname=[[UIView alloc]init];
    viewname.backgroundColor=[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    [View addSubview:viewname];
    [viewname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(View.mas_top).offset(5);
        make.height.offset(1);
        make.width.offset(kScreenWidth);
    }];
    
    self.SpecialTableView.tableHeaderView = View;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.SpecialArray.count;
}

//row 高
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    static NSString *cell_id=@"celL_id";
    mesagexqCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[mesagexqCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_id];
        
    }
    //cell.model= self.SpecialArray[indexPath.row];
   
   
    return cell;
}

-(void)butrightItem{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"审核" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    UIAlertAction *libarayAction = [UIAlertAction actionWithTitle:@"通过" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不通过" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    [alertC addAction:photoAction];
    [alertC addAction:libarayAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
