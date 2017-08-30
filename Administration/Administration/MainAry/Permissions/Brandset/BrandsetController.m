//
//  BrandsetController.m
//  Administration
//
//  Created by zhang on 2017/4/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BrandsetController.h"
#import "AddbranController.h"
#import "EditbrandController.h"
#import "DetailsbrandController.h"
#import "BranTableViewCell.h"
#import "branModel.h"

@interface BrandsetController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *daArr;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *indexArray;
@property (nonatomic,strong)NSArray *natureArr;
@property (nonatomic,strong)NSString *str;
@property(nonatomic,strong)NSMutableArray *ArrID;

@property(nonatomic,strong)NSMutableArray *groupNumber;
@end

@implementation BrandsetController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"::::%@",self.str);
    if ([self.str isEqualToString:@"1"]) {
         _tableView.emptyView.hidden = YES;
        [self datalade];
        self.str=@"0";
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.str = [[NSString alloc]init];
    self.title=@"品牌部";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStyleDone) target:self action:@selector(butItem)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight+49)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self datalade];
   
}
-(void)datalade{
    NSString *urlStr =[NSString stringWithFormat:@"%@user/queryBrandDepartment",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
     NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":@"1"};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.dataArray = [NSMutableArray array];
            _daArr = [NSMutableArray array];
            _ArrID = [NSMutableArray array];
            _groupNumber  = [NSMutableArray array];
            NSArray *array=[responseObject valueForKey:@"mList"];
            for (NSDictionary *dic in array) {
                
                NSArray *barndArr = [dic valueForKey:@"brandList"];
                [_daArr addObject:[dic valueForKey:@"departmentName"]];
                [_ArrID addObject:[dic valueForKey:@"id"]];
                 [_groupNumber addObject:[dic valueForKey:@"groupNumber"]];
                NSMutableArray *logoArr=[NSMutableArray array];
              
                    for (NSDictionary *dict in barndArr) {
                        branModel *model=[[branModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        [logoArr addObject:model];
                    }
                    [self.dataArray addObject:logoArr];
                }
            [self.tableView reloadData];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }
        if (self.dataArray.count==0) {
            [_tableView addEmptyViewWithImageName:@"" title:@"暂无消息" Size:20.0];
            _tableView.emptyView.hidden = NO;
        }
        //[self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    

}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)butItem{
    AddbranController *addbranVC=[[AddbranController alloc]init];
    addbranVC.blockStr=^(){
        self.str=@"1";
    };
    [self.navigationController pushViewController:addbranVC animated:YES];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _daArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BranTableViewCell *cell = [[BranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[BranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = _daArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
   
    if ([_dataArray[indexPath.row] count]==1) {
     
        for ( branModel *model in  _dataArray[indexPath.row]) {
            [cell.imageVie sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo]]placeholderImage:[UIImage imageNamed:@"banben100"]];
        }
    }else if ([_dataArray[indexPath.row] count]==2){
        NSMutableArray *LogoImage=[NSMutableArray array];
        for ( branModel *model in  _dataArray[indexPath.row]) {
            [LogoImage addObject:[NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo]];
        }
        cell.imageVie.image =[self addTwoImageToOne:[UIImage imageNamed:@"bg"] twoImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[0]]]] ThreeImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[1]]]]];
    }else if ([_dataArray[indexPath.row] count]==3){
        NSMutableArray *LogoImage=[NSMutableArray array];
        for ( branModel *model in  _dataArray[indexPath.row]) {
            [LogoImage addObject:[NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo]];
        }
        cell.imageVie.image =[self addTwoImageToOne:[UIImage imageNamed:@"bg"] twoImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[0]]]] ThreeImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[1]]]] fourImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[2]]]]];
    }else{
        NSMutableArray *LogoImage=[NSMutableArray array];
        for ( branModel *model in  _dataArray[indexPath.row]) {
            [LogoImage addObject:[NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo]];
        }
        if (LogoImage.count>0) {
             cell.imageVie.image =[self addTwoImageToOne:[UIImage imageNamed:@"bg"] twoImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[0]]]] ThreeImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[1]]]] fourImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[2]]]]fiveImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[3]]]]];
        }
        
    }
    return cell;
}
//编辑
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction * action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
     
        [self delDepartStr:_ArrID[indexPath.row] IndexPath:indexPath];
    }];
    
    action1.backgroundColor = GetColor(206, 175,219 ,1);
    UITableViewRowAction * action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //Action 2
        EditbrandController * EditVC=[[EditbrandController alloc]init];
         EditVC.nameStr = _daArr[indexPath.row];
         EditVC.BarandID=[NSString stringWithFormat:@"%@",_ArrID[indexPath.row]];
        EditVC.String=^(NSString *str){
            self.str=@"1";
        };
        
        [self.navigationController pushViewController:EditVC animated:YES];
       
      }];
    action2.backgroundColor = GetColor(220,220,220,1);
    return @[action1,action2];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsbrandController *detailVC=[[DetailsbrandController alloc]init];
    detailVC.blockStr=^(){
        self.str=@"0";
    };
    detailVC.nameStr = _daArr[indexPath.row];
    detailVC.BarandID=[NSString stringWithFormat:@"%@",_ArrID[indexPath.row]];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (UIImage *)addTwoImageToOne:(UIImage *)oneImg twoImage:(UIImage *)twoImg  ThreeImage:(UIImage *)ThreeImage
{
    UIGraphicsBeginImageContext(oneImg.size);
    [oneImg drawInRect:CGRectMake(0, 0, oneImg.size.width, oneImg.size.height)];
    [twoImg drawInRect:CGRectMake(oneImg.size.width/4, 0, oneImg.size.width/2, oneImg.size.height/2)];
    [ThreeImage drawInRect:CGRectMake(oneImg.size.width/4,oneImg.size.height/2, oneImg.size.width/2, oneImg.size.height/2)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}
- (UIImage *)addTwoImageToOne:(UIImage *)oneImg twoImage:(UIImage *)twoImg  ThreeImage:(UIImage *)ThreeImage fourImage:(UIImage *)fourImage

{
    UIGraphicsBeginImageContext(oneImg.size);
    [oneImg drawInRect:CGRectMake(0, 0, oneImg.size.width, oneImg.size.height)];
    [twoImg drawInRect:CGRectMake(oneImg.size.width/4, 0, oneImg.size.width/2, oneImg.size.height/2)];
    [ThreeImage drawInRect:CGRectMake(0,oneImg.size.height/2, oneImg.size.width/2, oneImg.size.height/2)];
    [fourImage drawInRect:CGRectMake(oneImg.size.width/2,oneImg.size.height/2, oneImg.size.width/2, oneImg.size.height/2)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}
- (UIImage *)addTwoImageToOne:(UIImage *)oneImg twoImage:(UIImage *)twoImg  ThreeImage:(UIImage *)ThreeImage fourImage:(UIImage *)fourImage fiveImage:(UIImage *)fiveImage
{
    UIGraphicsBeginImageContext(oneImg.size);
    [oneImg drawInRect:CGRectMake(0, 0, oneImg.size.width, oneImg.size.height)];
    [twoImg drawInRect:CGRectMake(0, 0, oneImg.size.width/2, oneImg.size.height/2)];
    [ThreeImage drawInRect:CGRectMake(oneImg.size.width/2,0, oneImg.size.width/2, oneImg.size.height/2)];
    [fourImage drawInRect:CGRectMake(0,oneImg.size.height/2, oneImg.size.width/2, oneImg.size.height/2)];
    [fiveImage drawInRect:CGRectMake(oneImg.size.width/2,oneImg.size.height/2, oneImg.size.width/2, oneImg.size.height/2)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}
-(void)delDepartStr:(NSString*)string IndexPath:( NSIndexPath *)IndexPath{
  
    NSString *urlStr =[NSString stringWithFormat:@"%@user/delDepartment.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":@"1",@"id":string,@"GroupNumber":_groupNumber[IndexPath.row]};//加上群号GroupNumber
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除成功" andInterval:1.0];
            [_dataArray removeObjectAtIndex:IndexPath.row];
            [_daArr removeObjectAtIndex:IndexPath.row];
            [_ArrID removeObjectAtIndex:IndexPath.row];
            [_groupNumber removeObjectAtIndex:IndexPath.row];
            [self.tableView reloadData];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            
        }
        if (self.dataArray.count==0) {
            [_tableView addEmptyViewWithImageName:@"" title:@"暂无消息" Size:20.0];
            _tableView.emptyView.hidden = NO;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

@end
