//
//  VRTUtils.m
//  DC_iOS
//
//  Created by MonsterENT on 10/6/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import "VRTUtils.h"

#import "../VRTInstance.h"
#import "../VRTSDKMaster.h"

#import "../View/VRTImageView.h"
#import "../View/VRTLabel.h"
#import "../View/VRTList.h"
#import "../View/VRTTextField.h"
#import "../View/VRTView.h"

#import "../Model/Model4VRTTextField.h"

#import "../ViewModel/VM4VRTList.h"

#import "../VRTMacro.h"

#import "../Others/VRTMutableDictionary.h"
#import "../Others/VRTTapGestureRecognizer.h"

@implementation VRTUtils

+(UIColor*)getVRTColorFromDic:(NSDictionary*)dic
{
    CGFloat r = [VRT_SAFE_VALUE(dic[@"x"]) floatValue];
    CGFloat g = [VRT_SAFE_VALUE(dic[@"y"]) floatValue];
    CGFloat b = [VRT_SAFE_VALUE(dic[@"z"]) floatValue];
    CGFloat a = [VRT_SAFE_VALUE(dic[@"w"]) floatValue];
    
    if(isnan(r) || isnan(g) || isnan(b) || isnan(a))
        return nil;
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

+(NSTextAlignment)getTextAlignmentFromStr:(NSString*)str
{
    if([str isEqualToString:@"TextAlignmentCenter"])
    {
        return NSTextAlignmentCenter;
    }
    else if([str isEqualToString:@"TextAlignmentRight"])
    {
        return NSTextAlignmentRight;
    }
    
    return NSTextAlignmentLeft;
}


+(NSArray*)parseWithSuperView:(nullable Model4VRTView*)superView subViews:(NSArray<NSDictionary*>*)subViews
{
    
    NSMutableArray<Model4VRTView*>* viewArray = nil;
    for(NSDictionary* jsView in subViews)
    {
        Model4VRTView* view = nil;
        
        NSString* clsName = jsView[@"_clsName"];
        
        if([clsName isEqualToString:@"View"])
        {
            view = [Model4VRTView new];
        }
        else if([clsName isEqualToString:@"Label"])
        {
            view = [Model4VRTLabel new];
            ((Model4VRTLabel*)view).text = VRT_SAFE_VALUE(jsView[@"text"]);
            ((Model4VRTLabel*)view).fontSize = [jsView[@"fontSize"] unsignedIntegerValue] * 1.0f * kFontPx2PtScale;
            ((Model4VRTLabel*)view).textAlignment = VRT_SAFE_VALUE(jsView[@"textAlignment"]);
            ((Model4VRTLabel*)view).textColor = [VRTUtils getVRTColorFromDic:VRT_SAFE_VALUE(jsView[@"textColor"])];
        }
        else if([clsName isEqualToString:@"ImgView"])
        {
            view = [Model4VRTImageView new];
            ((Model4VRTImageView*)view).imageUrl = VRT_SAFE_VALUE(jsView[@"imageUrl"]);
        }
        else if([clsName isEqualToString:@"TextField"])
        {
            view = [Model4VRTTextField new];
            ((Model4VRTTextField*)view).text = VRT_SAFE_VALUE(jsView[@"text"]);
            ((Model4VRTTextField*)view).fontSize = [VRT_SAFE_VALUE(jsView[@"fontSize"]) unsignedIntegerValue] * 1.0f * kFontPx2PtScale;
            ((Model4VRTTextField*)view).textAlignment = VRT_SAFE_VALUE(jsView[@"textAlignment"]);
            ((Model4VRTTextField*)view).textColor = [VRTUtils getVRTColorFromDic:VRT_SAFE_VALUE(jsView[@"textColor"])];
        }
        else if([clsName isEqualToString:@"List"])
        {
            view = [Model4VRTList new];
        }
        
        if(view == nil)
            break;
        
        if(viewArray == nil)
            viewArray = [NSMutableArray array];
        
        [viewArray addObject:view];
        [VRTUtils parseCommonProperty:jsView toModel:view];
        
        view.subViews = [self parseWithSuperView:view subViews:VRT_SAFE_VALUE(jsView[@"subViews"])];
    }
    
    return [viewArray copy];
}

+(void)parseCommonProperty:(NSDictionary*)jsView toModel:(Model4VRTView*)viewModel
{
    viewModel.x = [VRT_SAFE_VALUE(jsView[@"_x"]) floatValue] * kWidthPx2PtScale;
    viewModel.y = [VRT_SAFE_VALUE(jsView[@"_y"]) floatValue] * kWidthPx2PtScale;
    viewModel.height = [VRT_SAFE_VALUE(jsView[@"_height"]) floatValue] * kWidthPx2PtScale;
    viewModel.width = [VRT_SAFE_VALUE(jsView[@"_width"]) floatValue] * kWidthPx2PtScale;
    viewModel.cornerRadius = [VRT_SAFE_VALUE(jsView[@"cornerRadius"]) floatValue] * kWidthPx2PtScale;
    viewModel.vrtId = [NSString stringWithFormat:@"%@",VRT_SAFE_VALUE(jsView[@"_vrtId"])];
    viewModel.enableUserInteraction = [VRT_SAFE_VALUE(jsView[@"_enabledUserInteraction"]) boolValue];
#warning TODO
    viewModel.superView = nil;
    
    viewModel.backgroundColor = [VRTUtils getVRTColorFromDic:VRT_SAFE_VALUE(jsView[@"backgroundColor"])];
}


+(void)jsModelToNativeSuperView:(UIView*)superView subViews:(NSArray<Model4VRTView*>*)vrtViews compDelegate:(nullable VRTInstance*)vrtInstance
{
    for(Model4VRTView* vrtView in vrtViews)
    {
        UIView* view = nil;
        
        if([vrtView isKindOfClass:[Model4VRTLabel class]])
        {
            view = [VRTLabel new];
        }
        else if([vrtView isKindOfClass:[Model4VRTImageView class]])
        {
            view = [VRTImageView new];
        }
        else if([vrtView isKindOfClass:[Model4VRTTextField class]])
        {
            view = [VRTTextField new];
        }
        else if([vrtView isKindOfClass:[Model4VRTList class]])
        {
            view = [VRTList new];
        }
        else if([vrtView isKindOfClass:[Model4VRTView class]])
        {
            view = [VRTView new];
        }
        
        if(!view)
        {
            continue;
        }
        
        if(vrtView.enableUserInteraction)
        {
            view.userInteractionEnabled = true;
            VRTTapGestureRecognizer* tap = [[VRTTapGestureRecognizer alloc]initWithTarget:vrtInstance action:@selector(tapClickFNCenter:)];
            tap.vrtId = vrtView.vrtId;
            [view addGestureRecognizer:tap];
        }
        
        [VRTUtils parseModelToView:view vrtModel:vrtView compDelegate:vrtInstance];
        
        [vrtInstance.vrtIdToViewCache setObject:view forKey:[NSString stringWithFormat:@"%@",vrtView.vrtId]];
        [superView addSubview:view];
        [self jsModelToNativeSuperView:view subViews:vrtView.subViews compDelegate:vrtInstance];
        
    }
}


+(void)parseModelToView:(UIView*)view vrtModel:(Model4VRTView*)vrtModel compDelegate:(nullable VRTInstance*)vrtInstance
{
    if(!vrtModel || !view)
    {
        return;
    }
    
    if([vrtModel isKindOfClass:[Model4VRTLabel class]])
    {
        ((VRTLabel*)view).text = ((Model4VRTLabel*)vrtModel).text;
        ((VRTLabel*)view).textAlignment = [VRTUtils getTextAlignmentFromStr:((Model4VRTLabel*)vrtModel).textAlignment];
        ((VRTLabel*)view).textColor = ((Model4VRTLabel*)vrtModel).textColor;
        ((VRTLabel*)view).font = [UIFont systemFontOfSize:((Model4VRTLabel*)vrtModel).fontSize];
    }
    else if([vrtModel isKindOfClass:[Model4VRTImageView class]])
    {
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds  = YES;
        if([((Model4VRTImageView*)vrtModel).imageUrl containsString:@"http"])
        {
            [[VRTSDKMaster shareInstance] _setImageWithUrl:((Model4VRTImageView*)vrtModel).imageUrl imageView:((VRTImageView*)view)];
        }
        else
        {
            [(VRTImageView*)view setImage:[UIImage imageNamed:((Model4VRTImageView*)vrtModel).imageUrl]];
        }
        
    }
    else if([vrtModel isKindOfClass:[Model4VRTTextField class]])
    {
        ((VRTTextField*)view).text = ((Model4VRTTextField*)vrtModel).text;
        ((VRTTextField*)view).textAlignment = [VRTUtils getTextAlignmentFromStr:((Model4VRTTextField*)vrtModel).textAlignment];
        ((VRTTextField*)view).textColor = ((Model4VRTTextField*)vrtModel).textColor;
        ((VRTTextField*)view).font = [UIFont systemFontOfSize:((Model4VRTTextField*)vrtModel).fontSize];
        ((VRTTextField*)view).vrt_delegate = (id<VRTTextFieldDelegate>)vrtInstance;
    }
    else if([vrtModel isKindOfClass:[Model4VRTList class]])
    {
        VM4VRTList* viewModel = [VM4VRTList new];
        viewModel.delegate = (id<VRTListDelegate>)vrtInstance;
        [vrtInstance.vrtListVMCache setObject:viewModel forKey:vrtModel.vrtId];
        viewModel.outsideIdToViewCacheDic = vrtInstance.vrtIdToViewCache;
        viewModel.targetTableView = (VRTList*)view;
        viewModel.vrtlistModel = (Model4VRTList*)vrtModel;
        ((VRTList*)view).delegateMEx = (id<TVMExDelegate>)viewModel;
    }
    else if([vrtModel isKindOfClass:[Model4VRTView class]])
    {
    }
    
    if([view respondsToSelector:@selector(setOriginModel:)])
    {
        [view setValue:vrtModel forKey:@"originModel"];
    }
    
    view.frame = CGRectMake(vrtModel.x, vrtModel.y, vrtModel.width, vrtModel.height);
    view.backgroundColor = vrtModel.backgroundColor;
    
    if(vrtModel.cornerRadius > 0)
    {
        view.layer.cornerRadius = vrtModel.cornerRadius;
        view.clipsToBounds = true;
    }
}

@end
