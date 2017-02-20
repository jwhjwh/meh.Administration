//
//  PersonnelViewController.m
//  Administration
//  联系人->>各部门人员
//  Created by 九尾狐 on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "PersonnelViewController.h"

@interface PersonnelViewController ()

@end

@implementation PersonnelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"人员";//从上级界面传过来title
     self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
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
