//
//  GroupMenberController.m
//  Administration
//
//  Created by zhang on 2017/7/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GroupMenberController.h"
#import "GroupMenberCell.h"
#import "ZXDChineseString.h"
#import "PerLomapController.h"
#import "TransferGroupViewController.h"
#import "AddmemberController.h"
#import "inftionxqController.h"
#import "ModelArray.h"
@interface GroupMenberController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong)UITableView *tableViewMenber;
@property (nonatomic,strong)NSMutableArray *arrayMenber;//源数据
@property (nonatomic,strong)NSMutableArray *arrayIndex;
@property (nonatomic,strong)NSMutableArray *tempArray;
@property (nonatomic,strong)NSMutableArray *latterSortArray;
@property (nonatomic,strong)NSMutableArray *resultArr;//新数据源；
@property (nonatomic,strong)NSDictionary *dictBoss;//群主数据源;
@property (nonatomic,strong)NSMutableArray *arrList;
@property (nonatomic,assign)BOOL isGroupBoss;
@property (nonatomic,strong)NSString * index;
@property (nonatomic,strong)UIAlertView *altView1;
@property (nonatomic,strong)UIAlertView *altView2;
@property (nonatomic,strong)UIAlertView *altView3;
@property (nonatomic,strong)NSMutableArray *arraySelect;
@property (nonatomic,strong)UIButton *buttonDelet;
@property (nonatomic,assign)BOOL isMe;
@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,strong)NSMutableArray *arraySearch;
@property (nonatomic,strong)NSMutableArray *arrayName;
@property (nonatomic,strong)NSArray *filterdArray;
@property (nonatomic,strong)NSArray *array;
@end

@implementation GroupMenberController

