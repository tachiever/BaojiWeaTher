//
//  Lifeview.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/27.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Lifeview : UIView
@property (nonatomic)UILabel *titleLab;
@property (nonatomic)UILabel *indexLab;
@property (nonatomic)UIImageView *iconImage;

- (void)drawViewWithImage:(NSString *)image title:(NSString *)title index:(NSString *)index;
- (void)updateStatuesSting:(NSString *)sta;
@end
