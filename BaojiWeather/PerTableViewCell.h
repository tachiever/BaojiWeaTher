//
//  PerTableViewCell.h
//  BaojiWeather
//
//  Created by Tcy on 2017/3/23.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dutyLab;
@property (weak, nonatomic) IBOutlet UILabel *comany;
@property (weak, nonatomic) IBOutlet UIButton *faxbtn;
@property (weak, nonatomic) IBOutlet UIButton *phonebtn;
@property (weak, nonatomic) IBOutlet UILabel *otherLab;


@property (copy,nonatomic) void (^messageAction)();
@property (copy,nonatomic) void (^phoneAction)();
@property (copy,nonatomic) void (^faxAction)();

@end