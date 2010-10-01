    //
//  DemoImageLoaderController.m
//  AFKLoadManager
//
//  Created by Marco Tabini on 10-09-30.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import "DemoImageLoaderController.h"

#import "AFKDownloadManager.h"

#define kImageCount 10

static const NSString *kImages[] = {@"http://farm5.static.flickr.com/4143/4942521446_76817996ca_z.jpg",
	@"http://farm5.static.flickr.com/4141/4924390031_97ed66b84e_z.jpg",
	@"http://farm5.static.flickr.com/4120/4922143250_ba32ed3300_z.jpg",
	@"http://farm5.static.flickr.com/4099/4891958372_9aa36ac6a5_z.jpg",
	@"http://farm3.static.flickr.com/2068/2336176034_ea0442e74a_z.jpg",
	@"http://farm4.static.flickr.com/3199/2335353889_ab8c5c2fb6_z.jpg",
	@"http://farm3.static.flickr.com/2224/2392900549_50eae23469_z.jpg",
	@"http://farm3.static.flickr.com/2068/2392946101_44b7a59eeb_z.jpg",
	@"http://farm3.static.flickr.com/2168/2428157257_11e04a8f87_z.jpg",
	@"http://farm4.static.flickr.com/3290/2933367120_0c499c3f12_z.jpg"};


@implementation DemoImageLoaderController


- (NSString *) cachedPathForImage:(NSInteger) imageNumber {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	return [NSString stringWithFormat:@"%@/%d", [paths objectAtIndex:0], imageNumber];
}


- (void) imageLoaded:(NSData *) data {
	[data writeToFile:[self cachedPathForImage:imagesLoaded] atomically:YES];
	
	imagesLoaded++;
}


- (void) switchImage {
	if (!imagesLoaded) {
		[self performSelector:@selector(switchImage) withObject:Nil afterDelay:0.5];
		return;
	}
	
	currentIndex += 1;
	
	if (currentIndex >= imagesLoaded) {
		currentIndex = 0;
	}
	
	imageView1.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[self cachedPathForImage:currentIndex]]];
	
	[UIView beginAnimations:@"Animtaion" context:Nil];
	[UIView setAnimationDuration:0.5];
	
	imageView1.alpha = 1.0;
	imageView2.alpha= 0.0;
	
	[UIView commitAnimations];
	
	UIImageView *temp = imageView1;
	imageView1 = imageView2;
	imageView2 = temp;
	
	[self performSelector:@selector(switchImage) withObject:Nil afterDelay:3.0];
}


- (id) init {
	if ((self = [super init])) {
		self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
		
		self.view.autoresizesSubviews = YES;
		self.view.backgroundColor = [UIColor blackColor];
		
		loadingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2 - 10, self.view.bounds.size.width, 20)] autorelease];
		loadingLabel.text = @"Loading…";
		loadingLabel.textColor = [UIColor whiteColor];
		loadingLabel.textAlignment = UITextAlignmentCenter;
		loadingLabel.backgroundColor = [UIColor blackColor];
		loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		
		[self.view addSubview:loadingLabel];
		
		imageView1 = [[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
		imageView1.backgroundColor = [UIColor blackColor];
		imageView1.contentMode = UIViewContentModeScaleAspectFit;
		imageView1.alpha = 0.0;
		imageView1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view addSubview:imageView1];
		
		imageView2 = [[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
		imageView2.backgroundColor = [UIColor blackColor];
		imageView2.contentMode = UIViewContentModeScaleAspectFit;
		imageView2.alpha = 0.0;
		imageView2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view addSubview:imageView2];
		
		currentIndex = -1;
		imagesLoaded = 0;
		
		for (int i = 0; i < kImageCount; i++) {
			[AFKDownloadManager queueDownloadFromURL:[NSURL URLWithString:(NSString *) kImages[i]] 
													   withHTTPParameters:Nil 
																   target:self 
																 selector:@selector(imageLoaded:) 
															 atTopOfQueue:NO];
		}
		
		[self switchImage];
	}
	
	return self;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}


- (void)dealloc {
    [super dealloc];
}


@end
