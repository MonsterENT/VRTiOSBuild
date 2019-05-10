//
//  TableViewMEx.m
//  mayoung
//
//  Created by MonsterENT on 5/7/18.
//  Copyright © 2018 lab205. All rights reserved.
//

#import "TableViewMEx.h"
#import "NSObject+ProtocolHelper.h"

#define PACK_rowHeight @"rowHeight"
#define PACK_reuseID @"reuseId"

@interface TableViewMEx()<UITableViewDelegate,UITableViewDataSource,CellMExDelegate>

@property(strong,nonatomic)NSMutableArray<NSMutableDictionary*>* rowHeightArray_S;
@property(strong,nonatomic)WeakMutableArray* delegateArray;

@end

@implementation TableViewMEx

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _allowDelete = false;
        _tranportNextResponse = false;
        _delegateArray = [WeakMutableArray new];
        _rowHeightArray_S  = [NSMutableArray new];
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}


-(void)addMExDelegate:(id<TVMExDelegate>)delegate
{
    [self.delegateArray addObject:delegate];
}

-(void)refresh
{
    [self reloadData];
}
-(void)refreshClearRowCache
{
    [self.rowHeightArray_S removeAllObjects];
    [self reloadData];
}

-(void)refreshWithEndType:(NSUInteger)endType
{
    //    type_Header_unKnow =1,
    //    type_Header_noMore =2,
    //
    //    type_Footer_unKnow =10,
    //    type_Footer_noMore =11,
    //
    //    type_None = 20,
//    if(endType == type_None)
//    {
//        [self.mj_header endRefreshing];
//        [self.mj_footer endRefreshing];
//        [self refresh];
//    }
//    else if(endType == type_Header_noMore)
//    {
//        [self.mj_header endRefreshing];
//        [self.mj_footer endRefreshingWithNoMoreData];
//        [self refreshClearRowCache];
//    }
//    else if(endType == type_Header_unKnow)
//    {
//        [self.mj_header endRefreshing];
//        [self.mj_footer endRefreshing];
//        [self refreshClearRowCache];
//    }
//    else if(endType == type_Footer_noMore)
//    {
//        [self.mj_header endRefreshing];
//        [self.mj_footer endRefreshingWithNoMoreData];
//        [self refresh];
//    }
//    else if(endType == type_Footer_unKnow)
//    {
//        [self.mj_header endRefreshing];
//        [self.mj_footer endRefreshing];
//        [self refresh];
//    }
//
}

-(UITableViewCell*)getCellByIndex:(NSIndexPath*)indexPath
{
    for(UITableViewCell* cell in self.visibleCells)
    {
        if(cell.indexPath.row == indexPath.row && cell.indexPath.section == indexPath.section)
            return cell;
    }
    return nil;
}


-(void)setupMJRefreshWithTarget:(id)target resetSEL:(SEL)resetSel nextSEL:(SEL)nextSel
{
//    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:resetSel];
//    [header setTitle:@"下拉更新" forState: MJRefreshStateIdle];
//    [header setTitle:@"松手更新" forState: MJRefreshStatePulling];
//    [header setTitle:@"更新中" forState: MJRefreshStateRefreshing];
//
//    MJRefreshAutoNormalFooter* footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:nextSel];
//    [footer setTitle:@"上拉加载更多" forState: MJRefreshStateIdle];
//    [footer setTitle:@"加载中" forState: MJRefreshStateRefreshing];
//    [footer setTitle:@"没有更多的数据" forState:MJRefreshStateNoMoreData];
//
//    self.mj_header = header;
//    self.mj_footer = footer;
}

-(void)setupMJHeaderWithTargetM:(id)target sel:(SEL)sel pullAlert:(NSString*)pullAlert
{
//    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:sel];
//    [header setTitle:pullAlert forState: MJRefreshStateIdle];
//    [header setTitle:pullAlert forState: MJRefreshStatePulling];
//    [header setTitle:pullAlert forState: MJRefreshStateRefreshing];
//    self.mj_header = header;
}
-(void)setupMJFooterWithTargetM:(id)target sel:(SEL)sel pullAlert:(NSString*)pullAlert
{
//    MJRefreshAutoNormalFooter* footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:sel];
//    [footer setTitle:pullAlert forState: MJRefreshStateIdle];
//    [footer setTitle:pullAlert forState: MJRefreshStateRefreshing];
//    [footer setTitle:pullAlert forState:MJRefreshStateNoMoreData];
//    self.mj_footer = footer;
}


-(NSNumber*)validHeightAtIndexPath:(NSIndexPath*)indexPath reuseId:(NSString*)reuseId
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section < [_rowHeightArray_S count])
    {
        NSMutableDictionary* curSection = [_rowHeightArray_S objectAtIndex:section];
        NSDictionary* rowDic = [curSection objectForKey:@(row)];
        if(rowDic)
        {
            if(!reuseId)
            {
                return [rowDic objectForKey:PACK_rowHeight];
            }
            if([[rowDic objectForKey:PACK_reuseID] isEqualToString:reuseId])
                return [rowDic objectForKey:PACK_rowHeight];
            else
                return nil;
        }
    }
    return nil;
}


