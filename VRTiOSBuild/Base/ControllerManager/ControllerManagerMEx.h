//
//  ControllerManagerMEx.h
//  C_Class_iOS
//
//  Created by MonsterENT on 11/6/17.
//  Copyright © 2017 MonsterENT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define getVcView(VCName) (((UIViewController*)[[ControllerManagerMEx shareInstance]getControllerByName:VCName]).view)


@protocol ControllerManagerDelegate <NSObject>

@optional
-(BOOL)ControllerWillPush:(NSString*)CID;
-(void)ControllerDidPushed:(NSString*)CID;
-(BOOL)ControllerWillPop:(NSString*)CID;
-(void)ControllerDidPoped:(NSString*)CID;
@end



@interface ControllerManagerMEx : NSObject

+(instancetype)shareInstance;

/**
 * you can manager the controller more efficient,if you set this property.
 * recommend you to setup a baseController,and set this property when viewWillAppear
 * @note make sure the controller is already managed by the ControllerManagerMEx
 */
@property(weak,nonatomic)UIViewController* currentDisplayController;

-(void)addController:(UIViewController*)controller;
-(void)addController:(UIViewController*)controller withName:(NSString*)name;

/**
 * notice manager not to retain the ViewController you named
 @note this method will not Pop the ViewController
 */
-(void)releaseControllerNamed:(NSString*)name;

-(id)getControllerByName:(NSString*)name;

-(BOOL)presentController:(UIViewController*)controller withName:(NSString*)name base:(NSString*)baseControllerName;

-(BOOL)presentController:(UIViewController*)controller base:(NSString*)baseControllerName;

/**
 * set currentDisplayController before use this method
 */
-(BOOL)presentControllerOnCurrentDisplayController:(UIViewController*)controller;


/**
 * once you call
 * -(BOOL)presentController:(UIViewController*)controller WithName:(NSString*)name Base:(NSString*)baseControllerName;
 * to present a ViewController you should call this method
 * (notice manager not to retain this ViewController and dismiss this ViewController)
 */
-(BOOL)dismissControllerNamed:(NSString*)name;
-(BOOL)dismissController:(UIViewController*)controller;


-(BOOL)pushController:(UIViewController*)controller withName:(NSString*)name base:(NSString*)baseControllerName;
-(BOOL)pushController:(UIViewController*)controller base:(NSString*)baseControllerName;

/**
 * set currentDisplayController before use this method
 */
-(BOOL)pushControllerOnCurrentDisplayController:(UIViewController*)controller;
/**
 * once you call
 * -(BOOL)pushController:(UIViewController*)controller WithName:(NSString*)name Base:(NSString*)baseControllerName;
 * to push a ViewController you should call this method (notice manager not to retain this ViewController and Pop this ViewController from its NavigationController)
 * @note recommend you to use BaseNavigationController,then you can pop a ViewController as normal
 */
-(BOOL)PopControllerNamed:(NSString*)name;
-(BOOL)PopController:(UIViewController*)controller;
-(bool)canPopController:(UIViewController*)controller;

-(void)autoShowHideTabBarController:(id)tabBarController;
-(void)dismissAutoTabBar;


-(UIViewController*)currentNaBackRootViewController;

-(void)ShowHUDWithController:(UIViewController*)Controller;
-(void)HideHUDWithController:(UIViewController*)Controller;

-(void)ShowQickHUD;
-(void)HideQickHUD;


-(void)addDelegate:(id<ControllerManagerDelegate>) delegate;
-(void)removeDelegate:(id<ControllerManagerDelegate>) delegate;



#pragma Private method

-(void)ShouldReleaseController:(UIViewController*)controller;

@end
