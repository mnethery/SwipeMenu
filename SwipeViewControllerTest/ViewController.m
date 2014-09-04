//
//  ViewController.m
//  SwipeViewControllerTest
//
//  Created by Nethery, Matt on 5/22/13.
//  Copyright (c) 2013 Nethery, Matt. All rights reserved.
//

#import "ViewController.h"
#import "SidebarViewController.h"
#import "TestViewController.h"

#import "UINavigationItem+JTRevealSidebarV2.h"
#import "JTRevealSidebarV2Delegate.h"

@interface ViewController ()

@end

@implementation ViewController {
    TestViewController* swipeVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    swipeVC = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    SidebarViewController* menuController = [[SidebarViewController alloc] initWithNibName:@"SidebarViewController" bundle:nil];
    swipeVC.menuViewController = menuController;
    [self.view addSubview:swipeVC.view];
    
    //activate sidebar delegation
    self.navigationItem.revealSidebarDelegate = swipeVC;
	
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
