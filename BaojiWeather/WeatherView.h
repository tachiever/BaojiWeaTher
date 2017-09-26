//
//  WeatherView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/28.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherView : UIView
@property (nonatomic)UILabel *wearhLabt;
@property (nonatomic)UILabel *tempLabt;
@property (nonatomic)UIImageView *iconImaget;
@property (nonatomic)UILabel *wearhLabn;
@property (nonatomic)UILabel *tempLabn;
@property (nonatomic)UIImageView *iconImagen;

- (void)updateStatuesdic:(NSDictionary *)dic ;

@end
