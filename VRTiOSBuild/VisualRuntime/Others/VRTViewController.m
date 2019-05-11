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

@property(copy,nonatomic)NSString* url;
@property(copy,nonatomic)NSDictionary* param;
@property(copy,nonatomic)NSString* code;

@property(strong,nonatomic)VRTInstance* vrtInstance;
@end

@implementation VRTViewController

+(void)pushWithUrl:(NSString*)url param:(NSDictionary*)param baseControllerName:(nullable NSString*)baseName
{
    [[VRTSDKMaster shareInstance].httpAdapter getWithSubUrl:url param:@{} block:^(id data, id info) {
        if(data)
        {
            NSString* code = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            VRTViewController* vc = [VRTViewController new];
            vc.url = url;
            vc.param = param;
            vc.code = code;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(baseName)
                {
                    [[ControllerManagerMEx shareInstance]pushController:vc withName:url base:baseName];
                }
                else
                {
                    [[ControllerManagerMEx shareInstance]addController:vc withName:url];
                    [[ControllerManagerMEx shareInstance].currentDisplayController.navigationController pushViewController:vc animated:true];
                }
            });
        }
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _vrtInstance = [VRTInstance new];
    _vrtInstance.url = _url;
    _vrtInstance.param = _param;
    
    [_vrtInstance excuteCode:_code onViewController:self];
    
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
