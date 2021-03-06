//
//  UIViewDatePicker.m
//  testCalender
//
//  Created by zhang on 2017/11/23.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "UIViewDatePicker.h"

@interface UIViewDatePicker ()
@property (nonatomic,strong)IDJDatePickerView *djdateGregorianView;
@property (nonatomic,strong)IDJDatePickerView *djdateChineseView;
@property (nonatomic,weak)UIButton *buttonSure;
@property (nonatomic,weak)UIButton *buttonCancle;

@property (nonatomic,weak)UILabel *labelCalender;
@property (nonatomic,weak)UILabel *labelDate;




@end

@implementation UIViewDatePicker

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        
    }
    return self;
}

-(void)setUI
{
//    UIColor *color = [UIColor colorWithRed:234.0f/255.0f green:235.0f/255.0f blue:236.0f/255.0f alpha:1];
    UIColor *color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.5];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 310)];
    view.backgroundColor = [UIColor lightGrayColor];
    view.center = self.center;
    [self addSubview:view];
    
    UILabel *labelDate = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 31)];
    labelDate.backgroundColor = [UIColor whiteColor];
    labelDate.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labelDate];
    self.labelDate = labelDate;
    
    self.djdateGregorianView=[[IDJDatePickerView alloc]initWithFrame:CGRectMake(0, 31, 300, 200) type:Gregorian1];
    self.djdateGregorianView.delegate = self;
    [view addSubview:self.djdateGregorianView];
    
    
    self.djdateChineseView=[[IDJDatePickerView alloc]initWithFrame:CGRectMake(0, 31, 300, 200) type:Chinese1];
    self.djdateChineseView.delegate = self;
    self.djdateChineseView.hidden = YES;
    [view addSubview:self.djdateChineseView];
    
    
    UILabel *labelCalender = [[UILabel alloc]initWithFrame:CGRectMake(0,231 , 249, 41)];
    labelCalender.backgroundColor = [UIColor whiteColor];
    labelCalender.text = @"  公历";
    [view addSubview:labelCalender];
    self.labelCalender = labelCalender;
    
    UIView *viewS = [[UIView alloc]initWithFrame:CGRectMake(249, 231, 51, 41)];
    viewS.backgroundColor = [UIColor whiteColor];
    [view addSubview:viewS];
    
    UISwitch *sw = [[UISwitch alloc]initWithFrame:CGRectMake(0, 5, 51, 31)];
    [sw addTarget:self action:@selector(switchPress:) forControlEvents:UIControlEventValueChanged];
    [viewS addSubview:sw];
    
    UIButton *buttonCancle = [[UIButton alloc]initWithFrame:CGRectMake(0, 273, 149, 44)];
    [buttonCancle setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCancle setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonCancle setBackgroundColor:[UIColor whiteColor]];
    [buttonCancle addTarget:self action:@selector(buttonCancled) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonCancle];
    self.buttonCancle = buttonCancle;
    
    UIButton *buttonSure = [[UIButton alloc]initWithFrame:CGRectMake(150, 273, 150, 44)];
    [buttonSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonSure setTitle:@"确定" forState:UIControlStateNormal];
    [buttonSure setBackgroundColor:[UIColor whiteColor]];
    [buttonSure addTarget:self action:@selector(buttonSurehh) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonSure];
    self.buttonSure = buttonSure;
    
    

    labelDate.text = self.djdateGregorianView.stringGregorian;
    _flagggg = [[NSString alloc]init];
    _flagggg = @"2";
    self.stringGregorian =[[NSString alloc]init];
    self.stringChinese   =[[NSString alloc]init];
    

    self.stringChinese = self.djdateGregorianView.stringChinese;
    self.stringGregorian = self.djdateGregorianView.stringGregorian;
}

-(void)switchPress:(UISwitch *)sw
{
    if (sw.on) {
        self.djdateGregorianView.hidden  = YES;
        self.djdateChineseView.hidden = NO;
        self.labelCalender.text = @"    农历";
        
        self.labelDate.text = self.stringChinese;

        _flagggg = @"1";


        self.labelDate.text = self.djdateGregorianView.stringGregorian;
        


        
    }else
    {
        self.djdateChineseView.hidden = YES;
        self.djdateGregorianView.hidden = NO;
        self.labelCalender.text = @"    公历";
        self.labelDate.text = self.stringGregorian;

        _flagggg = @"2";

        self.labelDate.text = self.djdateGregorianView.stringChinese;


    }
}

