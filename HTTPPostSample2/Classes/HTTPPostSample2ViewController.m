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

// multipart（文字列）のポストデータを作る。
// key: POSTのキー　value: POSTの値
-(NSMutableString *)generateMultiPartString:(NSString *)key kValue:(NSString *)value
{
	NSMutableString *returnValue = [[NSMutableString alloc] init];
	
	NSString *boundary = @"AaB03x";
	
	[returnValue appendString:[NSString stringWithFormat:@"--%@\r\n", boundary]];
	[returnValue appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]];
	[returnValue appendString:value];
	[returnValue appendString:@"\r\n"];
	return returnValue;
}

- (NSData *)generatePostDataForData:(NSData *)uploadData file:(NSString *)fileName strData:(NSString *)stringData 
{
	// Content-Type: multipart/form-data; boundary=AaB03x
	NSMutableString *prePost = [[NSMutableString alloc] init];
	
	prePost = [self generateMultiPartString:@"soundFile" kValue:@"soundName"];
	
	[prePost appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.caf\"\r\nContent-Type: application/octet-strem\r\n\r\n", fileName, fileName]];
	
	NSString *post = prePost;// [NSString stringWithCString:prePost encoding:NSASCIIStringEncoding];
	
	NSLog(post);
	
	NSData *postHeaderData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSMutableData *postData = [[NSMutableData alloc] initWithLength:[postHeaderData length]];
	
	[postData setData:postHeaderData];
	
	[postData appendData:[@"\r\n--AaB03x--\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
	[postData appendData:uploadData];

	return postData;
}

-(void)uploadFile:(NSString *)urlStr strData:(NSString *)stringData fileData:(NSData *)uploadData file:(NSString *)fileName
{
	////////////////////
	NSData *postData = [self generatePostDataForData:uploadData file:fileName strData:stringData];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *uploadRequest = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30] autorelease];
	
	[uploadRequest setHTTPMethod:@"POST"];
	[uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
	
	[uploadRequest setHTTPBody:postData];
	
	//NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:uploadRequest delegate:self];
	NSURLResponse *response;
	NSError *error;
	NSData *res = [NSURLConnection sendSynchronousRequest:uploadRequest
										returningResponse:&response
													error:&error];
	NSLog(@"%@", [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding]);
}

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
		//[NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
	}
	//NSData *data = [postText dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES];
	return data;
}


// POSTでアップロードする。
-(IBAction) upload
{
	// アップロード先URL
	// 文字列データの作成
	NSArray *stringKeys = [[NSArray alloc] initWithObjects:@"upload", @"dummy",nil];
	NSArray *stringValues = [[NSArray alloc] initWithObjects:@"snd", @"dum", nil];
	
	NSDictionary *stringDict = [[NSDictionary alloc] initWithObjects:stringValues forKeys:stringKeys];
	// バイナリデータの作成
	NSArray *binaryKeys = [[NSArray alloc] initWithObjects:@"data", @"orgName", @"postName", nil];
	NSArray *binaryValues = [[NSArray alloc] initWithObjects:(NSData *)[self getUploadFile], @"83978.caf", @"soundFile", nil];
	NSDictionary *binaryDict = [[NSDictionary alloc] initWithObjects:binaryValues forKeys:binaryKeys];
	
	NSArray *binaries = [[NSArray alloc] initWithObjects:binaryDict, nil];
	MultipartPostHelper *postHelper = [[MultipartPostHelper alloc] init:urlStr];
	[postHelper setBinaryValues:binaries];
	[postHelper setStringValues:stringDict];
	
	NSString *res = [postHelper send];
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