#pragma -mark getData
//获取群成员列表
-(void)getGroupMenbers
{
    NSString *urlStr =[NSString stringWithFormat:@"%@group/selectGroupMembers.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *userid = [USER_DEFAULTS objectForKey:@"userid"];
    NSDictionary *dictInfo = @{@"appkey":appKeyStr,@"usersid":userid,@"groupinformationId":self.groupinformation[@"id"]};
    
    [ZXDNetworking GET:urlStr parameters:dictInfo success:^(id responseObject) {
        
        
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.arrayMenber = [[responseObject valueForKey:@"list"] mutableCopy];
            self.arrList = [responseObject valueForKey:@"list"];
            NSMutableArray *pinyinArr = [NSMutableArray array];
             self.resultArr = [NSMutableArray array];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
           // [dict setValue:@"0" forKey:@"isSelect"];
            self.tempArray = [self.arrayMenber mutableCopy];
            
            //取出所有的名字
            for (NSDictionary *dict in self.arrayMenber) {
                [self.arrayName addObject:dict[@"name"]];
            }
            //取出群主放到最上面
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSMutableArray *arrNew = [NSMutableArray array];
            for (int i=0; i<self.arrayMenber.count; i++) {
                dic = self.arrayMenber[i];
                //  pinyin = [pinyinArr[i] substringToIndex:1];
                int code = [[dic valueForKey:@"position"] intValue];
                NSString *stringC = [NSString stringWithFormat:@"%d",code];
                
                //判断是否是群主
                if ([stringC isEqualToString:@"0"]) {
                    self.isGroupBoss = YES;
                    [arrNew addObject:dic];
                    [self.resultArr insertObject:arrNew atIndex:0];
                    [self.arrayMenber removeObjectAtIndex:i];
                    break;
                }
            }

            //取出群主后的数组，取首字母
            for (int i=0; i<self.arrayMenber.count; i++) {
                dict = self.arrayMenber[i];
                [pinyinArr addObject:dict[@"name"]];
            }
            
            for (int  i =0; i<[self.arrayMenber count]; i++) {
                NSDictionary *dict1 = self.arrayMenber[i];
                NSString *mutableString1 = [NSMutableString stringWithString:dict1[@"name"]];
                CFStringTransform((__bridge CFMutableStringRef)mutableString1, NULL, kCFStringTransformMandarinLatin, NO);
                CFStringTransform((__bridge CFMutableStringRef)mutableString1, NULL, kCFStringTransformStripCombiningMarks, NO);
                NSString *string1 =  [mutableString1 uppercaseString];
                NSLog(@"%@", string1);
                for (int j =0; j<i; j++) {
                    NSDictionary *dict2 = self.arrayMenber[j];
                    NSString *mutableString2 = [NSMutableString stringWithString:dict2[@"name"]];
                    CFStringTransform((__bridge CFMutableStringRef)mutableString2, NULL, kCFStringTransformMandarinLatin, NO);
                    CFStringTransform((__bridge CFMutableStringRef)mutableString2, NULL, kCFStringTransformStripCombiningMarks, NO);
                    NSString *string2 =  [mutableString2 uppercaseString];
                    NSLog(@"%@", string2);
                    
                    if ([[string1 substringToIndex:1] compare:[string2 substringToIndex:1]]==NSOrderedAscending) {
                        [self.self.arrayMenber exchangeObjectAtIndex:i withObjectAtIndex:j];
                        
                        
                    }
                }
            }
            self.arrayIndex = [ZXDChineseString IndexArray:pinyinArr];
            [self.arrayIndex insertObject:@"群主（1人）" atIndex:0];
            self.latterSortArray = [ZXDChineseString LetterSortArray:pinyinArr];
        //    NSMutableArray *arrayL = [ZXDChineseString ReturnSortChineseArrar:pinyinArr];

            //名字首字母相同的放在一起
            NSString *stringtemp;
            NSDictionary *dictInfo = [NSDictionary dictionary];
            NSMutableArray *arrNew2;
            
            for (int i=0;i<self.arrayMenber.count;i++) {
                dictInfo = self.arrayMenber[i];
                
                NSMutableString *mutableString = [NSMutableString stringWithString:dictInfo[@"name"]];
                //将汉字转换为拼音(带音标)
                CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformMandarinLatin, NO);
                NSLog(@"%@", mutableString);
                
                //去掉拼音的音标
                CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
                NSLog(@"%@", mutableString);
                
            
                NSString *pinYin = [[mutableString capitalizedString]substringToIndex:1];
                
                if (![stringtemp isEqualToString:pinYin]) {
                    arrNew2 = [NSMutableArray array];
                    [arrNew2 addObject:dictInfo];
                    [self.resultArr addObject:arrNew2];
                    //遍历
                    stringtemp = pinYin;
                }
                
                else
                {
                    [arrNew2 addObject:dictInfo];
                }
            
            }
            
            [self.tableViewMenber reloadData];
        }
     
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
            return ;
        }
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请重新登录" andInterval:1.0];
            return ;
        }
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"1111"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return ;
        }

        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

