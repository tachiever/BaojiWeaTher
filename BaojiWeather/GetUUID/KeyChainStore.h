//
//  KeyChainStore.h
//  UUID
//
//  Created by tcy on 16/6/28.
//  Copyright © 2016年 tcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)deleteKeyData:(NSString *)service;



@end
