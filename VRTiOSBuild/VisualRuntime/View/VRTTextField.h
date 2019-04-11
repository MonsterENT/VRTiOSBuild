//
//  VRTTextField.h
//  DC_iOS
//
//  Created by MonsterENT on 10/4/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/Model4VRTTextField.h"

NS_ASSUME_NONNULL_BEGIN
@protocol VRTTextFieldDelegate <NSObject>
-(void)vrtTextFieldShouldReturn:(NSString*)text vrtId:(NSString*)vrtId;
@end

@interface VRTTextField : UITextField

@property(strong,nonatomic)Model4VRTTextField* originModel;

@property(weak,nonatomic)id<VRTTextFieldDelegate> vrt_delegate;
@end

NS_ASSUME_NONNULL_END
