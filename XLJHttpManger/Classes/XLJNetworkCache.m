//
//  XLJNetworkCache.m
//  XLJHttpManger
//
//  Created by m on 2017/3/26.
//  Copyright © 2017年 XLJ. All rights reserved.
//

#import "XLJNetworkCache.h"
#import <YYCache/YYCache.h>

static NSString *const NetworkResponseCache = @"XLJNetworkResponseCache";
static YYCache *_dataCache;

@implementation XLJNetworkCache

+ (void)initialize
{
    _dataCache = [YYCache cacheWithName:NetworkResponseCache];
}

//存储缓存数据
+ (void)setHttpCache:(id)httpData URL:(NSString *)url parameters:(NSDictionary *)parameters
{
    //url与parameters转换成cacheKey来保存
    NSString *cacheKey = [self cacheKeyWithURL:url parameters:parameters];
    
    //异步缓存不会阻塞主线程
    [_dataCache setObject:httpData forKey:cacheKey];
}

//取出缓存数据
+ (id)httpCacheForUrl:(NSString *)url parameters:(NSDictionary *)parameters
{
    NSString *cacheKey = [self cacheKeyWithURL:url parameters:parameters];
    return [_dataCache objectForKey:cacheKey];
}

+ (void)httpCacheForUrl:(NSString *)url parameters:(NSDictionary *)parameters withDataBlock:(void (^)(id<NSCoding>))block
{
    NSString *cacheKey = [self cacheKeyWithURL:url parameters:parameters];
    
    [_dataCache objectForKey:cacheKey withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(object);

        });
    }];
}

+ (NSInteger)getAllHttpCacheSize
{
    return [_dataCache.diskCache totalCost];
}

+ (void)removeAllHttpCache
{
    return [_dataCache.diskCache removeAllObjects];
}

//将url与参数转换成存储的key
+ (NSString *)cacheKeyWithURL:(NSString *)url parameters:(NSDictionary *)parameters {
    
    if (!parameters) {return url;}
    
    //将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paramString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    
    //将url与转换好的参数拼接成最终的key
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",url,paramString];
    return cacheKey;
}

















@end
