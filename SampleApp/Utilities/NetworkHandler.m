//
//  NetworkHandler.m
//  SampleApp
//
//  Created by Manoj Rai on 08/10/16.
//  Copyright © 2016 Manoj Rai. All rights reserved.
//

#import "NetworkHandler.h"

@implementation NetworkHandler

+ (NetworkHandler *)sharedInstance {
    static NetworkHandler *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[NetworkHandler alloc] init];
    });
    return __instance;
}

- (BOOL)isNetworkRechable {
    
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        
        if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi)
            NSLog(@"Network reachable via WWAN");
        else
            NSLog(@"Network reachable via Wifi");
        
        return YES;
    }
    else {
        
        NSLog(@"Network is not reachable");
        return NO;
    }
}

- (void) getAPI:(NSString *) urlString
         params: (NSDictionary *)params
completionHandler:(void (^)(id responseObject,NSError *error))completionHandler {
    
    [[AFHTTPSessionManager manager] GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"Progress........");
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject,nil);
        // NSLog(@"Success: %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil,error);
        // NSLog(@"Error: %@", error);
        
    }];
}

- (void) postAPI:(NSString *) urlString
          params: (NSDictionary *)params
completionHandler:(void (^)(id responseObject,NSError *error))completionHandler {
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [[AFHTTPSessionManager manager] setResponseSerializer:responseSerializer];
    
    [[AFHTTPSessionManager manager] POST:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"Progress........");
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil,error);
        
    }];
    
}


- (void) putAPI:(NSString *) urlString
         params: (NSDictionary *)params
completionHandler:(void (^)(id responseObject,NSError *error))completionHandler {
    
    [[AFHTTPSessionManager manager] PUT:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil,error);
    }];
}


- (void) deleteAPI:(NSString *) urlString
            params: (NSDictionary *)params
 completionHandler:(void (^)(id responseObject,NSError *error))completionHandler {
    
    [[AFHTTPSessionManager manager] DELETE:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil,error);
    }];
    
}


@end
