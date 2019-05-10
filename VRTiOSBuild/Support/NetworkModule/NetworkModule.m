//
//  NetworkModule.m
//  AFTEST
//
//  Created by MonsterENT on 6/27/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import "NetworkModule.h"

@interface NetworkModule()
@property(assign, nonatomic)BOOL enableSSL;
@end
@implementation NetworkModule

-(instancetype)initWithSSL:(BOOL)enableSSL
{
    _enableSSL = true;
    self = [self initWithBaseURL:nil];
    return self;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if(self)
    {
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setAllowInvalidCertificates:YES];
        [securityPolicy setValidatesDomainName:NO];
        if(_enableSSL)
        {
            self.securityPolicy = securityPolicy;
        }
        
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    }
    
    return self;
}

-(void)POSTHttpRequestWithSubUrl:(NSString*)url param:(NSDictionary*)param successBlock:(NetworkBaseBlock)successBlock failBlock:(NetworkBaseBlock)failBlock
{
    [self POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(nil,error);
    }];
}

-(void)GETHttpRequestWithSubUrl:(NSString*)url param:(NSDictionary*)param successBlock:(NetworkBaseBlock)successBlock failBlock:(NetworkBaseBlock)failBlock
{
    [self GET:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(nil,error);
    }];
}

-(void)setBlockCallBackWhenNetworkStuatsChanged:(NetworkStatusBlock)block
{
    AFNetworkReachabilityManager* manager = [AFNetworkReachabilityManager sharedManager];
    
    if(!block)
    {
        [manager stopMonitoring];
        return;
    }
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        block([self transformStatus:status]);
    }];
    [manager startMonitoring];
    
}

-(NetworkStatus)getNetworkStatus
{
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager]networkReachabilityStatus];
    return [self transformStatus:status];
}

-(NSString *)getBaseUrl
{
    return [[self baseURL] absoluteString];
}


-(NetworkStatus)transformStatus:(AFNetworkReachabilityStatus)status
{
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            return NetworkStatusUnKnow;
            break;
            
        case AFNetworkReachabilityStatusNotReachable:
            return NetworkStatusUnConnect;
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return NetworkStatusConnectWithCellular;
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return NetworkStatusConnectWithWiFi;
            break;
        default:
            return NetworkStatusUnKnow;
            break;
    }
}

@end
