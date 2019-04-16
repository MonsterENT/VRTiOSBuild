//
//  VRTInstance.m
//  DC_iOS
//
//  Created by MonsterENT on 9/11/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import "VRTInstance.h"
#import "VRTSDKMaster.h"

#import <JavaScriptCore/JavaScriptCore.h>

#import "VRTMacro.h"

#import "View/VRTTextField.h"
#import "View/VRTList.h"
#import "View/VRTCell.h"

#import "ViewModel/VM4VRTList.h"

#import "Model/Model4VRTVC.h"
#import "Model/Model4VRTCell.h"

#import "Others/VRTTapGestureRecognizer.h"
#import "Others/VRTViewController.h"
#import "Others/VRTMutableDictionary.h"
#import "Others/VRTUtils.h"

@interface VRTInstance()<VRTListDelegate,VRTTextFieldDelegate>
@property(strong,nonatomic)JSContext* context;
@property(strong,nonatomic)NSDictionary* jsDic;

@property(strong,nonatomic)Model4VRTVC* jsVC;
@property(weak,nonatomic)UIViewController* targetVC;

@property(strong,nonatomic)JSManagedValue* basicCallBack,*listCompCallBack,*textFieldReturnCallBack,*httpResponseCallBack,*didSelectAlertActionCallBack;
@end

@implementation VRTInstance

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _vrtListVMCache = [VRTMutableDictionary new];
        _vrtIdToViewCache = [VRTMutableDictionary new];
        _param = @{};
        
        typeof(self) __weak weakSelf = self;
        [_vrtIdToViewCache setBlockWhenSetKey:^(id  _Nonnull key, id  _Nonnull obj) {
            UIView* view = obj;
            if([weakSelf.vrtClickCache containsObject:key] && [view isKindOfClass:[UIView class]])
            {
                if(view)
                {
                    view.userInteractionEnabled = true;
                    VRTTapGestureRecognizer* tap = [[VRTTapGestureRecognizer alloc]initWithTarget:weakSelf action:@selector(tapClickFNCenter:)];
                    
                    typeof(self) self = weakSelf;
                    NSAssert1([key isKindOfClass:[NSString class]], @"the key : %@ is not a string value", key);
                    tap.vrtId = key;
                    [view addGestureRecognizer:tap];
                }
            }
        }];
        _vrtClickCache = [NSMutableArray new];
        _context = [JSContext new];
        [self registerContextBlock];
    }
    return self;
}

-(void)excuteLocalJS:(NSString*)fileName onViewController:(UIViewController*)viewController
{
    _targetVC = viewController;
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    [_context evaluateScript:script];
    
    [self getJSContentCallBack];
}

-(void)excuteRemoteJS:(NSURL*)url onViewController:(UIViewController*)viewController
{
    _targetVC = viewController;
    _url = url.absoluteString;
    
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"VRTJSFramework" ofType:@"js"];
    NSString *frameworkJS = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString *script = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //        dispatch_async(dispatch_get_main_queue(), ^{
    [self.context evaluateScript:[frameworkJS stringByAppendingString:script]];
    [self getJSContentCallBack];
    //        });
    //    });
}

-(void)getJSContentCallBack
{
    _basicCallBack =  [JSManagedValue managedValueWithValue:_context[@"_api_responseBasicCallBack"] andOwner:self];
    NSAssert([_basicCallBack isKindOfClass:[JSManagedValue class]], @"_api_responseBasicCallBack error");
    
    _listCompCallBack = [JSManagedValue managedValueWithValue:_context[@"_api_responseListDidSelectRow"] andOwner:self];
    NSAssert([_listCompCallBack isKindOfClass:[JSManagedValue class]], @"_api_responseListDidSelectRow error");
    
    _textFieldReturnCallBack = [JSManagedValue managedValueWithValue:_context[@"_api_responseTextFieldReturn"] andOwner:self];
    NSAssert([_textFieldReturnCallBack isKindOfClass:[JSManagedValue class]], @"_api_responseTextFieldReturn error");
    
    _httpResponseCallBack = [JSManagedValue managedValueWithValue:_context[@"_api_httpResponse"] andOwner:self];
    NSAssert([_httpResponseCallBack isKindOfClass:[JSManagedValue class]], @"_api_httpResponse error");
    
    _didSelectAlertActionCallBack = [JSManagedValue managedValueWithValue:_context[@"_api_didSelectAlertAction"] andOwner:self];
    NSAssert([_didSelectAlertActionCallBack isKindOfClass:[JSManagedValue class]], @"_didSelectAlertActionCallBack error");
}

