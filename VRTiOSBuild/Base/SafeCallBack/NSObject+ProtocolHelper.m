//
//  NSObject+ProtocolHelper.m
//  C_Class_iOS
//
//  Created by MonsterENT on 11/6/17.
//  Copyright © 2017 MonsterENT. All rights reserved.
//

#import "NSObject+ProtocolHelper.h"

@implementation NSObject (ProtocolHelper)

-(BOOL)SafeCALLBACK:(SEL)Selector withObj:(id)obj
{
    if([self respondsToSelector:Selector])
    {
        [self performSelector:Selector withObject:obj];
        return true;
    }
    return false;
}


-(BOOL)SafeCALLBACK:(SEL)Selector withObj:(id)obj andObj:(id)obj2
{
    if([self respondsToSelector:Selector])
    {
        [self performSelector:Selector withObject:obj withObject:obj2];
        return true;
    }
    return false;
}


-(BOOL)SafeCALLBACK:(SEL)Selector withObjs:(NSArray*)objs
{
    NSMethodSignature* sig = [self methodSignatureForSelector:Selector];
    if([self respondsToSelector:Selector] && sig)
    {
        NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
        if(inv)
        {
            NSUInteger index = 2;
            for(id obj in objs)
            {
                [inv setArgument:&obj atIndex:index++];
            }
            [inv invokeWithTarget:self];
            return true;
        }
    }
    
    return false;
}






-(id)SafeCALLBACKWithReturnValue:(SEL)Selector WithObj:(id)obj
{
    if([self respondsToSelector:Selector])
        return [self performSelector:Selector withObject:obj];
    else
        return nil;
}

-(id)SafeCALLBACKWithReturnValue:(SEL)Selector WithObj:(id)obj andObj:(id)obj2
{
    if([self respondsToSelector:Selector])
        return [self performSelector:Selector withObject:obj withObject:obj2];
    else
        return nil;
}
@end
