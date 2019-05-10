//
//  ControllerManagerMEx.m
//  C_Class_iOS
//
//  Created by MonsterENT on 11/6/17.
//  Copyright © 2017 MonsterENT. All rights reserved.
//

#warning TOFIX currentDisplayController

#import "ControllerManagerMEx.h"
#import "WeakMutableArray.h"
#import "NSObject+ProtocolHelper.h"

static ControllerManagerMEx* Manager = NULL;

@interface ControllerManagerMEx()

@property(strong,nonatomic) NSMutableDictionary* ControllerMap;
@property(strong,nonatomic) WeakMutableArray* delegates;
@property(weak,nonatomic)id autoTabBarController;

@end;

@implementation ControllerManagerMEx
{
}

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Manager = [ControllerManagerMEx new];
    });
    return Manager;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _ControllerMap = [NSMutableDictionary new];
        _delegates = [WeakMutableArray new];
    }
    return self;
}

-(void)addController:(UIViewController*)controller
{
    [self addController:controller withName:NSStringFromClass([controller class])];
}

-(void)addController:(UIViewController*)controller withName:(NSString*)name
{
    [ControllerManagerMEx shareInstance].ControllerMap[name] = controller;
}

-(void)releaseControllerNamed:(NSString*)name
{
    [[ControllerManagerMEx shareInstance].ControllerMap removeObjectForKey:name];
}

-(id)getControllerByName:(NSString*)name
{
    return [[ControllerManagerMEx shareInstance].ControllerMap valueForKey:name];
}

-(BOOL)presentController:(UIViewController*)controller withName:(NSString*)name base:(NSString*)baseControllerName
{
    BOOL Ret = true;
    for(id<ControllerManagerDelegate>delegate in [_delegates allObjects])
    {
        if([delegate respondsToSelector:@selector(ControllerWillPush:)])
        {
            Ret = [delegate ControllerWillPush:name];
        }
    }
    if(!Ret)
        return Ret;
    
    [ControllerManagerMEx shareInstance].ControllerMap[name] = controller;
    [[self getControllerByName:baseControllerName] presentViewController:controller animated:true completion:nil];
    self.currentDisplayController = controller;
    for(id<ControllerManagerDelegate>delegate in [_delegates allObjects])
    {
        if([delegate respondsToSelector:@selector(ControllerDidPushed:)])
        {
            [(id)delegate SafeCALLBACK:@selector(ControllerDidPoped:) withObj:name];
        }
    }
    
    return true;
}
-(BOOL)dismissControllerNamed:(NSString*)name
{
    BOOL Ret = true;
    for(id<ControllerManagerDelegate>delegate in [_delegates allObjects])
    {
        if([delegate respondsToSelector:@selector(ControllerWillPop:)])
        {
            Ret = [delegate ControllerWillPop:name];
        }
    }
    
    if(!Ret)
        return Ret;
    
    UIViewController* vc = [[ControllerManagerMEx shareInstance] getControllerByName:name];
    
    if([vc conformsToProtocol:@protocol(ControllerManagerDelegate)])
        [self removeDelegate:(id<ControllerManagerDelegate>)vc];
    
    if(vc)
    {
        [[ControllerManagerMEx shareInstance].ControllerMap removeObjectForKey:name];
        [vc dismissViewControllerAnimated:true completion:nil];
    }
    
    for(id<ControllerManagerDelegate>delegate in [_delegates allObjects])
    {
        [(id)delegate SafeCALLBACK:@selector(ControllerDidPoped:) withObj:name];
    }
    
    return true;
}

-(BOOL)dismissController:(UIViewController*)controller
{
    return [self dismissControllerNamed:NSStringFromClass([controller class])];
}

-(BOOL)presentController:(UIViewController*)controller base:(NSString*)baseControllerName
{
    return [self presentController:controller withName:NSStringFromClass([controller class]) base:baseControllerName];
}

-(BOOL)presentControllerOnCurrentDisplayController:(UIViewController*)controller
{
    return [self presentController:controller base:NSStringFromClass([self.currentDisplayController class])];
}

-(BOOL)pushController:(UIViewController*)controller withName:(NSString*)name base:(NSString*)baseControllerName
{
    BOOL Ret = true;
    for(id<ControllerManagerDelegate>delegate in [_delegates allObjects])
    {
        if([delegate respondsToSelector:@selector(ControllerWillPush:)])
        {
            Ret = [delegate ControllerWillPush:name];
        }
    }
    
    if(!Ret)
        return Ret;
    
    
    
    UIViewController* BaseController =[self getControllerByName:baseControllerName];
    
    if(!BaseController)
        return false;
    
    [ControllerManagerMEx shareInstance].ControllerMap[name] = controller;
    if(_autoTabBarController && BaseController.navigationController.viewControllers.count == 1)
    {
#warning TODO
//        [_autoTabBarController setTabBarHidden:true animated:true];
    }
    [[BaseController navigationController]pushViewController:controller animated:true];
    self.currentDisplayController = controller;
    
    for(id<ControllerManagerDelegate>delegate in [_delegates allObjects])
    {
        [(id)delegate SafeCALLBACK:@selector(ControllerDidPushed:) withObj:name];
    }
    
    return true;
}

