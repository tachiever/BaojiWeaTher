//
//  NBRequest.h
//  UI_爱新闻
//
//  Created by YuTengxiao on 15/10/11.
//  Copyright (c) 2015年 YuTengxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用系统的方式，来定义枚举
typedef NS_ENUM(NSInteger, NBRequestType) {
    RequestNormal,  // 普通请求
    RequestRefresh, // 下拉刷新
    RequestMore     // 上拉加载
};

@interface NBRequest : NSObject
@property (nonatomic) AFHTTPRequestOperationManager *manager;

+ (void)requestWithURL:(NSString *)url type:(NBRequestType)type success:(void (^)(NSData *requestData))success failed:(void (^)(NSError *error))failed;
+ (void)postWithURL:(NSString *)url type:(NBRequestType)type dic:(NSMutableDictionary *)dic success:(void (^)(NSData *data))success failed:(void (^)(NSError *error))failed;
+ (void)cancleRequest;
@end
