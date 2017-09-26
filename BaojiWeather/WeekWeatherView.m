//
//  WeekWeatherView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/25.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "WeekWeatherView.h"

#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
@implementation WeekWeatherView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
    }
    return self;
}

- (void)createWeekWeatherWhihTemH:(NSArray *)temH temL:(NSArray *)temL{
    CGFloat f1,f2,f3,w,w1,w2;
    f1=SCREEN_HEIGHT>600 ?24:22;
    f2=SCREEN_HEIGHT>600 ?35:32;
    f3=SCREEN_HEIGHT>600 ?70:60;
    w=SCREEN_HEIGHT>600 ?30.0:33.0;
    w1=SCREEN_HEIGHT>600 ?250.0:115.0;
    w2=SCREEN_HEIGHT>600 ?116.0:100.0;
    NSDate *date = [NSDate date];
    NSArray *dayArray=[NSArray arrayWithArray:[self sevenDays:date]];
    
    NSArray *weekDayArray=[NSArray arrayWithArray:[self sevenWeekDay:date]];
    
    NSMutableArray *weekArray=[NSMutableArray new];
    weekArray =[weekDayArray mutableCopy];
    [weekArray replaceObjectAtIndex:0 withObject:@"今天"];
    
 
    IconAndLabView *titLab=[[IconAndLabView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-95,4,190, 30)];
    [titLab setImage:[UIImage imageNamed:@"tqqs"] text:@"未来七天天气趋势"];
    [titLab setTextFont:19];
    [self addSubview:titLab];
    
    _lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(8, 35, SCREEN_WIDTH-16, 220) andLineChartType:JHChartLineValueNotForEveryX];
    _lineChart.xLineDataArr =weekArray;
    
    //_lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
   // _lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
    //_lineChart.valueArr = @[temH,temL];
    _lineChart.valueArr = @[@[@"10",@"10",@"10",@1,@1,@1,@1],@[@"0",@"0",@"0",@0,@0,@0,@0]];
    _lineChart.yDescTextFontSize = _lineChart.xDescTextFontSize = 12.0;
    _lineChart.valueFontSize = 13.0;
    /* 值折线的折线颜色 默认暗黑色*/
    _lineChart.valueLineColorArr =@[ [UIColor orangeColor], [UIColor yellowColor]];
    
    /* 值点的颜色 默认橘黄色*/
    _lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    
    /*        是否展示Y轴分层线条 默认否        */
    _lineChart.showYLevelLine = NO;
    _lineChart.showValueLeadingLine = NO ;
    _lineChart.showYLevelLine = YES;
    _lineChart.showYLine = YES;
    
    /* X和Y轴的颜色 默认暗黑色 */
    _lineChart.xAndYLineColor = [UIColor darkGrayColor];
    _lineChart.backgroundColor = [UIColor clearColor];
    /* XY轴的刻度颜色 m */
    _lineChart.xAndYNumberColor = [UIColor whiteColor];
    
    _lineChart.contentFill = YES;
    
    _lineChart.pathCurve = YES;
    
    _lineChart.contentFillColorArr = @[[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0],[UIColor colorWithRed:0.000 green:1 blue:0 alpha:0]];
    [self addSubview:_lineChart];
    [_lineChart showAnimation];
    
    
    UIImageView *imageViewH=[[UIImageView alloc]initWithFrame:CGRectMake(30, 275, 40, 4)];
    imageViewH.image=[UIImage imageNamed:@"tempH"];
    [self addSubview:imageViewH];
    
    
    UILabel *hLab=[[UILabel alloc]initWithFrame:CGRectMake(70, 272,30, 10)];
    hLab.font=[UIFont fontWithName:@"ArialMT" size:13];
    hLab.textColor=[UIColor orangeColor];
    hLab.textAlignment=NSTextAlignmentCenter;
    hLab.text=@"高温";
    [self addSubview:hLab];
    
    
    UIImageView *imageViewL=[[UIImageView alloc]initWithFrame:CGRectMake(105, 275, 40, 4)];
    imageViewL.image=[UIImage imageNamed:@"tempL"];
    [self addSubview:imageViewL];
    
    UILabel *lLab=[[UILabel alloc]initWithFrame:CGRectMake(145, 272,30, 10)];
    lLab.font=[UIFont fontWithName:@"ArialMT" size:13];
    lLab.textColor=[UIColor yellowColor];
    lLab.textAlignment=NSTextAlignmentCenter;
    lLab.text=@"低温";
    [self addSubview:lLab];
    
    for (int i=0; i<7; i++) {
        DateAndWeekday *dawView=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*i, 300, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+20)];
        [dawView drawViewWithkind:@"date" title:weekArray[i] date:dayArray[i] imageName:nil];
       //dawView.backgroundColor=[UIColor yellowColor];
        [self addSubview:dawView];
    }
    
    
    _weatherDay1=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*0, 300+(SCREEN_WIDTH-20)/7.0+20, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+25)];
    [_weatherDay1 drawViewWithkind:@"up" title:@"晴" date:nil imageName:@"d_qing"];
    [self addSubview:_weatherDay1];
    
    _weatherDay2=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*1, 300+(SCREEN_WIDTH-20)/7.0+20, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+25)];
    [_weatherDay2 drawViewWithkind:@"up" title:@"晴" date:nil imageName:@"d_qing"];
    [self addSubview:_weatherDay2];
    
    _weatherDay3=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*2, 300+(SCREEN_WIDTH-20)/7.0+20, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+25)];
    [_weatherDay3 drawViewWithkind:@"up" title:@"晴" date:nil imageName:@"d_qing"];
    [self addSubview:_weatherDay3];
    
    _weatherDay4=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*3, 300+(SCREEN_WIDTH-20)/7.0+20, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+25)];
    [_weatherDay4 drawViewWithkind:@"up" title:@"晴" date:nil imageName:@"d_qing"];
    [self addSubview:_weatherDay4];
    
    _weatherDay5=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*4, 300+(SCREEN_WIDTH-20)/7.0+20, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+25)];
    [_weatherDay5 drawViewWithkind:@"up" title:@"晴" date:nil imageName:@"d_qing"];
    [self addSubview:_weatherDay5];
    
    _weatherDay6=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*5, 300+(SCREEN_WIDTH-20)/7.0+20, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+25)];
    [_weatherDay6 drawViewWithkind:@"up" title:@"晴" date:nil imageName:@"d_qing"];
    [self addSubview:_weatherDay6];
    
    _weatherDay7=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*6, 300+(SCREEN_WIDTH-20)/7.0+20, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+25)];
    [_weatherDay7 drawViewWithkind:@"up" title:@"晴" date:nil imageName:@"d_qing"];
    [self addSubview:_weatherDay7];
    
    

    _weatherNight1=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*0, 300+(SCREEN_WIDTH-20)/7.0*2+40, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+25)];
    [_weatherNight1 drawViewWithkind:@"down" title:@"晴" date:nil imageName:@"n_qing"];
    [self addSubview:_weatherNight1];
    
    _weatherNight2=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*1, 300+(SCREEN_WIDTH-20)/7.0*2+40, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+25)];
    [_weatherNight2 drawViewWithkind:@"down" title:@"晴" date:nil imageName:@"n_qing"];
    [self addSubview:_weatherNight2];
    
    _weatherNight3=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*2, 300+(SCREEN_WIDTH-20)/7.0*2+40, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+25)];
    [_weatherNight3 drawViewWithkind:@"down" title:@"晴" date:nil imageName:@"n_qing"];
    [self addSubview:_weatherNight3];
    
    _weatherNight4=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*3, 300+(SCREEN_WIDTH-20)/7.0*2+40, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+25)];
    [_weatherNight4 drawViewWithkind:@"down" title:@"晴" date:nil imageName:@"n_qing"];
    [self addSubview:_weatherNight4];
    
    _weatherNight5=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*4, 300+(SCREEN_WIDTH-20)/7.0*2+40, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+25)];
    [_weatherNight5 drawViewWithkind:@"down" title:@"晴" date:nil imageName:@"n_qing"];
    [self addSubview:_weatherNight5];
    
    _weatherNight6=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*5,300+(SCREEN_WIDTH-20)/7.0*2+40, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+25)];
    [_weatherNight6 drawViewWithkind:@"down" title:@"晴" date:nil imageName:@"n_qing"];
    [self addSubview:_weatherNight6];
    
    _weatherNight7=[[DateAndWeekday alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/7.0*6, 300+(SCREEN_WIDTH-20)/7.0*2+40, (SCREEN_WIDTH-20)/7.0, (SCREEN_WIDTH-20)/7.0+25)];
    [_weatherNight7 drawViewWithkind:@"down" title:@"晴" date:nil imageName:@"n_qing"];
    [self addSubview:_weatherNight7];
    
}

