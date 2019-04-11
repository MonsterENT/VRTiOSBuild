//
//  BaseNavigationController.m
//  C_Class_iOS
//
//  Created by MonsterENT on 11/1/17.
//  Copyright © 2017 MonsterENT. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ControllerManagerMEx.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setTranslucent:false];
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(self.viewControllers.count <= 1)
    {
        return false;
    }
    if([[ControllerManagerMEx shareInstance]canPopController:[self.viewControllers lastObject]])
    {
        [self popViewControllerAnimated:true];
    }
    return false;
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [[ControllerManagerMEx shareInstance] ShouldReleaseController:[self.viewControllers lastObject]];
    return [super popViewControllerAnimated:animated];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self popViewControllerAnimated:YES];
    });
    return YES;
}
@end
