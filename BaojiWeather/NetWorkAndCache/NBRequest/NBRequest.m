//
//  NBRequest.m
//  UI_爱新闻
//
//  Created by YuTengxiao on 15/10/11.
//  Copyright (c) 2015年 YuTengxiao. All rights reserved.
//

#import "NBRequest.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "NBCacheManager.h"

/*
 1. 如果没有网络连接， 直接从缓存读取数据
 2. 如果是3G连接， 先从缓存，超时时间2个小时
 3. 如果是WiFi，先从缓存，超时时间3分钟
 4. 如果是下拉刷新，直接从网络请求数据
 */

@implementation NBRequest
+ (void)requestWithURL:(NSString *)url type:(NBRequestType)type success:(void (^)(NSData *data))success failed:(void (^)(NSError *error))failed {
    // 请求数据的时候，显示进度
    //[SVProgressHUD showSuccessWithStatus:@"正在上传数据，请稍后！"];
    
    NBCacheManager *cacheManager = [NBCacheManager sharedManager];
    if (((NetWorkStatus == AFNetworkReachabilityStatusNotReachable && [cacheManager isFileExistWithUrl:url]) ||
         (NetWorkStatus == AFNetworkReachabilityStatusReachableViaWWAN && [cacheManager isFileExistWithUrl:url] && [cacheManager isOutTimeWithUrl:url time:30*60] == NO) || (NetWorkStatus == AFNetworkReachabilityStatusReachableViaWiFi && [cacheManager isFileExistWithUrl:url] && [cacheManager isOutTimeWithUrl:url time:3*60] == NO))  && (type != RequestRefresh)) {
        // 读取缓存
        // NSLog(@"从缓存去读");
        NSData *data = [cacheManager cacheDataWithUrl:url];
        if (success) {
            success(data);
        }
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 写入进缓存
        [cacheManager cacheData:responseObject forUrl:url];
        
        if (success) {
            success(responseObject);
        }
    //    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failed) {
            failed(error);
        }
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        
    }];
}


+ (void)postWithURL:(NSString *)url type:(NBRequestType)type dic:(NSMutableDictionary *)dic success:(void (^)(NSData *data))success failed:(void (^)(NSError *error))failed {
    // 请求数据的时候，显示进度
    //[SVProgressHUD showSuccessWithStatus:@"正在上传数据，请稍后！"];
    
    NBCacheManager *cacheManager = [NBCacheManager sharedManager];
    if (((NetWorkStatus == AFNetworkReachabilityStatusNotReachable && [cacheManager isFileExistWithUrl:url]) || (NetWorkStatus == AFNetworkReachabilityStatusReachableViaWWAN && [cacheManager isFileExistWithUrl:url] && [cacheManager isOutTimeWithUrl:url time:30*60] == NO) || (NetWorkStatus == AFNetworkReachabilityStatusReachableViaWiFi && [cacheManager isFileExistWithUrl:url] && [cacheManager isOutTimeWithUrl:url time:3*60] == NO))  && (type != RequestRefresh)) {
        // 读取缓存
        // NSLog(@"从缓存去读");
        NSData *data = [cacheManager cacheDataWithUrl:url];
        if (success) {
            success(data);
        }
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation * operation, id responseObject) {
        // 写入进缓存
        [cacheManager cacheData:responseObject forUrl:url];
        
        if (success) {
            success(responseObject);
        }
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (failed) {
            failed(error);
        }
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

+ (void)cancleRequest{
    AFHTTPRequestOperationManager *httpmanager = [AFHTTPRequestOperationManager manager];
    
    [httpmanager.operationQueue cancelAllOperations];

}
@end
