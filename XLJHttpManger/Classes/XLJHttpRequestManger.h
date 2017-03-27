//
//  XLJHttpRequestManger.h
//  XLJHttpManger
//
//  Created by m on 2017/3/25.
//  Copyright © 2017年 XLJ. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 网络请求的方式

 - HTTPRequestGET: GET
 - HTTPRequestPOST: POST
 */
typedef NS_ENUM(NSInteger, HTTPRequestType){
    HTTPRequestGET,
    HTTPRequestPOST
};


/**
 网络状态

 - XLJNetworkStatusUnKnown: 未知网络
 - XLJNetworkStatusNotReachable: 无网络
 - XLJNetworkStatusReachiableViaWWAN: 手机网络
 - XLJNetworkStatusReachiableWiFi: WiFi网络
 */
typedef NS_ENUM(NSInteger, XLJNetworkStatus) {
    XLJNetworkStatusUnKnown,
    XLJNetworkStatusNotReachable,
    XLJNetworkStatusReachiableViaWWAN,
    XLJNetworkStatusReachiableWiFi
};

/**请求成功*/
typedef void(^XLJHttpRequestSuccess)(id responseObject);
/**请求失败*/
typedef void(^XLJHttpRequestFailed)(NSError *error);
/**缓存请求*/
typedef void(^XLJHttpRequestCache)(id responseCache);
/**网络状态*/
typedef void(^XLJNetworkStatusType)(XLJNetworkStatus status);

@interface XLJHttpRequestManger : NSObject


/**
 是否有网络:YES,有;NO,无

 @return <#return value description#>
 */
+ (BOOL)isNetwork;

/**
 是否为手机网络:YES,有; NO,无

 @return <#return value description#>
 */
+ (BOOL)isWWANNetwork;
/**WiFi网络*/
+ (BOOL)isWiFiNetwork;

/**实时获取网络状态*/
+ (void)networkStatusWithBlock:(XLJNetworkStatusType)networkStatus;

/**
 单例网络请求
 @return <#return value description#>
 */
+ (XLJHttpRequestManger *)sharedHttpManager;

//+ (__kindof NSURLSessionTask *)requestNetWorkWithResponseCache:(BOOL)isResponeCache httpType:(HTTPRequestType)httpType
//                                        responseCache:(BOOL) isResponeCache
//                                           requestUrl:(NSString *)path
//                                           parameters:(NSDictionary *)parameters
//                                        responseCache:(XLJHttpRequestCache) responseCache
//                                              success:(XLJHttpRequestSuccess) success
//                                              failure:(XLJHttpRequestFailed) failure;



/**
 网络请求GET/POST
 @param httpType GET或POST
 @param path 请求地址
 @param parameters 请求参数
 @param responseCache 缓存数据回调
 @param success 请求成功回调
 @param failure 请求失败回调
 @return 返回的对象可取消请求，调用cancel方法
 */
+ (__kindof NSURLSessionTask *)requestNetWorkWithType:(HTTPRequestType)httpType
                                           requestUrl:(NSString *)path
                                           parameters:(NSDictionary *)parameters
                                        responseCache:(XLJHttpRequestCache) responseCache
                                              success:(XLJHttpRequestSuccess) success
                                              failure:(XLJHttpRequestFailed) failure;

@end
