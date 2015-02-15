//
//  AppDelegate.m
//  QuizKorean
//
//  Created by jun on 2/10/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "AppDelegate.h"
#import "iRate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma mark - iRate

//+ (void)initialize
//{
//	//set the bundle ID. normally you wouldn't need to do this
//	//as it is picked up automatically from your Info.plist file
//	//but we want to test with an app that's actually on the store
//	[iRate sharedInstance].applicationBundleID = @"Clarity.Clarity";
//	[iRate sharedInstance].onlyPromptIfLatestVersion = NO;
//	
//	//enable preview mode
//	[iRate sharedInstance].previewMode = YES;
//}


#pragma mark - didFinishLaunchingWithOptions

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	//[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	return YES;
}


#pragma mark - Application's State

- (void)applicationWillResignActive:(UIApplication *)application
{
	
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
	
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
	
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
	
}


- (void)applicationWillTerminate:(UIApplication *)application
{
	
}


@end
