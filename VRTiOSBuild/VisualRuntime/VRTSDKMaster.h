//
//  VRTSDKMaster.h
//  DC_iOS
//
//  Created by MonsterENT on 9/29/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning TODO
#import "../Base/Network/NetworkMEx.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VRTSDKMasterDelegate <NSObject>

-(CGFloat)getNavigationBarHeight;
-(CGFloat)getTabBarHeight;

@end


@interface VRTSDKMaster : NSObject

+(instancetype)shareInstance;

@property(strong,nonatomic)NetworkMEx* httpAdapter;

@property(weak,nonatomic)id<VRTSDKMasterDelegate> delegate;

@property(assign,nonatomic)CGFloat naBarHeight,tabBarHeight,statusBarHeight;

@end

NS_ASSUME_NONNULL_END
