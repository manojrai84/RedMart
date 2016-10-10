//
//  NetworkHandler.h
//  SampleApp
//
//  Created by Manoj Rai on 08/10/16.
//  Copyright © 2016 Manoj Rai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetworkHandler : NSObject

+ (NetworkHandler *)sharedInstance;

- (BOOL)isNetworkRechable;

- (void) getAPI:(NSString *) urlString
         params: (NSDictionary *)params
completionHandler:(void (^)(id responseObject,NSError *error))completionHandler;

- (void) postAPI:(NSString *) urlString
          params: (NSDictionary *)params
completionHandler:(void (^)(id responseObject,NSError *error))completionHandler;

- (void) putAPI:(NSString *) urlString
         params: (NSDictionary *)params
completionHandler:(void (^)(id responseObject,NSError *error))completionHandler;

- (void) deleteAPI:(NSString *) urlString
            params: (NSDictionary *)params
 completionHandler:(void (^)(id responseObject,NSError *error))completionHandler;



@end
