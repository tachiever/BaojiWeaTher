//
//  DateAndWeekday.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/25.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "DateAndWeekday.h"

@implementation DateAndWeekday


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
    }
    return self;
}

- (void)setup {
    CGFloat f,f1,w;
    f1=SCREEN_HEIGHT>600 ?20:18;
    f=SCREEN_HEIGHT>600?22:15;
    w=SCREEN_HEIGHT>600?20:15;
    
    if ([_kind isEqualToString:@"date"]) {
        _weekLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, 20)];
        _weekLab.font=[UIFont fontWithName:@"ArialMT" size:f];
        _weekLab.textColor=[UIColor whiteColor];
        _weekLab.textAlignment=NSTextAlignmentCenter;
        _weekLab.text=@"今天";
        [self addSubview:_weekLab];
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(w/2, 88, self.frame.size.width-w, self.frame.size.width-w)];
        bgView.backgroundColor=[UIColor whiteColor];
        bgView.layer.masksToBounds=YES;
        bgView.layer.cornerRadius=(self.frame.size.width-w)/2;
        [self addSubview:bgView];
        
        _dateLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width-16, 30)];
        _dateLab.center=bgView.center;
        _dateLab.font=[UIFont fontWithName:@"ArialMT" size:f1];
        _dateLab.textColor=[UIColor blackColor];
        _dateLab.text=@"22";
        _dateLab.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_dateLab];
    }
    if ([_kind isEqualToString:@"up"]) {
        _weatherLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 3,self.frame.size.width, 20)];
        _weatherLab.font=[UIFont fontWithName:@"ArialMT" size:f];
        _weatherLab.textColor=[UIColor whiteColor];
        _weatherLab.textAlignment=NSTextAlignmentCenter;
        _weatherLab.text=@"今天";
        [self addSubview:_weatherLab];
        
        _weatherImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 28, self.frame.size.width-20, self.frame.size.width-20)];
        _weatherImage.backgroundColor=[UIColor whiteColor];
        [self addSubview:_weatherImage];
        
    }
    if ([_kind isEqualToString:@"down"]) {
        _weatherLab=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-20,self.frame.size.width, 20)];
        _weatherLab.font=[UIFont fontWithName:@"ArialMT" size:f];
        _weatherLab.textColor=[UIColor whiteColor];
        _weatherLab.textAlignment=NSTextAlignmentCenter;
        _weatherLab.text=@"今天";
        [self addSubview:_weatherLab];
        
        _weatherImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.width-20)];
        _weatherImage.backgroundColor=[UIColor whiteColor];
        [self addSubview:_weatherImage];
    }

}

- (void)drawViewWithkind:(NSString *)kin title:(NSString *)tit date:(NSString *)date imageName:(NSString *)imageName{

    CGFloat f,f1,f2,w1,w2;
    f2=SCREEN_HEIGHT>600 ?18:16;
    f1=SCREEN_HEIGHT>600 ?18:16;
    f=SCREEN_HEIGHT>600?16:14;
    w1=SCREEN_HEIGHT>600?18:14;
    w2=SCREEN_HEIGHT>600?14:10;
    

    if ([kin isEqualToString:@"date"]) {
        _weekLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 3,self.frame.size.width, 20)];
        _weekLab.font=[UIFont fontWithName:@"ArialMT" size:f2];
        _weekLab.textColor=[UIColor whiteColor];
        _weekLab.textAlignment=NSTextAlignmentCenter;
        _weekLab.text=tit;
        [self addSubview:_weekLab];
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(w1/2, 30, self.frame.size.width-w1, self.frame.size.width-w1)];
        bgView.backgroundColor=[UIColor whiteColor];
        bgView.layer.masksToBounds=YES;
        bgView.layer.cornerRadius=(self.frame.size.width-w1)/2;
        [self addSubview:bgView];
        
        _dateLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, 30)];
        _dateLab.center=bgView.center;
        _dateLab.font=[UIFont fontWithName:@"ArialMT" size:f1];
        _dateLab.textColor=[UIColor blackColor];
        _dateLab.text=date;
        _dateLab.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_dateLab];
    }
    if ([kin isEqualToString:@"up"]) {
        _weatherLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 3,self.frame.size.width, 20)];
        _weatherLab.font=[UIFont fontWithName:@"ArialMT" size:f];
        _weatherLab.textColor=[UIColor whiteColor];
        _weatherLab.textAlignment=NSTextAlignmentCenter;
        _weatherLab.text=tit;
        [self addSubview:_weatherLab];
        
        _weatherImage=[[UIImageView alloc]initWithFrame:CGRectMake(w2/2, 33, self.frame.size.width-w2, self.frame.size.width-w2)];
        [_weatherImage setImage:[UIImage imageNamed:imageName]];
        [self addSubview:_weatherImage];
        
    }
    if ([kin isEqualToString:@"down"]) {
        _weatherImage=[[UIImageView alloc]initWithFrame:CGRectMake(w2/2, 3, self.frame.size.width-w2, self.frame.size.width-w2)];
        [_weatherImage setImage:[UIImage imageNamed:imageName]];
        [self addSubview:_weatherImage];
        
        _weatherLab=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.width-w2+13,self.frame.size.width, 20)];
        _weatherLab.font=[UIFont fontWithName:@"ArialMT" size:f];
        _weatherLab.textColor=[UIColor whiteColor];
        _weatherLab.textAlignment=NSTextAlignmentCenter;
        _weatherLab.text=tit;
        [self addSubview:_weatherLab];
    }
}

- (void)updateViewwithTitle:(NSString *)tit imageName:(NSString *)imageName {
    
    _weatherLab.text=tit;
    [_weatherImage setImage:[UIImage imageNamed:imageName]];

}


@end
