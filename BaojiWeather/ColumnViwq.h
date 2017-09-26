//
//  ColumnViwq.h
//  BaojiWeather
//
//  Created by Tcy on 2017/3/16.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColumnViwq : UIView
@property (nonatomic, assign) CGFloat zerolenth;
@property (nonatomic, assign) CGFloat yPerVal;
@property (nonatomic, assign) CGFloat xwidth;
@property (nonatomic, assign) CGFloat xfont;
@property (nonatomic, assign) CGFloat yValfont;
@property (nonatomic, assign) CGFloat xYLineWidth;
//@property (nonatomic, assign) UIColor *xYlineColor;
- (void)drawZhuZhuangTu:(NSArray *)x_itemArr and:(NSArray *)y_itemArr;
@end
