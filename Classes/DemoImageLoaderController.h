//
//  DemoImageLoaderController.h
//  AFKLoadManager
//
//  Created by Marco Tabini on 10-09-30.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DemoImageLoaderController : UIViewController {

	UILabel *loadingLabel;
	
	UIImageView *imageView1;
	UIImageView *imageView2;
	
	int currentIndex;
	int imagesLoaded;
}

@end
