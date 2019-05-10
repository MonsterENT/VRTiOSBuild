//
//  NetworkModule.h
//  AFTEST
//
//  Created by MonsterENT on 6/27/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "NetworkMEx.h"

@interface NetworkModule : AFHTTPSessionManager<NetWorkMExModuleDelegate>

-(instancetype)initWithSSL:(BOOL)enableSSL;

@end
