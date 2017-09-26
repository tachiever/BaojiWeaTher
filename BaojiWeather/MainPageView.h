//
//  MainPageView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/21.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconAndLabView.h"
#import "ScrelloryLab.h"

@interface MainPageView : UIView
@property(nonatomic)NSString *jieqi;
@property(nonatomic)IconAndLabView *rainLab;
@property(nonatomic)IconAndLabView *humLab;
@property(nonatomic)IconAndLabView *windLab;
@property(nonatomic)ScrelloryLab *dateLab;
@property(nonatomic)UILabel *weatherLab;
@property(nonatomic)UILabel *temLab;
@property(nonatomic)UILabel *jieqiLab;
- (void)updateViewdata:(NSDictionary *)dic;

@property (copy,nonatomic) void (^action)();
@property (copy,nonatomic) void (^actionShowWebPage)();

@end
