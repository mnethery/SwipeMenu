//
//  SwipeViewController.m
//  SwipeViewControllerTest
//
//  Created by Nethery, Matt on 5/22/13.
//  Copyright (c) 2013 Nethery, Matt. All rights reserved.
//
#import "AppDelegate.h"
#import "SwipeViewController.h"
#import "SidebarViewController.h"

#import "UIViewController+JTRevealSidebarV2.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "JTRevealSidebarV2Delegate.h"

#define RIGHT_SWIPE_START 120
#define Y_CENTER_MINUS_NAV (self.view.frame.size.height/2) + 10
#define JUMP_TWEAK_DELTA 20 //this is to keep the buggy jumpiness from happening
#define LEFT_BOUNDARY self.view.frame.size.width/2
#define ANIMATION_DURATION .35
#define RIGHT_SWIPE_DECISION_POINT self.view.frame.size.width-(self.view.frame.size.width/8)
#define RIGHT_REVEAL_REST (self.view.frame.size.width*.344)+self.view.frame.size.width

@interface SwipeViewController ()

@end

@implementation SwipeViewController{
    UISwipeGestureRecognizer *rightSwipe;
    UIPanGestureRecognizer *panSwipe;
    
    AppDelegate *appDelegate;
    
    BOOL initLeftSidebar;
    BOOL allowPan;
    float oldPosition;
    float startLocationX;
    BOOL menuOpen;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIView *)viewForLeftSidebar {
    // Use applicationViewFrame to get the correctly calculated view's frame
    // for use as a reference to our sidebar's view
    CGRect viewFrame = self.navigationController.applicationViewFrame;
    UIView *view = self.leftSidebarView;
    if ( ! view) {
        //SidebarViewController *controller = [[SidebarViewController alloc] initWithNibName:@"SidebarViewController" bundle:nil];
        //view = self.leftSidebarView = controller.view;
        view = self.leftSidebarView = self.menuViewController.view;
        //NSLog(@"Controller.view: %@", controller.view);
        //NSLog(@"View: %@", view);
    }
    //this is for the right side
    //view.frame = CGRectMake(self.navigationController.view.frame.size.width - 270, viewFrame.origin.y, 270, viewFrame.size.height);
    
    //this is for the left side
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 20);
    return view;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //disable webView bouncing here
    //[[self.webView scrollView] setBounces: NO];//for using Cordova
    
    appDelegate = [[UIApplication sharedApplication] delegate];
	
    //setup swipe gesture recognizers
    //    rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    //    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    //    rightSwipe.numberOfTouchesRequired = 1;
    //[self.view addGestureRecognizer:rightSwipe];
    
    panSwipe = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanDrag:)];
    panSwipe.minimumNumberOfTouches = 1;
    panSwipe.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:panSwipe];
    
    
}

- (void)handlePanDrag:(UIPanGestureRecognizer*)paramSender{
    
    UINavigationController *navController = (UINavigationController*)appDelegate.window.rootViewController;
    
    if (paramSender.state == UIGestureRecognizerStateBegan){
        //NSLog(@"Begin touches");
        
        //this should probably live in view did load, or the main viewcontroller
        if (!initLeftSidebar){
            [navController insertLeftSidebar];
            initLeftSidebar = YES;
        }
        
        allowPan = NO;
        CGPoint location = [paramSender locationInView:paramSender.view.superview.superview];
        startLocationX = location.x;
        
        //hit test to see if we should allow drag gesture
        if (location.x < RIGHT_SWIPE_START && !menuOpen){
            allowPan = YES;
        } else if (menuOpen){
            allowPan = YES;
        }
    }
    
    CGPoint location = [paramSender locationInView:paramSender.view.superview.superview];
    int y = Y_CENTER_MINUS_NAV;
    
    if (paramSender.state != UIGestureRecognizerStateFailed && paramSender.state == UIGestureRecognizerStateChanged){
        
        //make sure it's a right swipe
        if (startLocationX > location.x && !menuOpen)
            return;
        
        float delta = location.x - oldPosition;
        if (delta > JUMP_TWEAK_DELTA)
            delta = delta/2;
        
        if (allowPan && self.view.superview.center.x >= LEFT_BOUNDARY){
            //NSLog(@"Delta %f", delta);
            //[UIView animateWithDuration:.5 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
            
            self.view.superview.center = CGPointMake(self.view.superview.center.x+delta, y);
            //NSLog(@"X: %f Y: %i",delta, y);
            
            //} completion:^(BOOL finished){}];
            
            oldPosition = location.x;
        }
    }
    
    if (paramSender.state == UIGestureRecognizerStateEnded){
        //NSLog(@"state ended");
        
        [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationCurveEaseOut animations:^{
            
            if (self.view.superview.center.x > RIGHT_SWIPE_DECISION_POINT){//decision point right<-->left
                //Reveal sidebar
                self.view.superview.center = CGPointMake(RIGHT_REVEAL_REST, Y_CENTER_MINUS_NAV);
                menuOpen = YES;
                oldPosition = self.view.frame.size.width;
            } else {
                //hide sidebar
                self.view.superview.center = CGPointMake(LEFT_BOUNDARY, Y_CENTER_MINUS_NAV);
                menuOpen = NO;
                oldPosition = 0;//modify this correctly
            }
        } completion:^(BOOL finished){}];
        
    }
    
}

//-(void)handleSwipes:(UISwipeGestureRecognizer *)paramSender{
//
//    if(paramSender.direction & UISwipeGestureRecognizerDirectionRight){
//        NSLog(@"Swipe Right");
//
//        UINavigationController *navController = (UINavigationController*)appDelegate.window.rootViewController;
//        ViewController *viewController = [navController.viewControllers objectAtIndex:0];
//        UIWebView *webView = viewController.viewController.webView;
//        [webView stringByEvaluatingJavaScriptFromString:@"cordova.fireDocumentEvent('swipeRight')"];
//    }
//
//
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
