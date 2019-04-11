//
//  UIViewController+ControllerManagerMEx.m
//  DC_iOS
//
//  Created by MonsterENT on 7/4/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import "UIViewController+ControllerManagerMEx.h"

@implementation UIViewController (ControllerManagerMEx)

-(BOOL)push
{
    return [[ControllerManagerMEx shareInstance]pushControllerOnCurrentDisplayController:self];
}

-(BOOL)pop
{
    return [[ControllerManagerMEx shareInstance]PopController:self];
}

-(BOOL)present
{
    return [[ControllerManagerMEx shareInstance]presentControllerOnCurrentDisplayController:self];
}

-(BOOL)dismiss
{
    return [[ControllerManagerMEx shareInstance]dismissController:self];
}

@end
