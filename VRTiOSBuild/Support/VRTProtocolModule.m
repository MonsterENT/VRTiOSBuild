//
//  VRTProtocolModule.m
//  VRTiOSBuild
//
//  Created by MonsterENT on 4/16/19.
//  Copyright © 2019 MonsterEntertainment. All rights reserved.
//

#import "VRTProtocolModule.h"
/* SDWebImage 头文件 */
#import "UIImageView+WebCache.h"

@implementation VRTProtocolModule

-(void)setImageWithUrl:(NSString *)url withImageView:(UIImageView *)imgView
{
    [imgView sd_setImageWithURL:[NSURL URLWithString:url]];
}


@end
