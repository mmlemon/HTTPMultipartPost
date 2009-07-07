//
//  HTTPPostSample2AppDelegate.h
//  HTTPPostSample2
//
//  Created by mmlemon on 09/06/01.
//  Copyright hi-farm.net 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTPPostSample2ViewController;

@interface HTTPPostSample2AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    HTTPPostSample2ViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HTTPPostSample2ViewController *viewController;

@end

