//
//  VCAddGonggao.m
//  Administration
//
//  Created by zhang on 2017/10/26.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCAddGonggao.h"
#import "CellGonggao.h"
@interface VCAddGonggao ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)NSString *string2;
@end

@implementation VCAddGonggao

#pragma -mark custem
-(void)setUI
{
    UITableView *tableVeiw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableVeiw.delegate = self;
    tableVeiw.dataSource = self;
    tableVeiw.rowHeight = UITableViewAutomaticDimension;
    tableVeiw.estimatedRowHeight = 100;
    [ZXDNetworking setExtraCellLineHidden:tableVeiw];
    [tableVeiw registerClass:[CellGonggao class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableVeiw];
    self.tableView  = tableVeiw;
}

-(void)submitData
{
    NSLog(@"string1 = %@,string2 = %@",self.string1,self.string2);
    NSString *urlStr =[NSString stringWithFormat:@"%@adminNotice/addNotice",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *companyID = [USER_DEFAULTS valueForKey:@"companyinfoid"];
    
    NSDictionary *info=@{@"appkey":appKeyStr,
                         @"usersid":[USER_DEFAULTS  objectForKey:@"userid"],
                         @"comId":companyID,
                         @"title":self.string1,
                         @"content":self.string2};
    
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

-(void)showTips
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要发布此项内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma -mark alertView

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self submitData];
    }
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellGonggao *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellGonggao alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textView.delegate =self;
    if (indexPath.row==0) {
        cell.textView.placeholder = @"请输入标题（30字以内）";
        cell.textView.font = [UIFont systemFontOfSize:20];
        
    }else
    {
        cell.textView.placeholder = @"点击编辑内容";
        cell.textView.font = [UIFont systemFontOfSize:14];
    }
    return cell;
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    CellGonggao *cell = (CellGonggao *)[textView superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.row==0) {
        if (textView.text.length>30) {
            textView.text = [textView.text substringToIndex:30];
        }
        self.string1 = textView.text;
        
    }else
    {
        self.string2 = textView.text;
    }
    
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }
    cell.textView.frame = CGRectMake(frame.origin.x, frame.origin.y,cell.contentView.frame.size.width, size.height);
    
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}


#pragma -make system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加公告";
    [self setUI];
    
    self.string1 = @"";
    self.string2 = @"";
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:(UIBarButtonItemStyleDone) target:self action:@selector(showTips)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
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
