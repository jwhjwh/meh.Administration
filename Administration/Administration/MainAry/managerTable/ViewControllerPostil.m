//
//  ViewControllerPostil.m
//  Administration
//
//  Created by zhang on 2017/8/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerPostil.h"
#import "CellPostil.h"
@interface ViewControllerPostil ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate>
{
    UITableView *tableView1;
    NSInteger inter;
    NSDictionary *dictPosition;
    NSMutableArray * array;
    BOOL isSelect;
    NSIndexPath *indexP;
   
    NSString *comment;//批注的内容
    NSString *location;//报表的内容
    
    NSString *stringObj;
    
    BOOL isAddPostil;
    
    
    NSMutableArray *array1;
    NSMutableArray *array2;
    NSMutableArray *array3;
    NSMutableArray *array4;
    
}
@property (nonatomic ,strong)NSString *postiliD;
@end

@implementation ViewControllerPostil
#pragma -mark custem

-(void)submit
{
    UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要提交此项内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alt show];
}

-(void)lpGR:(UILongPressGestureRecognizer *)lpGR
{
    if (lpGR.state == UIGestureRecognizerStateBegan) {//手势开始
        
        CGPoint point = [lpGR locationInView:tableView1];
        
        indexP = [tableView1 indexPathForRowAtPoint:point]; // 可以获取我们在哪个cell上长按
        
       
    }
    
    if (lpGR.state == UIGestureRecognizerStateEnded)//手势结束
    {
        CellPostil *cell = [tableView1 cellForRowAtIndexPath:indexP];
        UIButton *button = [self showDeletImage:CGRectMake(cell.contentView.frame.size.width/2-20,0, 60, 50)];
        [cell.contentView addSubview:button];
    }
    
}

-(UIButton *)showDeletImage:(CGRect )frame;
{
   
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:@"sc_icof"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"删除" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 10);
    
    
    return button;
}

-(void)deleteCell:(UIButton *)button
{
    
    inter --;
    
    CellPostil *cell = (CellPostil *)[button superview].superview;
    
    NSIndexPath *indexPath = [tableView1 indexPathForCell:cell];
    
    NSMutableDictionary *dict = [array[indexPath.section]mutableCopy];
    NSMutableArray  *arrayC = [dict[@"list"] mutableCopy];
    
    NSDictionary *dct = arrayC[indexPath.row];
    if ([[NSString stringWithFormat:@"%@",dct[@"id"]]isEqualToString:@""]) {
        [arrayC removeObjectAtIndex:indexPath.row];
        
        [dict setValue:arrayC forKey:@"list"];
        [array replaceObjectAtIndex:indexPath.section withObject:dict];
    }else
    {
        [self deletePositil:[NSString stringWithFormat:@"%@",dct[@"id"]]];
    }
    
    
    
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
    [tableView1 reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    [button removeFromSuperview];
}

-(void)allReady:(UIButton *)button
{
    CellPostil *cell = (CellPostil *)[[button superview]superview];
    NSIndexPath *indePath = [tableView1 indexPathForCell:cell];
    NSDictionary *dict = array[indePath.section];
    NSArray *arrayL = dict[@"list"];
    NSDictionary *dic = arrayL[indePath.row];
    if (dic[@"id"]==nil||[[NSString stringWithFormat:@"%@",dic[@"id"]] isEqualToString:@""]) {
        self.postiliD = @"";
    }
    else
    {
        self.postiliD = [NSString stringWithFormat:@"%@",dic[@"id"]];
    }
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSString *DateTime = [formatter stringFromDate:date];
    cell.labelTime.text = DateTime;
    
    if (cell.textView1.text.length==0) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写批注内容" andInterval:1];
        return;
    }
    if (cell.textView2.text.length==0) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写批注对象" andInterval:1];
        return;
    }
    
    if ([cell.buttonComp.titleLabel.text isEqualToString:@"完成"]) {
        [self submitPostil];
        isAddPostil = YES;
        [cell.buttonComp setTitle:@"修改" forState:UIControlStateNormal];
        cell.textView1.userInteractionEnabled = NO;
        cell.textView2.userInteractionEnabled = NO;
    }else
    {
        [cell.buttonComp setTitle:@"完成" forState:UIControlStateNormal];
        cell.textView1.userInteractionEnabled = YES;
        cell.textView2.userInteractionEnabled = YES;
    }
    
}

