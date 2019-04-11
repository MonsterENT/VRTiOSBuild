//
//  VRTMutableDictionary.m
//  DC_iOS
//
//  Created by MonsterENT on 10/4/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import "VRTMutableDictionary.h"

@interface VRTMutableDictionary()

@property(strong,nonatomic)NSMutableDictionary* m_dic;

@end

@implementation VRTMutableDictionary

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _m_dic = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    [_m_dic setObject:anObject forKey:aKey];
    if(self.blockWhenSetKey)
        self.blockWhenSetKey(aKey,anObject);
}

-(id)objectForKey:(id<NSCopying>)aKey
{
    return [_m_dic objectForKey:aKey];
}
@end
