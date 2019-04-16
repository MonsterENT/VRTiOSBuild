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
@property(copy,nonatomic)NSMutableDictionary* rowDataInSection;
@end

@implementation VM4VRTList

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _numberOfSections = 0;
        _rowDataInSection = [NSMutableDictionary new];
    }
    return self;
}

-(void)updateRowDataInSectionWithOffset:(int)offset length:(int)length dataDic:(NSDictionary*)dataDic
{
    NSMutableDictionary* tmpDic = [NSMutableDictionary new];
    if(offset < 0)
    {
        for(NSString* key in dataDic.allKeys)
        {
            NSArray* rowDatas = dataDic[key];
            if(![rowDatas isKindOfClass:[NSArray class]])
            {
                continue;
            }
            NSMutableArray* rowDataResolved = [NSMutableArray new];
            for(NSDictionary* dic in rowDatas)
            {
                if(![dic isKindOfClass:[NSDictionary class]])
                {
                    continue;
                }
                if([VRT_SAFE_VALUE([dic objectForKey:@"_clsName"]) isEqualToString:@"Cell"])
                {
                    Model4VRTCell* cellModel = [Model4VRTCell new];
                    [VRTUtils parseCommonProperty:dic toModel:cellModel];
                    cellModel.subViews = [VRTUtils parseWithSuperView:cellModel subViews:VRT_SAFE_VALUE([dic objectForKey:@"subViews"])];
                    [rowDataResolved addObject:cellModel];
                }
            }
            [tmpDic setObject:rowDataResolved forKey:key];
        }
    }
    else
    {
        NSString* key = [NSString stringWithFormat:@"%d", offset];
        NSArray* rowDatas = dataDic[key];
        if([rowDatas isKindOfClass:[NSArray class]])
        {
            NSMutableArray* rowDataResolved = [NSMutableArray new];
            for(NSDictionary* dic in rowDatas)
            {
                if([dic isKindOfClass:[NSDictionary class]])
                {
                    if([VRT_SAFE_VALUE([dic objectForKey:@"_clsName"]) isEqualToString:@"Cell"])
                    {
                        Model4VRTCell* cellModel = [Model4VRTCell new];
                        [VRTUtils parseCommonProperty:dic toModel:cellModel];
                        cellModel.subViews = [VRTUtils parseWithSuperView:cellModel subViews:VRT_SAFE_VALUE([dic objectForKey:@"subViews"])];
                        [rowDataResolved addObject:cellModel];
                    }
                }
            }
            [tmpDic setObject:rowDataResolved forKey:key];
        }
    }
    _rowDataInSection = [tmpDic copy];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    NSInteger tmpCount = _vrtlistModel.dataSource.allKeys.count;
    //    tmpCount = tmpCount > 1 ? tmpCount-1 : 0;
    return _numberOfSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* rowData = _rowDataInSection[[NSString stringWithFormat:@"%ld",(long)section]];
    if([rowData isKindOfClass:[NSArray class]])
    {
        return [rowData count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VRTCell* cell = [tableView dequeueReusableCellWithIdentifier:@"vrtReuseCellId"];
    
    NSArray* rowData = _rowDataInSection[[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    Model4VRTCell* cellModel = rowData[indexPath.row];
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
