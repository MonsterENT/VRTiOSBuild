//
//  NSObject+ProtocolHelper.h
//  C_Class_iOS
//
//  Created by MonsterENT on 11/6/17.
//  Copyright © 2017 MonsterENT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ProtocolHelper)

-(BOOL)SafeCALLBACK:(SEL)Selector withObj:(id)obj;

-(BOOL)SafeCALLBACK:(SEL)Selector withObj:(id)obj andObj:(id)obj2;

-(BOOL)SafeCALLBACK:(SEL)Selector withObjs:(NSArray*)objs;


-(id)SafeCALLBACKWithReturnValue:(SEL)Selector WithObj:(id)obj;

-(id)SafeCALLBACKWithReturnValue:(SEL)Selector WithObj:(id)obj andObj:(id)obj2;

@end
