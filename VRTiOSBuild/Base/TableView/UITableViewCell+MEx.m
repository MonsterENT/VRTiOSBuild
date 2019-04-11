//
//  UITableViewCell+MonsterEx.m
//  Cycle
//
//  Created by MonsterENT on 8/27/17.
//  Copyright © 2017 Monster. All rights reserved.
//

#import "UITableViewCell+MEx.h"
@interface UITableViewCell()

@end


@implementation UITableViewCell (MEx)

-(id<CellMExDelegate>)privateMExDelegate
{
    return objc_getAssociatedObject(self,@"MonsterExdelegate");
}
-(void)setPrivateMExDelegate:(id<CellMExDelegate>)MonsterExdelegate
{
    objc_setAssociatedObject(self, @"MonsterExdelegate", MonsterExdelegate, OBJC_ASSOCIATION_ASSIGN);
}

-(id<CellMExCommonDelegate>)commonDelegateMEx
{
    return objc_getAssociatedObject(self,@"MExCommonDelegate");
}
-(void)setCommonDelegateMEx:(id<CellMExDelegate>)MExCommonDelegate
{
    objc_setAssociatedObject(self, @"MExCommonDelegate", MExCommonDelegate, OBJC_ASSOCIATION_ASSIGN);
}

//-(NSNumber*)rowHeight
//{
//    return objc_getAssociatedObject(self, @"rowHeight");
//}
//-(void)setRowHeight:(NSNumber *)rowHeight
//{
//    objc_setAssociatedObject(self, @"rowHeight", rowHeight, OBJC_ASSOCIATION_COPY);
//}

-(void)enableHeightDynamic:(CGFloat)height
{
    CGFloat tempHeight = [(TableViewMEx*)self.privateMExDelegate getHeightAtIndexPath:self.indexPath withReuserId:self.reuseIdentifier];
    if(fabs(height - tempHeight) > 0.01)
    {
        if (@available(iOS 11.0, *)) {
            [(UITableView*)self.privateMExDelegate performBatchUpdates:^{
                [self.privateMExDelegate enableHeightDynamic:height indexPath:self.indexPath reuseId:self.reuseIdentifier];
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [(UITableView*)self.privateMExDelegate beginUpdates];
            [self.privateMExDelegate enableHeightDynamic:height indexPath:self.indexPath reuseId:self.reuseIdentifier];
            [(UITableView*)self.privateMExDelegate endUpdates];
        }
        
    }
}

-(CGFloat)getCacheHeightAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.privateMExDelegate getHeightAtIndexPath:indexPath withReuserId:self.reuseIdentifier];
}

//-(void)setSuperTableView:(UITableView*)tableView IndexPath:(NSIndexPath*)indexPath
//{
//    self.tableView = tableView;
//    self.indexPath = indexPath;
//}

//-(UITableView *)tableView
//{
//    return objc_getAssociatedObject(self, @"tableView");
//}
//
//-(void)setTableView:(UITableView *)tableView
//{
//    objc_setAssociatedObject(self, @"tableView", tableView, OBJC_ASSOCIATION_ASSIGN);
//}

-(NSIndexPath *)indexPath
{
    return objc_getAssociatedObject(self, @"indexPath");
}

-(void)setIndexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self, @"indexPath", indexPath, OBJC_ASSOCIATION_COPY);
}

-(void)setDefaultHeight_MEx:(NSNumber*)defaultHeight_MEx
{
    objc_setAssociatedObject(self, @"defaultHeight_MEx", defaultHeight_MEx, OBJC_ASSOCIATION_COPY);
}

-(NSNumber*)defaultHeight_MEx
{
    return objc_getAssociatedObject(self, @"defaultHeight_MEx");
}

-(CGFloat)heightAtIndexPath:(NSIndexPath*)indexPath
{
    return [[self defaultHeight_MEx] floatValue];
}

-(void)heightCacheClear
{
    [self.privateMExDelegate enableHeightDynamic:0 indexPath:self.indexPath reuseId:@""];
}

-(void)dealloc
{
    NSLog(@"%@ dealloc %p",self.reuseIdentifier,self);
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if([self.privateMExDelegate isAllowTranportNextResponse])
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
}
@end

