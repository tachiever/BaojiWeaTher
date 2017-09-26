//
//  DataDefault.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/15.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDefault : NSObject


/**
 * Singleton
 */
+ (instancetype) shareInstance;


/**
 * User
 */
@property(nonatomic) NSString *userPhone;
@property(nonatomic) NSString *appVersion;
@property(nonatomic) NSMutableArray *cityId;

@property(nonatomic) NSMutableArray *airInformArray;
@property(nonatomic) NSMutableArray *rainInformArray;
@property(nonatomic) NSMutableArray *tempInformArray;







@end
