//
//  AFKLoadManagerAppDelegate.h
//  AFKLoadManager
//
//  Created by Marco Tabini on 10-09-30.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DemoImageLoaderController.h"

@interface AFKLoadManagerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	DemoImageLoaderController *controller;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

