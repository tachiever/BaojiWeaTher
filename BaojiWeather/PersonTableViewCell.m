//
//  PersonTableViewCell.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/23.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "PersonTableViewCell.h"

@implementation PersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)sendMessage:(UIButton *)sender {
    if(self.messageAction)
    {
        self.messageAction
        ();
    }
}
- (IBAction)makeTell:(id)sender {
    if(self.phoneAction)
    {
        self.phoneAction();
    }
}
- (IBAction)callFax:(id)sender {
    if(self.faxAction)
    {
        self.faxAction();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
