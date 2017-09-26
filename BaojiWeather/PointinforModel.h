//
//  PointinforModel.h
//  BaojiWeather
//
//  Created by Tcy on 2017/3/21.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointinforModel : NSObject
@property (nonatomic,copy) NSString *distance;
@property (nonatomic,copy) NSString *dpt;
@property (nonatomic,copy) NSString *hours_values;
@property (nonatomic,copy) NSString *pre_12h;
@property (nonatomic,copy) NSString *pre_1h;
@property (nonatomic,copy) NSString *pre_24h;
@property (nonatomic,copy) NSString *pre_3h;
@property (nonatomic,copy) NSString *pre_6h;
@property (nonatomic,copy) NSString *prs_max;
@property (nonatomic,copy) NSString *prs;
@property (nonatomic,copy) NSString *prs_max_otime;
@property (nonatomic,copy) NSString *prs_min;
@property (nonatomic,copy) NSString *prs_min_otime;
@property (nonatomic,copy) NSString *prs_sea;
@property (nonatomic,copy) NSString *rhu;
@property (nonatomic,copy) NSString *rhu_min;
@property (nonatomic,copy) NSString *rhu_min_otime;
@property (nonatomic,copy) NSString *temp;
@property (nonatomic,copy) NSString *temp_max;
@property (nonatomic,copy) NSString *temp_max_otime;
@property (nonatomic,copy) NSString *temp_min;
@property (nonatomic,copy) NSString *temp_min_otime;
@property (nonatomic,copy) NSString *update_time;
@property (nonatomic,copy) NSString *vap;
@property (nonatomic,copy) NSString *win_d_avg_10mi;
@property (nonatomic,copy) NSString *win_d_avg_2mi;
@property (nonatomic,copy) NSString *win_d_inst;
@property (nonatomic,copy) NSString *win_d_inst_max;
@property (nonatomic,copy) NSString *win_d_inst_max_12h;
@property (nonatomic,copy) NSString *win_d_inst_max_6h;
@property (nonatomic,copy) NSString *win_d_s_max;
@property (nonatomic,copy) NSString *win_s_avg_10mi;
@property (nonatomic,copy) NSString *win_s_avg_2mi;
@property (nonatomic,copy) NSString *win_s_inst;
@property (nonatomic,copy) NSString *win_s_inst_max;
@property (nonatomic,copy) NSString *win_s_inst_max_12h;
@property (nonatomic,copy) NSString *win_s_inst_max_6h;
@property (nonatomic,copy) NSString *win_s_inst_max_otime;
@property (nonatomic,copy) NSString *win_s_max;
@property (nonatomic,copy) NSString *win_s_max_otime;
@end
