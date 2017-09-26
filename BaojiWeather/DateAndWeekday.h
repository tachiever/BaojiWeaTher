//
//  DateAndWeekday.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/25.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateAndWeekday : UIView
@property (nonatomic)NSString *kind;
@property (nonatomic)UILabel *weekLab;
@property (nonatomic)UILabel *dateLab;
@property (nonatomic)UILabel *weatherLab;
@property (nonatomic)UIImageView *weatherImage;


- (void)drawViewWithkind:(NSString *)kin title:(NSString *)tit date:(NSString *)date imageName:(NSString *)imageName;
- (void)updateViewwithTitle:(NSString *)tit imageName:(NSString *)imageName;
@end
