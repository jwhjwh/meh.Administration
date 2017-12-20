//
//  VCPostionMobai.m
//  Administration
//
//  Created by zhang on 2017/11/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCPostionMobai.h"
#import "CollectionViewCellPosition.h"
#import "VCManagerMobai.h"
@interface VCPostionMobai ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,strong)NSMutableArray *arrayId;

@end

@implementation VCPostionMobai

#pragma -mark custem
-(void)getAllPosition
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/selectDepartmentId.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS valueForKey:@"userid"],@"CompanyInfoId":compid,@"type":@"2"};
    
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
    
    VCManagerMobai *vc = [[VCManagerMobai alloc]init];
    NSDictionary *dict = self.arrayData[indexPath.section];
    [ShareModel shareModel].roleID = [NSString stringWithFormat:@"%@",dict[@"roleId"]];
    NSString *roleId = [NSString stringWithFormat:@"%@",dict[@"roleId"]];
    
    
    if ([dict[@"departmentID"] isEqualToString:@""]) {
        if ([roleId isEqualToString:@"1"]||[roleId isEqualToString:@"7"]) {
            [self.navigationController pushViewController:vc animated:YES];
            [ShareModel shareModel].departmentID = @"";
        }else
        {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无部门" andInterval:1.0f];
        return;
        }
    }else
    {
        
        NSArray *arrayDid = [dict[@"departmentID"]componentsSeparatedByString:@","];
        [ShareModel shareModel].departmentID = arrayDid[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
//每一个分组的上左下右间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    
    return UIEdgeInsetsMake(5, Scree_width/2-175, 5, 5);
    
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择职位";
    // [self getAllPosition];
    
    self.arrayData = [NSMutableArray array];
    self.arrayId = [NSMutableArray array];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"请选择您要操作的职位";
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    //同一行相邻两个cell的最小间距
    
    layout.minimumInteritemSpacing = 0;
    
    //最小两行之间的间距
    
    layout.minimumLineSpacing = 100;
    
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    NSString* phoneModel = [UIDevice devicePlatForm];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        label.frame =CGRectMake(8, 98, Scree_width, 14);
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 118, Scree_width, Scree_height) collectionViewLayout:layout];
        
    }else{
        label.frame =CGRectMake(8, 74, Scree_width, 14);
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 94, Scree_width, Scree_height) collectionViewLayout:layout];
        
    }
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CollectionViewCellPosition class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
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
