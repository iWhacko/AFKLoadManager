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

@synthesize url, HTTPParameters, downloadManager, target, selector, running, urlConnection, content;


#pragma mark -
#pragma mark Download Management


- (void) start {

	NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc] initWithURL:self.url] autorelease];
	
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

- (void) dealloc {
	
	self.url = Nil;
	self.HTTPParameters = Nil;
	self.target = Nil;
	self.downloadManager = Nil;
	
	self.urlConnection = Nil;
	self.content = Nil;
	
	[super dealloc];
	
}


@end