- (void)updateTemH:(NSArray *)temH temL:(NSArray *)temL weatherDay:(NSArray *)weatherDay weatherNig:(NSArray *)weatherNig imageDay:(NSArray *)imageDay imageNig:(NSArray *)imageNig{
    [_lineChart clear];
    int n=0;
    for (int i=0; i<temH.count; i++) {
        if ([temH[i] doubleValue]<0||[temL[i] doubleValue]<0) {
            n++;
        }
    }
    
    if (n>0) {
        _lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;

    }else{
    
        _lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;

    }

    _lineChart.valueArr = @[temH,temL];
    
    [_lineChart showAnimation];
    
    NSArray *dayWeatherImage=[NSArray arrayWithArray:[self dayWeatherChangeImage:imageDay]];
    
    
   // NSArray *nightWeatherImage=[NSArray arrayWithArray:[self nightWeatherChangeImage:imageNig]];
    NSArray *nightWeatherImage=[NSArray arrayWithArray:[self dayWeatherChangeImage:imageNig]];
    
    [_weatherDay1 updateViewwithTitle:weatherDay[0] imageName:dayWeatherImage[0]];
    [_weatherDay2 updateViewwithTitle:weatherDay[1] imageName:dayWeatherImage[1]];
    [_weatherDay3 updateViewwithTitle:weatherDay[2] imageName:dayWeatherImage[2]];
    [_weatherDay4 updateViewwithTitle:weatherDay[3] imageName:dayWeatherImage[3]];
    [_weatherDay5 updateViewwithTitle:weatherDay[4] imageName:dayWeatherImage[4]];
    [_weatherDay6 updateViewwithTitle:weatherDay[5] imageName:dayWeatherImage[5]];
    [_weatherDay7 updateViewwithTitle:weatherDay[6] imageName:dayWeatherImage[6]];
    [_weatherNight1 updateViewwithTitle:weatherNig[0] imageName:nightWeatherImage[0]];
    [_weatherNight2 updateViewwithTitle:weatherNig[1] imageName:nightWeatherImage[1]];
    [_weatherNight3 updateViewwithTitle:weatherNig[2] imageName:nightWeatherImage[2]];
    [_weatherNight4 updateViewwithTitle:weatherNig[3] imageName:nightWeatherImage[3]];
    [_weatherNight5 updateViewwithTitle:weatherNig[4] imageName:nightWeatherImage[4]];
    [_weatherNight6 updateViewwithTitle:weatherNig[5] imageName:nightWeatherImage[5]];
    [_weatherNight7 updateViewwithTitle:weatherNig[6] imageName:nightWeatherImage[6]];



}
- (NSArray *)dayWeatherChangeImage:(NSArray *)weatherArray{
    NSMutableArray *imageArray=[NSMutableArray new];
    
    for (int i=0; i<weatherArray.count; i++) {
        NSString *dayIconstr;
        NSInteger dayIcon=[weatherArray[i] integerValue];
            if (0==dayIcon){
                dayIconstr=@"d_qing";
            }
            else if (1==dayIcon){
                dayIconstr=@"d_duoyun";
            }
            else if (2==dayIcon){
                dayIconstr=@"d_yin";
                
            }
            else if (3==dayIcon){
                dayIconstr=@"d_zhenyu";
            }
            else if (4==dayIcon){
                dayIconstr=@"d_leizhenyu";
            }
            else if (5==dayIcon){
                dayIconstr=@"d_leizhengyubanyoubingbao";
            }
            else if (6==dayIcon){
                dayIconstr=@"d_yujiaxue";
            }
            else if (7==dayIcon){
                dayIconstr=@"d_xiaoyu";
            }
            else if (8==dayIcon){
                dayIconstr=@"d_zhongyu";
            }
            else if (9==dayIcon){
                dayIconstr=@"d_dayu";
            }
            else if (10==dayIcon){
                dayIconstr=@"d_baoyu";
            }
            else if (11==dayIcon){
                dayIconstr=@"d_dabaoyu";
            }
            else if (12==dayIcon){
                dayIconstr=@"d_tedabaoyu";
            }
            else if (13==dayIcon){
                dayIconstr=@"d_zhenxue";
            }
            else if (14==dayIcon){
                dayIconstr=@"d_xiaoxue";
            }
            else if (15==dayIcon){
                dayIconstr=@"d_zhongxue";
            }
            else if (16==dayIcon){
                dayIconstr=@"d_daxue";
            }
            else if (17==dayIcon){
                dayIconstr=@"d_baoxue";
            }
            else if (18==dayIcon){
                dayIconstr=@"d_wu";
            }
            else if (19==dayIcon){
                dayIconstr=@"d_dongyu";
            }
            else if (20==dayIcon){
                dayIconstr=@"d_shachenbao";
            }
            else if (21==dayIcon){
                dayIconstr=@"d_xiaoyu_zhongyu";
            }
            else if (22==dayIcon){
                dayIconstr=@"d_zhongyu_dayu";
            }
            else if (23==dayIcon){
                dayIconstr=@"d_dayu_baoyu";
            }
            else if (24==dayIcon){
                dayIconstr=@"d_baoyu_dabaoyu";
            }
            else if (25==dayIcon){
                dayIconstr=@"d_dabaoyu_tedabaoyu";
            }
            else if (26==dayIcon){
                dayIconstr=@"d_xiaoxue_zhongxue";
            }
            else if (27==dayIcon){
                dayIconstr=@"d_zhongxue_daxue";
            }
            else if (28==dayIcon){
                dayIconstr=@"d_daxue_baoxue";
            }
            else if (29==dayIcon){
                dayIconstr=@"d_fuchen";
            }
            else if (30==dayIcon){
                dayIconstr=@"d_yangsha";
            }
            else if (31==dayIcon){
                dayIconstr=@"d_qiangshachenbao";
            }
            else if (32==dayIcon){
                dayIconstr=@"d_mai";
            }
        [imageArray addObject: dayIconstr];;
        }
    return imageArray;
}
- (NSArray *)nightWeatherChangeImage:(NSArray *)weatherArray{
    NSMutableArray *imageArray=[NSMutableArray new];
    
    for (int i=0; i<weatherArray.count; i++) {
        NSString *dayIconstr;
        NSInteger dayIcon=[weatherArray[i] integerValue];
        if (0==dayIcon){
            dayIconstr=@"n_qing";
        }
        else if (1==dayIcon){
            dayIconstr=@"n_duoyun";
        }
        else if (2==dayIcon){
            dayIconstr=@"d_yin";
            
        }
        else if (3==dayIcon){
            dayIconstr=@"d_zhenyu";
        }
        else if (4==dayIcon){
            dayIconstr=@"d_leizhenyu";
        }
        else if (5==dayIcon){
            dayIconstr=@"d_leizhengyubanyoubingbao";
        }
        else if (6==dayIcon){
            dayIconstr=@"d_yujiaxue";
        }
        else if (7==dayIcon){
            dayIconstr=@"d_xiaoyu";
        }
        else if (8==dayIcon){
            dayIconstr=@"d_zhongyu";
        }
        else if (9==dayIcon){
            dayIconstr=@"d_dayu";
        }
        else if (10==dayIcon){
            dayIconstr=@"d_baoyu";
        }
        else if (11==dayIcon){
            dayIconstr=@"d_dabaoyu";
        }
        else if (12==dayIcon){
            dayIconstr=@"d_tedabaoyu";
        }
        else if (13==dayIcon){
            dayIconstr=@"d_zhenxue";
        }
        else if (14==dayIcon){
            dayIconstr=@"d_xiaoxue";
        }
        else if (15==dayIcon){
            dayIconstr=@"d_zhongxue";
        }
        else if (16==dayIcon){
            dayIconstr=@"d_daxue";
        }
        else if (17==dayIcon){
            dayIconstr=@"d_baoxue";
        }
        else if (18==dayIcon){
            dayIconstr=@"d_wu";
        }
        else if (19==dayIcon){
            dayIconstr=@"d_dongyu";
        }
        else if (20==dayIcon){
            dayIconstr=@"d_shachenbao";
        }
        else if (21==dayIcon){
            dayIconstr=@"d_xiaoyu_zhongyu";
        }
        else if (22==dayIcon){
            dayIconstr=@"d_zhongyu_dayu";
        }
        else if (23==dayIcon){
            dayIconstr=@"d_dayu_baoyu";
        }
        else if (24==dayIcon){
            dayIconstr=@"d_baoyu_dabaoyu";
        }
        else if (25==dayIcon){
            dayIconstr=@"d_dabaoyu_tedabaoyu";
        }
        else if (26==dayIcon){
            dayIconstr=@"d_xiaoxue_zhongxue";
        }
        else if (27==dayIcon){
            dayIconstr=@"d_zhongxue_daxue";
        }
        else if (28==dayIcon){
            dayIconstr=@"d_daxue_baoxue";
        }
        else if (29==dayIcon){
            dayIconstr=@"d_fuchen";
        }
        else if (30==dayIcon){
            dayIconstr=@"d_yangsha";
        }
        else if (31==dayIcon){
            dayIconstr=@"d_qiangshachenbao";
        }
        else if (32==dayIcon){
            dayIconstr=@"d_mai";
        }
        [imageArray addObject: dayIconstr];;
    }
    return imageArray;
}

