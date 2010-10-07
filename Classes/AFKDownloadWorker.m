//
//  AFKDownloadWorker.m
//  Funnies for iPad
//
//  Created by Marco Tabini on 10-08-16.
//  Copyright 2010 AFK Studio. All rights reserved.
//

#import "AFKDownloadWorker.h"
#import "AFKDownloadManager.h"


@implementation AFKDownloadWorker

@synthesize method, url, queryParameters, HTTPParameters, downloadManager, target, selector, running, urlConnection, content;


#pragma mark -
#pragma mark Download Management


- (void) start {
	NSString *urlPayload;

	if (self.queryParameters && self.queryParameters.count) {
		urlPayload = [[NSMutableString new] autorelease];
		
		NSMutableArray *parameters = [[[NSMutableArray alloc] initWithCapacity:queryParameters.count] autorelease];

		for (NSString *key in self.queryParameters) {
			[parameters addObject:[NSString stringWithFormat:@"%@=%@",
								   [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
								   [[((NSString *) [self.queryParameters objectForKey:key]) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];
		}
			 
		urlPayload = [parameters componentsJoinedByString:@"&"];
	}
		 
	NSMutableURLRequest *urlRequest;
	
	if (urlPayload) {
		if ([self.method isEqualToString:@"GET"]) {
			NSString *urlString = [self.url absoluteString];
			NSString *actualURL = [NSString stringWithFormat:([urlString rangeOfString:@"?"].location == NSNotFound) ? @"%@?%@" : @"%@&%@",
								   urlString, urlPayload];
			
			urlRequest = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:actualURL]] autorelease];
		} else {
			urlRequest = [[[NSMutableURLRequest alloc] initWithURL:self.url] autorelease];
		}
	} else {
		urlRequest = [[[NSMutableURLRequest alloc] initWithURL:self.url] autorelease];
	}

	
	[urlRequest setHTTPMethod:self.method];

	for (NSString *key in self.HTTPParameters) {
		[urlRequest setValue:[self.HTTPParameters objectForKey:key] forHTTPHeaderField:key];
	}
	
	self.content = [NSMutableData new];
	self.urlConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
	
	running = YES;
}


- (void) stop {
	
	[self.urlConnection cancel];
	
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData {
	
	[self.content appendData:newData];
	
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	[downloadManager workerIsDone:self];
	[self.target performSelector:self.selector withObject:Nil];
	
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[downloadManager workerIsDone:self];
	[self.target performSelector:self.selector withObject:self.content];
	
}


#pragma mark -
#pragma mark Initialization and Management


- (id) init {
	if ((self = [super init])) {
		self.method = @"GET";
	}
	
	return self;
}


- (void) dealloc {
	
	self.method = Nil;
	self.url = Nil;
	self.queryParameters = Nil;
	self.HTTPParameters = Nil;
	self.target = Nil;
	self.downloadManager = Nil;
	
	self.urlConnection = Nil;
	self.content = Nil;
	
	[super dealloc];
	
}


@end
