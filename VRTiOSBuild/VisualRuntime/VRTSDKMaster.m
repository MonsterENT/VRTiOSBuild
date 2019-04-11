//
//  VRTSDKMaster.m
//  DC_iOS
//
//  Created by MonsterENT on 9/29/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import "VRTSDKMaster.h"

@implementation VRTSDKMaster

+(instancetype)shareInstance
{
    static VRTSDKMaster* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [VRTSDKMaster new];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if(self)
    {
        _httpAdapter = [NetworkMEx new];
#warning TODO
//        [_httpAdapter setNetworkModuleInstance:[[NetworkModule alloc]init]];
    }
    return self;
}

-(CGFloat)naBarHeight
{
    return [_delegate getNavigationBarHeight];
}

-(CGFloat)tabBarHeight
{
    return [_delegate getTabBarHeight];
}

-(CGFloat)statusBarHeight
{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

@end