-(void)viewDidLoad_CallBack
{
    [_basicCallBack.value callWithArguments:@[[NSString stringWithFormat:@"%@CallBackViewDidLoad",_jsVC.vrtId]]];
}

-(void)viewWillAppear_CallBack
{
    [_basicCallBack.value callWithArguments:@[[NSString stringWithFormat:@"%@CallBackViewWillAppear",_jsVC.vrtId]]];
}

-(void)viewDidAppear_CallBack
{
    [_basicCallBack.value callWithArguments:@[[NSString stringWithFormat:@"%@CallBackViewDidAppear",_jsVC.vrtId]]];
}

-(void)viewWillDisappear_CallBack
{
    [_basicCallBack.value callWithArguments:@[[NSString stringWithFormat:@"%@CallBackViewWillDisappear",_jsVC.vrtId]]];
}

-(void)registerContextBlock
{
    typeof(self) __weak weakSelf = self;
    _context[@"api_commitVC"] = ^(JSValue* controller){
        if(controller)
        {
            weakSelf.jsDic = [controller toDictionary];
            [weakSelf parseJsDic];
        }
    };
    
    _context[@"api_refreshView"] = ^(NSString* vrtId,NSString* key,JSValue* value){
        id view = [weakSelf.vrtIdToViewCache objectForKey:vrtId];
        if(view && ![view isEqual:[NSNull null]])
        {
            [weakSelf refreshView:view withKey:key value:value];
        }
    };
    
    _context[@"api_refreshListData"] = ^(NSString* vrtId,NSNumber* numberOfSections,NSNumber* offset,NSNumber* length,NSDictionary* rowDataAtSection){
        id view = [weakSelf.vrtIdToViewCache objectForKey:vrtId];
        
        if([view isKindOfClass:[VRTList class]] && [numberOfSections isKindOfClass:[NSNumber class]] && [offset isKindOfClass:[NSNumber class]] && [length isKindOfClass:[NSNumber class]] && [rowDataAtSection isKindOfClass:[NSDictionary class]])
        {
            VM4VRTList* vm = [weakSelf.vrtListVMCache objectForKey:vrtId];
            vm.numberOfSections = [numberOfSections integerValue];
            [vm updateRowDataInSectionWithOffset:[offset intValue] length:[length intValue] dataDic:rowDataAtSection];
            [(VRTList*)view refreshClearRowCache];
        }
    };
    
    _context[@"api_platform"] =(NSString*)^(){
        return @"iOS";
    };
    
    _context[@"api_log"] = ^(NSString* logInfo){
        if([logInfo isKindOfClass:[NSString class]])
            NSLog(@"%@",logInfo);
    };
    
    _context[@"api_getBaseViewHeight"] = (NSNumber*)^(NSNumber* hasNavigationBar,NSNumber* hasTabBar){
        //        return @(weakSelf.targetVC.view.frame.size.height);
        CGFloat height = kScreen_Height;
        if([hasNavigationBar boolValue] == YES)
        {
            height -= [VRTSDKMaster shareInstance].statusBarHeight + [VRTSDKMaster shareInstance].naBarHeight;
        }
        if([hasTabBar boolValue] == YES)
        {
            height -= [VRTSDKMaster shareInstance].tabBarHeight;
        }
        return @(height);
    };
    
    _context[@"api_getBaseViewWidth"] = (NSNumber*)^(){
        return @(kScreen_Width);
    };
    
    _context[@"api_addViewClick"] = ^(NSString* vrtId){
        [weakSelf.vrtClickCache addObject:vrtId];
        UIView* view = [weakSelf.vrtIdToViewCache objectForKey:vrtId];
        if(view)
        {
            view.userInteractionEnabled = true;
            VRTTapGestureRecognizer* tap = [[VRTTapGestureRecognizer alloc]initWithTarget:weakSelf action:@selector(tapClickFNCenter:)];
            tap.vrtId = vrtId;
            [view addGestureRecognizer:tap];
        }
    };
    
    _context[@"api_httpRequest"] = ^(JSValue* httpRequest){
        NSDictionary* dic = [httpRequest toDictionary];
        
        NSString* url = VRT_SAFE_VALUE(dic[@"url"]);
        
        [[VRTSDKMaster shareInstance].httpAdapter postWithSubUrl:url param:VRT_SAFE_VALUE(dic[@"_param"]) block:^(id data, id info) {
            if(data)
            {
                [weakSelf.httpResponseCallBack.value callWithArguments:@[url,data,info==nil?@"":info]];
            }
        }];
    };
    
    _context[@"api_getThisNavigationComp"] = (NSDictionary*)^(){
        return @{@"url":weakSelf.url==nil?@"":weakSelf.url};
    };
    
    _context[@"api_pushUrlWithParam"] = ^(NSString* url,NSDictionary* param){
        if(![url isKindOfClass:[NSString class]] || ![param isKindOfClass:[NSDictionary class]])
            return ;
        VRTViewController* vc = [VRTViewController new];
        vc.url = url;
        vc.param = param;
        [vc push];
    };
    
    _context[@"api_popThis"] = ^(){
        [[ControllerManagerMEx shareInstance]PopControllerNamed:weakSelf.url];
    };
    
    _context[@"api_getPushedParam"] = (NSDictionary*)^(){
        return weakSelf.param;
    };
    
    
    _context[@"api_showAlert"] = ^(JSValue* alert){
        [weakSelf showAlertWithDic:[alert toDictionary]];
    };
    
    _context[@"api_dispatchWithAnimation"] = ^(NSNumber* duration,JSValue* func){
        if(![duration isKindOfClass:[NSNumber class]])
            return ;
        if(![func isKindOfClass:[JSValue class]])
            return ;
        NSTimeInterval _duration = [duration doubleValue];
        [UIView animateWithDuration:_duration animations:^{
            [func callWithArguments:nil];
        }];
    };
}

