//
//  TVCBindHelperMEx.h
//  C_Class_iOS
//
//  Created by MonsterENT on 12/5/17.
//  Copyright © 2017 MonsterENT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewMEx.h"
@protocol BindHelperMExDelegate<NSObject>

@required



@optional
-(NSArray*)dataSource4BindHelper;//在同时处理多个tableView时并不安全
-(NSArray*)dataSource4BindHelperWithTag:(NSString*)tag;
-(void)tableViewBinderHelper:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)tableViewBinderHelperDidScroll:(UIScrollView *)scrollView;

-(NSString*)currentCellClassWithIndexPath:(NSIndexPath*)indexPath;
-(bool)currentReuseControl;
@end

@interface TVCBindHelperMEx : NSObject

@property(copy,nonatomic)NSString* tag;

@property(assign,nonatomic)bool noReuse;

-(instancetype)initBinderWithTVC:(TableViewMEx*)tableView cellClass:(NSString*)cellClass;

@property(weak,nonatomic)id<BindHelperMExDelegate> delegate;

-(void)didSelectedCellAtIndexPath:(NSIndexPath*)indexPath;

@end
