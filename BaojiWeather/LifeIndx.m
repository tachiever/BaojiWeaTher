

//
//  LifeIndx.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/27.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "LifeIndx.h"



@implementation LifeIndx

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        [self setup];
    }
    return self;
}

- (void)setup {
    NSArray *imageArray=@[@"wnl.png",@"zwx.png",@"cy.png",@"ys.png",@"cl.png",@"zs.png",@"ganmao.png",@"yd.png",@"xc.png",@"ls.png",@"yh.png",@"ly.png"];
    NSArray *nameArray=@[@"万年历",@"紫外线强度",@"穿衣指数",@"雨伞",@"晨练指数",@"舒适度",@"感冒指数",@"运动",@"洗车指数",@"晾晒指数",@"约会指数",@"旅游指数"];
    
    IconAndLabView *titLab=[[IconAndLabView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-55,4,110, 30)];
    [titLab setImage:[UIImage imageNamed:@"shzs"] text:@"生活指数"];
    [titLab setTextFont:19];
    [self addSubview:titLab];
    
    _dawView1=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*0, 50+64*0, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView1 drawViewWithImage:imageArray[0] title:nameArray[0] index:[self dataString]];
    _dawView1.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView1];
    
    
    
    _dawView2=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*1, 50+64*0, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView2 drawViewWithImage:imageArray[1] title:nameArray[1] index:nil];
    _dawView2.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView2];
    
    _dawView3=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*0, 50+64*1, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView3 drawViewWithImage:imageArray[2] title:nameArray[2] index:nil];
    _dawView3.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView3];
    
    _dawView4=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*1, 50+64*1, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView4 drawViewWithImage:imageArray[3] title:nameArray[3] index:nil];
    _dawView4.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView4];
    
    _dawView5=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*0, 50+64*2, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView5 drawViewWithImage:imageArray[4] title:nameArray[4] index:nil];
    _dawView5.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView5];
    _dawView6=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*1, 50+64*2, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView6 drawViewWithImage:imageArray[5] title:nameArray[5] index:nil];
    _dawView6.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView6];
    _dawView7=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*0, 50+64*3, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView7 drawViewWithImage:imageArray[6] title:nameArray[6] index:nil];
    _dawView7.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView7];
    _dawView8=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*1, 50+64*3, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView8 drawViewWithImage:imageArray[7] title:nameArray[7] index:nil];
    _dawView8.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView8];
    _dawView9=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*0, 50+64*4, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView9 drawViewWithImage:imageArray[8] title:nameArray[8] index:nil];
    _dawView9.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView9];
    _dawView10=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*1, 50+64*4, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView10 drawViewWithImage:imageArray[9] title:nameArray[9] index:nil];
    _dawView10.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView10];
    _dawView11=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*0, 50+64*5, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView11 drawViewWithImage:imageArray[10] title:nameArray[10] index:nil];
    _dawView11.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView11];
    _dawView12=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*1, 50+64*5, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView12 drawViewWithImage:imageArray[11] title:nameArray[11] index:nil];
    _dawView12.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView12];
    
    for (int i=0; i<7; i++) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(4, 43+64*i, self.frame.size.width-8, 1)];
        lineView.backgroundColor=RGBACOLOR(222, 222, 222, 0.7);
        [self addSubview:lineView];
        
    }
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 43, 1, 64*6)];
    lineView.backgroundColor=RGBACOLOR(222, 222, 222, 0.7);
    [self addSubview:lineView];
    
}

