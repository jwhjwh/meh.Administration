//
//  DetailsbrandController.m
//  Administration
//
//  Created by zhang on 2017/4/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DetailsbrandController.h"
#import "BranTableViewCell.h"
#import "AddbranTableViewCell.h"
#import "branModel.h"
#import "ModifyController.h"

@interface DetailsbrandController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIView *view;
    UITableView *infonTableview;
    NSIndexPath *index;
    BOOL  _isenabled;
    NSMutableArray *barr;
}
@property (strong,nonatomic) NSArray *dateAry;
@property (nonatomic,retain) NSString *nameBarn;
@property (strong,nonatomic) NSArray *tileAry;
@property (strong,nonatomic) NSArray *paleAry;
@property (strong,nonatomic) AddbranTableViewCell *addCell;
@property (strong,nonatomic) NSMutableArray *arr;
@property (nonatomic,strong)NSString *branID;
@property (nonatomic,retain) NSString *DepartName;
@end

@implementation DetailsbrandController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_nameStr;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
  
    [self rightBar];
    [self InterTableUI];
    _tileAry=@[@"名称",@"负责品牌"];
    _paleAry=@[_nameStr,@""];
    barr=[NSMutableArray array];
    for (branModel *model in _branarr) {
        [barr addObject:model.ID];
    }
}
-(void)rightBar{
    view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 66, 28)];
    UIButton *bton = [UIButton buttonWithType:UIButtonTypeCustom];
    bton.frame =CGRectMake(0, 0, 28,28);
    [bton setBackgroundImage:[UIImage imageNamed:@"bj_ico"] forState:UIControlStateNormal];
    [bton addTarget: self action: @selector(buttonrightItem) forControlEvents: UIControlEventTouchUpInside];
    [view addSubview:bton];
    UIButton *bn = [UIButton buttonWithType:UIButtonTypeCustom];
    bn.frame =CGRectMake(38,0,28,28);
    [bn setBackgroundImage:[UIImage imageNamed:@"sc_ico"] forState:UIControlStateNormal];
    [bn addTarget: self action: @selector(buttonItem) forControlEvents: UIControlEventTouchUpInside];
    [view addSubview:bn];
    UIBarButtonItem *btonItem=[[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem=btonItem;
    _isenabled=NO;
}
-(void)buttonrightItem{
    [view removeFromSuperview];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
     _isenabled=YES;
    [infonTableview reloadData];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
        _addCell = [[AddbranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        if (_addCell == nil) {
            _addCell = [[AddbranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        }
        _addCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _addCell.titleLabel.text=_tileAry[indexPath.row];
        if (_nameBarn==nil) {
            _addCell.BarnLabel.text=_paleAry[indexPath.row];
        }else{
            _addCell.BarnLabel.text=_dateAry[indexPath.row];
        }
        [_addCell.BarnLabel addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
        _addCell.BarnLabel.tag = indexPath.row;
       
        if (_isenabled==YES) {
            if (indexPath.row==0) {
             _addCell.BarnLabel.enabled=YES;
            }else{
                _addCell.BarnLabel.enabled=NO;
            }
            
        }else{
             _addCell.BarnLabel.enabled=NO;
        }
     
        return _addCell;
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
    if (_isenabled == YES) {
        ModifyController *multiVC=[[ModifyController alloc]init];
        multiVC.departmentID=_BarandID;
        multiVC.blockArr=^(NSMutableArray *array){
            _branarr =array;
            _arr=[NSMutableArray array];
            for (branModel *model in array) {
                [_arr addObject:model.ID];
            }
            
            [infonTableview reloadData];
        };
        [self.navigationController pushViewController:multiVC animated:YES];
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
-(void)rightItemAction{
    NSLog(@"%@=====%@",_dateAry[0],_paleAry[0]);

    NSLog(@"%@=====%@",[_arr componentsJoinedByString:@","],[barr componentsJoinedByString:@","]);
    NSLog(@"%@",_BarandID);
    
    if (_dateAry[0]==nil&&_arr.count==0) {
             [ELNAlerTool showAlertMassgeWithController:self andMessage:@"未进行修改，不能完成操作" andInterval:1.0];
    }else  if (!(_dateAry[0]==nil)&&[_dateAry[0]isEqualToString:_paleAry[0]]&&_arr.count==0) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"未进行修改，不能完成操作" andInterval:1.0];
    }else if (_dateAry[0]==nil&&[[_arr componentsJoinedByString:@","] isEqualToString:[barr componentsJoinedByString:@","]]&&!(_arr.count==0)) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"未进行修改，不能完成操作" andInterval:1.0];
    }else  if ([_dateAry[0]isEqualToString:_paleAry[0]]&&[[_arr componentsJoinedByString:@","] isEqualToString:[barr componentsJoinedByString:@","]]) {
           [ELNAlerTool showAlertMassgeWithController:self andMessage:@"未进行修改，不能完成操作" andInterval:1.0];
    }else{
       
        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否确定要修改此内容" sureBtn:@"确认" cancleBtn:@"取消"];
        
        alertView.resultIndex = ^(NSInteger index){
            if (_dateAry[0]==nil) {
                _DepartName=_paleAry[0];
            }else{
                _DepartName=_dateAry[0];
            }
            NSString *urlStr =[NSString stringWithFormat:@"%@user/updateDepartment.action",KURLHeader];
            NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
            NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
            NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
            NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":@"1",@"BrandID":[NSString stringWithFormat:@"%@",_arr],@"id":_BarandID,@"DepartmentName":_DepartName};
            [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
                if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改成功" andInterval:1.0];
                    self.blockStr();
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"2000"]) {
                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"此品牌部下还有员工不能进行删除操作" andInterval:1.0];
                    
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
-(void)buttonItem{
    NSLog(@"%@",_BarandID);
    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要删除此品牌部" sureBtn:@"确认" cancleBtn:@"取消"];
    
    alertView.resultIndex = ^(NSInteger index){
        
        NSString *urlStr =[NSString stringWithFormat:@"%@user/delDepartment.action",KURLHeader];
        NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
        NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
        NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":@"1",@"id":_BarandID};
        [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除成功" andInterval:1.0];
                self.blockStr();
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                });
            }else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"2000"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"此品牌部下还有员工不能进行删除操作" andInterval:1.0];
           
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

@end
