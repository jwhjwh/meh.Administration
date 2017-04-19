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
@interface DetailsbrandController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *infonTableview;
    NSIndexPath *index;
}
@property (strong,nonatomic) NSArray *tileAry;
@property (strong,nonatomic) NSArray *paleAry;
@end

@implementation DetailsbrandController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"品牌部";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 66, 28)];
    UIButton *bton = [UIButton buttonWithType:UIButtonTypeCustom];
    bton.frame =CGRectMake(0, 0, 28,28);
    [bton setBackgroundImage:[UIImage imageNamed:@"bj_ico"] forState:UIControlStateNormal];
    [bton addTarget: self action: @selector(buttonrightItem) forControlEvents: UIControlEventTouchUpInside];
    [view addSubview:bton];
    UIButton *bn = [UIButton buttonWithType:UIButtonTypeCustom];
    bn.frame =CGRectMake(38,0,28,28);
    [bn setBackgroundImage:[UIImage imageNamed:@"sc_ico"] forState:UIControlStateNormal];
    [bn addTarget: self action: @selector(buttonrightItem) forControlEvents: UIControlEventTouchUpInside];
    [view addSubview:bn];
    UIBarButtonItem *btonItem=[[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem=btonItem;
    [self InterTableUI];
    _tileAry=@[@"名称",@"性质",@"所选品牌"];
    _paleAry=@[_nameStr,_nature,@""];

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
        if (indexPath.row==2) {
            return 40;
        }
    }
    
    return 70;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row<=2) {
        AddbranTableViewCell *cell = [[AddbranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        if (cell == nil) {
            cell = [[AddbranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text=_tileAry[indexPath.row];
        cell.BarnLabel.text=_paleAry[indexPath.row];
        [cell.BarnLabel addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
        cell.BarnLabel.tag = indexPath.row;
        cell.BarnLabel.enabled=NO;
     
        return cell;
    }else{
        static NSString *identifi = @"gameCell";
        BranTableViewCell *cell = [[BranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
        if (!cell) {
            cell = [[BranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
            cell.backgroundColor =[UIColor whiteColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        branModel *model=_branarr[indexPath.row-3];
        cell.titleLabel.text =model.finsk;
        [cell.imageVie sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo]]placeholderImage:[UIImage imageNamed:@"banben100"]];
        return cell;
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



@end
