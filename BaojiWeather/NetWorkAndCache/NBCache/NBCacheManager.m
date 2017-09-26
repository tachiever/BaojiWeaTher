//
//  NBCacheManager.m
//  UI_02One
//
//  Created by YuTengxiao on 15/10/5.
//  Copyright (c) 2015年 YuTengxiao. All rights reserved.
//

#import "NBCacheManager.h"
#import "NSString+Hashing.h"

#define CACHE_DIRECTORY @"OneCache"

@interface NBCacheManager ()
// 文件的完整路径
@property (nonatomic, copy) NSString *path;

@end

@implementation NBCacheManager

+ (instancetype)sharedManager {
    static NBCacheManager *manager = nil;
    if (manager == nil) {
        manager = [[self alloc] init];
    }
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        // 创建缓存文件夹
        [self createCacheDirectory];
    }
    return self;
}

- (void)createCacheDirectory {
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    self.path = [cache stringByAppendingPathComponent:CACHE_DIRECTORY];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = NO;
    [fm fileExistsAtPath:self.path isDirectory:&isExist];
    if (!isExist) {
        [fm createDirectoryAtPath:self.path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

// 内部的私有方法
- (NSString *)fullPathWithUrl:(NSString *)url {
    // 对url进行加密
    url = [url MD5Hash];
    return [self.path stringByAppendingPathComponent:url];
}

- (void)cacheData:(NSData *)data forUrl:(NSString *)url {
    url = [self fullPathWithUrl:url];
    [data writeToFile:url atomically:YES];
}

- (BOOL)isFileExistWithUrl:(NSString *)url {
    url = [self fullPathWithUrl:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:url];
}

- (NSData *)cacheDataWithUrl:(NSString *)url {
    NSData *data = nil;
    if ([self isFileExistWithUrl:url]) {
        url = [self fullPathWithUrl:url];
        data = [[NSData alloc] initWithContentsOfFile:url];
    }
    return data;
}

- (BOOL)isOutTimeWithUrl:(NSString *)url time:(NSTimeInterval)time {
    BOOL isTimeOut = YES; // 默认已经超时
    if ([self isFileExistWithUrl:url]) {
        url  = [url MD5Hash];
        NSString *fullPath = [self.path stringByAppendingPathComponent:url];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSDictionary *attribute = [fm attributesOfItemAtPath:fullPath error:nil];
        // 获取文件的创建日期
        NSDate *date = attribute[NSFileCreationDate];
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
        isTimeOut = interval > time;
    }
    return isTimeOut;
}

- (void)clearAllCache {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:self.path error:nil];
    [self createCacheDirectory];
}

@end
