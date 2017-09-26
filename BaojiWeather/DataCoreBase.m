//
//  DataCoreBase.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/17.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "DataCoreBase.h"
#import "AppDelegate.h"

#ifdef IHDEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

@implementation DataCoreBase

+(AppDelegate*) app
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

+(NSManagedObjectContext*) context
{
    return [[self app] managedObjectContext];
}









// remove assign object
+(void) remove:(NSManagedObject*)object
{
    [[self context] deleteObject:object];
}

// Save
+ (BOOL) save {
    NSError *error = nil;
    if ([[self context] save:&error]) {
        DLog(@"save CoreData successfully");
        return YES;
    }
    else {
        DLog(@"save CoreData error:%@,%@", error, [error userInfo]);
        return NO;
    }
    
}

@end
