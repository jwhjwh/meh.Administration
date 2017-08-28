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
    NSMutableArray *arrayContent;
    
}
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
        
        NSLog(@"%@",indexP);
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
    NSLog(@"长安");
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
    NSLog(@"cell.te = %@",cell.textView1.text);
    
    
    NSIndexPath *indexPath = [tableView1 indexPathForCell:cell];
    
    NSMutableDictionary *dict = [array[indexPath.section]mutableCopy];
    
    NSMutableArray *mutArray = [arrayContent[indexPath.section]mutableCopy];
    [mutArray removeObjectAtIndex:indexPath.row];
    [arrayContent replaceObjectAtIndex:indexPath.section withObject:mutArray];
    
    [dict setValue:[NSString stringWithFormat:@"%ld",inter] forKey:@"number"];
    [array replaceObjectAtIndex:indexPath.section withObject:dict];
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
    [tableView1 reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    [button removeFromSuperview];
}

-(void)allReady:(UIButton *)button
{
    
    CellPostil *cell = (CellPostil *)[[button superview]superview];
    NSIndexPath *indePath = [tableView1 indexPathForCell:cell];
    NSMutableArray *mutArray = arrayContent[indePath.section];
    NSMutableDictionary *dict = mutArray[indePath.row];
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSString *DateTime = [formatter stringFromDate:date];
    cell.labelTime.text = DateTime;
    if ([cell.buttonComp.titleLabel.text isEqualToString:@"完成"]) {
        [cell.buttonComp setTitle:@"修改" forState:UIControlStateNormal];
        cell.textView1.userInteractionEnabled = NO;
        cell.textView2.userInteractionEnabled = NO;
        [dict setValue:cell.textView1.text forKey:@"textView1"];
        [dict setValue:cell.textView2.text forKey:@"textView2"];
        [dict setValue:@"3" forKey:@"buttonState"];
        [dict setValue:DateTime forKey:@"date"];
        [mutArray replaceObjectAtIndex:indePath.row withObject:dict];
        [arrayContent replaceObjectAtIndex:indePath.section  withObject:mutArray];
        
    }else
    {
        [cell.buttonComp setTitle:@"完成" forState:UIControlStateNormal];
        cell.textView1.userInteractionEnabled = YES;
        cell.textView2.userInteractionEnabled = YES;
        [dict setValue:cell.textView1.text forKey:@"textView1"];
        [dict setValue:cell.textView2.text forKey:@"textView2"];
        [dict setValue:@"2" forKey:@"buttonState"];
        [dict setValue:DateTime forKey:@"date"];
        [mutArray replaceObjectAtIndex:indePath.row withObject:dict];
        [arrayContent replaceObjectAtIndex:indePath.section  withObject:mutArray];
    }
    
}

-(void)addPostil:(UIButton *)sender
{
    
    
    NSMutableDictionary *dictL = [NSMutableDictionary dictionary];
    [dictL setValue:@"" forKey:@"textView1"];
    [dictL setValue:@"" forKey:@"textView2"];
    [dictL setValue:@"1" forKey:@"buttonState"];
    [dictL setValue:@"" forKey:@"date"];
    
    NSUInteger index = sender.tag;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:index -10];
    NSMutableDictionary *dict = [array[index-10]mutableCopy];
    
    NSMutableArray *mutArray = [arrayContent[index-10]mutableCopy];
    [mutArray insertObject:dictL atIndex:0];
    
    [arrayContent replaceObjectAtIndex:index-10 withObject:mutArray];
    
    inter = [dict[@"number"]intValue];
    inter ++;
    
    [dict setValue:[NSString stringWithFormat:@"%ld",inter] forKey:@"number"];
    [array replaceObjectAtIndex:index-10 withObject:dict];
    [tableView1 reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

#pragma -mark alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        //提交数据
        [self back];
    }
}

