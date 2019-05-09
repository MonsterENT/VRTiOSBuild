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
@interface ViewController ()
@property(strong,nonatomic)VRTInstance* vrtInstance;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    _vrtInstance = [VRTInstance new];
    [_vrtInstance excuteRemoteJS:[NSURL URLWithString:@"http://21xa689434.imwork.net:8090/public/tmp/VRTDebugger.js"] onViewController:self];
    
    [_vrtInstance viewDidLoad_CallBack];
//    UILabel* main = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    main.text = @"FFF";
//    main.backgroundColor = [UIColor whiteColor];
//    main.font = [UIFont systemFontOfSize:15];
//    [self.view addSubview:main];
    
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
