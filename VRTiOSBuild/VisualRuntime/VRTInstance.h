//
//  VRTInstance.h
//  DC_iOS
//
//  Created by MonsterENT on 9/11/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VRTMutableDictionary;
@interface VRTInstance : NSObject

-(void)excuteLocalJS:(NSString*)fileName onViewController:(UIViewController*)viewController;

-(void)excuteRemoteJS:(NSURL*)url onViewController:(UIViewController*)viewController;

-(void)viewDidLoad_CallBack;
-(void)viewWillAppear_CallBack;
-(void)viewDidAppear_CallBack;
-(void)viewWillDisappear_CallBack;

@property(copy,nonatomic)NSString* url;
@property(copy,nonatomic)NSDictionary* param;

@property(strong,nonatomic)VRTMutableDictionary* vrtIdToViewCache;
@property(strong,nonatomic)NSMutableArray* vrtClickCache;
@property(strong,nonatomic)VRTMutableDictionary* vrtListVMCache;

@end