-(void)showAlertWithDic:(NSDictionary*)jsDic
{
    NSString* title = VRT_SAFE_VALUE(jsDic[@"title"]);
    NSString* msg = VRT_SAFE_VALUE(jsDic[@"msg"]);
    
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    NSArray* actions = VRT_SAFE_VALUE(jsDic[@"_actions"]);
    if([actions isKindOfClass:[NSArray class]])
    {
        for(NSDictionary* actionDic in actions)
        {
            typeof(self) __weak weakSelf = self;
            NSString* acId = VRT_SAFE_VALUE(actionDic[@"_acId"]);
            NSString* title = VRT_SAFE_VALUE(actionDic[@"title"]);
            UIAlertAction* action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.didSelectAlertActionCallBack.value callWithArguments:@[acId==nil?@"":acId]];
            }];
            
            [ac addAction:action];
        }
    }
    
    [[ControllerManagerMEx shareInstance].currentDisplayController presentViewController:ac animated:true completion:nil];
}

-(void)refreshView:(UIView*)view withKey:(NSString*)key value:(JSValue*)value
{
    if([key isEqualToString:@"_x"])
    {
        double x = [value toDouble];
        if(isnan(x))
            return;
        CGRect originFrame = view.frame;
        view.frame = CGRectMake(x, originFrame.origin.y, originFrame.size.width, originFrame.size.height);
    }
    else if([key isEqualToString:@"_y"])
    {
        double y = [value toDouble];
        if(isnan(y))
            return;
        CGRect originFrame = view.frame;
        view.frame = CGRectMake(originFrame.origin.x, y, originFrame.size.width, originFrame.size.height);
    }
    else if([key isEqualToString:@"_height"])
    {
        double height = [value toDouble];
        if(isnan(height))
            return;
        CGRect originFrame = view.frame;
        view.frame = CGRectMake(originFrame.origin.x, originFrame.origin.y, originFrame.size.width, height);
    }
    else if([key isEqualToString:@"_width"])
    {
        double width = [value toDouble];
        if(isnan(width))
            return;
        CGRect originFrame = view.frame;
        view.frame = CGRectMake(originFrame.origin.x, originFrame.origin.y, width, originFrame.size.height);
    }
    else if([key isEqualToString:@"backgroundColor"])
    {
        if([view respondsToSelector:NSSelectorFromString(key)])
        {
            NSDictionary* dic = [value toDictionary];
            view.backgroundColor = [VRTUtils getVRTColorFromDic:dic];
        }
    }
    else if([key isEqualToString:@"cornerRadius"])
    {
        if([view.layer respondsToSelector:NSSelectorFromString(key)])
        {
            double cornerRadius = [value toDouble];
            if(isnan(cornerRadius))
                return;
            if(cornerRadius > 0)
            {
                view.layer.cornerRadius = cornerRadius;
                view.clipsToBounds = true;
            }
        }
    }
    else if([key isEqualToString:@"text"])
    {
        if([view respondsToSelector:NSSelectorFromString(key)])
            [view setValue:[value toString] forKey:@"text"];
    }
    else if([key isEqualToString:@"fontSize"])
    {
        if([view respondsToSelector:NSSelectorFromString(@"font")])
        {
            double fontSize = [value toDouble];
            if(isnan(fontSize))
                return;
            [view setValue:[UIFont systemFontOfSize:fontSize] forKey:@"font"];
        }
    }
    else if([key isEqualToString:@"textColor"])
    {
        if([view respondsToSelector:NSSelectorFromString(key)])
        {
            NSDictionary* dic = [value toDictionary];
            [view setValue:[VRTUtils getVRTColorFromDic:dic] forKey:@"textColor"];
        }
    }
    else if([key isEqualToString:@"numberOfLines"])
    {
        if([view respondsToSelector:NSSelectorFromString(key)])
        {
            NSUInteger numberOfLines = [value toUInt32];
            if(isnan(numberOfLines) || ![view isKindOfClass:[UILabel class]])
                return;
            ((UILabel*)view).numberOfLines = numberOfLines;
        }
    }
    else if([key isEqualToString:@"imageUrl"])
    {
        if([view isKindOfClass:[UIImageView class]])
        {
            NSString* imgUrl = [value toString];
            [[VRTSDKMaster shareInstance] _setImageWithUrl:imgUrl imageView:(UIImageView*)view];
        }
    }
    else if([key isEqualToString:@"textAlignment"])
    {
        if([view respondsToSelector:NSSelectorFromString(key)])
        {
            NSString* textAlignmentStr = [value toString];
            if([textAlignmentStr isKindOfClass:[NSString class]])
                ((UILabel*)view).textAlignment = [VRTUtils getTextAlignmentFromStr:[value toString]];
        }
    }
    
}

