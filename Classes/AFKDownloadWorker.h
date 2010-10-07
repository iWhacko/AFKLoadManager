//
//  FIDownloadWorker.h
//  Funnies for iPad
//
//  Created by Marco Tabini on 10-08-16.
//  Copyright 2010 AFK Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFKDownloadManager;

@interface AFKDownloadWorker : NSObject {

	NSString *method;
	NSURL *url;
	NSDictionary *queryParameters;
	
	NSDictionary *HTTPParameters;
	
	AFKDownloadManager *downloadManager;
	
	id target;
	SEL selector;

	BOOL running;
	
	NSURLConnection *urlConnection;
	NSMutableData *content;
	
	NSAutoreleasePool *pool;
	
}


@property (nonatomic,retain) NSString *method;

@property (nonatomic,retain) NSURL *url;
@property (nonatomic,retain) NSDictionary *queryParameters;

@property (nonatomic,retain) NSDictionary *HTTPParameters;

@property (nonatomic,retain) AFKDownloadManager *downloadManager;

@property (nonatomic,retain) id target;
@property (nonatomic,assign) SEL selector;

@property (nonatomic,readonly) BOOL running;

@property (nonatomic,retain) NSURLConnection *urlConnection;
@property (nonatomic,retain) NSMutableData *content;


- (void) start;


@end
