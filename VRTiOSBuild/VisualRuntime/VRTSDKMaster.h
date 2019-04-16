//
//  VRTSDKMaster.h
//  DC_iOS
//
//  Created by MonsterENT on 9/29/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Protocol/VRTProtocol.h"
#import "../Base/Network/NetworkMEx.h"

NS_ASSUME_NONNULL_BEGIN

@interface VRTSDKMaster : NSObject

+(instancetype)shareInstance;

@property(strong,nonatomic, readonly)NetworkMEx* httpAdapter;

@property(assign,nonatomic)CGFloat naBarHeight, tabBarHeight, statusBarHeight;

-(void)setMasterDelegate:(VRTProtocol*)delegate;
-(void)setNetworkAdapter:(NetworkMEx*)adapter;

-(void)_setImageWithUrl:(NSString*)url imageView:(UIImageView*)imgView;
@end

NS_ASSUME_NONNULL_END
