//
//  TableViewMEx.h
//  mayoung
//
//  Created by MonsterENT on 5/7/18.
//  Copyright © 2018 lab205. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TVMExDelegate <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@required

@optional
- (void)tableViewMEx:(UITableView *)tableView deleteCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TableViewMEx : UITableView

@property(copy,nonatomic)NSString* name;

@property(assign)BOOL allowDelete;
@property(assign)BOOL tranportNextResponse;

@property(weak,nonatomic)id<TVMExDelegate> delegateMEx;

-(void)addMExDelegate:(id<TVMExDelegate>)delegate;

-(void)refresh;
-(void)refreshClearRowCache;
-(void)refreshWithEndType:(NSUInteger)endType;

-(UITableViewCell*)getCellByIndex:(NSIndexPath*)indexPath;
-(CGFloat)getHeightAtIndexPath:(NSIndexPath *)indexPath withReuserId:(NSString *)reuseId;

-(void)setupMJRefreshWithTarget:(id)target resetSEL:(SEL)resetSel nextSEL:(SEL)nextSel;

-(void)setupMJHeaderWithTargetM:(id)target sel:(SEL)sel pullAlert:(NSString*)pullAlert;
-(void)setupMJFooterWithTargetM:(id)target sel:(SEL)sel pullAlert:(NSString*)pullAlert;

@end
