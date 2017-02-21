//
//  EditDataViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "EditDataViewController.h"

@interface EditDataViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
}
@end

@implementation EditDataViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"编辑资料";
    [self InterTableUI];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setExtraCellLineHidden:tableview];
    // Do any additional setup after loading the view.
}
-(void)InterTableUI
{
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    
    tableview.scrollEnabled =YES;
    tableview.dataSource=self;
    tableview.delegate =self;
    [self.view addSubview:tableview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 5;
            break;
        case 3:
            return 3;
            break;
        case 4:
            return 2;
            break;
            
        default:
            break;
    }
    return section;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (0 == indexPath.section) {
        cell.textLabel.text = @"头像";
         }else if (1 == indexPath.section){
             if (0 == indexPath.row) {
                cell.textLabel.text = @"账号";
                 }else if (1 == indexPath.row){
                    cell.textLabel.text = @"职位";
                     
                 }
            }else if (2 == indexPath.section){
                if (0 == indexPath.row) {
                    cell.textLabel.text = @"真实姓名";
                } else if (1 == indexPath.row) {
                    cell.textLabel.text = @"出生日期";
                }else if (2 == indexPath.row){
                    cell.textLabel.text = @"年龄";
                }else if (3 == indexPath.row){
                    cell.textLabel.text = @"身份证号";
                }else if (4 == indexPath.row){
                    cell.textLabel.text = @"现住地址";
                }
            }else if (3 == indexPath.section){
                if (0 == indexPath.row) {
                    cell.textLabel.text = @"手机号";
                }else if (1 == indexPath.row){
                    cell.textLabel.text = @"微信号";
                }else {
                    cell.textLabel.text = @"QQ号";
                }
            }else{
                if (0 == indexPath.row) {
                    cell.textLabel.text =@"兴趣爱好";
                }else{
                    cell.textLabel.text  = @"个性签名";
                }
            }
    if ([cell.textLabel.text  isEqual: @"头像"]) {
        UIImageView *TXImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80, 20, 40, 40)];
        TXImage.image = [UIImage imageNamed:@"tx23.png"];
        TXImage.backgroundColor = [UIColor whiteColor];
        TXImage.layer.masksToBounds = YES;
        TXImage.layer.cornerRadius = 20.0;//设置圆角
        [tableview addSubview:TXImage];
        NSLog(@"加上图片了么");
        
    };
    if (indexPath.section >=1) {
        CGRect labelRect2 = CGRectMake(150, 0, self.view.bounds.size.width-150, 50);
        UITextField *text1 = [[UITextField alloc] initWithFrame:labelRect2];
        text1.backgroundColor=[UIColor whiteColor];
        if ([cell.textLabel.text isEqual: @"身份证号"]) {
            text1.placeholder =@"必填";
        }
        text1.font = [UIFont boldSystemFontOfSize:15.6f];
        text1.clearButtonMode = UITextFieldViewModeWhileEditing;
        text1.adjustsFontSizeToFitWidth = YES;
        
        [cell addSubview:text1];
    }
    
       return cell;

}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{ if (section == 4 ){
    return 0;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
    
    return 80;
    }
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == tableview)
    {
        CGFloat sectionHeaderHeight = 80;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
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
