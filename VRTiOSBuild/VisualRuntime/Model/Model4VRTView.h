//
//  Model4VRTView.h
//  DC_iOS
//
//  Created by MonsterENT on 9/29/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Model4VRTView : NSObject

@property(assign,nonatomic)CGFloat x,y,height,width;

@property(assign,nonatomic)CGFloat cornerRadius;

@property(copy,nonatomic)NSString* vrtId;

@property(weak,nonatomic)Model4VRTView* superView;

@property(strong,nonatomic)NSArray<Model4VRTView*>* subViews;

@property(strong,nonatomic)UIColor* backgroundColor;

@property(assign, nonatomic)bool enableUserInteraction;

@end

NS_ASSUME_NONNULL_END