-(BOOL)pushController:(UIViewController*)controller base:(NSString*)baseControllerName
{
    return [self pushController:controller withName:NSStringFromClass([controller class]) base:baseControllerName];
}

-(BOOL)pushControllerOnCurrentDisplayController:(UIViewController*)controller
{
    return [self pushController:controller base:NSStringFromClass([self.currentDisplayController class])];
}

-(BOOL)PopControllerNamed:(NSString*)name
{
    
    BOOL Ret = true;
    for(id<ControllerManagerDelegate>delegate in [_delegates allObjects])
    {
        
        if([delegate respondsToSelector:@selector(ControllerWillPop:)])
        {
            Ret = [delegate ControllerWillPop:name];
        }
    }
    
    if(!Ret)
        return Ret;
    
    UIViewController*  vc = [[ControllerManagerMEx shareInstance] getControllerByName:name];
    
    if([vc conformsToProtocol:@protocol(ControllerManagerDelegate)])
        [self removeDelegate:(id<ControllerManagerDelegate>)vc];
    
    if(vc)
    {
        if(_autoTabBarController && vc.navigationController.viewControllers.count == 2)
        {
#warning TODO
//            [_autoTabBarController setTabBarHidden:false animated:true];
        }
        [[ControllerManagerMEx shareInstance].ControllerMap removeObjectForKey:name];
        [[vc navigationController] popViewControllerAnimated:true];
    }
    
    for(id<ControllerManagerDelegate>delegate in [_delegates allObjects])
    {
        [(id)delegate SafeCALLBACK:@selector(ControllerDidPoped:) withObj:name];
    }
    
    return true;
}

-(BOOL)PopController:(UIViewController*)controller
{
    return [self PopControllerNamed:NSStringFromClass([controller class])];
}

//-(void)retainController:(UIViewController *)controller Named:(NSString *)name
//{
//    [ControllerManagerMEx shareInstance].ControllerMap[name] = controller;
//}


-(void)autoShowHideTabBarController:(id)tabBarController
{
    _autoTabBarController = tabBarController;
    [self addController:tabBarController withName:NSStringFromClass([tabBarController class])];
}

-(void)dismissAutoTabBar
{
    [self releaseControllerNamed:NSStringFromClass([_autoTabBarController class])];
    _autoTabBarController = nil;
}

-(UIViewController*)currentNaBackRootViewController
{
    UIViewController* baseVC = [_currentDisplayController.navigationController viewControllers].firstObject;
    if(baseVC)
    {
        NSArray* vcs = [baseVC.navigationController viewControllers];
        if(vcs.count > 1)
        {
            NSArray* removeVcs = [vcs subarrayWithRange:NSMakeRange(1, vcs.count-1)];
            
            for(UIViewController* vc in removeVcs)
                [self ShouldReleaseController:vc];
        }
        [_currentDisplayController.navigationController setViewControllers:@[baseVC]];
    }
    _currentDisplayController = baseVC;
    return baseVC;
}

-(void)ShowHUDWithController:(UIViewController*)Controller
{
//    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:Controller.view animated:true];
//    hud.label.text = @"请稍等...";
}
-(void)HideHUDWithController:(UIViewController*)Controller
{
//    [MBProgressHUD hideHUDForView:Controller.view animated:true];
}

-(void)ShowQickHUD
{
//    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:gKeyWindow animated:true];
//    hud.label.text = @"请稍等...";
}
-(void)HideQickHUD
{
//    [MBProgressHUD hideHUDForView:gKeyWindow animated:true];
}


-(void)addDelegate:(id<ControllerManagerDelegate>)delegate
{
    [_delegates addObject:delegate];
}

-(void)removeDelegate:(id<ControllerManagerDelegate>) delegate
{
}





#pragma Private method

-(bool)canPopController:(UIViewController*)controller
{
    __block bool ret = true;
    
    [self.ControllerMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if([obj isEqual:controller])
        {
            for(id<ControllerManagerDelegate>delegate in [self.delegates allObjects])
            {
                if(![delegate ControllerWillPop:key])
                {
                    ret = false;
                    break;
                }
            }
            *stop = true;
        }
    }];
    
    return ret;
}

-(void)ShouldReleaseController:(UIViewController*)controller
{
    [self.ControllerMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if([obj isEqual:controller])
        {
            [self releaseControllerNamed:key];
            NSArray* vcArray = [[controller navigationController] viewControllers];
            self.currentDisplayController = [vcArray objectAtIndex:vcArray.count - 2];
            if(self.autoTabBarController && ((UIViewController*)obj).navigationController.viewControllers.count == 2)
            {
#warning TODO
//                [self.autoTabBarController setTabBarHidden:false animated:true];
            }
            for(id<ControllerManagerDelegate>delegate in [self.delegates allObjects])
            {
                [(id)delegate SafeCALLBACK:@selector(ControllerDidPoped:) withObj:key];
            }
            *stop = true;
        }
    }];
}

@end
