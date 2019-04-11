//
//  VRTViewController.m
//  DC_iOS
//
//  Created by MonsterENT on 10/10/18.
//  Copyright © 2018 MonsterEntertainment. All rights reserved.
//

#import "VRTViewController.h"
#import "../VRTSDKMaster.h"
#include "../VRTInstance.h"

@interface VRTViewController ()

@property(strong,nonatomic)VRTInstance* vrtInstance;

@end

@implementation VRTViewController

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _vrtInstance = [VRTInstance new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _vrtInstance.url = _url;
    _vrtInstance.param = _param;
    [_vrtInstance excuteRemoteJS:[NSURL URLWithString:_url] onViewController:self];
    
    [_vrtInstance viewDidLoad_CallBack];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_vrtInstance viewWillAppear_CallBack];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_vrtInstance viewDidAppear_CallBack];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_vrtInstance viewWillDisappear_CallBack];
}



@end
