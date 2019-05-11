//
//  VRTViewController.h
//  DC_iOS
//
//  Created by MonsterENT on 10/10/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VRTViewController : UIViewController

+(void)pushWithUrl:(NSString*)url param:(NSDictionary*)param baseControllerName:(nullable NSString*)baseName;

@end

NS_ASSUME_NONNULL_END