- (NSArray *)sevenDays:(NSDate *)nowDate{
    NSMutableArray *dayArray =[NSMutableArray new];
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    for (int i=0; i<7; i++) {
        NSDate* theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*i ];
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSCalendarUnit calenderUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *components = [calendar components:calenderUnit fromDate:theDate];
        [dayArray addObject:[NSString stringWithFormat:@"%ld", components.day]];
    }
    return dayArray;
}
- (NSMutableArray *)sevenWeekDay:(NSDate *)nowDate{
    
    NSMutableArray *dayArray =[NSMutableArray new];
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    //[dateformatter setDateFormat:@"yyy"];
    // NSString *  yearString = [dateformatter stringFromDate:senddate];
    //[dateformatter setDateFormat:@"MM"];
    // NSString *  monthString = [dateformatter stringFromDate:senddate];
    //[dateformatter setDateFormat:@"dd"];
    // NSString *  dayString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"EEE"];
    
    for (int i=0; i<7; i++) {
        NSDate* theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*i ];
        NSString *  weekString = [dateformatter stringFromDate:theDate];
        [dayArray addObject:weekString];
    }
    return dayArray;
}
- (NSArray *)EchangeCHArray:(NSArray *)arrary{
    NSMutableArray *chArray=[NSMutableArray new];
    
    for (int i=0; i<arrary.count; i++) {
        NSString *weekday;
        if ([arrary[i] isEqualToString:@"Mon"]) {
            weekday = @"周一";
            [chArray addObject:weekday];
        } else if ([arrary[i] isEqualToString:@"Tue"]) {
            weekday = @"周二";
            [chArray addObject:weekday];
        } else if ([arrary[i] isEqualToString:@"Wed"]) {
            weekday = @"周三";
            [chArray addObject:weekday];
        } else if ([arrary[i] isEqualToString:@"Thu"]) {
            weekday = @"周四";
            [chArray addObject:weekday];
        } else if ([arrary[i] isEqualToString:@"Fri"]) {
            weekday = @"周五";
            [chArray addObject:weekday];
        } else if ([arrary[i] isEqualToString:@"Sat"]) {
            weekday = @"周六";
            [chArray addObject:weekday];
        } else if ([arrary[i] isEqualToString:@"Sun"]) {
            weekday = @"周天";
            [chArray addObject:weekday];
        }
        
    }
    return chArray;
    
}

@end
