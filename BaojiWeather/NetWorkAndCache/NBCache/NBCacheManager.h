//
//  NBCacheManager.h
//  UI_02One
//
//  Created by YuTengxiao on 15/10/5.
//  Copyright (c) 2015年 YuTengxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

// 缓存模块，设计成单例
@interface NBCacheManager : NSObject

+ (instancetype)sharedManager;
// 缓存url接口对应的数据
- (void)cacheData:(NSData *)data forUrl:(NSString *)url;
// 根据url接口，返回缓存的数据
- (NSData *)cacheDataWithUrl:(NSString *)url;
// 文件是否存在
- (BOOL)isFileExistWithUrl:(NSString *)url;
// 判断url对于的缓存数据是否过期 time : 超时时间
- (BOOL)isOutTimeWithUrl:(NSString *)url time:(NSTimeInterval)time;
// 清空缓存
- (void)clearAllCache;

@end
