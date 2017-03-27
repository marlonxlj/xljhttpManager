//
//  XLJNetworkCache.h
//  XLJHttpManger
//
//  Created by m on 2017/3/26.
//  Copyright © 2017年 XLJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLJNetworkCache : NSObject

/**
 异步缓存网络数据

 @param httpData 服务返回的数据
 @param url 请求地址
 @param parameters 请求参数
 */
+ (void)setHttpCache:(id)httpData URL:(NSString *)url parameters:(NSDictionary *)parameters;


/**
 根据请求的url与parameters取出缓存数据

 @param url 请求地址
 @param parameters 请求参数
 @return 缓存的服务器数据
 */
+ (id)httpCacheForUrl:(NSString *)url parameters:(NSDictionary *)parameters;


/**
 根据请求的url与parameters 异步取出缓存数据

 @param url 请求地址
 @param parameters 请求参数
 @param block 异步回调缓存数据
 */
+ (void)httpCacheForUrl:(NSString *)url parameters:(NSDictionary *)parameters withDataBlock:(void(^)(id<NSCoding> object))block;


/**
 获取网络缓存的总大小bytes(字节)

 @return 总大小
 */
+ (NSInteger)getAllHttpCacheSize;

/**
 删除所有网络缓存
 */
+ (void)removeAllHttpCache;

@end
