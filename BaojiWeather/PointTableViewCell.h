//
//  PointTableViewCell.h
//  BaojiWeather
//
//  Created by Tcy on 2017/3/15.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *pointLab;
@property (weak, nonatomic) IBOutlet UILabel *aqi;
@property (weak, nonatomic) IBOutlet UILabel *pm2_5;
@property (weak, nonatomic) IBOutlet UILabel *qualityLab;

@end
