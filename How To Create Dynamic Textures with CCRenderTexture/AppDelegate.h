//
//  AppDelegate.h
//  How To Create Dynamic Textures with CCRenderTexture
//
//  Created by Kyungmin Lee on 11. 8. 12..
//  Copyright 2km 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
