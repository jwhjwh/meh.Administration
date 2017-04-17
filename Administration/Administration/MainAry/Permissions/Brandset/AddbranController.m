//
//  AddbranController.m
//  Administration
//
//  Created by zhang on 2017/4/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AddbranController.h"

#import "ChosebradController.h"
#import "multiController.h"
#import "AddbranTableViewCell.h"
#import "ZXYAlertView.h"
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
    _tileAry=@[@"名称",@"性质",@"所选品牌"];
     _paleAry=@[@"请输入品牌名称",@"请选择品牌性质",@"请选择品牌"];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _tileAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    AddbranTableViewCell *cell = [[AddbranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[AddbranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text=_tileAry[indexPath.row];
    cell.BarnLabel.placeholder=_paleAry[indexPath.row];
    [cell.BarnLabel addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
    cell.BarnLabel.tag = indexPath.row;
    if (!(indexPath.row==0)) {
        cell.BarnLabel.enabled=NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    index=indexPath;
    if (indexPath.row==1) {
        [self.view endEditing:YES];
        ZXYAlertView *alert = [ZXYAlertView alertViewDefault];
        alert.title = @"性质";
        alert.sizie=13.0f;
        alert.buttonArray = @[@"主力品牌部(单一品牌)",@"非主力品牌综合部(单个或者多个品牌)"];
        alert.delegate = self;
        [alert show];
    }else  if (indexPath.row==2){
        if (self.mainon==nil) {
              [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择品牌性质" andInterval:1.0];
        }else    if ([self.mainon isEqualToString:@"0"]){
            ChosebradController *choseVC=[[ChosebradController alloc]init];
            [self.navigationController pushViewController:choseVC animated:YES];
        }else{
            multiController *multiVC=[[multiController alloc]init];
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
            
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            _Choobrand=sender.text;
            
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(ZXYAlertView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) {
         AddbranTableViewCell *cell = [infonTableview cellForRowAtIndexPath:index];
        cell.BarnLabel.text=@"主力品牌部(单一品牌)";
        self.mainon=@"0";
    }else{
        AddbranTableViewCell *cell = [infonTableview cellForRowAtIndexPath:index];
        cell.BarnLabel.text=@"非主力品牌综合部(单个或者多个品牌)";
        self.mainon=@"1";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
