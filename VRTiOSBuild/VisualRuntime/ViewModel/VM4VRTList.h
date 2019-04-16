//
//  VM4VRTList.h
//  DC_iOS
//
//  Created by MonsterENT on 10/3/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VRTMutableDictionary;
@class VRTList;

@class Model4VRTList;
@class Model4VRTCell;

NS_ASSUME_NONNULL_BEGIN
@protocol VRTListDelegate <NSObject>

-(void)vrtListDidSelectRowAtIndexPath:(NSIndexPath*)indexPath vrtId:(NSString*)vrtId;

//-(void)vrtListCallBackCommitCellAtIndexPath:(NSIndexPath*)indexPath vrtId:(NSString*)vrtId;
@end

@class VRTMutableDictionary;
@class VRTList;

@interface VM4VRTList : NSObject

@property(weak,nonatomic)VRTList* targetTableView;

@property(strong,nonatomic)Model4VRTList* vrtlistModel;

@property(assign,nonatomic)NSInteger numberOfSections;

@property(weak,nonatomic)VRTMutableDictionary* outsideIdToViewCacheDic;

@property(weak,nonatomic)id<VRTListDelegate> delegate;

-(void)updateRowDataInSectionWithOffset:(int)offset length:(int)length dataDic:(NSDictionary*)dataDic;
@end

NS_ASSUME_NONNULL_END
