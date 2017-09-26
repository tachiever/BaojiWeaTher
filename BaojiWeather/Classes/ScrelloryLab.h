//
//  ScrelloryLab.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/25.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagicLabel.h"

@interface ScrelloryLab : UIView
@property (nonatomic)MagicLabel *lab;
@property (nonatomic)UIImageView *icon;
@property (copy,nonatomic) void (^action)();

- (void)setImage:(UIImage *)image text:(NSString *)text;
- (void)updateText:(NSString *)text;
@end
