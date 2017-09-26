//
//  MainPageView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/21.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "MainPageView.h"


@implementation MainPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        [self getJieqi];
        [self setup];
        
    }
    return self;
}
- (void)getJieqi{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSCalendarUnit calenderUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:calenderUnit fromDate:date];
    //            NSLog(@"Year: %ld", components.year);
    //            NSLog(@"Month: %ld", components.month);
    //            NSLog(@"Day: %ld", components.day);
    
    
    _jieqi=[NSString stringWithFormat:@"%@",[self getLunarSpecialDate:components.year Month:components.month Day:components.day]];
    //NSLog(@"-----%@-----",[self getLunarSpecialDate:components.year Month:components.month Day:components.day]);
    NSLog(@"-----%@-----",_jieqi);
}
- (void)setup {
    CGFloat f1,f2,f3,w,w1,w2;
    f1=SCREEN_HEIGHT>600 ?24:22;
    f2=SCREEN_HEIGHT>600 ?35:32;
    f3=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?70:68):55;
    w=SCREEN_HEIGHT>600 ?30.0:33.0;
    w1=SCREEN_HEIGHT>600 ?125.0:115.0;
    w2=SCREEN_HEIGHT>600 ?116.0:100.0;
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 130, 35)];
    lab.text=@"当前天气";
    lab.textColor=[UIColor whiteColor];
    lab.font=[UIFont systemFontOfSize:f1];
    [self addSubview:lab];
    
    _weatherLab=[[UILabel alloc]initWithFrame:CGRectMake(14, 35, 130, 55)];
    _weatherLab.text=@"";
    _weatherLab.textColor=[UIColor whiteColor];
    _weatherLab.font=[UIFont systemFontOfSize:f2];
    [self addSubview:_weatherLab];
    
    _temLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 90, 180, 80)];
    _temLab.text=@"℃";
    _temLab.textColor=[UIColor whiteColor];
    _temLab.font=[UIFont fontWithName:@"GeezaPro" size:f3];
    [self addSubview:_temLab];
    
    
    _jieqiLab=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-w+3,self.frame.size.height-30 ,35, 25)];
    _jieqiLab.text=_jieqi;
    _jieqiLab.textColor=[UIColor whiteColor];
    _jieqiLab.font=[UIFont fontWithName:@"GeezaPro" size:16];
    [self addSubview:_jieqiLab];
    _jieqiLab.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturer)];
    tapGesture.numberOfTapsRequired = 1;
    [_jieqiLab addGestureRecognizer:tapGesture];
    
    
    _jieqiLab.hidden=YES;

    
    if (![_jieqi isEqualToString:@""]){
        
       _jieqiLab.hidden=NO;

        
        _dateLab=[[ScrelloryLab alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-w+40,self.frame.size.height-30 , self.frame.size.width/2.0-15, 25)];


    }else{
    
    
        _dateLab=[[ScrelloryLab alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-w,self.frame.size.height-30 , self.frame.size.width/2.0+20, 25)];

    }

    [_dateLab setImage:[UIImage imageNamed:@"sk_calendy"] text:[NSString stringWithFormat:@"%@(点击查看日历)",[self dataString]]];
    [self addSubview:_dateLab];
    
    
    
    __block MainPageView *  blockSelf = self;

    [_dateLab setAction:^( ) {
        [self touchLab];
    }];
    
    _windLab=[[IconAndLabView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-w,self.frame.size.height-60 , self.frame.size.width/2.0+10, 25)];
    [_windLab setImage:[UIImage imageNamed:@"sk_wind"] text:@"风:"];
    [self addSubview:_windLab];
    
    _rainLab=[[IconAndLabView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-w,self.frame.size.height-90 ,w1, 25)];
    [_rainLab setImage:[UIImage imageNamed:@"sk_rain"] text:@"降水:"];
    [self addSubview:_rainLab];
    
    
    _humLab=[[IconAndLabView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-w+w2,self.frame.size.height-90 , self.frame.size.width/2.0+10, 25)];
    [_humLab setImage:[UIImage imageNamed:@"sk_temp"] text:@"湿度:"];
    [self addSubview:_humLab];
    
    
}
- (void)tapGesturer{
    NSLog(@"slslsl");
    
    NSString *st=[NSString stringWithFormat:baikeUrl,_jieqi];
    st = [st  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    

    NSURL *url=[NSURL URLWithString:st];
    NSLog(@"%@",url);

    [[UIApplication sharedApplication] openURL:url];
}

- (void)updateViewdata:(NSDictionary *)dic{
    [_weatherLab setText:dic[@"weather"]];
    [_temLab setText:dic[@"tem"]];;
    [_windLab updateText:[NSString stringWithFormat:@"风:%@风 %@ %@m/s",[self windDirection:dic[@"wind_direction"]],[self windSpeed:dic[@"wind_lv"]],dic[@"wind_lv"]]];
    [_humLab updateText:[NSString stringWithFormat:@"湿度:%@",dic[@"hum"]]];
    [_rainLab updateText:[NSString stringWithFormat:@"降水:%@",dic[@"rain"]]];
    [_dateLab updateText:[NSString stringWithFormat:@"%@(点击查看日历)",[self dataString]]];
}

- (NSString *)windSpeed:(NSString *)dic{
    NSString *jb;
    NSInteger val=[dic integerValue];
    if (0.0 <= val && val <= 0.2) {
        jb = @"0级";
    } else if (0.3 <= val && val <= 1.5) {
        jb = @"1级";
    } else if (1.6 <= val && val <= 3.3) {
        jb = @"2级";
    } else if (3.4 <= val && val <= 5.4) {
        jb = @"3级";
    } else if (5.5 <= val && val <= 7.9) {
        jb = @"4级";
    } else if (8.0 <= val && val <= 10.7) {
        jb = @"5级";
    } else if (10.8 <= val && val <= 13.8) {
        jb = @"6级";
    } else if (13.9 <= val && val <= 17.1) {
        jb = @"7级";
    } else if (17.2 <= val && val <= 17.2) {
        jb = @"8级";
    } else if (20.8 <= val && val <= 24.4) {
        jb = @"9级";
    } else if (24.5<= val && val <= 28.4) {
        jb = @"10级";
    } else if (28.5<= val && val <= 32.6) {
        jb = @"11级";
    } else if (32.7<= val && val <= 36.9) {
        jb = @"12级";
    } else if (37.0 <= val && val <= 41.4) {
        jb = @"13级";
    } else if (41.5 <= val && val <= 46.1) {
        jb = @"14级";
    } else if (46.2 <= val && val <= 50.9) {
        jb = @"15级";
    } else if (51.0 <= val && val <= 56.0) {
        jb = @"16级";
    }else if (56.1<= val && val <= 61.2) {
        jb = @"17级";
    }else if(val>=61.3){
        jb = @"18级";
    }
    
    return jb;


}
- (NSString *)windDirection:(NSString *)dic{
    
	   NSString *WindDirection;
    NSInteger val=[dic integerValue];
	   if (0 == val) {
           WindDirection = @"北";
           //		   img_id=R.drawable.trend_wind_1;
       } else if (0 < val && val < 90) {
           WindDirection = @"东北";
           //	    	img_id=R.drawable.trend_wind_2;
       }  else if (90 == val) {
           WindDirection = @"东";
           //	    	img_id=R.drawable.trend_wind_3;
       } else if (90 < val && val <180) {
           WindDirection = @"东南";
           //	    	img_id=R.drawable.trend_wind_4;
       } else if (180 == val) {
           WindDirection = @"南";
           //	    	img_id=R.drawable.trend_wind_5;
       } else if (180 < val && val <270) {
           WindDirection = @"西南";
           //	    	img_id=R.drawable.trend_wind_6;
       } else if (270 == val) {
           WindDirection = @"西";
           //	    	img_id=R.drawable.trend_wind_7;
       } else if (270 < val && val <359.9) {
           WindDirection = @"西北";
           //	    	img_id=R.drawable.trend_wind_8;
       }  else {
           WindDirection = @"静";
           //	    	img_id=R.drawable.main_icon_wind_no;
       }
    return WindDirection;
}

- (NSString *)dataString{
    NSArray *chineseYear = @[@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪"];
    
    NSDate *date = [NSDate date];
    
    
//    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
//    
//    //计算世界时间与本地时区的时间偏差值
//    NSInteger offset = [localTimeZone secondsFromGMTForDate:date];
//    
//    //世界时间＋偏差值 得出中国区时间
//    NSDate *localDate = [date dateByAddingTimeInterval:offset];
    
    
    
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
            NSCalendarUnit calenderUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
            NSDateComponents *components = [calendar components:calenderUnit fromDate:date];
//            NSLog(@"Year: %ld", components.year);
//            NSLog(@"Month: %ld", components.month);
//            NSLog(@"Day: %ld", components.day);
    
    
   // NSLog(@"-----%@-----",[self getLunarSpecialDate:components.year Month:components.month Day:components.day]);
    
    
    
  //  NSLog(@"Day: %@", localDate);
    //NSLog(@"Day: %@", date);
    
    NSString *sss=[NSString stringWithFormat:@"%@",date];
    NSString *ss= [sss substringToIndex:10];
    
    NSCalendar *calendarChinese = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSCalendarUnit calenderUnitChinese = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *componentsChinese = [calendarChinese components:calenderUnitChinese fromDate:date];
//    NSLog(@"Year: %ld", componentsChinese.year);
//    NSLog(@"Month: %ld", componentsChinese.month);
//    NSLog(@"Day: %ld", componentsChinese.day);
//    NSLog(@"Day: %@", date);
    
    
    NSString *mon=[NSString stringWithFormat:@"%@",[self monToString:componentsChinese.month]];
    NSString *days=[NSString stringWithFormat:@"%@",[self dayToString:componentsChinese.day]];
    NSInteger y=(componentsChinese.year -1)%chineseYear.count;
    NSString *day=[NSString stringWithFormat:@"今天是公历%@农历%@年%@月%@",ss,chineseYear[y],mon,days];
    
    return day;
    
}
- (NSString *)monToString:(NSInteger )num{
    NSString *str;
    switch (num) {
        case 1:
            str=@"一";
            break;
        case 2:
            str=@"二";
            break;
        case 3:
            str=@"三";
            break;
        case 4:
            str=@"四";
            break;
        case 5:
            str=@"五";
            break;
        case 6:
            str=@"六";
            break;
        case 7:
            str=@"七";
            break;
        case 8:
            str=@"八";
            break;
        case 9:
            str=@"九";
            break;
        case 10:
            str=@"十";
            break;
        case 11:
            str=@"十一";
            break;
        case 12:
            str=@"腊";
            break;
        default:
            NSLog(@"错误");
            break;
    }
    return str;
}
- (NSString *)dayToString:(NSInteger )num{
    NSString *str;
    switch (num) {
        case 1:
            str=@"初一";
            break;
        case 2:
            str=@"初二";
            break;
        case 3:
            str=@"初三";
            break;
        case 4:
            str=@"初四";
            break;
        case 5:
            str=@"初五";
            break;
        case 6:
            str=@"初六";
            break;
        case 7:
            str=@"初七";
            break;
        case 8:
            str=@"初八";
            break;
        case 9:
            str=@"初九";
            break;
        case 10:
            str=@"初十";
            break;
        case 11:
            str=@"十一";
            break;
        case 12:
            str=@"十二";
            break;
        case 13:
            str=@"十三";
            break;
        case 14:
            str=@"十四";
            break;
        case 15:
            str=@"十五";
            break;
        case 16:
            str=@"十六";
            break;
        case 17:
            str=@"十七";
            break;
        case 18:
            str=@"十八";
            break;
        case 19:
            str=@"十九";
            break;
        case 20:
            str=@"二十";
            break;
        case 21:
            str=@"廿一";
            break;
        case 22:
            str=@"廿二";
            break;
        case 23:
            str=@"廿三";
            break;
        case 24:
            str=@"廿四";
            break;
        case 25:
            str=@"廿五";
            break;
        case 26:
            str=@"廿六";
            break;
        case 27:
            str=@"廿七";
            break;
        case 28:
            str=@"廿八";
            break;
        case 29:
            str=@"廿九";
            break;
        case 30:
            str=@"三十";
            break;
        case 31:
            str=@"三十一";
            break;
        default:
            NSLog(@"错误");
            break;
    }
    return str;
}




//24节气只有(1901 - 2050)之间为准确的节气
const  int START_YEAR =1901;
const  int END_YEAR   =2050;

static int32_t gLunarHolDay[]=
{
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1901
    0X96,0XA4, 0X96,0X96, 0X97,0X87, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1902
    0X96,0XA5, 0X87,0X96, 0X87,0X87, 0X79,0X69, 0X69,0X69, 0X78,0X78,   //1903
    0X86,0XA5, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X78,0X87,   //1904
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1905
    0X96,0XA4, 0X96,0X96, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1906
    0X96,0XA5, 0X87,0X96, 0X87,0X87, 0X79,0X69, 0X69,0X69, 0X78,0X78,   //1907
    0X86,0XA5, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1908
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1909
    0X96,0XA4, 0X96,0X96, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1910
    0X96,0XA5, 0X87,0X96, 0X87,0X87, 0X79,0X69, 0X69,0X69, 0X78,0X78,   //1911
    0X86,0XA5, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1912
    0X95,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1913
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1914
    0X96,0XA5, 0X97,0X96, 0X97,0X87, 0X79,0X79, 0X69,0X69, 0X78,0X78,   //1915
    0X96,0XA5, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1916
    0X95,0XB4, 0X96,0XA6, 0X96,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X87,   //1917
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X77,   //1918
    0X96,0XA5, 0X97,0X96, 0X97,0X87, 0X79,0X79, 0X69,0X69, 0X78,0X78,   //1919
    0X96,0XA5, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1920
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X87,   //1921
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X77,   //1922
    0X96,0XA4, 0X96,0X96, 0X97,0X87, 0X79,0X79, 0X69,0X69, 0X78,0X78,   //1923
    0X96,0XA5, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1924
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X87,   //1925
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1926
    0X96,0XA4, 0X96,0X96, 0X97,0X87, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1927
    0X96,0XA5, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1928
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1929
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1930
    0X96,0XA4, 0X96,0X96, 0X97,0X87, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1931
    0X96,0XA5, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1932
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1933
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1934
    0X96,0XA4, 0X96,0X96, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1935
    0X96,0XA5, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1936
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1937
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1938
    0X96,0XA4, 0X96,0X96, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1939
    0X96,0XA5, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1940
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1941
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1942
    0X96,0XA4, 0X96,0X96, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1943
    0X96,0XA5, 0X96,0XA5, 0XA6,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1944
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1945
    0X95,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X77,   //1946
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1947
    0X96,0XA5, 0XA6,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //1948
    0XA5,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X79, 0X78,0X79, 0X77,0X87,   //1949
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X77,   //1950
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1951
    0X96,0XA5, 0XA6,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //1952
    0XA5,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1953
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X78,0X79, 0X78,0X68, 0X78,0X87,   //1954
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1955
    0X96,0XA5, 0XA5,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //1956
    0XA5,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1957
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1958
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1959
    0X96,0XA4, 0XA5,0XA5, 0XA6,0X96, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1960
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1961
    0X96,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1962
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1963
    0X96,0XA4, 0XA5,0XA5, 0XA6,0X96, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1964
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1965
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1966
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1967
    0X96,0XA4, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1968
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1969
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1970
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1971
    0X96,0XA4, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1972
    0XA5,0XB5, 0X96,0XA5, 0XA6,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1973
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1974
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X77,   //1975
    0X96,0XA4, 0XA5,0XB5, 0XA6,0XA6, 0X88,0X89, 0X88,0X78, 0X87,0X87,   //1976
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //1977
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X78,0X87,   //1978
    0X96,0XB4, 0X96,0XA6, 0X96,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X77,   //1979
    0X96,0XA4, 0XA5,0XB5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1980
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X77,0X87,   //1981
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1982
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X77,   //1983
    0X96,0XB4, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X87,   //1984
    0XA5,0XB4, 0XA6,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //1985
    0XA5,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1986
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X79, 0X78,0X69, 0X78,0X87,   //1987
    0X96,0XB4, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //1988
    0XA5,0XB4, 0XA5,0XA5, 0XA6,0X96, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1989
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1990
    0X95,0XB4, 0X96,0XA5, 0X86,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1991
    0X96,0XB4, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //1992
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0X96, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1993
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1994
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X76, 0X78,0X69, 0X78,0X87,   //1995
    0X96,0XB4, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //1996
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1997
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1998
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1999
    0X96,0XB4, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //2000
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2001
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //2002
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //2003
    0X96,0XB4, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //2004
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2005
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2006
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //2007
    0X96,0XB4, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X87,0X78, 0X87,0X86,   //2008
    0XA5,0XB3, 0XA5,0XB5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2009
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2010
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X78,0X87,   //2011
    0X96,0XB4, 0XA5,0XB5, 0XA5,0XA6, 0X87,0X88, 0X87,0X78, 0X87,0X86,   //2012
    0XA5,0XB3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X87,   //2013
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2014
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //2015
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X87,0X88, 0X87,0X78, 0X87,0X86,   //2016
    0XA5,0XC3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X87,   //2017
    0XA5,0XB4, 0XA6,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2018
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //2019
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X97,0X87, 0X87,0X78, 0X87,0X86,   //2020
    0XA5,0XC3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //2021
    0XA5,0XB4, 0XA5,0XA5, 0XA6,0X96, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2022
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //2023
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X97,0X87, 0X87,0X78, 0X87,0X96,   //2024
    0XA5,0XC3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //2025
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2026
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //2027
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X97,0X87, 0X87,0X78, 0X87,0X96,   //2028
    0XA5,0XC3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //2029
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2030
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //2031
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X97,0X87, 0X87,0X78, 0X87,0X96,   //2032
    0XA5,0XC3, 0XA5,0XB5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X86,   //2033
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X78, 0X88,0X78, 0X87,0X87,   //2034
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2035
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X97,0X87, 0X87,0X78, 0X87,0X96,   //2036
    0XA5,0XC3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //2037
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2038
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2039
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X97,0X87, 0X87,0X78, 0X87,0X96,   //2040
    0XA5,0XC3, 0XA5,0XB5, 0XA5,0XA6, 0X87,0X88, 0X87,0X78, 0X87,0X86,   //2041
    0XA5,0XB3, 0XA5,0XB5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2042
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2043
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X97,0X87, 0X87,0X88, 0X87,0X96,   //2044
    0XA5,0XC3, 0XA5,0XB4, 0XA5,0XA6, 0X87,0X88, 0X87,0X78, 0X87,0X86,   //2045
    0XA5,0XB3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X87,   //2046
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2047
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA5, 0X97,0X87, 0X87,0X88, 0X86,0X96,   //2048
    0XA4,0XC3, 0XA5,0XA5, 0XA5,0XA6, 0X97,0X87, 0X87,0X78, 0X87,0X86,   //2049
    0XA5,0XC3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X78,0X78, 0X87,0X87    //2050
    
};
-(NSString *)getLunarSpecialDate:(NSInteger)iYear Month:(NSInteger)iMonth  Day:(NSInteger)iDay  {
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"小寒",@"大寒",@"立春",@"雨水",@"惊蛰",@"春分",
                          
                          @"清明",@"谷雨",@"立夏",@"小满",@"芒种",@"夏至",
                          
                          @"小暑",@"大暑",@"立秋",@"处暑",@"白露",@"秋分",
                          
                          @"寒露",@"霜降",@"立冬",@"小雪",@"大雪",@"冬至",nil];
    
    
    long array_index = (iYear -START_YEAR)*12+iMonth -1 ;
    
    
    int64_t flag =gLunarHolDay[array_index];
    int64_t day;
    
    if(iDay <15)
        day= 15 - ((flag>>4)&0x0f);
    else
        day = ((flag)&0x0f)+15;
    
    long index = -1;
    
    if(iDay == day){
        index = (iMonth-1) *2 + (iDay>15?1: 0);
    }
    
    if ( index >=0  && index < [chineseDays count] ) {
        [chineseDays objectAtIndex:index];
        NSLog(@"%@",chineseDays[index]);
       // _day = chineseDays[index];
        return chineseDays[index];
        
        
    } else {
        return @"";
    }
    
}
- (void)touchLab{
    if(self.action)
    {
        self.action();
    }
}



@end
