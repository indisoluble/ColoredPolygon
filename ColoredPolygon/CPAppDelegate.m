//
//  CPAppDelegate.m
//  ColoredPolygon
//
//  Created by Enrique de la Torre Fernández on 14/12/11.
//  Copyright (c) 2011 Enrique de la Torre. All rights reserved.
//

#import "CPAppDelegate.h"

#import "CPCreatePolygonViewController.h"



@interface CPAppDelegate ()
{
    UINavigationController *__navController;
}

@property (nonatomic, retain) UINavigationController *navController;

@end



@implementation CPAppDelegate

#pragma mark - Synthesized properties
@synthesize window = _window;
@synthesize navController = __navController;

#pragma mark - Memory management
- (void)dealloc
{
    self.navController = nil;
    
    [_window release];
    [super dealloc];
}

#pragma mark - UIApplicationDelegate methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    self.navController = [[[UINavigationController alloc] init] autorelease];
    CPCreatePolygonViewController *createPolygonViewController =
        [[[CPCreatePolygonViewController alloc]
          initWithNibName:@"CPCreatePolygonViewController" bundle:nil] autorelease];
    createPolygonViewController.title = @"Create polygon";
    [self.navController pushViewController:createPolygonViewController animated:NO];
    
    [self.window addSubview:self.navController.view];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
