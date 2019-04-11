//
//  VRTMutableDictionary.h
//  DC_iOS
//
//  Created by MonsterENT on 10/4/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^VRTDicCallBackWhenSetKey)(id key,id obj);

@interface VRTMutableDictionary : NSObject

@property(strong,nonatomic)VRTDicCallBackWhenSetKey blockWhenSetKey;

-(void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;

-(id)objectForKey:(id<NSCopying>)aKey;

@end

NS_ASSUME_NONNULL_END
