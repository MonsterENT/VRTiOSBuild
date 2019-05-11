//
//  NetworkMEx.m
//  AFTEST
//
//  Created by MonsterENT on 6/27/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import "NetworkMEx.h"

#define PACK_Token (@"userToken")
#define PACK_UserDevice (@"userDevice")

#define PACK_ModuleInstance ((id<NetWorkMExModuleDelegate>)_networkModuleInstance)

#define printRequestLogIfCloud do{\
if(instance.showRequestLog)\
NSLog(@"%@",[NSString stringWithFormat:@"NetworkMExLog\n URL:%@%@\n param:%@\n responseData:%@\n responseInfo:%@",[weakSelf getBaseUrl],url,param,data,info]);\
}while(0)

static NetworkMEx* instance;

@interface NetworkMEx()

@end

@implementation NetworkMEx


+(instancetype)shareInstance
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NetworkMEx new];
    });
    return instance;
}

-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
#ifdef DEBUG
        _showRequestLog = true;
#else
        _showRequestLog = false;
#endif
    }
    
    return self;
}

-(void)setBlockCallBackWhenNetworkStatusChanged:(NetworkStatusBlock)blockCallBackWhenNetworkStatusChanged
{
    _blockCallBackWhenNetworkStatusChanged = blockCallBackWhenNetworkStatusChanged;
    [PACK_ModuleInstance setBlockCallBackWhenNetworkStuatsChanged:_blockCallBackWhenNetworkStatusChanged];
}

-(void)postWithSubUrl:(NSString*)url param:(NSDictionary*)param block:(NetworkBaseBlock)block
{
    typeof(self) __weak weakSelf = self;
    if(param == nil)
    {
        param = @{};
    }
    NSMutableDictionary* tempParam = [NSMutableDictionary dictionaryWithDictionary:param];
    if(_userModelDelegate)
    {
        NSString* token = [_userModelDelegate userTokenNetworking];
        if(token)
        {
            [tempParam setObject:token forKey:PACK_Token];
        }
    }
    [tempParam setObject:@"iOS" forKey:PACK_UserDevice];
    [PACK_ModuleInstance POSTHttpRequestWithSubUrl:url param:[tempParam copy] successBlock:^(id data, id info) {
        printRequestLogIfCloud;
        block([self resolveData:data withSubUrl:url],info);
    } failBlock:^(id data, id info) {
        printRequestLogIfCloud;
        block([self resolveData:data withSubUrl:url],nil);
    }];
}

-(void)getWithSubUrl:(NSString*)url param:(NSDictionary*)param block:(NetworkBaseBlock)block
{
    typeof(self) __weak weakSelf = self;
    NSMutableDictionary* tempParam = [NSMutableDictionary dictionaryWithDictionary:param];
    if(_userModelDelegate)
        [tempParam setObject:[_userModelDelegate userTokenNetworking] forKey:PACK_Token];
    [tempParam setObject:@"iOS" forKey:PACK_UserDevice];
    [PACK_ModuleInstance GETHttpRequestWithSubUrl:url param:[tempParam copy] successBlock:^(id data, id info) {
        printRequestLogIfCloud;
        block([self resolveData:data withSubUrl:url],info);
    } failBlock:^(id data, id info) {
        printRequestLogIfCloud;
        block([self resolveData:data withSubUrl:url],nil);
    }];
}

-(id)resolveData:(id)data withSubUrl:(NSString*)subUrl
{
    if(data && [data isKindOfClass:[NSDictionary class]])
    {
        if([[data objectForKey:@"info"] isKindOfClass:[NSString class]])
        {
            if([[data objectForKey:@"info"] isEqualToString:@"token timeout"])
            {
                data = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.userModelDelegate tokenTimeoutOperationWithSubUrl:subUrl];
                });
            }
        }
    }
    return data;
}

-(NetworkStatus)getNetworkStatus
{
    return [PACK_ModuleInstance getNetworkStatus];
}

-(NSString*)getBaseUrl
{
    return [PACK_ModuleInstance getBaseUrl];
}
@end
