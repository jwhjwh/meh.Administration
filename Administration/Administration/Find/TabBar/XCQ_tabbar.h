
#import <UIKit/UIKit.h>
/**
    自定义tabbar 上的按钮，可以定义选中和非选中的图片与标题
 **/



@interface XCQ_tabbar : UIView
//未选中图片
@property(nonatomic,strong) UIImage *unSelectedImg ;
//选中图片
@property(nonatomic,strong) UIImage *selectedImg ;
//点击事件
@property(nonatomic,assign) id tabbarTarget ;
@property(nonatomic,assign) SEL tabbarAction;
//选中状态以及推送红点状态
@property(nonatomic,assign) BOOL tabbarSelected ,redIndex;
//盛放tabbarBtn的View
@property(nonatomic,strong) UIView *itemView ;
//显示标题的title
@property(nonatomic,strong) UILabel *titleLabel ;
//显示标签图片的imgView
@property(nonatomic,strong) UIImageView *tabbarImgView ;


#pragma mark -- 按钮的初始化方法

-(id)initWithFrame:(CGRect)frame
 withUnSelectedImg:(UIImage *)unSelectedImg
   withSelectedImg:(UIImage *)selectedImg
         withTitle:(NSString *)tabbarTitle ;

#pragma mark -- 按钮的点击事件

-(void)setClickEventTarget:(id)target action:(SEL)action ;

#pragma mark -- tabbar按钮添加徽标以及徽标数目

-(void)setRedIndex:(BOOL)redIndex andBudgeNum:(NSInteger)budgeNum;

-(void)setSelected:(BOOL)selected ;

@end
