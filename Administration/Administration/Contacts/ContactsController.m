//
//  ContactsController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ContactsController.h"
#import "inftionxqController.h"

#import "LVModel.h"
#import "LVFmdbTool.h"
#define Start_X 10.0f           // 第一个按钮的X坐标
#define Start_Y 50.0f           // 第一个按钮的Y坐标
#define Width_Space 20.0f        // 2个按钮之间的横间距
#define Height_Space 20.0f      // 竖间距
#define Button_Height 65.0f    // 高
#define Button_Width 50.0f      // 宽
@interface ContactsController ()<UITabBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UIButton *sousuoBtn;//搜索框
@property (strong,nonatomic) UIView *view1;//第一条线
@property (strong,nonatomic) UILabel * lxLabel;//最近联系人Label
@property (strong,nonatomic) UITableView *ZJLXTable;//最近联系人列表
@property (nonatomic,strong)NSMutableArray *dataArray;//数据源
@property (nonatomic,strong)NSMutableArray *ImageAry;//各部门图片

@end

@implementation ContactsController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   NSMutableArray *array=[NSMutableArray arrayWithArray:[LVFmdbTool queryData:nil]];
    self.dataArray=[NSMutableArray arrayWithArray:[[array reverseObjectEnumerator] allObjects]];
    [self.ZJLXTable reloadData];
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"通讯录";
    
    [self UIBtn];
}
-(void)UIBtn{
    //搜索按钮
    _sousuoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *imageBtn = [UIImage imageNamed:@"ss_ico01"];
    [_sousuoBtn setBackgroundImage:imageBtn forState:UIControlStateNormal];
    //防止图片变灰
    _sousuoBtn.adjustsImageWhenHighlighted = NO;
    _sousuoBtn.layer.masksToBounds = YES;
    _sousuoBtn.layer.cornerRadius = 8.0;
    [_sousuoBtn addTarget:self action:@selector(Touchsearch)forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_sousuoBtn];
    [_sousuoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(self.view.mas_top).offset(70);
        make.height.mas_equalTo(40);
    }];
    //各部门按钮
    for (int i = 0 ; i < 4; i++) {
        NSInteger index = i % 4;
        NSInteger page = i / 4;
        UIButton *aBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        aBt.adjustsImageWhenHighlighted = NO;
        aBt.backgroundColor = [UIColor clearColor];
        aBt.frame = CGRectMake(index * (Scree_width/4)+Height_Space, page  * (Button_Height + Height_Space)+Start_Y+70, Button_Width, Button_Height);

        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Contact%d",i]];
        [aBt setBackgroundImage:image forState:UIControlStateNormal];
        aBt.tag= i;
        [aBt addTarget:self action:@selector(TouchAbt:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aBt];
    }
    //分割线
    _view1 = [[UIView alloc]init];
    _view1.backgroundColor = [UIColor RGBview];
    [self.view addSubview:_view1];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(_sousuoBtn.mas_bottom).offset(78);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(2);
    }];
    //最近联系人
    _lxLabel = [[UILabel alloc]init];
    _lxLabel.text= @"最近联系人";
    _lxLabel.textColor = [UIColor RGBview];
    _lxLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_lxLabel];
    [_lxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.top.mas_equalTo(_view1.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    //最近联系人列表
    _ZJLXTable = [[UITableView alloc]init];
    _ZJLXTable.backgroundColor = [UIColor whiteColor];
   // _ZJLXTable.separatorStyle = UITableViewCellSelectionStyleNone;
    _ZJLXTable.delegate = self;
    _ZJLXTable.dataSource = self;
    [self.view addSubview:_ZJLXTable];
    //去除多余的cell线
    [ZXDNetworking setExtraCellLineHidden:_ZJLXTable];
    [_ZJLXTable registerNib:[UINib nibWithNibName:@"ZJLXRTableViewCell" bundle:nil] forCellReuseIdentifier:@"BASE"];
    [_ZJLXTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lxLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-49);
    }];

}
-(void)Touchsearch{
    //SearchViewController
    SearchViewController *SearchVC = [[SearchViewController alloc]init];
    [self.navigationController showViewController:SearchVC sender:nil];

}
-(void)TouchAbt:(UIButton *)aBt{
    PersonnelViewController *PersonVC = [[PersonnelViewController alloc]init];
    switch (aBt.tag) {
        case 0:
            PersonVC.roleld= @"2";
            [self.navigationController showViewController:PersonVC sender:nil];
            break;
        case 1:
            PersonVC.roleld= @"5";
            [self.navigationController showViewController:PersonVC sender:nil];
            break;
        case 2:
            PersonVC.roleld= @"3";
            [self.navigationController showViewController:PersonVC sender:nil];
            break;
        case 3:
            PersonVC.roleld= @"4";
            [self.navigationController showViewController:PersonVC sender:nil];
            break;
            
        default:
            break;
    }
    
    
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJLXRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BASE"forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model=self.dataArray[indexPath.row];
   
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    inftionxqController *imftionVC=[[inftionxqController alloc]init];
    LVModel *lmodel=self.dataArray[indexPath.row];
    imftionVC.IDStr=lmodel.roleld;
    [self.navigationController pushViewController:imftionVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
