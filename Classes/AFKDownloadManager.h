//
//  AFKDownloadManager.h
//  Funnies for iPad
//
//  Created by Marco Tabini on 10-08-16.
//  Copyright 2010 AFK Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAFKDownloadManagerActivityStarted @"kAFKDownloadManagerActivityStarted"
#define kAFKDownloadManagerActivityEnded @"kAFKDownloadManagerActivityEnded"


@class AFKDownloadWorker;

@interface AFKDownloadManager : NSObject {
	
	NSMutableArray *queue;
	
	NSMutableArray *liveWorkers;

	int maximumWorkers;
	
}


@property (nonatomic,assign) int maximumWorkers;


+ (AFKDownloadManager *) defaultManager;
+ (void) queueDownloadFromURL:(NSURL *) url withHTTPParameters:(NSDictionary *) parameters target:(id) target selector:(SEL) selector atTopOfQueue:(BOOL) atTopOfQueue;
+ (void) queueDownloadFromURL:(NSURL *) url method:(NSString *) method queryParameters:(NSDictionary *) queryParameters HTTPParameters:(NSDictionary *) HTTPParameters target:(id) target selector:(SEL) selector atTopOfQueue:(BOOL) atTopOfQueue;

- (void) workerIsDone:(AFKDownloadWorker *) worker;


@end