#pragma mark CellMonsterEx delegate

-(void)enableHeightDynamic:(CGFloat)rowHeight indexPath:(NSIndexPath *)indexPath reuseId:(NSString*)reuseId
{
    NSMutableDictionary* curSectionLine = [_rowHeightArray_S objectAtIndex:indexPath.section];
    [curSectionLine setObject:@{
                                PACK_reuseID:reuseId,
                                PACK_rowHeight:@(rowHeight)
                                } forKey:@(indexPath.row)];
    
}

-(CGFloat)getHeightAtIndexPath:(NSIndexPath *)indexPath withReuserId:(NSString *)reuseId
{
    NSNumber* tempHeight = [self validHeightAtIndexPath:indexPath reuseId:reuseId];
    if(!tempHeight)
        return -1;
    else
        return [tempHeight floatValue];
}

-(BOOL)isAllowTranportNextResponse
{
    return _tranportNextResponse;
}

#pragma UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numSection;
    if([_delegateMEx respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        numSection = [_delegateMEx numberOfSectionsInTableView:tableView];
    }
    else
        numSection = 1;
    
    if(numSection > self.rowHeightArray_S.count)
    {
        for(int i =0;i<numSection;i++)
        {
            NSMutableDictionary* rowHeightLine = [NSMutableDictionary new];
            [self.rowHeightArray_S addObject:rowHeightLine];
        }
    }
    return numSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_delegateMEx tableView:tableView numberOfRowsInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber* height = [self validHeightAtIndexPath:indexPath reuseId:nil];
    if(height)
    {
//        NSLog(@"TVC heightForRowAtIndexPath");
        return [height floatValue];
    }
//    NSLog(@"TVC heightForRowAtIndexPath NULL Height");
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"TVC cellForRowAtIndexPath");
    UITableViewCell * cell = [_delegateMEx tableView:tableView cellForRowAtIndexPath:indexPath];
    
    [cell setIndexPath:indexPath];
    [cell setPrivateMExDelegate:self];
    
    if(![self validHeightAtIndexPath:indexPath reuseId:cell.reuseIdentifier])
    {
        [self enableHeightDynamic:[cell heightAtIndexPath:indexPath] indexPath:indexPath reuseId:cell.reuseIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(id)_delegateMEx SafeCALLBACK:@selector(tableView:didSelectRowAtIndexPath:) withObj:tableView andObj:indexPath];
    
    for(id<TVMExDelegate> delegate in _delegateArray.allObjects)
    {
        [(id)delegate SafeCALLBACK:@selector(tableView:didSelectRowAtIndexPath:) withObj:tableView andObj:indexPath];
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(id)_delegateMEx SafeCALLBACK:@selector(tableView:willDisplayCell:forRowAtIndexPath:) withObjs:@[tableView,cell,indexPath]];
    
    for(id<TVMExDelegate> delegate in _delegateArray.allObjects)
    {
        [(id)delegate SafeCALLBACK:@selector(tableView:willDisplayCell:forRowAtIndexPath:) withObjs:@[tableView,cell,indexPath]];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([_delegateMEx respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
    {
        return [_delegateMEx tableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([_delegateMEx respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
    {
        return [_delegateMEx tableView:tableView heightForHeaderInSection:section];
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(_delegateMEx && [_delegateMEx respondsToSelector:@selector(tableView:viewForFooterInSection:)])
    {
        return [_delegateMEx tableView:tableView viewForFooterInSection:section];
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(_delegateMEx && [_delegateMEx respondsToSelector:@selector(tableView:heightForFooterInSection:)])
    {
        return [_delegateMEx tableView:tableView heightForFooterInSection:section];
    }
    return 0;
}




-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [(id)_delegateMEx SafeCALLBACK:@selector(scrollViewDidScroll:) withObj:scrollView];
    
    for(id<TVMExDelegate> delegate in _delegateArray.allObjects)
    {
        [(id)delegate SafeCALLBACK:@selector(scrollViewDidScroll:) withObj:scrollView];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [(id)_delegateMEx SafeCALLBACK:@selector(scrollViewDidEndScrollingAnimation:) withObj:scrollView];
    
    for(id<TVMExDelegate> delegate in _delegateArray.allObjects)
    {
        [(id)delegate SafeCALLBACK:@selector(scrollViewDidEndScrollingAnimation:) withObj:scrollView];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.allowDelete;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if([_delegateMEx respondsToSelector:@selector(tableViewMEx:deleteCellAtIndexPath:)])
        {
            [_delegateMEx tableViewMEx:tableView deleteCellAtIndexPath:indexPath];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


-(void)dealloc
{
//    NSLog(@"TableViewMEx dealloc %@",self.name);
}

#pragma private
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if(_tranportNextResponse)
        [self.nextResponder touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if(_tranportNextResponse)
        [self.nextResponder touchesEnded:touches withEvent:event];
}

@end
