//
//  ManagerShopPosition.m
//  Administration
//
//  Created by zhang on 2017/12/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ManagerShopPosition.h"
#import "CollectionViewCellPosition.h"
#import "ManagerShop.h"
#import "VCManagerDepartment.h"
@interface ManagerShopPosition ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,strong)NSMutableArray *arrayId;

@end

@implementation ManagerShopPosition

#pragma -mark custem
-(void)getAllPosition
{
    NSString *urlStr =[NSString stringWithFormat:@"%@stores/selectDepartmentRoleId.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS valueForKey:@"userid"],@"CompanyInfoId":compid};
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *stringCode = [responseObject valueForKey:@"status"];
        if ([stringCode isEqualToString:@"0000"]) {
            //显示自己担任的所有职位
            self.arrayData = [responseObject valueForKey:@"list"];
            for (NSDictionary *dict in self.arrayData) {
                NSString *string = [NSString stringWithFormat:@"%@",dict[@"roleId"]];
                [self.arrayId addObject:string];
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
    NSDictionary *dct = self.arrayData[indexPath.section];
    cell.labelName.text = dct[@"newName"];
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
    
    
    NSDictionary *dict = self.arrayData[indexPath.section];
    NSString *roleID = [NSString stringWithFormat:@"%@",dict[@"roleId"]];
    
    [ShareModel shareModel].roleID = roleID;
    [ShareModel shareModel].departmentID = [NSString stringWithFormat:@"%@",dict[@"departmentId"]];
    
    if ([roleID isEqualToString:@"2"]) {
        ManagerShop *vc = [[ManagerShop alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        VCManagerDepartment *vc = [[VCManagerDepartment alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    NSInteger numberOfItems = [collectionView numberOfItemsInSection:0];
    
    CGFloat combinedItemWidth = (numberOfItems * collectionViewLayout.itemSize.width) + ((numberOfItems - 1)*collectionViewLayout.minimumInteritemSpacing);
    
    CGFloat padding = (collectionView.frame.size.width - combinedItemWidth)/2;
    
    padding = padding>0 ? padding :0 ;
    
    return UIEdgeInsetsMake(0, padding,0, padding);
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择职位";
    // [self getAllPosition];
    
    self.arrayData = [NSMutableArray array];
    self.arrayId = [NSMutableArray array];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, kTopHeight, Scree_width, 21)];
    label.text = @"请选择您要操作的职位";
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    //同一行相邻两个cell的最小间距
    
    layout.minimumInteritemSpacing = 0;
    
    //最小两行之间的间距
    
    layout.minimumLineSpacing = 100;
    
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kTopHeight+40, Scree_width, Scree_height) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CollectionViewCellPosition class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [[ShareModel shareModel].arrayData removeAllObjects];
    [[ShareModel shareModel].arrayArea removeAllObjects];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getAllPosition];
    self.tabBarController.tabBar.hidden = YES;
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
