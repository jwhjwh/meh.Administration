//
//  CityChooseViewController.h
//  Administration
//
//  Created by 九尾狐 on 2017/3/1.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnTextBlock)(NSString *showText);
typedef void(^SelectedHandle)(NSString * province, NSString * city, NSString * area,NSString*zhadd);
@interface CityChooseViewController : UIViewController
@property(nonatomic, copy) SelectedHandle selectedBlock;
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

@property (nonatomic,copy) NSString *isfoyou;

@property (nonatomic,copy) NSString *storesssss;
@property (nonatomic,copy) NSString *storescity;
@property (nonatomic,copy) NSString *storesCount;
@property (nonatomic,copy) NSString *storespoince;
@property (nonatomic,copy) NSString *storesaddes;

@property (nonatomic,strong) NSString *shopnanme;
@end
