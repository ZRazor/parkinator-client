//
//  AppDelegate.m
//  parkinator
//
//  Created by Anton Zlotnikov on 06.11.15.
//  Copyright © 2015 Anton Zlotnikov. All rights reserved.
//

#import "AppDelegate.h"
#import "MRTabBarController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MRLoginViewController.h"
#import "MRAppDataProvider.h"
#import "MRConsts.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [GMSServices provideAPIKey:@"AIzaSyC_2rLHivgT7GXJny_48gw-mX6iaTHXwqU"];
    
    [[UINavigationBar appearance] setBarTintColor:mainColor];
    [[UINavigationBar appearance] setTintColor:orangeColor];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setBarTintColor:mainColor];
    [[UITabBar appearance] setTintColor:orangeColor];
    
    NSDictionary * navBarTitleTextAttributes =
    @{ NSForegroundColorAttributeName : orangeColor,
       NSFontAttributeName            : [UIFont systemFontOfSize:21]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];

    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [[self window] setBackgroundColor:[UIColor whiteColor]];
    [[self window] makeKeyAndVisible];
    
    if ([[[MRAppDataProvider shared] userData] isAuthed]) {
        MRTabBarController *tabBarController = [[MRTabBarController alloc] init];
        [[self window] setRootViewController:tabBarController];
    } else {
        MRLoginViewController *loginViewController = [[MRLoginViewController alloc] init];
        [[self window] setRootViewController:loginViewController];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
