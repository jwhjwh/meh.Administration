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
//事项数组
@property (nonatomic,strong)NSMutableArray *mattersArr;
@property (nonatomic,strong)MessageView *riView;
@property (nonatomic,strong)MessageView *zhiView;
@property (nonatomic,strong)MessageView *xingView;
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
    rightn.frame =CGRectMake(0, 0,45,28);
    [rightn setTitle:@"审核" forState: UIControlStateNormal ];
    [rightn addTarget: self action: @selector(butrightItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *rightnItem=[[UIBarButtonItem alloc]initWithCustomView:rightn];
    self.navigationItem.rightBarButtonItem=rightnItem;
     [self addSubViewS];
    
    NSString *urlStr =[NSString stringWithFormat:@"%@manager/bqueryallinfo.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"code":_codeStr,@"Sort":_sortStr,@"flag":_flagStr,@"id":_IdStr,@"remark":_remarkStr};

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
    
    self.SpecialTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+49)];
    //分割线无
     self.SpecialTableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    //
     _SpecialTableView.showsVerticalScrollIndicator = NO;
    self.SpecialTableView.delegate = self;
    self.SpecialTableView.dataSource = self;
    [self.view addSubview: self.SpecialTableView];
    
    UIView * View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,91)];
    UIView *viewname=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 1)];
    viewname.backgroundColor=[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    [View addSubview:viewname];
    _riView=[[MessageView alloc]initWithFrame:CGRectMake(0, viewname.bottom, Scree_width,30)];
    _riView.label.text=@"日 期:";
    _riView.textField.text=@"2016-12-18";
    [View addSubview:_riView];
    _zhiView=[[MessageView alloc]initWithFrame:CGRectMake(0, _riView.bottom, Scree_width,30)];
    _zhiView.label.text=@"职 位:";
    [View addSubview:_zhiView];
    _xingView=[[MessageView alloc]initWithFrame:CGRectMake(0, _zhiView.bottom, Scree_width,30)];
    _xingView.label.text=@"姓 名:";
    [View addSubview:_xingView];
    self.SpecialTableView.tableHeaderView = View;
    _mattersArr=[[NSMutableArray alloc]initWithObjects:@"地区店名老板",@"目标",@"业绩",@"出货",@"发现问题",@"解决方案",@"感悟分享",@"明日计划",@"明日目标",@"总结", nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mattersArr.count;
}

//row 高
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    static NSString *cell_id=@"celL_id";
    mesagexqCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[mesagexqCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_id];
        
    }
    if (indexPath.row==0) {
    [cell.button removeFromSuperview];
    }
    //点击后不变灰
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.biaoLabel.text= self.mattersArr[indexPath.row];
   
   
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
