//
//  HTTPPostSample2ViewController.m
//  HTTPPostSample2
//
//  Created by mmlemon on 09/06/01.
//  Copyright hi-farm.net 2009. All rights reserved.
//

#import "HTTPPostSample2ViewController.h"

@implementation HTTPPostSample2ViewController

@synthesize uploadBtn;

/**
 * アップロードするファイルをNSDataとして取得する
 */
-(NSData *)getUploadFile
{
	NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"83978" ofType:@"caf"];
	NSFileManager *fm = [NSFileManager defaultManager];
	NSData *data;
	if([fm fileExistsAtPath:dataPath])
	{
		NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:dataPath];
		data = [handle readDataToEndOfFile];
		[handle closeFile];
	}
	return data;
}


// POSTでアップロードする。
-(IBAction) upload
{
	// アップロード先URL
	NSString *urlStr = @"http://localhost:8888/uploadsample.php";
	//---------------------------->> 文字列データの作成
	NSArray *stringKeys = [[NSArray alloc] initWithObjects:@"upload", @"dummy",nil];
	NSArray *stringValues = [[NSArray alloc] initWithObjects:@"snd", @"dum", nil];
	
	NSDictionary *stringDict = [[NSDictionary alloc] initWithObjects:stringValues forKeys:stringKeys];
	
	//---------------------------->> バイナリデータの作成
	NSArray *binaryKeys = [[NSArray alloc] initWithObjects:@"data", @"orgName", @"postName", nil];
	NSArray *binaryValues = [[NSArray alloc] initWithObjects:(NSData *)[self getUploadFile], @"83978.caf", @"soundFile", nil];
	NSDictionary *binaryDict = [[NSDictionary alloc] initWithObjects:binaryValues forKeys:binaryKeys];
	
	NSArray *binaries = [[NSArray alloc] initWithObjects:binaryDict, nil];
	MultipartPostHelper *postHelper = [[MultipartPostHelper alloc] init:urlStr];
	// バイナリデータの追加
	[postHelper setBinaryValues:binaries];
	// 文字データの追加
	[postHelper setStringValues:stringDict];
	// 送信処理
	NSString *res = [postHelper send];
	// 送信先から返されるデータをNSLogで表示
	NSLog(res);
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[uploadBtn release];
    [super dealloc];
}

@end
