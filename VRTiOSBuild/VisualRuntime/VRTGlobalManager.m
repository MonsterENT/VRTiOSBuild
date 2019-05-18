//
//  VRTGlobalManager.m
//  VRTiOSBuild
//
//  Created by MonsterENT on 5/12/19.
//  Copyright © 2019 MonsterEntertainment. All rights reserved.
//

#import "VRTGlobalManager.h"
static VRTGlobalManager* g_manager;
@implementation VRTGlobalManager

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_manager = [VRTGlobalManager new];
    });
    return g_manager;
}

@end
