//
//  ViewController.m
//  VRTiOSBuild
//
//  Created by MonsterENT on 4/11/19.
//  Copyright © 2019 MonsterEntertainment. All rights reserved.
//

#import "ViewController.h"
#import "VRTSDKMaster.h"
#import "VisualRuntime/VRTInstance.h"
#import "VisualRuntime/Others/VRTViewController.h"
#import "VisualRuntime/VRTMacro.h"

#define BTN_LENGTH_PX (200 * kWidthPx2PtScale)

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_DARK_DEEP;
    
    UIButton* startBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x - BTN_LENGTH_PX / 2.0, self.view.center.y - BTN_LENGTH_PX / 2.0, BTN_LENGTH_PX, BTN_LENGTH_PX)];
    startBtn.backgroundColor = COMMON_DARK;
    [startBtn setTitleColor:COMMON_YELLOW forState:UIControlStateNormal];
    startBtn.layer.cornerRadius = BTN_LENGTH_PX / 2.0;
    [startBtn setTitle:@"Start" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startFN) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
}

-(void)startFN
{
    [VRTViewController pushWithUrl:@"http://21xa689434.imwork.net:8090/public/tmp/VRTJSFramework/code/VRTDebugger/VRTDebugger.js" param:@{} baseControllerName:nil];
}

@end
