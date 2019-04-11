//
//  Model4VRTVC.h
//  DC_iOS
//
//  Created by MonsterENT on 9/29/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@class Model4VRTView;

@interface Model4VRTVC : NSObject

@property(strong,nonatomic)NSString* vrtId;

@property(strong,nonatomic)Model4VRTView* view;

@property(strong,nonatomic)JSManagedValue* viewDidLoad,*viewWillAppear,*viewDidAppear,*viewWillDisappear;

@property(copy,nonatomic)NSString* title;

@end

NS_ASSUME_NONNULL_END
