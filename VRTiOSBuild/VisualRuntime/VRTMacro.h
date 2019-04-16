//
//  VRTMacro.h
//  VRTiOSBuild
//
//  Created by MonsterENT on 4/12/19.
//  Copyright © 2019 MonsterEntertainment. All rights reserved.
//

#ifndef VRTMacro_h
#define VRTMacro_h

#define VRT_SAFE_VALUE(v) ((v && ![v isEqual:[NSNull null]])? v : nil)

#define kFontPx2PtScale kWidthPx2PtScale
#define kWidthPx2PtScale (1.0f / [UIScreen mainScreen].scale * [UIScreen mainScreen].bounds.size.width / 375.0)


#endif /* VRTMacro_h */
