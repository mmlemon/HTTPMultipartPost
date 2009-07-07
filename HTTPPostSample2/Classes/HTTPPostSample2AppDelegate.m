//
//  HTTPPostSample2AppDelegate.m
//  HTTPPostSample2
//
//  Created by mmlemon on 09/06/01.
//  Copyright hi-farm.net 2009. All rights reserved.
//

#import "HTTPPostSample2AppDelegate.h"
#import "HTTPPostSample2ViewController.h"

@implementation HTTPPostSample2AppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
