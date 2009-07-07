//
//  HTTPPostSample2ViewController.h
//  HTTPPostSample2
//
//  Created by mmlemon on 09/06/01.
//  Copyright hi-farm.net 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultipartPostHelper.h"

@class MultipartPostHelper;

@interface HTTPPostSample2ViewController : UIViewController {
	
	IBOutlet UIButton *uploadBtn;
}

@property(nonatomic, retain) IBOutlet UIButton *uploadBtn;

-(IBAction)upload;

@end