-(void)addPostil:(UIButton *)sender
{
    NSMutableDictionary *dictL = [NSMutableDictionary dictionary];
    [dictL setValue:@"" forKey:@"addTime"];
    [dictL setValue:@"" forKey:@"comment"];
    [dictL setValue:@"1" forKey:@"fieldValue"];
    [dictL setValue:@"" forKey:@"id"];
    [dictL setValue:@"" forKey:@"location"];
    [dictL setValue:@"" forKey:@"mid"];
    [dictL setValue:@"" forKey:@"reportId"];
    [dictL setValue:@"" forKey:@"reportRemark"];
    [dictL setValue:@"" forKey:@"roleId"];
    
    NSUInteger index = sender.tag;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:index -10];
    NSMutableDictionary *dict = [array[index-10]mutableCopy];
    
    NSMutableArray *mutArray = [dict[@"list"]mutableCopy];
    [mutArray insertObject:dictL atIndex:0];
    
   
    [dict setValue:mutArray forKey:@"list"];
    
    [array replaceObjectAtIndex:index-10 withObject:dict];
    
    inter = [dict[@"number"]intValue];
    inter ++;

    
    [USER_DEFAULTS setValue:@"" forKey:@"postilID"];
    [dict setValue:[NSString stringWithFormat:@"%ld",inter] forKey:@"number"];
    [array replaceObjectAtIndex:index-10 withObject:dict];
    [tableView1 reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

-(void)submitPostil
{
    NSString *urlStr =[NSString stringWithFormat:@"%@manager/addReportPostil",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    
    
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"DepartmentID":self.departmentID,
                           @"field":self.theKey,
                           @"comment":comment,
                           @"location":location,
                           @"reportId":self.tableID,
                           @"remark":self.remark,
                           @"id":self.postiliD,
                           @"Num":self.num};
    
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"成功" andInterval:1];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"token请求超时" andInterval:1];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return ;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据空" andInterval:1];
            return ;
        }
        if ([code isEqualToString:@"0003"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有权限" andInterval:1];
            return ;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)deletePositil:(NSString *)postilID
{
    NSString *urlStr =[NSString stringWithFormat:@"%@manager/mDeletePostil",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS valueForKey:@"userid"],@"id":postilID};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        
        if ([code isEqualToString:@"0000"]) {
            [self getData];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)getData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@manager/queryReportPostilInfo",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"DepartmentID":self.departmentID,
                           @"field":self.theKey,
                           @"reportId":self.tableID,
                           @"remark":self.remark};
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        [array1 removeAllObjects];
        [array2 removeAllObjects];
        [array3 removeAllObjects];
        [array4 removeAllObjects];
        NSString *code = [responseObject valueForKey:@"status"];
        NSMutableArray *arraylist = [[responseObject valueForKey:@"list"]mutableCopy];
        NSMutableDictionary *dictInfo = [NSMutableDictionary dictionary];
        if (arraylist==nil) {
            arraylist  = [NSMutableArray array];
            [dictInfo setValue:@"" forKey:@"addTime"];
            [dictInfo setValue:@"" forKey:@"comment"];
            [dictInfo setValue:@"" forKey:@"fieldValue"];
            [dictInfo setValue:@"" forKey:@"id"];
            [dictInfo setValue:@"" forKey:@"location"];
            [dictInfo setValue:@"" forKey:@"mid"];
            [dictInfo setValue:@"" forKey:@"reportId"];
            [dictInfo setValue:@"" forKey:@"reportRemark"];
            [dictInfo setValue:@"" forKey:@"roleId"];
            [array1 addObject:dictInfo];
            [array2 addObject:dictInfo];
            [array3 addObject:dictInfo];
            [array4 addObject:dictInfo];
        }
        self.postiliD = @"";
        for (NSDictionary *dictionary in arraylist) {
            NSString *roleid = [NSString stringWithFormat:@"%@",dictionary[@"roleId"]];
            if ([roleid isEqualToString:@"1"]) {
                [array1 addObject:dictionary];
            }else if([roleid isEqualToString:@"7"])
            {
                [array2 addObject:dictionary];
            }else if ([roleid isEqualToString:@"8"]||[roleid isEqualToString:@"6"]||[roleid isEqualToString:@"12"]||[roleid isEqualToString:@"13"]||[roleid isEqualToString:@"15"])
            {
                [array3 addObject:dictionary];
            }else
            {
                [array4 addObject:dictionary];
            }
            
        }
        
        NSString *roleid = [USER_DEFAULTS valueForKey:@"roleId"];
        
        [dictPosition enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([roleid isEqualToString:key]) {
                obj = dictPosition[roleid];
                stringObj = [NSString stringWithFormat:@"%@",obj];
                if ([stringObj containsString:@"老板"]) {
                    array =  [NSMutableArray arrayWithObjects:@{@"position":@"经理批注",@"show":@"0",@"number":@"0",@"list":array3},@{@"position":@"行政批注",@"show":@"0",@"number":@"0",@"list":array2},@{@"position":@"老板批注",@"show":@"1",@"number":@"1",@"list":array1}, nil];
                    
                }else if([stringObj containsString:@"行政"])
                {
                    array = [NSMutableArray arrayWithObjects:@{@"position":@"经理批注",@"show":@"0",@"number":@"0",@"list":array3},@{@"position":@"行政批注",@"show":@"1",@"number":@"1",@"list":array2},@{@"position":@"老板批注",@"show":@"0",@"number":@"0",@"list":array1}, nil];
                }else if([stringObj containsString:@"总监"])
                {
                    array = [NSMutableArray arrayWithObjects:@{@"position":@"总监批注",@"show":@"1",@"number":@"1",@"list":array4},@{@"position":@"行政批注",@"show":@"0",@"number":@"0",@"list":array2},@{@"position":@"老板批注",@"show":@"0",@"number":@"0",@"list":array1}, nil];
                }else
                {
                    array = [NSMutableArray arrayWithObjects:@{@"position":@"经理批注",@"show":@"1",@"number":@"1",@"list":array3},@{@"position":@"行政批注",@"show":@"0",@"number":@"0",@"list":array2},@{@"position":@"老板批注",@"show":@"0",@"number":@"0",@"list":array1}, nil];
                }
            }
        }];
        
        
        if ([code isEqualToString:@"0000"]) {
            
            [tableView1 reloadData];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"token请求超时" andInterval:1];
            return;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return;
        }
        if ([code isEqualToString:@"5000"]) {
            [tableView1 reloadData];
            return;
        }
        if ([code isEqualToString:@"0003"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有权限" andInterval:1];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

#pragma -mark tabelView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict =array[section];
   // return array[section];
    NSArray *arr = dict[@"list"];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellPostil *cell = [tableView1 dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellPostil alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.contentView.backgroundColor = GetColor(255, 252, 241, 1);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lpGR:)];
    // cell.buttonComp.hidden = YES;
    //设定最小的长按时间 按不够这个时间不响应手势
    cell.textView1.delegate = self;
    cell.textView2.delegate = self;
    longPressGR.minimumPressDuration = 1;
    NSDictionary *dict = array[indexPath.section];
    NSArray *arrayList = dict[@"list"];
    NSDictionary *dictInfo = arrayList[indexPath.row];
    
    //NSDictionary *dcit1 = arrayContent[indexPath.section][indexPath.row];
   
    cell.textView1.text = dictInfo[@"location"];
    cell.textView2.text = dictInfo[@"comment"];
    if ([dictInfo[@"addTime"] length]!=0) {
        cell.labelTime.text = [dictInfo[@"addTime"] substringToIndex:15];
    }else
    {
        cell.labelTime.text = @"刚刚";
    }
    
    if ([[ShareModel shareModel].roleID isEqualToString:[NSString stringWithFormat:@"%@",dict[@"roleId"]]]) {
        cell.buttonComp.hidden = NO;
        cell.buttonComp.userInteractionEnabled = YES;
    }else
    {
        cell.buttonComp.hidden = YES;
        cell.buttonComp.userInteractionEnabled = NO;
    }
    
  //  [cell.buttonComp setTitle:@"修改" forState:UIControlStateNormal];
    
    if (cell.textView1.text.length!=0||cell.textView2.text.length!=0) {
        cell.buttonComp.hidden = NO;
        cell.buttonComp.userInteractionEnabled = YES;
        [cell.buttonComp setTitle:@"修改" forState:UIControlStateNormal];
        cell.textView1.userInteractionEnabled = NO;
        cell.textView2.userInteractionEnabled = NO;
        
    }else
    {
        cell.buttonComp.hidden = YES;
        cell.buttonComp.userInteractionEnabled = NO;
        cell.textView1.userInteractionEnabled = YES;
        cell.textView2.userInteractionEnabled = YES;

        
    }
    
    [cell addGestureRecognizer:longPressGR];
    [cell.buttonComp addTarget:self action:@selector(allReady:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc]init];
    
    NSDictionary *dict = array[section];
    if ([dict[@"number"] isEqualToString:@"0"])
    {
        view.frame = CGRectMake(0, 0,tableView1.bounds.size.width, 50);
    }else
    {
        view.frame = CGRectMake(0, 0,tableView1.bounds.size.width, 70);
    }
    
    view.backgroundColor = GetColor(255, 252, 241, 1);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 100, 30)];
    label.text = dict[@"position"];
    [view addSubview:label];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(-8,30, 100, 20)];
    button.tag = section+10;
    [button setTitle:@"添加批注 +" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:GetColor(142, 124, 108, 1) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addPostil:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    if ([dict[@"show"] isEqualToString:@"0"]) {
        button.userInteractionEnabled = NO;
        button.hidden = YES;
        tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = array[section];
    if ([dict[@"number"] isEqualToString:@"0"])
    {
        return 50;
    }else
    {
        return 70;
    }
    
}

#pragma -mark textView
-(void)textViewDidChange:(UITextView *)textView
{
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }
    
    CellPostil *cell = (CellPostil *)[textView superview].superview;
    if ( cell.textView1.text.length!=0||cell.textView2.text.length!=0) {
        cell.buttonComp.hidden = NO;
        cell.buttonComp.userInteractionEnabled = YES;
        [cell.buttonComp setTitle:@"完成" forState:UIControlStateNormal];
        if ([textView isEqual:cell.textView1]) {
            if (cell.textView1.text.length!=0) {
                location = cell.textView1.text;
            }else
            {
               location = @"";
            }
            
        }else if ([textView isEqual:cell.textView2]) {
            if (cell.textView2.text.length!=0) {
                comment = cell.textView2.text;
            }else
            {
                comment = @"";
            }
            
        }else
        {
            location = @"";
            comment = @"";
        }
    }
    else
    {
        cell.buttonComp.hidden = YES;
    }
    
    
    
    cell.textView1.frame = CGRectMake(frame.origin.x, frame.origin.y,cell.contentView.frame.size.width, size.height);
    cell.viewText.frame = CGRectMake(frame.origin.x, frame.origin.y, cell.contentView.frame.size.width, size.height+31);
    // cell.textView2.frame = CGRectMake(frame.origin.x, frame.origin.y+size.height+1, cell.contentView.frame.size.width, 30);
    [tableView1 beginUpdates];
    [tableView1 endUpdates];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"批注";
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 40)];
    textView.attributedText = self.stringName;
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.backgroundColor = GetColor(255, 249, 230, 1);
    
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)];
    textView.frame = CGRectMake(textView.frame.origin.x, 0, textView.frame.size.width, size.height);
    [self.view addSubview:textView];
    
    self.postiliD = @"";
    
    array1 = [NSMutableArray array];
    array2 = [NSMutableArray array];
    array3 = [NSMutableArray array];
    array4 = [NSMutableArray array];
    
    inter=1;
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,Scree_width , Scree_height) style:UITableViewStyleGrouped];
    [tableView1 registerClass:[CellPostil class] forCellReuseIdentifier:@"cell"];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.backgroundColor = GetColor(255, 252, 241, 1);
    tableView1.rowHeight = UITableViewAutomaticDimension;
    tableView1.tableHeaderView = textView;
    tableView1.estimatedRowHeight = 80;
    [self.view addSubview:tableView1];
    
    dictPosition = @{@"1":@"老板",
                     @"2":@"美导",
                     @"3":@"客服",
                     @"4":@"物流",
                     @"5":@"业务",
                     @"6":@"品牌经理",
                     @"7":@"行政管理",
                     @"8":@"业务经理",
                     @"9":@"业务总监",
                     @"10":@"市场总监",
                     @"11":@"财务总监",
                     @"12":@"客服经理",
                     @"13":@"物流经理",
                     @"14":@"仓库",
                     @"15":@"财务经理",
                     @"16":@"会计",
                     @"17":@"出纳"};

   
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
