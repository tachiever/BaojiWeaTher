//
//  DataCoreBase.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/17.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataCoreBase : NSObject





// remove assign object
+(void) remove:(NSManagedObject*)object;

// save
+ (BOOL) save;


@end
