//
//  VRTSDKMaster.m
//  DC_iOS
//
//  Created by MonsterENT on 9/29/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import "VRTSDKMaster.h"
#import "VRTGlobalManager.h"

@interface VRTSDKMaster()
@property(strong, nonatomic)id<VRTSDKMasterDelegate> sdkMasterDelegate;
@property(strong, nonatomic)id<VRTImageWithURL> imgUrlDelegate;
@end

@implementation VRTSDKMaster

+(instancetype)shareInstance
{
    static VRTSDKMaster* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [VRTSDKMaster new];
        [VRTGlobalManager shareInstance].frameworkCode = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://21xa689434.imwork.net:8090/public/tmp/VRTJSFramework/code/VRTJSFramework.js"] encoding:NSUTF8StringEncoding error:nil];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if(self)
    {
    }
    return self;
}

-(void)setMasterDelegate:(VRTProtocol*)delegate
{
    _imgUrlDelegate = (id<VRTImageWithURL>)delegate;
    _sdkMasterDelegate = (id<VRTSDKMasterDelegate>)delegate;
}

-(void)setNetworkAdapter:(NetworkMEx*)adapter
{
    _httpAdapter = adapter;
}

-(void)_setImageWithUrl:(NSString*)url imageView:(UIImageView*)imgView
{
    [_imgUrlDelegate setImageWithUrl:url withImageView:imgView];
}

-(CGFloat)naBarHeight
{
    return [_sdkMasterDelegate getNavigationBarHeight];
}

-(CGFloat)tabBarHeight
{
    return [_sdkMasterDelegate getTabBarHeight];
}

-(CGFloat)statusBarHeight
{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

@end
