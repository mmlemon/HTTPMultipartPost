//
//  MultipartPostHelper.h
//  HTTPPostSample2
//
//  Created by mmlemon on 09/06/10.
//  Copyright 2009 hi-farm.net. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MultipartPostHelper : NSObject {
	
	NSString			*url;			// 送信先url
	NSDictionary		*stringValues;	// 文字列のdictionary
	NSArray				*binaryValues;	// バイナリデータのdictionary
	
@private
	NSString			*boundary;		// パート毎の境界線
}

@property(nonatomic, retain) NSString			*url;
@property(nonatomic, retain) NSDictionary		*stringValues;
@property(nonatomic, retain) NSArray			*binaryValues;

@property(nonatomic, retain) NSString			*boundary;

-(id)init:(NSString *)sendUrl;
-(NSString *)send;
-(NSString *)send:(NSString *)sendUrl;
@end
