//
//  VRTSDKMaster.m
//  DC_iOS
//
//  Created by MonsterENT on 9/29/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import "VRTSDKMaster.h"

@interface VRTSDKMaster()
@property(weak, nonatomic)id<VRTSDKMasterDelegate> sdkMasterDelegate;
@property(weak, nonatomic)id<VRTImageWithURL> imgUrlDelegate;
@end

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
