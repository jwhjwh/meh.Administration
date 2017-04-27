//
//  AddbranController.m
//  Administration
//
//  Created by zhang on 2017/4/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AddbranController.h"
#import "BranTableViewCell.h"
#import "multiController.h"
#import "AddbranTableViewCell.h"
#import "ZXYAlertView.h"
#import "branModel.h"
@interface AddbranController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZXYAlertViewDelegate>
{
    UITableView *infonTableview;
    NSIndexPath *index;
}
@property (strong,nonatomic) NSArray *tileAry;
@property (strong,nonatomic) NSArray *paleAry;
@property (strong,nonatomic) NSArray *dateAry;
@property (nonatomic,retain) NSString *nameBarn;
@property (nonatomic,retain) NSString *nature;
@property (nonatomic,retain) NSString *Choobrand;
@property (nonatomic,retain) NSString *mainon;

@property (nonatomic,strong)NSMutableArray *branarr;
@property (nonatomic,strong)NSString *branID;
@end

@implementation AddbranController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加品牌部";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"完成"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(masgegeClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self InterTableUI];
    _branarr=[NSMutableArray array];
    _tileAry=@[@"名称",@"所选品牌"];
     _paleAry=@[@"请输入品牌名称",@"请选择品牌"];
}
-(void)InterTableUI
{
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    [ZXDNetworking setExtraCellLineHidden:infonTableview];
    [self viewDidLayoutSubviews];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)masgegeClick{
   
    if (_nameBarn==nil ||_branID.length==0) {
    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请完善信息" andInterval:1.0];
    }else{
        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要添加此品牌部" sureBtn:@"确认" cancleBtn:@"取消"];
        
        alertView.resultIndex = ^(NSInteger index){
            
                NSLog(@"%@",[NSString stringWithFormat:@"%@",_branID]);
                NSString *urlStr =[NSString stringWithFormat:@"%@user/addDepartment",KURLHeader];
                NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
                NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
                NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
                NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":@"1",@"BrandID":[NSString stringWithFormat:@"%@",_branID],@"DepartmentName":_nameBarn};
                [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
                    if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"添加成功" andInterval:1.0];
                        _nameBarn = nil;
                        [_branarr removeAllObjects];
                        [infonTableview reloadData];
                        self.blockStr();
                    }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
                        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登陆超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
                        
                        alertView.resultIndex = ^(NSInteger index){
                            ViewController *loginVC = [[ViewController alloc] init];
                            UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                            [self presentViewController:loginNavC animated:YES completion:nil];
                        };
                        [alertView showMKPAlertView];
                    }
                    
                    [infonTableview reloadData];
                } failure:^(NSError *error) {
                    
                } view:self.view MBPro:YES];
            
        };
        [alertView showMKPAlertView];

    }
  }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _tileAry.count+_branarr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_branarr.count>0) {
        if (indexPath.row==1) {
            return 40;
        }
    }
    
    return 70;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<=1) {
        AddbranTableViewCell *cell = [[AddbranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        if (cell == nil) {
            cell = [[AddbranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text=_tileAry[indexPath.row];
        if (_nameBarn==nil) {
               cell.BarnLabel.placeholder=_paleAry[indexPath.row];
        }else{
            cell.BarnLabel.text=_dateAry[indexPath.row];
        }
        [cell.BarnLabel addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
        cell.BarnLabel.tag = indexPath.row;
        if (!(indexPath.row==0)) {
            cell.BarnLabel.enabled=NO;
        }
          return cell;
    }else{
        static NSString *identifi = @"gameCell";
        BranTableViewCell *cell = [[BranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
        if (!cell) {
            cell = [[BranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
            cell.backgroundColor =[UIColor whiteColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        branModel *model=_branarr[indexPath.row-2];
        cell.titleLabel.text =model.finsk;
        [cell.imageVie sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo]]placeholderImage:[UIImage imageNamed:@"banben100"]];
     return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    index=indexPath;
    if (indexPath.row==1) {
       if (_nameBarn==nil) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请输入品牌名称" andInterval:1.0];
       }else{
           multiController *multiVC=[[multiController alloc]init];
           multiVC.blockArr=^(NSMutableArray *array){
               _branarr =array;
               NSMutableArray *arr=[NSMutableArray array];
               for (branModel *model in array) {
                   [arr addObject:model.ID];
               }
               _branID = [arr componentsJoinedByString:@","];
               [infonTableview reloadData];
           };
           [self.navigationController pushViewController:multiVC animated:YES];
          }
       }
}

#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([infonTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [infonTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([infonTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [infonTableview setLayoutMargins:UIEdgeInsetsZero];
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
-(void)FieldText:(UITextField*)sender{
    
    switch (sender.tag) {
        case 0:{
            _nameBarn=sender.text;
            _dateAry=@[_nameBarn,@""];

        }
            break;
        default:
            break;
    }
}

//- (void)alertView:(ZXYAlertView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex {
//    
//    if (buttonIndex==0) {
//        if ([self.mainon isEqualToString:@"2"]) {
//            [_branarr removeAllObjects];
//            [infonTableview reloadData];
//        }
//         AddbranTableViewCell *cell = [infonTableview cellForRowAtIndexPath:index];
//        cell.BarnLabel.text=@"主力品牌部(单一品牌)";
//        _Choobrand=@"主力品牌部(单一品牌)";
//        self.mainon=@"1";
//        _dateAry=@[_nameBarn,_Choobrand,@""];
//    
//    }else{
//        if ([self.mainon isEqualToString:@"1"]) {
//            [_branarr removeAllObjects];
//            [infonTableview reloadData];
//        }
//        AddbranTableViewCell *cell = [infonTableview cellForRowAtIndexPath:index];
//        cell.BarnLabel.text=@"非主力品牌综合部(单个或者多个品牌)";
//        _Choobrand=@"非主力品牌综合部(单个或者多个品牌)";
//        self.mainon=@"2";
//        _dateAry=@[_nameBarn,_Choobrand,@""];
//      
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
