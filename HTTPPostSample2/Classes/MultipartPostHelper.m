//
//  MultipartPostHelper.m
//  HTTPPostSample2
//
//  Created by mmlemon on 09/06/10.
//  Copyright 2009 hi-farm.net. All rights reserved.
//

#import "MultipartPostHelper.h"


@implementation MultipartPostHelper

@synthesize		url;
@synthesize		stringValues;
@synthesize		binaryValues;

@synthesize		boundary;

-(id)init
{
	if([super init])
	{
		NSLog(@"init in MultipartPostHelper");
		[self setBoundary:@"AaB03x"];
	}
	return self;
}

-(id)init:(NSString *)sendUrl
{
	[self init];
	[self setUrl:sendUrl];
	return self;
}

/**
 バイナリの部分を作る。
 @param uploadData	: データを作るバイナリデータ
 @param orgName		: オリジナルのファイル名
 @param postName	: Postされる時の名前（$_FILES["postName"]）
 
 @return POSTように作成されたデータ（NSData形式） 
*/
-(NSData *)generatePostBinaryData:(NSData *)uploadData orgName:(NSString *)orgFileName postName:(NSString *)postLabel
{
	NSMutableString *prePost = [[NSMutableString alloc] init];
	// ----> データを作成
	[prePost appendString:[NSString stringWithFormat:@"--%@\r\n", boundary]];
	[prePost appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n", postLabel, orgFileName]];
	
	NSLog(@"prePost:%@",prePost);
	// <---- データを作成
	NSMutableData *returnValue = [[NSMutableData alloc] init];
	// headerdata
	[returnValue appendData:[prePost dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
	
	// 実際のデータを追加する
	[returnValue appendData:uploadData];
	
	[returnValue appendData:[[NSString stringWithFormat:@"\r\n--%@--", boundary] dataUsingEncoding:NSUTF8StringEncoding
				allowLossyConversion:YES]];
	
	return returnValue;
}

// multipart（文字列）のポストデータを作る。
// key: POSTのキー　value: POSTの値
-(NSData *)generateMultiPartString:(NSString *)key kValue:(NSString *)value
{
	NSMutableString *returnString = [[NSMutableString alloc] init];
	
	[returnString appendString:[NSString stringWithFormat:@"--%@\r\n", boundary]];
	[returnString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]];
	[returnString appendString:value];
	[returnString appendString:@"\r\n"];
	
	NSLog(@"string:::: %@", returnString);
	// stringをデータに変換
	NSData *returnValue = [[NSData alloc] initWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
	return returnValue;
}


// 送信処理
// レスポンスを返す。
-(NSString *)send
{
	if([self url] == nil)
	{
		// 必要なデータが無ければ、例外を発生させる
		NSException *exception = [[NSException alloc] initWithName:@"noUrl" 
															reason:@"url property is not set." 
														  userInfo:nil];
		[exception raise];
	}
	
	// 送信データを作って、送信する
	// 送信データ作成
	NSMutableData *postData = [[NSMutableData alloc] init];
	
	// 文字列のデータを作成
	NSArray *stringValuesKeys = [self.stringValues allKeys];
	for(int i=0; i < [stringValuesKeys count]; i++)
	{
		// キーを取得
		NSString *key = (NSString *)[stringValuesKeys objectAtIndex:i];
		
		[postData appendData:[self generateMultiPartString:key 
													kValue:[self.stringValues objectForKey:key]]];
	}
	
	// バイナリデータを作成
	// こちらは配列の中に、data:実データ, orgName:オリジナルのファイル名, postName:POSTされる時の名前を格納
	for(int i=0; i < [self.binaryValues count]; i++)
	{
		NSDictionary *binaryDict = (NSDictionary *)[self.binaryValues objectAtIndex:i];
		[postData appendData:[self generatePostBinaryData:(NSData *)[binaryDict objectForKey:@"data"]
												  orgName:(NSString *)[binaryDict objectForKey:@"orgName"]
												 postName:(NSString *)[binaryDict objectForKey:@"postName"]
		 ]];
	}
	
	NSLog(@"%d", [postData length]);
	// HTTPの組み立て
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self url]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30] autorelease];
	[request setHTTPMethod:@"POST"];
	[request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
	[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	// 送信準備
	NSURLResponse *response;
	NSError *error;
	NSData *res = [NSURLConnection sendSynchronousRequest:request 
										returningResponse:&response 
													error:&error];
	return [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding];
}

// 送信時にURLを設定するバージョン。
-(NSString *)send:(NSString *)sendUrl
{
	[self setUrl:sendUrl];
	
	return [self send];
}

@end
