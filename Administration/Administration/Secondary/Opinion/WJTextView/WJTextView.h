//
//  WJTextView.h
//  Administration
//
//  Created by 九尾狐 on 2017/2/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJTextView : UITextView

@property (nonatomic,copy)NSString *placehoder;
@property (nonatomic,strong)UIColor *placehoderColor;
@property (nonatomic,assign)BOOL isAutoHeight;
@end
