//
//  SwipeViewController.h
//  SwipeViewControllerTest
//
//  Created by Nethery, Matt on 5/22/13.
//  Copyright (c) 2013 Nethery, Matt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeViewController : UIViewController

@property(nonatomic, strong)UIView *leftSidebarView;
@property(nonatomic, strong)UIViewController *menuViewController;//menu for a regular VC
@property(nonatomic, strong)UITableViewController *menuTableViewController;//menu for a tableVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (UIView *)viewForLeftSidebar;

@end
