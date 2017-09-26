//
//  LifeIndx.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/27.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconAndLabView.h"
#import "Lifeview.h"

@interface LifeIndx : UIView
@property (nonatomic)    Lifeview *dawView1;
@property (nonatomic)    Lifeview *dawView2;
@property (nonatomic)    Lifeview *dawView3;
@property (nonatomic)    Lifeview *dawView4;
@property (nonatomic)    Lifeview *dawView5;
@property (nonatomic)    Lifeview *dawView6;
@property (nonatomic)    Lifeview *dawView7;
@property (nonatomic)    Lifeview *dawView8;
@property (nonatomic)    Lifeview *dawView9;
@property (nonatomic)    Lifeview *dawView10;
@property (nonatomic)    Lifeview *dawView11;
@property (nonatomic)    Lifeview *dawView12;
- (void)createSHZSView:(NSArray *)staArray;
- (void)updateStatues:(NSArray *)staArray;
@end