#pragma -mark tabelView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict =array[section];
    return [dict[@"number"]intValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellPostil *cell = [tableView1 dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellPostil alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lpGR:)];
    // cell.buttonComp.hidden = YES;
    //设定最小的长按时间 按不够这个时间不响应手势
    cell.textView1.delegate = self;
    cell.textView2.delegate = self;
    longPressGR.minimumPressDuration = 1;
    
    NSDictionary *dict = arrayContent[indexPath.section][indexPath.row];
    if (dict[@"textView1"]!=nil) {
        cell.textView1.text = dict[@"textView1"];
    }
    
    if (dict[@"textView2"]!=nil) {
        cell.textView2.text = dict[@"textView2"];
    }
    
    if ([dict[@"buttonState"] isEqualToString:@"1"]) {
        cell.buttonComp.hidden = YES;
        cell.textView1.userInteractionEnabled = YES;
        cell.textView2.userInteractionEnabled = YES;
        
    }else if ([dict[@"buttonState"] isEqualToString:@"2"])
    {
        [cell.buttonComp setTitle:@"完成" forState:UIControlStateNormal];
        cell.textView1.userInteractionEnabled = YES;
        cell.textView2.userInteractionEnabled = YES;
        cell.buttonComp.hidden = NO;
    }else
    {
        [cell.buttonComp setTitle:@"修改" forState:UIControlStateNormal];
        cell.textView1.userInteractionEnabled = NO;
        cell.textView2.userInteractionEnabled = NO;
        cell.buttonComp.hidden = NO;
    }
    NSString *stringDate = dict[@"date"];
    if (stringDate.length==0) {
        cell.labelTime.text = @"刚刚";
    }else
    {
        cell.labelTime.text = dict[@"date"];
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
    
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 100, 30)];
    label.text = dict[@"position"];
    [view addSubview:label];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(-8,30, 100, 20)];
    button.tag = section+10;
    [button setTitle:@"添加批注 +" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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
        [cell.buttonComp setTitle:@"完成" forState:UIControlStateNormal];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"批注";
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(-1, 64, Scree_width+1, 44)];
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.0f;
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 40)];
    label.text  = [NSString stringWithFormat:@"   %@",self.stringName];
    label.backgroundColor = GetColor(255, 249, 230, 1);
    [view addSubview:label];
    
    NSDictionary *dictTitle = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStyleDone) target:self action:@selector(submit)];
    [rightitem setTitleTextAttributes:dictTitle forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    inter=1;
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 108,Scree_width , Scree_height) style:UITableViewStyleGrouped];
    [tableView1 registerClass:[CellPostil class] forCellReuseIdentifier:@"cell"];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.backgroundColor = GetColor(255, 252, 241, 1);
    tableView1.rowHeight = UITableViewAutomaticDimension;
    tableView1.estimatedRowHeight = 80;
    [self.view addSubview:tableView1];
    
    arrayContent = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"" forKey:@"textView1"];
    [dict setValue:@"" forKey:@"textView2"];
    [dict setValue:@"1" forKey:@"buttonState"];
    [dict setValue:@"" forKey:@"date"];
    for (int i=0; i<3; i++) {
        NSMutableArray *mutArray = [NSMutableArray arrayWithObject:dict];
        [arrayContent insertObject:mutArray atIndex:0];
    }
    NSLog(@"mutArray = %@",arrayContent);
    
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
    NSString *roleid = [USER_DEFAULTS valueForKey:@"roleId"];
    
    [dictPosition enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([roleid isEqualToString:key]) {
            obj = dictPosition[roleid];
            NSLog(@"obj = %@",obj);
            NSString *stringObj = [NSString stringWithFormat:@"%@",obj];
            if ([stringObj containsString:@"老板"]) {
                array =  [NSMutableArray arrayWithObjects:@{@"position":@"经理批注",@"show":@"0",@"number":@"0"},@{@"position":@"行政批注",@"show":@"0",@"number":@"0"},@{@"position":@"老板批注",@"show":@"1",@"number":@"1"}, nil];
                
            }else if([stringObj containsString:@"行政"])
            {
                array = [NSMutableArray arrayWithObjects:@{@"position":@"经理批注",@"show":@"0",@"number":@"0"},@{@"position":@"行政批注",@"show":@"1",@"number":@"1"},@{@"position":@"老板批注",@"show":@"0",@"number":@"0"}, nil];
            }else if([stringObj containsString:@"总监"])
            {
                array = [NSMutableArray arrayWithObjects:@{@"position":@"总监批注",@"show":@"1",@"number":@"1"},@{@"position":@"行政批注",@"show":@"0",@"number":@"0"},@{@"position":@"老板批注",@"show":@"0",@"number":@"0"}, nil];
            }else
            {
                array = [NSMutableArray arrayWithObjects:@{@"position":@"经理批注",@"show":@"1",@"number":@"1"},@{@"position":@"行政批注",@"show":@"0",@"number":@"0"},@{@"position":@"老板批注",@"show":@"0",@"number":@"0"}, nil];
            }
        }
    }];
   
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
