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
    
    _hornImage=[[UIImageView alloc]initWithFrame:CGRectMake(5,self.frame.size.height/2-22, 28, 28)];
    
    _hornImage.image=[UIImage imageNamed:@"laba"];
    [self addSubview:_hornImage];
    
    _fullImage=[[UIImageView alloc]initWithFrame:CGRectMake(_hornImage.right+3,1, 16,16)];
    
    _fullImage.image=[UIImage imageNamed:@"xulie"];
    [self addSubview:_fullImage];
    _label=[[UILabel alloc]initWithFrame:CGRectMake(_fullImage.right, 0,self.frame.size.width-10,20)];
   
    _label.font = [UIFont systemFontOfSize:10];
    [self addSubview:_label];
    _TopLineView = [[ZYJHeadLineView alloc]initWithFrame:CGRectMake(_hornImage.right+5, _hornImage.top-1,kMidViewWidth, kMidViewHeight)];

    [self addSubview:_TopLineView];
  
    NSString *urlStr =[NSString stringWithFormat:@"%@adminNotice/getLatest.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"comId":compid};
    
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        NSDictionary *dic=[responseObject valueForKey:@"adminNotice"];
        NSString *contStr=[NSString stringWithFormat:@"%@",[dic valueForKey:@"content"]];
        //通过字符切割成数组
        NSArray *contArr= [contStr componentsSeparatedByString:@"，"];
        _label.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"title"]];
       
        _dataArr=[[NSMutableArray alloc]init];
        
        for (int i=0; i<contArr.count; i++) {
            ZYJHeadLineModel *model = [[ZYJHeadLineModel alloc]init];
            model.title = contArr[i];
            [_dataArr addObject:model];
        }
        NSLog(@"%@",_dataArr);
        [_TopLineView setVerticalShowDataArr:_dataArr];
        
        
    } failure:^(NSError *error) {
        
    } view:nil MBPro:YES];

   
   
}
-(void)array:(NSArray*)array title:(NSString *)title {
    
}
@end
