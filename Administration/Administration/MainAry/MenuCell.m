//
//  MenuCell.m
//  快速入口轮番
//
//  Created by yhj on 16/1/13.
//  Copyright © 2016年 QQ:1787354782 QQ群:524884683. All rights reserved.
//

#import "MenuCell.h"
#import "ZYJHeadLineModel.h"
@interface MenuCell ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIView *firstVC;

@property(nonatomic,strong)UIView *secondVC;

//@property(nonatomic,strong)UIPageControl *pageControl;

@end

#define MenuH 270
#define Num 1
#define pageH 0
@implementation MenuCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _firstVC=[[UIView alloc]initWithFrame:CGRectMake(0,0,Scree_width,MenuH)];
        _secondVC=[[UIView alloc]initWithFrame:CGRectMake(Scree_width,0,Scree_width,MenuH)];
        UIScrollView *scrollView=[[UIScrollView alloc]init];
        if (menuArray.count>8) {
          scrollView.frame =CGRectMake(0,0,Scree_width,MenuH+pageH);
        }else{
        scrollView.frame =CGRectMake(0,0,Scree_width,MenuH+pageH);
        }
        
        scrollView.contentSize=CGSizeMake(Num*Scree_width,MenuH+pageH);
        scrollView.pagingEnabled=YES;
        
        //禁止滑动
        scrollView.alwaysBounceVertical = NO;
        scrollView.delegate=self;
        scrollView.showsHorizontalScrollIndicator=NO;
        [scrollView addSubview:_firstVC];
        [scrollView addSubview:_secondVC];
        [self addSubview:scrollView];
        
        for (int i=0;i<menuArray.count;i++) {
            if (i<4) {
                CGRect frame=CGRectMake(i*Scree_width/4,0,Scree_width/4,MenuH/3);
                ZYJHeadLineModel *model =menuArray[i];
                NSString *title=model.title;
                NSString *imageStr=model.type;
                NSString *teeg = model.teeeg;
                int ivalue = [teeg intValue];
                YHJBtnView *btnView=[[YHJBtnView alloc]initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag=ivalue;
                [_firstVC addSubview:btnView];
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
            }
            else if (i<8)
            {
                CGRect frame=CGRectMake((i-4)*Scree_width/4,MenuH/3,Scree_width/4,MenuH/3);
                ZYJHeadLineModel *model =menuArray[i];
                NSString *title=model.title;
                NSString *imageStr=model.type;
                NSString *teeg = model.teeeg;
                int ivalue = [teeg intValue];
                YHJBtnView *btnView=[[YHJBtnView alloc]initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag=ivalue;
                [_firstVC addSubview:btnView];
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
            }
            else if (i<12)
            {
                CGRect frame=CGRectMake((i-8)*Scree_width/4,(MenuH/3)*2,Scree_width/4,MenuH/3);
                ZYJHeadLineModel *model =menuArray[i];
                NSString *title=model.title;
                NSString *imageStr=model.type;
                NSString *teeg = model.teeeg;
                int ivalue = [teeg intValue];
                YHJBtnView *btnView=[[YHJBtnView alloc]initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag=ivalue;
                [_firstVC addSubview:btnView];
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
            }
            else
            {
                CGRect frame=CGRectMake((i-12)*Scree_width/4,(MenuH/3)*3,Scree_width/4,MenuH/3);
                ZYJHeadLineModel *model =menuArray[i];
                NSString *title=model.title;
                NSString *imageStr=model.type;
                NSString *teeg = model.teeeg;
                int ivalue = [teeg intValue];
                YHJBtnView *btnView=[[YHJBtnView alloc]initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag=ivalue;
                [_secondVC addSubview:btnView];
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
            }
        }
//        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(Scree_width/2-pageH,MenuH,0,pageH)];
//        _pageControl.currentPage=0;
//        _pageControl.numberOfPages=Num;
//        [self addSubview:_pageControl];
//     [_pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
//        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    }
    return self;
}

-(void)OnTapBtnView:(UITapGestureRecognizer *)sender
{
    NSLog(@"tag:%ld",sender.view.tag);
    self.resultBLock(sender.view.tag);
  
 }

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
//    _pageControl.currentPage = page;
    
    
    
    
    
    
//    int page=(scrollView.contentOffset.x+scrollView.frame.size.width/2)/scrollView.frame.size.width;
//    _pageControl.currentPage=page;
    
}

@end
