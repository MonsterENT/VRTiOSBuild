//
//  Model4VRTTextField.h
//  DC_iOS
//
//  Created by MonsterENT on 10/4/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import "Model4VRTView.h"

NS_ASSUME_NONNULL_BEGIN

@interface Model4VRTTextField : Model4VRTView

@property(copy,nonatomic)NSString* text;
@property(assign,nonatomic)NSUInteger fontSize;
@property(copy,nonatomic)NSString* textAlignment;
@property(strong,nonatomic)UIColor* textColor;

@end

NS_ASSUME_NONNULL_END