- (void)notifyNewCalendar:(IDJCalendar *)cal {
    if ([cal isMemberOfClass:[IDJCalendar class]]) {
        NSLog(@"%@:era=%@, year=%@, month=%@, day=%@, weekday=%@", cal, cal.era, cal.year, cal.month, cal.day, cal.weekday);
        
        Solar *s = [[Solar alloc]initWithYear:[cal.year intValue]
                                     andMonth:[cal.month intValue]
                                       andDay:[cal.day intValue]];
        //得出阴历
        Lunar *l = [CalendarDisplyManager obtainLunarFromSolar:s];
    
        NSArray *array =  [CalendarDisplyManager resultWithLunar:l resultFormat:[NSString stringWithFormat:@"%d",l.lunarYear] Month:[NSString stringWithFormat:@"%d",l.lunarMonth] Day:[NSString stringWithFormat:@"%d",l.lunarDay]];
        
        NSString *year = [self getCnMoneyByString:array[0]];
        
        self.stringChinese = [NSString stringWithFormat:@"%@年%@%@",year,array[1],array[2]];
        self.stringGregorian = [NSString stringWithFormat:@"%@-%@-%@",cal.year,cal.month,cal.day];
        self.labelDate.text = self.stringChinese;
    } else if ([cal isMemberOfClass:[IDJChineseCalendar class]]) {
        IDJChineseCalendar *_cal=(IDJChineseCalendar *)cal;
        NSLog(@"%@:era=%@, year=%@, month=%@, day=%@, weekday=%@, animal=%@", cal, cal.era, cal.year, cal.month, cal.day, cal.weekday, _cal.animal);
        
        NSString *stringYear = [self getCnMoneyByString:cal.year];
        
        NSString *stringM = [cal.month substringWithRange:NSMakeRange(2, cal.month.length-2)];
        
        NSString *stringMonth = _cal.chineseMonths[[stringM intValue]-1];
        
        NSString *stringDay = _cal.chineseDays[[cal.day intValue]-1];
        
        self.stringChinese = [NSString stringWithFormat:@"%@年%@%@",stringYear,stringMonth,stringDay];
        
        NSString *string = [cal.month substringWithRange:NSMakeRange(2, cal.month.length-2)];
        
        Lunar *l = [[Lunar alloc]initWithYear:[cal.year intValue] andMonth:[string intValue] andDay:[cal.day intValue]];
        
        Solar *s = [CalendarDisplyManager obtainSolarFromLunar:l];
        
        self.stringGregorian = [NSString stringWithFormat:@"%d-%d-%d",s.solarYear,s.solarMonth,s.solarDay];
        self.labelDate.text = self.stringGregorian;
        
        
    }
}

-(void)buttonCancled
{
    [self.buttonCancle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonCancle setBackgroundColor:[UIColor purpleColor]];
    [self removeFromSuperview];
}

-(void)buttonSurehh
{
   
 //   self.blcokStrrrr(self.stringGregorian,self.stringChinese,_flagggg);
    
    [self.buttonSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonSure setBackgroundColor:[UIColor purpleColor]];

    if ([self.delegate respondsToSelector:@selector(getChooseDate)]) {
        [self.delegate getChooseDate];

    }

//    if ([self.delegate respondsToSelector:@selector(getChooseDate)]) {
//        [self.delegate getChooseDate];
//        [ShareModel shareModel].stringGregorian = self.stringGregorian;
//        [ShareModel shareModel].stringChinese = self.stringChinese;
//    }
    
    NSLog(@"%@---%@---%@",self.stringGregorian,self.stringChinese,_flagggg);
    
    [self removeFromSuperview];
    
}

-(NSString *)getCnMoneyByString:(NSString*)string
{
    NSString *string1 = @"";
    
    for ( int i=0; i<string.length; i++) {
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        NSInteger interg = [s intValue];
        
        switch (interg) {
            case 0:
                string1 =[string1 stringByAppendingString:@"零"];
                break;
            case 1:
                string1 =[string1 stringByAppendingString:@"一"];
                break;
            case 2:
                string1 =[string1 stringByAppendingString:@"二"];
                break;
            case 3:
                string1 =[string1 stringByAppendingString:@"三"];
                break;
            case 4:
                string1 =[string1 stringByAppendingString:@"四"];
                break;
            case 5:
                string1 =[string1 stringByAppendingString:@"五"];
                break;
            case 6:
                string1 =[string1 stringByAppendingString:@"六"];
                break;
            case 7:
                string1 =[string1 stringByAppendingString:@"七"];
                break;
            case 8:
                string1 =[string1 stringByAppendingString:@"八"];
                break;
            case 9:
                string1 =[string1 stringByAppendingString:@"九"];
                break;
                
            default:
                break;
        }
    }
    
    return string1;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
