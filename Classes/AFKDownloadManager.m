//
//  AFKDownloadManager.m
//  Funnies for iPad
//
//  Created by Marco Tabini on 10-08-16.
//  Copyright 2010 AFK Studio. All rights reserved.
//

#import "AFKDownloadManager.h"
#import "AFKDownloadWorker.h"

@implementation AFKDownloadManager

@synthesize maximumWorkers;


#pragma mark -
#pragma mark Worker management


- (void) processQueue {

	if (liveWorkers.count < self.maximumWorkers) {
		
		if (queue.count) {
			
			AFKDownloadWorker *worker = [queue objectAtIndex:0];
			
			[liveWorkers addObject:worker];
			[queue removeObjectAtIndex:0];
			
			[worker start];
		}
		
	}
	
	if (liveWorkers.count) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kAFKDownloadManagerActivityStarted object:self];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:kAFKDownloadManagerActivityEnded object:self];
	}

}


- (void) workerIsDone:(AFKDownloadWorker *) worker {

	worker.downloadManager = Nil;
	[liveWorkers removeObject:worker];
	
	[self processQueue];
	
}


- (void) enqueueWorker:(AFKDownloadWorker *) worker atTopOfQueue:(BOOL) atTopOfQueue {
	
	if (atTopOfQueue) {
		[queue insertObject:worker atIndex:0];
	} else {
		[queue addObject:worker];
	}

	[self processQueue];
	
}


- (void) setMaximumWorkers:(int) value {

	maximumWorkers = value;
	[self processQueue];
	
}


#pragma mark -
#pragma mark Initialization and Memory Management


+ (AFKDownloadManager *) defaultManager {
	
	static AFKDownloadManager *globalInstance;
	
	if (!globalInstance) {
		globalInstance = [AFKDownloadManager new];
	}
	
	return globalInstance;
	
}


+ (void) queueDownloadFromURL:(NSURL *) url withHTTPParameters:(NSDictionary *) parameters target:(id) target selector:(SEL) selector atTopOfQueue:(BOOL) atTopOfQueue {
	
	AFKDownloadManager *manager = [AFKDownloadManager defaultManager];

	AFKDownloadWorker *worker = [[AFKDownloadWorker new] autorelease];
	
	worker.url = url;
	worker.HTTPParameters = parameters;
	
	worker.downloadManager = manager;
	
	worker.target = target;
	worker.selector = selector;
	
	[manager enqueueWorker:worker atTopOfQueue:atTopOfQueue];
	
}


- (id) init {

	if (self = [super init]) {
		queue = [NSMutableArray new];
		liveWorkers = [NSMutableArray new];
		maximumWorkers = 5;
	}
	
	return self;
	
}


- (void) dealloc {

	[queue release];
	[liveWorkers release];
	
	[super dealloc];
	
}


@end
