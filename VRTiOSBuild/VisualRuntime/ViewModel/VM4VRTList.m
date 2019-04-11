//
//  VM4VRTList.m
//  DC_iOS
//
//  Created by MonsterENT on 10/3/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import "VM4VRTList.h"
#import "../View/VRTCell.h"
#import "../Others/VRTMutableDictionary.h"

#import "../Others/VRTUtils.h"

#import "../VRTMacro.h"

#import "../Model/Model4VRTList.h"
#import "../Model/Model4VRTCell.h"

@interface VM4VRTList()<TVMExDelegate>

@end

@implementation VM4VRTList

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _numberOfSections = 0;
        _numberOfRowsInSection = @{};
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    NSInteger tmpCount = _vrtlistModel.dataSource.allKeys.count;
    //    tmpCount = tmpCount > 1 ? tmpCount-1 : 0;
    return _numberOfSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber* count = _numberOfRowsInSection[[NSString stringWithFormat:@"%ld",(long)section]];
    if([count isKindOfClass:[NSNumber class]])
        return [count integerValue];
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    VRTCell* cell = [tableView dequeueReusableCellWithIdentifier:@"vrtReuseCellId"];
    
    [_delegate vrtListCallBackCommitCellAtIndexPath:indexPath vrtId:self.vrtlistModel.vrtId];
    Model4VRTCell* cellModel = [_delegate getCommitedCell];
    NSAssert(cellModel != nil, @"cellModel can not be nil");
    
    if(!cell)
    {
        cell = [[VRTCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"vrtReuseCellId"];
        [VRTUtils jsModelToNativeSuperView:cell subViews:cellModel.subViews compDelegate:nil];
    }
    else
    {
        NSDictionary* restoredCache = [[self resotreModels:cellModel.subViews perDic:nil] copy];
        for(UIView* view in cell.subviews)
        {
            if([view respondsToSelector:@selector(originModel)])
            {
                Model4VRTView* model = [view valueForKey:@"originModel"];
                [VRTUtils parseModelToView:view vrtModel:VRT_SAFE_VALUE(restoredCache[model.vrtId]) compDelegate:nil];
            }
        }
    }
    
    cell.defaultHeight_MEx = @(cellModel.height);
    cell.backgroundColor = cellModel.backgroundColor;
    cell.clipsToBounds = true;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate vrtListDidSelectRowAtIndexPath:indexPath vrtId:self.vrtlistModel.vrtId];
}


-(NSDictionary*)resotreModels:(NSArray<Model4VRTView*>*)models perDic:(NSMutableDictionary*)dic
{
    if(!dic)
        dic = [NSMutableDictionary dictionary];
    
    for(Model4VRTView* model in models)
    {
        [dic setObject:model forKey:model.vrtId];
        [self resotreModels:model.subViews perDic:dic];
    }
    
    return dic;
}

@end
