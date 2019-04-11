//
//  NetworkMEx.h
//  AFTEST
//
//  Created by MonsterENT on 6/27/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    NetworkStatus_NoModule = 0,
    NetworkStatusUnKnow = 1,
    NetworkStatusUnConnect,
    NetworkStatusConnectWithCellular,
    NetworkStatusConnectWithWiFi,
} NetworkStatus;

typedef void(^NetworkStatusBlock)(NetworkStatus status);
typedef void(^NetworkBaseBlock)(id data,id info);


@protocol NetWorkMExModuleDelegate <NSObject>

@required

-(void)POSTHttpRequestWithSubUrl:(NSString*)url param:(NSDictionary*)param successBlock:(NetworkBaseBlock)successBlock failBlock:(NetworkBaseBlock)failBlock;

-(void)GETHttpRequestWithSubUrl:(NSString*)url param:(NSDictionary*)param successBlock:(NetworkBaseBlock)successBlock failBlock:(NetworkBaseBlock)failBlock;

-(void)setBlockCallBackWhenNetworkStuatsChanged:(NetworkStatusBlock)block;

-(NetworkStatus)getNetworkStatus;

-(NSString*)getBaseUrl;
@end


@protocol NetWorkUserModelDelegate <NSObject>

-(NSString*)userTokenNetworking;
-(void)tokenTimeoutOperationWithSubUrl:(NSString*)subUrl;

@end

@interface NetworkMEx : NSObject

+(instancetype)shareInstance;

/**
 * @note the module should implement NetWorkMExModuleDelegate
 */
@property(strong,nonatomic)id networkModuleInstance;

@property(weak,nonatomic)id<NetWorkUserModelDelegate> userModelDelegate;

@property(strong,nonatomic)NetworkStatusBlock blockCallBackWhenNetworkStatusChanged;

@property(assign,nonatomic)bool showRequestLog;

-(void)postWithSubUrl:(NSString*)url param:(NSDictionary*)param block:(NetworkBaseBlock)block;
-(void)getWithSubUrl:(NSString*)url param:(NSDictionary*)param block:(NetworkBaseBlock)block;

-(NetworkStatus)getNetworkStatus;

/**
 * @note the returnValue could be nil
 */
-(NSString*)getBaseUrl;


@end
