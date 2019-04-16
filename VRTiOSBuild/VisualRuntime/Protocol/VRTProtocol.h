//
//  VRTProtocol.h
//  VRTiOSBuild
//
//  Created by MonsterENT on 4/13/19.
//  Copyright © 2019 MonsterEntertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VRTImageWithURL <NSObject>
@required
-(void)setImageWithUrl:(NSString*)url withImageView:(UIImageView*)imgView;
@end

@protocol VRTSDKMasterDelegate <NSObject>
@required
-(CGFloat)getNavigationBarHeight;
-(CGFloat)getTabBarHeight;

@end

@interface VRTProtocol : NSObject<VRTImageWithURL, VRTSDKMasterDelegate>

@end

NS_ASSUME_NONNULL_END
