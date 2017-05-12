//
//  NoticeView.m
//  Administration
//
//  Created by zhang on 2017/2/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "NoticeView.h"

@implementation NoticeView


#pragma mark 代码创建
- (instancetype)initWithFrame:(CGRect)frame  {
    if (self = [super initWithFrame:frame]) {
        
        [self initSubView];
        
    }
    return self;
}
#pragma mark 初始化控件
- (void)initSubView {
  
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:12.5];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor =[UIColor RGBNav].CGColor;
    
    _hornImage=[[UIImageView alloc]initWithFrame:CGRectMake(5,self.frame.size.height/2-10, 28, 28)];
    
    _hornImage.image=[UIImage imageNamed:@"laba"];
    [self addSubview:_hornImage];
    
    _fullImage=[[UIImageView alloc]initWithFrame:CGRectMake(_hornImage.right+3,6, 16,16)];
    
    _fullImage.image=[UIImage imageNamed:@"xulie"];
    [self addSubview:_fullImage];
    _label=[[UILabel alloc]initWithFrame:CGRectMake(_fullImage.right, 0,self.frame.size.width-10,30)];
    _label.numberOfLines=0;
    _label.font = [UIFont systemFontOfSize:14];
    [self addSubview:_label];
    _TopLineView = [[ZYJHeadLineView alloc]initWithFrame:CGRectMake(_hornImage.right+5, _hornImage.top-1,kMidViewWidth, kMidViewHeight)];

    [self addSubview:_TopLineView];
  
    NSString *urlStr =[NSString stringWithFormat:@"%@adminNotice/getLatest.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"comId":compid};
    
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        NSString * statStr=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        if ([statStr isEqualToString:@"0000"]) {
            NSDictionary *dic=[NSDictionary changeType:[responseObject valueForKey:@"adminNotice"]];
            NSString *contStr;
            if ([[NSString stringWithFormat:@"%@", dic] isEqualToString:@""]) {
                contStr=@"暂无公告";
            }else{
                 contStr=[NSString stringWithFormat:@"%@",[dic valueForKey:@"content"]];
            }
            NSString *strUrl = [contStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            //通过字符切割成数组
            NSMutableArray *contArr=[NSMutableArray array];
            NSInteger Intege;
            int a;
            if ( [UIScreen
                   mainScreen].bounds.size.height == 568.0) {
                a=15;
            }else if([UIScreen
                      mainScreen].bounds.size.height == 667.0){
                a=16;
            }else if ([UIScreen
                       mainScreen].bounds.size.height == 736.0){
                a=17;
            }
            BOOL isleng=  [self isPureFloat:[NSString stringWithFormat:@"%lu",strUrl.length/a]];
            if (isleng==YES) {
               Intege = (int)strUrl.length/a+1;
            }else{
                Intege = (int)strUrl.length/a;
            }
            NSString * b;
            for (int i=0;  Intege >i; i++) {
                if (Intege-1>i) {
                     b= [strUrl substringWithRange:NSMakeRange (i*a,a)];
                }else{
                     b=  [strUrl substringFromIndex:i*a];
                }
                [contArr addObject:b];
            }
            if ([[NSString stringWithFormat:@"%@", dic] isEqualToString:@""]) {
                _label.text= @"暂无公告";
            }else{
                _label.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"title"]];
            }
           
            
            _dataArr=[[NSMutableArray alloc]init];
            
            for (int i=0; i<contArr.count; i++) {
                ZYJHeadLineModel *model = [[ZYJHeadLineModel alloc]init];
                model.title = contArr[i];
                [_dataArr addObject:model];
            }
       
            [_TopLineView setVerticalShowDataArr:_dataArr];
        }
        
    } failure:^(NSError *error) {
        
    } view:nil MBPro:YES];

 
   
}
-(void)array:(NSArray*)array title:(NSString *)title {
    
}

- (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}
@end
