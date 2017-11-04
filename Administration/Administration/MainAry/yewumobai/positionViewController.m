//
//  positionViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/9/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "positionViewController.h"
#import "CollectionViewCellPosition.h"
#import "businessViewController.h"
@interface positionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,strong)NSMutableArray *arrayId;
@property (nonatomic,strong)NSMutableArray *departmentID;
@end

@implementation positionViewController

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择职位";
    // [self getAllPosition];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    self.view.backgroundColor = [UIColor whiteColor];
     NSString* phoneModel = [UIDevice devicePlatForm];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"请选择您要操作的职位";
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
            make.top.mas_equalTo(self.view.mas_top).offset(94);
        }else{
            make.top.mas_equalTo(self.view.mas_top).offset(74);
        }
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(8);
        make.height.mas_offset(14);
    }];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    //同一行相邻两个cell的最小间距
    
    layout.minimumInteritemSpacing = 0;
    
    //最小两行之间的间距
    
    layout.minimumLineSpacing = 100;
    
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CollectionViewCellPosition class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
    
}
-(void)getAllPosition
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/selectDepartmentId.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS valueForKey:@"userid"],@"CompanyInfoId":compid};
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *stringCode = [responseObject valueForKey:@"status"];
        if ([stringCode isEqualToString:@"0000"]) {
            //显示自己担任的所有职位
            NSArray *array=[responseObject valueForKey:@"list"];
            self.arrayId = [[NSMutableArray alloc]init];
            self.arrayData = [[NSMutableArray alloc]init];
            self.departmentID  =[[NSMutableArray alloc]init];
            for (NSDictionary *dic in array) {
                NSString *string = [NSString stringWithFormat:@"%@",dic[@"roleId"]];
                [self.arrayId addObject:string];
                
                NSString *namestring = [NSString stringWithFormat:@"%@",dic[@"newName"]];
                [self.arrayData addObject:namestring];
                NSString *departmentID = [[NSString alloc]init];
                if (dic[@"departmentIDs"] == nil) {
                    departmentID = @"";
                }else{
                    departmentID  = [NSString stringWithFormat:@"%@",dic[@"departmentIDs"]];

                }
                [self.departmentID addObject:departmentID];
                
            }
            [self.collectionView reloadData];
            return ;
        }
        if ([stringCode isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
            return;
        }
        if ([stringCode isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return;
        }
        if ([stringCode isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据空" andInterval:1];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
#pragma -mark collectionView

//一共有多少个组

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.arrayData.count;
    
}

//每一组有多少个cell

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1;
    
}

//每一个cell是什么

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCellPosition *cell = (CollectionViewCellPosition *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    cell.labelName.text = _arrayData[indexPath.section];
    return cell;
    
}

//定义每一个cell的大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    return CGSizeMake(200, 200);
    
}

//cell的点击事件

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    businessViewController *businVC = [[businessViewController alloc]init];
    businVC.strId = _arrayId[indexPath.section];
    [USER_DEFAULTS  setObject:_departmentID[indexPath.section] forKey:@"departmentIDs"];
    NSLog(@"%@",self.arrayId);
    NSLog(@"%@",businVC.strId);
    [self.navigationController showViewController:businVC sender:nil];
    
}
//每一个分组的上左下右间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    
    return UIEdgeInsetsMake(5, Scree_width/2-175, 5, 5);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getAllPosition];
    self.tabBarController.tabBar.hidden=YES;
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
