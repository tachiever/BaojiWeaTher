//
//  TableHeadView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/27.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableHeadView : UIView
@property (nonatomic) UIView *bgView;
@property (nonatomic) UILabel *infoLab;
@property (nonatomic) UILabel *countLab;
@property (nonatomic) UIImageView *iconBgimage;
@property (nonatomic) UIImageView *iconImageView;
- (void)updateHeaderWithDic:(NSDictionary *)dic;

@property (copy,nonatomic) void (^actionShow)();

@end
