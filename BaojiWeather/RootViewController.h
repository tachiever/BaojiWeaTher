//
//  RootViewController.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/15.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainPageViewController;
@class RightViewController;
@class  LeftViewController;
@interface RootViewController : UIViewController

- (id)initWithCenterVC:(MainPageViewController *)centerVC rightVC:(RightViewController *)rightVC leftVC:(LeftViewController *)leftVC;


@end