//转让群
-(void)transferGroup
{
    TransferGroupViewController *controller = [[TransferGroupViewController alloc]init];
    controller.arrList = self.resultArr;
    controller.arrTitle = self.arrayIndex;
    controller.groupInfo = self.groupinformation;
    [self.navigationController pushViewController:controller animated:YES];
}
//解散/退出群
-(void)dissoveGroup
{
    NSString *urlStr =[NSString stringWithFormat:@"%@group/deleteGroupMembers.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *userid = [USER_DEFAULTS objectForKey:@"userid"];
    
    NSDictionary *dic = @{@"appkey":appKeyStr,@"usersid":userid,@"groupinformationId":self.groupinformation[@"id"],@"groupNumber":self.groupinformation[@"groupNumber"],@"uuid":[USER_DEFAULTS objectForKey:@"uuid"]};
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
        NSString *stringCode = [responseObject valueForKey:@"status"];
        if ([stringCode isEqualToString:@"0000"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return ;
        }
        if ([stringCode isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请重新登录" andInterval:1];
            return;
        }
        if ([stringCode isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1];
            return;
        }
        if ([stringCode isEqualToString:@"1111 "]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

//查看群成员位置
-(void)getMenberLocaion:(UIButton *)button
{
    NSDictionary *dict = [NSDictionary dictionary];
    GroupMenberCell *cell = (GroupMenberCell *)[[button superview] superview];
    NSIndexPath *indexPath = [self.tableViewMenber indexPathForCell:cell];
    if (indexPath.section==0&&indexPath.row==0) {
        dict = self.dictBoss;
    }else
    {
        dict = self.resultArr[indexPath.section][indexPath.row];
    }
    
    PerLomapController *controller = [[PerLomapController alloc]init];
    controller.uesrId = dict[@"userId"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)loadDeletButton
{
    self.buttonDelet = [[UIButton alloc]initWithFrame:CGRectMake(0, Scree_height-44, Scree_width, 44)];
    self.buttonDelet.backgroundColor = GetColor(238, 238, 238, 1);
    [self.buttonDelet addTarget:self action:@selector(deleteTip) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonDelet setTitle:@"删除" forState:UIControlStateNormal];
    [self.buttonDelet setTitleColor:GetColor(0, 132, 249, 1) forState:UIControlStateNormal];
    if ([self.index isEqualToString:@"2"]) {
       [self.view addSubview:self.buttonDelet];
        self.tableViewMenber.frame = CGRectMake(0, 0, Scree_width, Scree_height-44);
    }else
    {
        [self.buttonDelet removeFromSuperview];
         self.tableViewMenber.frame = CGRectMake(0, 0, Scree_width, Scree_height);
    }
  
    
}
//提示
-(void)deleteTip
{
    self.altView3  = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确定要将选中用户删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [self.altView3 show];
}

//删除群成员
-(void)deletMenber
{
    NSString *urlStr =[NSString stringWithFormat:@"%@group/deleteGroupMembersuserid.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *userid = [USER_DEFAULTS objectForKey:@"userid"];
    
    NSMutableArray *arrList = [NSMutableArray array];
    NSDictionary *dictinfo = [NSDictionary dictionary];
    for (int i=0; i<self.arraySelect.count; i++) {
        dictinfo = self.arraySelect[i];
        NSMutableDictionary *listUersid = [NSMutableDictionary dictionary];
        [listUersid setValue:dictinfo[@"userId"] forKey:@"userId"];
        [listUersid setValue:dictinfo[@"uuid"] forKey:@"uuid"];
        [arrList addObject:listUersid];
    }
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:arrList options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":userid,@"groupinformationId":self.groupinformation[@"id"],@"groupNumber":self.groupinformation[@"groupNumber"],@"list":jsonStr};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *stringCode = [responseObject objectForKey:@"status"];
        if ([stringCode isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"成功" andInterval:1];
            [self getGroupMenbers];
            [self.buttonDelet removeFromSuperview];
            [self.tableViewMenber reloadData];
            return ;
        }
        if ([stringCode isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"token超时请重新登录" andInterval:1];
            return ;
        }
        if ([stringCode isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1];
            return ;
        }
        if ([stringCode isEqualToString:@"1111"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除失败" andInterval:1];
            return ;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

//添加群成员
-(void)addMenber
{
    AddmemberController *controller = [[AddmemberController alloc]init];
    controller.isHaveGroup = YES;
    controller.groupinformationId = self.groupinformation[@"id"];
    controller.groupID = self.groupinformation[@"groupNumber"];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma --mark actionSheet
-(void)showActionSheet
{
    UIActionSheet *actionSheet;
    if (self.isGroupBoss) {
        actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看群成员位置",@"邀请群成员",@"删除群成员",@"退出该群", nil];
    }else
    {
        actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看群成员位置",@"邀请群成员",@"退出该群", nil];
    }
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.index = [NSString stringWithFormat:@"%ld",(long)buttonIndex];
    if (self.isGroupBoss) {
        switch (buttonIndex) {
            case 0:
                [self.tableViewMenber reloadData];
                break;
            case 1:
                 [self addMenber];
                break;
            case 2:
                [self loadDeletButton];
                [self.tableViewMenber reloadData];
                break;
            case 3:
                self.altView1 = [[UIAlertView alloc]initWithTitle:@"" message:@"你是群主，请选择转让或解散" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"转让",@"解散",nil];
                [self.altView1 show];
                break;
            default:
                break;
        }
    }
    else
    {
        
        switch (buttonIndex) {
            case 0:
                [self.tableViewMenber reloadData];
                break;
            case 1:
                [self addMenber];
                break;
            case 2:
                [self dissoveGroup];
                break;
                
            default:
                break;
        }
    }
}

#pragma -mark alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView==self.altView1) {
        if (buttonIndex==1) {
            [self transferGroup];
        }else if(buttonIndex==2){
            self.altView2 = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你将要与群成员失去联系确定要解散？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [self.altView2 show];
        }
    }
    if (alertView==self.altView2) {
        if (buttonIndex==1) {
           [self dissoveGroup];
        }
        
    }
    if(alertView==self.altView3)
    {
        if (buttonIndex==1) {
            [self deletMenber];
        }
    }
}

#pragma --mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.searchBar isFirstResponder]) {
        return 1;
    }
    return self.arrayIndex.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.searchBar isFirstResponder]) {
        return self.arraySearch.count;
    }
    return [self.resultArr[section] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.searchBar isFirstResponder]) {
        return @"群成员";
    }
        return self.arrayIndex[section];

    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    self.array = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    return self.array;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index

{
    NSInteger count = 0;
    
    for(NSString *character in self.array)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupMenberCell *cell = [self.tableViewMenber dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[GroupMenberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.labelDivision.hidden = YES;
    cell.locationButton.hidden = YES;
    cell.zhiLabel.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.searchBar isFirstResponder]) {
        NSDictionary *dict = self.arraySearch[indexPath.row];
        NSMutableString *name = [dict[@"name"] mutableCopy];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:name];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, self.searchBar.text.length)];
        
        cell.nameLabel.attributedText = attributedString;
        cell.TelLabel.text = dict[@"account"];
        NSString *logoImage=[NSString stringWithFormat:@"%@%@",KURLHeader,self.dictBoss[@"img"]];
        [cell.TXImage sd_setImageWithURL:[NSURL URLWithString:logoImage] placeholderImage:[UIImage imageNamed:@"banben100"]];
    }
    else{
    NSDictionary *dict = self.resultArr[indexPath.section][indexPath.row];
    cell.nameLabel.text = dict[@"name"];
    cell.TelLabel.text = dict[@"account"];
    NSString *logoImage=[NSString stringWithFormat:@"%@%@",KURLHeader,self.dictBoss[@"img"]];
    [cell.TXImage sd_setImageWithURL:[NSURL URLWithString:logoImage] placeholderImage:[UIImage imageNamed:@"banben100"]];
    
    if ([[NSString stringWithFormat:@"%@",dict[@"userId"]] isEqualToString:[USER_DEFAULTS objectForKey:@"userid"]]) {
        self.isMe = YES;
        cell.zhiLabel.hidden= NO;
        cell.zhiLabel.text = @"我";
        cell.labelDivision.hidden = YES;
        cell.locationButton.hidden = YES;
    }else
    {
        cell.zhiLabel.hidden = YES;
        if ([self.index isEqualToString:@"0"]) {
            cell.locationButton.hidden = NO;
            cell.labelDivision.hidden = NO;
            [cell.locationButton addTarget:self action:@selector(getMenberLocaion:) forControlEvents:UIControlEventTouchUpInside];
        }else
        {
            cell.locationButton.hidden = YES;
            cell.labelDivision.hidden = YES;
        }
        if ([self.index isEqualToString:@"2"]) {
            [cell.selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                make.height.mas_equalTo(30);
                make.width.mas_equalTo(30);
                make.left.mas_equalTo(cell.contentView.mas_left).offset(8);
                    
                }];
                
            }
        
    }
    
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.searchBar isFirstResponder]) {
        NSDictionary *dict = self.arraySearch[indexPath.row];
        inftionxqController *controller = [[inftionxqController alloc]init];
        controller.IDStr = dict[@"userId"];
        [self.navigationController pushViewController:controller animated:YES];
    }else
    {
    NSMutableDictionary *dict = [self.resultArr[indexPath.section][indexPath.row] mutableCopy];
    if ([self.index isEqualToString:@"2"]) {
       // [self.resultArr removeObjectAtIndex:0];
        
        GroupMenberCell *cell = [self.tableViewMenber cellForRowAtIndexPath:indexPath];
        cell.isSelected = !cell.isSelected;
        if (cell.isSelected) {
            cell.selectImage.image = [UIImage imageNamed:@"xuanzhong"];
            cell.isSelected = YES;
            NSString *string = @"1";
            [dict setValue:string forKey:@"isSelect"];
            [self.arraySelect addObject:dict];
            self.buttonDelet.userInteractionEnabled = YES;
             [self.buttonDelet setTitle:[NSString stringWithFormat:@"确定（%lu）",(unsigned long)self.arraySelect.count] forState:UIControlStateNormal];
            self.buttonDelet.userInteractionEnabled = YES;
            
        }else
        {
            cell.selectImage.image = [UIImage imageNamed:@"weixuanzhong"];
            cell.isSelected = NO;
            [self.arraySelect removeObject:dict];
            NSString *string = @"2";
            [dict setValue:string forKey:@"isSelect"];
            [self.buttonDelet setTitle:[NSString stringWithFormat:@"确定（%lu）",(unsigned long)self.arraySelect.count] forState:UIControlStateNormal];
            if (self.arraySelect.count==0) {
                [self.buttonDelet setTitle:@"确定" forState:UIControlStateNormal];
                self.buttonDelet.userInteractionEnabled = NO;
            }
        }
  
    }
    else
    {
        inftionxqController *controller = [[inftionxqController alloc]init];
        controller.model = self.resultArr[indexPath.section][indexPath.row];
        controller.IDStr = dict[@"userId"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma -mark searchbar
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSDictionary *dict = [NSDictionary dictionary];
    [self.arraySearch removeAllObjects];
    for (int i=0;i<self.arrayName.count;i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", searchText];
        
        self.filterdArray = [self.arrayName filteredArrayUsingPredicate:predicate];
        
//        [self.arraySearch addObjectsFromArray:self.filterdArray];
    }
    for (int i=0; i<self.filterdArray.count; i++) {
        for (int j=0; j<self.tempArray.count; j++) {
            dict = self.tempArray[j];
            if ([self.filterdArray[i]isEqualToString:dict[@"name"]]) {
                [self.arraySearch addObject:dict];
            }
        }
    }
    
   // NSExpression *
    
    [self.tableViewMenber reloadData];
    
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar isFirstResponder] ;
    self.navigationController.navigationBar.hidden = YES;
    self.searchBar.frame = CGRectMake(0, 20, Scree_width, 40);
    self.tableViewMenber.frame = CGRectMake(0, 60, Scree_width,Scree_height-40);
    [self.tableViewMenber reloadData];
    return YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    self.searchBar.frame = CGRectMake(0, 64, Scree_width, 40);
    self.tableViewMenber.frame = CGRectMake(0, 104, Scree_width,Scree_height-40);
    self.searchBar.text = @"";
    self.navigationController.navigationBar.hidden = NO;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self searchBarTextDidEndEditing:self.searchBar];
    [self.tableViewMenber reloadData];
    NSLog(@"2");
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"群成员";
    self.arrayMenber = [NSMutableArray array];
    self.arrayIndex = [NSMutableArray array];
    self.arraySelect = [NSMutableArray array];
    self.arraySearch = [NSMutableArray array];
    self.arrayName = [NSMutableArray array];
    self.tempArray = [NSMutableArray array];
    self.filterdArray = [NSMutableArray array];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, Scree_width, 40)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    self.searchBar.backgroundColor = [UIColor lightGrayColor];
    self.searchBar.showsCancelButton = YES;
    [self.view addSubview:self.searchBar];
    
//    self.tableViewMenber = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, Scree_width,Scree_height) style:UITableViewStyleGrouped];
    self.tableViewMenber = [[UITableView alloc]init];
    self.tableViewMenber.backgroundColor = [UIColor whiteColor];
    self.tableViewMenber.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableViewMenber.delegate = self;
    self.tableViewMenber.dataSource = self;
    [self.tableViewMenber registerClass:NSClassFromString(@"GroupMenberCell") forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableViewMenber];
    [self.tableViewMenber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"···" style:(UIBarButtonItemStyleDone) target:self action:@selector(showActionSheet)];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    self.navigationItem.rightBarButtonItem = rightitem;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.arrayMenber removeAllObjects];
    [self getGroupMenbers];
    
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