- (void)createSHZSView:(NSArray *)staArray{
    
    NSArray *imageArray=@[@"wnl.png",@"zwx.png",@"cy.png",@"ys.png",@"cl.png",@"zs.png",@"ganmao.png",@"yd.png",@"xc.png",@"ls.png",@"yh.png",@"ly.png"];
    NSArray *nameArray=@[@"万年历",@"紫外线强度",@"穿衣指数",@"雨伞",@"晨练指数",@"舒适度",@"感冒指数",@"运动",@"洗车指数",@"晾晒指数",@"约会指数",@"旅游指数"];
    
    IconAndLabView *titLab=[[IconAndLabView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-55,4,110, 30)];
    [titLab setImage:[UIImage imageNamed:@"shzs"] text:@"生活指数"];
    [titLab setTextFont:19];
    [self addSubview:titLab];
    
    _dawView1=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*0, 50+64*0, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView1 drawViewWithImage:imageArray[0] title:nameArray[0] index:[self dataString]];
    _dawView1.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView1];
    
    
    
    _dawView2=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*1, 50+64*0, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView2 drawViewWithImage:imageArray[1] title:nameArray[1] index:staArray[1]];
    _dawView2.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView2];
    
    _dawView3=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*0, 50+64*1, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView3 drawViewWithImage:imageArray[2] title:nameArray[2] index:staArray[2]];
    _dawView3.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView3];
    
    _dawView4=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*1, 50+64*1, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView4 drawViewWithImage:imageArray[3] title:nameArray[3] index:staArray[3]];
    _dawView4.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView4];
    
    _dawView5=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*0, 50+64*2, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView5 drawViewWithImage:imageArray[4] title:nameArray[4] index:staArray[4]];
    _dawView5.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView5];
    _dawView6=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*1, 50+64*2, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView6 drawViewWithImage:imageArray[5] title:nameArray[5] index:staArray[5]];
    _dawView6.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView6];
    _dawView7=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*0, 50+64*3, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView7 drawViewWithImage:imageArray[6] title:nameArray[6] index:staArray[6]];
    _dawView7.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView7];
    _dawView8=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*1, 50+64*3, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView8 drawViewWithImage:imageArray[7] title:nameArray[7] index:staArray[7]];
    _dawView8.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView8];
    _dawView9=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*0, 50+64*4, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView9 drawViewWithImage:imageArray[8] title:nameArray[8] index:staArray[8]];
    _dawView9.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView9];
    _dawView10=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*1, 50+64*4, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView10 drawViewWithImage:imageArray[9] title:nameArray[9] index:staArray[9]];
    _dawView10.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView10];
    _dawView11=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*0, 50+64*5, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView11 drawViewWithImage:imageArray[10] title:nameArray[10] index:staArray[10]];
    _dawView11.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView11];
    _dawView12=[[Lifeview alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*1, 50+64*5, (SCREEN_WIDTH-20-10)/2, 50.0)];
    [_dawView12 drawViewWithImage:imageArray[11] title:nameArray[11] index:staArray[11]];
    _dawView12.backgroundColor=RGBACOLOR(31, 51, 68, 0.9);
    [self addSubview:_dawView12];
    
    for (int i=0; i<7; i++) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(4, 43+64*i, self.frame.size.width-8, 1)];
        lineView.backgroundColor=RGBACOLOR(222, 222, 222, 0.7);
        [self addSubview:lineView];
        
    }
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 43, 1, 64*6)];
    lineView.backgroundColor=RGBACOLOR(222, 222, 222, 0.7);
    [self addSubview:lineView];


}

- (void)updateStatues:(NSArray *)staArray{
    [_dawView2 updateStatuesSting:staArray[0]];
    [_dawView3 updateStatuesSting:staArray[1]];
    [_dawView4 updateStatuesSting:staArray[2]];
    [_dawView5 updateStatuesSting:staArray[3]];
    [_dawView6 updateStatuesSting:staArray[4]];
    [_dawView7 updateStatuesSting:staArray[5]];
    [_dawView8 updateStatuesSting:staArray[6]];
    [_dawView9 updateStatuesSting:staArray[7]];
    [_dawView10 updateStatuesSting:staArray[8]];
    [_dawView11 updateStatuesSting:staArray[9]];
    [_dawView12 updateStatuesSting:staArray[10]];
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
    
    
    
    //        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    //
    //        NSCalendarUnit calenderUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    //        NSDateComponents *components = [calendar components:calenderUnit fromDate:date];
    //        NSLog(@"Year: %ld", components.year);
    //        NSLog(@"Month: %ld", components.month);
    //        NSLog(@"Day: %ld", components.day);
    //  NSLog(@"Day: %@", localDate);
    //NSLog(@"Day: %@", date);
    
//    NSString *sss=[NSString stringWithFormat:@"%@",date];
//    NSString *ss= [sss substringToIndex:10];
    
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
    NSString *day=[NSString stringWithFormat:@"%@年%@月%@",chineseYear[y],mon,days];
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
            str=@"十二";
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
@end
