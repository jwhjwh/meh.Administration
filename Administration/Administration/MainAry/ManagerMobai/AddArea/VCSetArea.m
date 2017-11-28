//
//  VCSetArea.m
//  Administration
//
//  Created by zhang on 2017/11/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCSetArea.h"
#import "ViewChooseCity.h"

@interface VCSetArea ()<ViewChooseCityDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)ViewChooseCity *chooseCity;
@end

@implementation VCSetArea

#pragma -mark custem
//
//-(void)getHttpData
//{
//    
//}
//
//-(void)submitData
//{
//    
//}

-(void)showCityView
{
    ViewChooseCity *city = [[ViewChooseCity alloc]initWithFrame:CGRectMake(0, kTopHeight+45, Scree_width, Scree_height)];
    city.delegate = self;
    [self.view addSubview:city];
    self.chooseCity = city;
}

-(void)setUI
{
    UIButton *buttonArea = [[UIButton alloc]initWithFrame:CGRectMake(-1, kTopHeight, Scree_width+2, 44)];
    buttonArea.layer.borderWidth = 1.0f;
    buttonArea.layer.borderColor = GetColor(239, 239, 244, 1).CGColor;
    buttonArea.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonArea.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [buttonArea setBackgroundColor:[UIColor whiteColor]];
    [buttonArea setTitle:@"负责区域" forState:UIControlStateNormal];
    [buttonArea setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonArea addTarget:self action:@selector(showCityView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonArea];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(buttonArea.frame.size.width-20, 15, 15, 10)];
    imageView.image = [UIImage imageNamed:@"down"];
    [buttonArea addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(-2, 200, Scree_width+4, 30)];
    label.layer.borderColor = GetColor(239, 239, 244, 1).CGColor;
    label.layer.borderWidth = 2.0f;
    label.text = @"   负责区域";
    label.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 231, Scree_width, Scree_height-231)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

#pragma -mark viewChooseCityDelegate

-(void)getCity
{
    if (self.chooseCity.stringAll ==nil) {
        [self.arrayData addObject:@""];
    }else
    {
        [self.arrayData addObject:self.chooseCity.stringAll];
    }
    
    [ShareModel shareModel].stringProvince = [self.chooseCity.arrayProvince componentsJoinedByString:@","];
    [ShareModel shareModel].stringCity = [self.chooseCity.arrayCity componentsJoinedByString:@","];
    [ShareModel shareModel].stringCountry = [self.chooseCity.arrayCountry componentsJoinedByString:@","];
    
    [self.tableView reloadData];
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.imageView.image = [UIImage imageNamed:@"location_ico"];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.arrayData[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"负责区域";
    
    [self setUI];
    self.arrayData = [NSMutableArray array];
    
//    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(submitData)];
//    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
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
