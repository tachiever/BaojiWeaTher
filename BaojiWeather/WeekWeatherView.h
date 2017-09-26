//
//  WeekWeatherView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/25.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconAndLabView.h"
#import "DateAndWeekday.h"
#import "JHChartHeader.h"

@interface WeekWeatherView : UIView
@property (nonatomic) JHLineChart *lineChart;
@property (nonatomic) DateAndWeekday *weatherDay1;
@property (nonatomic) DateAndWeekday *weatherDay2;
@property (nonatomic) DateAndWeekday *weatherDay3;
@property (nonatomic) DateAndWeekday *weatherDay4;
@property (nonatomic) DateAndWeekday *weatherDay5;
@property (nonatomic) DateAndWeekday *weatherDay6;
@property (nonatomic) DateAndWeekday *weatherDay7;
@property (nonatomic) DateAndWeekday *weatherNight1;
@property (nonatomic) DateAndWeekday *weatherNight2;
@property (nonatomic) DateAndWeekday *weatherNight3;
@property (nonatomic) DateAndWeekday *weatherNight4;
@property (nonatomic) DateAndWeekday *weatherNight5;
@property (nonatomic) DateAndWeekday *weatherNight6;
@property (nonatomic) DateAndWeekday *weatherNight7;

- (void)createWeekWeatherWhihTemH:(NSArray *)temH temL:(NSArray *)temL;

- (void)updateTemH:(NSArray *)temH temL:(NSArray *)temL weatherDay:(NSArray *)weatherDay weatherNig:(NSArray *)weatherNig imageDay:(NSArray *)imageDay imageNig:(NSArray *)imageNig;
@end
