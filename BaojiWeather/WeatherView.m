//
//  WeatherView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/28.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "WeatherView.h"

@implementation WeatherView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        
        [self setup];
        
    }
    return self;
}

- (void)setup {
    CGFloat f1;
    f1=SCREEN_HEIGHT>600 ?18:16;
    
    _iconImaget=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-8-45, self.frame.size.height-8-45, 45,45)];
     [_iconImaget setImage:[UIImage imageNamed:@"d_qing"]];
    [self addSubview:_iconImaget];
    
    _iconImagen=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-8-45, self.frame.size.height-8-45, 45,45)];
     [_iconImagen setImage:[UIImage imageNamed:@"d_qing"]];
    [self addSubview:_iconImagen];
    
    
    UILabel *dayLab=[[UILabel alloc]initWithFrame:CGRectMake(8, 13, 46, 26)];
    dayLab.font=[UIFont fontWithName:@"ArialMT" size:f1];
    dayLab.textColor=[UIColor whiteColor];
    dayLab.textAlignment=NSTextAlignmentLeft;
    dayLab.text=@"今天";
    [self addSubview:dayLab];
    
    _wearhLabt=[[UILabel alloc]initWithFrame:CGRectMake(8,self.frame.size.height-8-26,120, 26)];
    _wearhLabt.font=[UIFont fontWithName:@"ArialMT" size:f1];
    _wearhLabt.textColor=[UIColor whiteColor];
    _wearhLabt.textAlignment=NSTextAlignmentLeft;
    _wearhLabt.text=@"晴转多云";
    [self addSubview:_wearhLabt];
    
    _tempLabt=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-8-120, 13,120, 26)];
    _tempLabt.font=[UIFont fontWithName:@"ArialMT" size:f1];
    _tempLabt.textColor=RGBACOLOR(242, 242, 242, 0.9);
    _tempLabt.textAlignment=NSTextAlignmentRight;
    _tempLabt.text=@"晴转多云";

    [self addSubview:_tempLabt];
    
    UILabel *dayLabn=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2+8, 13, 46, 26)];
    dayLabn.font=[UIFont fontWithName:@"ArialMT" size:f1];
    dayLabn.textColor=[UIColor whiteColor];
    dayLabn.textAlignment=NSTextAlignmentLeft;
    dayLabn.text=@"明天";
    [self addSubview:dayLabn];
    
    _wearhLabn=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2+8,self.frame.size.height-8-26,120, 26)];
    _wearhLabn.font=[UIFont fontWithName:@"ArialMT" size:f1];
    _wearhLabn.textColor=[UIColor whiteColor];
    _wearhLabn.textAlignment=NSTextAlignmentLeft;
    _wearhLabn.text=@"晴转多云";

    [self addSubview:_wearhLabn];
    
    _tempLabn=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-8-120, 13,120, 26)];
    _tempLabn.font=[UIFont fontWithName:@"ArialMT" size:f1];
    _tempLabn.textColor=RGBACOLOR(242, 242, 242, 0.9);
    _tempLabn.textAlignment=NSTextAlignmentRight;
    _tempLabn.text=@"晴转多云";

    [self addSubview:_tempLabn];
    
    for (int i=0; i<2; i++) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,self.frame.size.height*i, self.frame.size.width, 1)];
        lineView.backgroundColor=RGBACOLOR(222, 222, 222, 0.7);
        [self addSubview:lineView];
        
    }
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2,0, 1, self.frame.size.height)];
    lineView.backgroundColor=RGBACOLOR(222, 222, 222, 0.7);
    [self addSubview:lineView];
}
- (void)updateStatuesdic:(NSDictionary *)dic{
    _wearhLabt.text=dic[@"weather_tod"];
    _tempLabt.text=dic[@"tem_tod"];
    _wearhLabn.text=dic[@"weather_tom"];
    _tempLabn.text=dic[@"tem_tom"];
    
    
    [_iconImaget setImage:[UIImage imageNamed:[self dayWeatherChangeImage:dic[@"weatherIamgeD"]]]];
    [_iconImagen setImage:[UIImage imageNamed:[self dayWeatherChangeImage:dic[@"weatherIamgeT"]]]];
    

}

- (NSString *)dayWeatherChangeImage:(NSString *)weather{
    
        NSString *dayIconstr;
        NSInteger dayIcon=[weather integerValue];
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
  
    return dayIconstr;
}
@end
