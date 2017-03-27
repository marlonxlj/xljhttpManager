//
//  XLJHttpRequestManger.m
//  XLJHttpManger
//
//  Created by m on 2017/3/25.
//  Copyright © 2017年 XLJ. All rights reserved.
//

#import "XLJHttpRequestManger.h"
#import "AFNetworking/AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "XLJNetworkCache.h"

#ifdef DEBUG
#define NSLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define NSLog(...)
#endif

static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_httpManger;


@implementation XLJHttpRequestManger

//网络状态
+ (BOOL)isNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}
//实时监听网络状态
+ (void)networkStatusWithBlock:(XLJNetworkStatusType)networkStatus
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown: networkStatus ? networkStatus(XLJNetworkStatusUnKnown) : nil;
                    NSLog(@"未知网络");
                    break;
                case AFNetworkReachabilityStatusNotReachable: networkStatus ? networkStatus(XLJNetworkStatusNotReachable) : nil;
                case AFNetworkReachabilityStatusReachableViaWWAN: networkStatus ? networkStatus(XLJNetworkStatusReachiableViaWWAN) : nil;
                case AFNetworkReachabilityStatusReachableViaWiFi: networkStatus ? networkStatus(XLJNetworkStatusReachiableWiFi) : nil;
                default:
                    break;
            }
        }];
    });
}

+ (NSMutableArray *)allSessionTask{
    if (!_allSessionTask) {
        _allSessionTask = @[].mutableCopy;
    }
    
    return _allSessionTask;
}

+ (void)initialize{
    _httpManger = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    _httpManger.requestSerializer = requestSerializer;
    _httpManger.responseSerializer = [AFJSONResponseSerializer serializer];
    //菊花状态
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    _httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
}

    
+ (XLJHttpRequestManger *)sharedHttpManager
{
    static XLJHttpRequestManger *mangerHttp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mangerHttp = [[self alloc] init];
    });
    
    return mangerHttp;
}

+ (NSURLSessionTask *)requestNetWorkWithType:(HTTPRequestType)httpType requestUrl:(NSString *)path parameters:(NSDictionary *)parameters responseCache:(XLJHttpRequestCache)responseCache success:(XLJHttpRequestSuccess)success failure:(XLJHttpRequestFailed)failure
{
    //读取缓存
    responseCache ? responseCache([XLJNetworkCache httpCacheForUrl:path parameters:parameters]) : nil;
    
    switch (httpType) {
        case HTTPRequestGET:
        {
            NSURLSessionTask *sessionTaskGet = [_httpManger GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [[self allSessionTask] removeObject:task];
                success ? success(responseObject) : nil;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [[self allSessionTask] removeObject:task];
                failure ? failure(error) : nil;
            }];
            
            sessionTaskGet ? [[self allSessionTask] addObject:sessionTaskGet] :  nil;
            
            return sessionTaskGet;
        }
            break;
        case HTTPRequestPOST:
        {
            NSURLSessionTask *sessionTaskPost = [_httpManger POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [[self allSessionTask] removeAllObjects];
                success ? success(responseObject) : nil;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [[self allSessionTask] removeAllObjects];
                failure ? failure(error) : nil;
            }];
            
            sessionTaskPost ? [[self allSessionTask] addObject:sessionTaskPost] : nil;
            
            return sessionTaskPost;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

#ifdef DEBUG

@end
@implementation NSArray(XLJ)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strMutable = [NSMutableString stringWithFormat:@"(\n)"];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [strMutable appendFormat:@"\t%@,\n",obj];
    }];
    
    [strMutable appendString:@")"];
    
    return strMutable;
}

@end

@implementation NSDictionary (XLJ)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *stringMutable = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [stringMutable appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [stringMutable appendString:@"}\n"];
    
    return stringMutable;
}

@end

#endif

