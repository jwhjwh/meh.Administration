//
//  MySubmittedViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "MySubmittedViewController.h"
#import "TableViewCell.h"
@interface MySubmittedViewController ()<UITableViewDelegate,UITableViewDataSource,TextViewCellDelegate>


//列表
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataLabel;
@property (strong, nonatomic)  UIImageView *dateImage;//图片
@property (strong,nonatomic) UIButton *submittedBtn;//报岗记录按钮
@end

@implementation MySubmittedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片报岗";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataLabel =[NSMutableArray arrayWithObjects:@"时间",@"地点",@"想做的事",@"进展程度", nil];
    [self mySubmittedUI];
    
}
-(void)mySubmittedUI{

    _submittedBtn = [[UIButton alloc]init];
    [_submittedBtn setBackgroundImage:[UIImage imageNamed:@"wdbg.png"] forState:UIControlStateNormal];
    [self.view addSubview:_submittedBtn];
    [_submittedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo (self.view.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(@80);
    }];
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TableViewCell"];
    [self setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.view.mas_top).offset(70);
        make.left.equalTo (self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(_submittedBtn.mas_top).offset(0);
    }];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataLabel.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    cell.textViewCellDelegate = self;
    if (indexPath.row == 0) {
        
        cell.backgroundColor = [UIColor redColor];
    }
    
    cell.cellLabel.text = self.dataLabel[indexPath.row];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 240)];
    view.backgroundColor = [UIColor redColor];
        _dateImage = [[UIImageView alloc]init];
        _dateImage.image = [UIImage imageNamed:@"ph_mt02"];
        [view addSubview:_dateImage];
        [_dateImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo (view.mas_top).offset(5);
            make.left.equalTo(view.mas_left).offset(15);
            make.right.equalTo(view.mas_right).offset(-15);
            make.height.mas_equalTo(@240);
        }];
    
    [tableView addSubview:view];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 240;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 240;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (void)textViewCell:(TableViewCell *)cell didChangeText:(UITextView *)textView
{
   //监听输入框
    
    
    
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
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
