//
//  TVCBindHelperMEx.m
//  C_Class_iOS
//
//  Created by MonsterENT on 12/5/17.
//  Copyright © 2017 MonsterENT. All rights reserved.
//

#import "TVCBindHelperMEx.h"
#import "../SafeCallBack/NSObject+ProtocolHelper.h"

@interface TVCBindHelperMEx()<TVMExDelegate>

@property(copy,nonatomic)NSString* cellClassStr;
@property(weak,nonatomic)TableViewMEx* target;
@end

@implementation TVCBindHelperMEx

-(instancetype)initBinderWithTVC:(TableViewMEx*)tableView cellClass:(NSString*)cellClass
{
    self = [super init];
    if(self)
    {
        tableView.delegateMEx = self;
        _target = tableView;
        _cellClassStr = cellClass;
        _noReuse = false;
    }
    return self;
}

-(void)didSelectedCellAtIndexPath:(NSIndexPath*)indexPath
{
    if(_target)
        [[[_target visibleCells] objectAtIndex:indexPath.row] setSelected:true animated:true];
}

#pragma mark TVC
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([_delegate respondsToSelector:@selector(dataSource4BindHelperWithTag:)])
    {
        return [[_delegate dataSource4BindHelperWithTag:self.tag] count];
    }
    else if([_delegate respondsToSelector:@selector(dataSource4BindHelper)])
        return [[_delegate dataSource4BindHelper] count];
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    
    if([_delegate respondsToSelector:@selector(currentCellClassWithIndexPath:)])
    {
        _cellClassStr = [_delegate currentCellClassWithIndexPath:indexPath];
    }
    
    if([_delegate respondsToSelector:@selector(currentReuseControl)])
    {
        _noReuse = ![_delegate currentReuseControl];
    }
    
    NSString* cellId;
    if(_noReuse)
    {
        cellId = [NSString stringWithFormat:@"%@ %ld",_cellClassStr,(long)indexPath.row];
    }
    else
        cellId = _cellClassStr;
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[NSClassFromString(_cellClassStr) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    id VM = nil;
    if([_delegate respondsToSelector:@selector(dataSource4BindHelperWithTag:)])
    {
        VM = [[_delegate dataSource4BindHelperWithTag:self.tag] objectAtIndex:indexPath.row];
    }
    else if([_delegate respondsToSelector:@selector(dataSource4BindHelper)])
        VM = [[_delegate dataSource4BindHelper] objectAtIndex:indexPath.row]; 
    
    SEL setter = NSSelectorFromString(@"setViewModel:");
    [cell SafeCALLBACK:setter withObj:VM];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(id)_delegate SafeCALLBACK:@selector(tableViewBinderHelper:didSelectRowAtIndexPath:) withObj:tableView andObj:indexPath];
}

-(void)tableViewDidScroll:(UIScrollView *)scrollView
{
    [(id)_delegate SafeCALLBACK:@selector(tableViewBinderHelperDidScroll:) withObj:scrollView];
}
@end
