//
//  AppDelegate.m
//  getTogether
//
//  Created by Brendan Walsh  on 7/4/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import "AppDelegate.h"
#import "UserDataSingleton.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyBXSS0iBrZPzDWKYzCIt9VR87U9aSi3Mdc"];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"Application entered background.");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"Application will terminate.");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    UserDataSingleton *singleton = [UserDataSingleton getInstance];
    if ([singleton getUserID] != nil) {
        NSLog(@"Singleton contains data. Performing logout request.");
        int uID = [[singleton getUserID] intValue];
        NSURL *logoutURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://walsh.browning.edu/logout.php?userID=%i",uID]];
        NSURLRequest *request = [NSURLRequest requestWithURL:logoutURL];
        NSURLResponse *response = nil;
        NSError *err = nil;
        NSLog(@"Connection will begin.");
        [NSURLConnection sendSynchronousRequest:request
                              returningResponse:&response
                                          error:&err];
        NSLog(@"Connection finished, shutting down.");
    } else {
        NSLog(@"Singleton contains no data. Shutting down.");
    }
}

@end