-(void)parseJsDic
{
    if(!_jsDic)
    {
        return;
    }
    _jsVC = [Model4VRTVC new];
    _jsVC.title = VRT_SAFE_VALUE(self.jsDic[@"title"]);
    _jsVC.vrtId = VRT_SAFE_VALUE(self.jsDic[@"_vrtId"]);
    _jsVC.view = [VRTUtils parseWithSuperView:nil subViews:@[self.jsDic[@"view"]]][0];
    
    _targetVC.view.backgroundColor = _jsVC.view.backgroundColor;
    [_vrtIdToViewCache setObject:_targetVC.view forKey:[NSString stringWithFormat:@"%@",_jsVC.view.vrtId]];
    [VRTUtils jsModelToNativeSuperView:_targetVC.view subViews:_jsVC.view.subViews compDelegate:self];
}



-(void)tapClickFNCenter:(VRTTapGestureRecognizer*)tapGr
{
    NSString* vrtId = tapGr.vrtId;
    if(vrtId)
    {
        [_basicCallBack.value callWithArguments:@[vrtId]];
    }
}


#pragma mark VRTListDelegate
-(void)vrtListDidSelectRowAtIndexPath:(NSIndexPath *)indexPath vrtId:(NSString*)vrtId
{
    [_listCompCallBack.value callWithArguments:@[[NSString stringWithFormat:@"%@CallBackDidSelectRowAtIndexPath",vrtId],@(indexPath.section),@(indexPath.row)]];
}

#pragma mark VRTTextFieldDelegate
-(void)vrtTextFieldShouldReturn:(NSString *)text vrtId:(NSString *)vrtId
{
    [_textFieldReturnCallBack.value callWithArguments:@[[NSString stringWithFormat:@"%@CallBackDidReturn",vrtId],text]];
}
@end
