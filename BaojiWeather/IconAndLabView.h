//
//  IconAndLabView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/24.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconAndLabView : UIView

@property (nonatomic)UILabel *lab;
@property (nonatomic)UIImageView *icon;

- (void)setImage:(UIImage *)image text:(NSString *)text;
- (void)updateText:(NSString *)text;
- (void)setTextFont:(CGFloat)font;
@end
