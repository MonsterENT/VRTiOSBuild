//
//  UITableViewCell+MonsterEx.h
//  Cycle
//
//  Created by MonsterENT on 8/27/17.
//  Copyright © 2017 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "TableViewMEx.h"
//private
@protocol CellMExDelegate <NSObject>

-(void)enableHeightDynamic:(CGFloat)rowHeight indexPath:(NSIndexPath*)indexPath reuseId:(NSString*)reuseId;
-(CGFloat)getHeightAtIndexPath:(NSIndexPath*)indexPath withReuserId:(NSString*)reuseId;
-(BOOL)isAllowTranportNextResponse;

@end
//


@protocol CellMExCommonDelegate <NSObject>

@optional
-(void)DeleteOfflineCellWithIndex:(NSIndexPath*)index;

@end

@interface UITableViewCell (MEx)



@property(weak,nonatomic)NSIndexPath* indexPath;

@property(strong,nonatomic)id<CellMExDelegate> privateMExDelegate;

@property(strong,nonatomic)id<CellMExCommonDelegate> commonDelegateMEx;

//-(void)enableHeight:(CGFloat)height;
-(void)enableHeightDynamic:(CGFloat)height;
-(CGFloat)getCacheHeightAtIndexPath:(NSIndexPath*)indexPath;

@property(nonatomic)NSNumber* defaultHeight_MEx;
-(CGFloat)heightAtIndexPath:(NSIndexPath*)indexPath;

-(void)heightCacheClear;
@end
