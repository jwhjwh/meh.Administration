//
//  AddBusinessViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/4/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//  添加业务组

#import "AddBusinessViewController.h"

@interface AddBusinessViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *AddBusinessTableview;
    
}


@end

@implementation AddBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加业务部";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *letfbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    letfbtn.frame =CGRectMake(0, 0, 28,28);
    [letfbtn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [letfbtn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:letfbtn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    //+
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"完成"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(buttonrightItem)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self InterTableUI];
}
-(void)buttonrightItem{

}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)InterTableUI
{
    AddBusinessTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,20,self.view.bounds.size.width,self.view.bounds.size.height+29) style:UITableViewStylePlain];
    AddBusinessTableview.dataSource=self;
    AddBusinessTableview.delegate =self;
    AddBusinessTableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:AddBusinessTableview];
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = GetColor(201, 201, 201, 1);
    [AddBusinessTableview addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.bottom.equalTo(AddBusinessTableview.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *ary = [[NSArray alloc]initWithObjects:@"名称",@"所属总监", nil];
    
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [AddBusinessTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *btLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width, 20)];
    btLabel.text = ary[indexPath.row];
    btLabel.font = [UIFont systemFontOfSize:kWidth*30];
    [cell addSubview:btLabel];
    if (indexPath.row == 0) {
        UITextField *nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 40, self.view.bounds.size.width, 30)];
        nameTextField.placeholder = @"请输入业务部名称";
        nameTextField.font = [UIFont systemFontOfSize:kWidth*30];
        [cell addSubview:nameTextField];
    }else{
        UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, self.view.bounds.size.width, 30)];
        placeLabel.text = @"请选择所属总监";
        placeLabel.textColor = GetColor(193, 193, 193, 1);
        placeLabel.font = [UIFont systemFontOfSize:kWidth*30];
        [cell addSubview:placeLabel];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        NSLog(@"点击了弹出框");
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    
    view.backgroundColor =GetColor(201, 201, 201, 1);
    
    
    return view;
    
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
