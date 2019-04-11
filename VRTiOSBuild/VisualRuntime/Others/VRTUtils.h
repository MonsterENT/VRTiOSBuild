//
//  VRTUtils.h
//  DC_iOS
//
//  Created by MonsterENT on 10/6/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VRTInstance;
@class Model4VRTView;
@interface VRTUtils : NSObject

+(UIColor*)getVRTColorFromDic:(NSDictionary*)dic;

+(NSTextAlignment)getTextAlignmentFromStr:(NSString*)str;

+(NSArray*)parseWithSuperView:(nullable Model4VRTView*)superView subViews:(NSArray<NSDictionary*>*)subViews;

+(void)parseCommonProperty:(NSDictionary*)jsView toModel:(Model4VRTView*)viewModel;

+(void)jsModelToNativeSuperView:(UIView*)superView subViews:(NSArray<Model4VRTView*>*)vrtViews compDelegate:(nullable VRTInstance*)vrtInstance;

+(void)parseModelToView:(UIView*)view vrtModel:(Model4VRTView*)vrtModel compDelegate:(nullable VRTInstance*)vrtInstance;

@end

NS_ASSUME_NONNULL_END
