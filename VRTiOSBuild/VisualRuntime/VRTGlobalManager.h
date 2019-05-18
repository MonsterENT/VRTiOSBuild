//
//  VRTGlobalManager.h
//  VRTiOSBuild
//
//  Created by MonsterENT on 5/12/19.
//  Copyright © 2019 MonsterEntertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VRTGlobalManager : NSObject

+(instancetype)shareInstance;

@property(strong, nonatomic)NSString* frameworkCode;

@end

NS_ASSUME_NONNULL_END
