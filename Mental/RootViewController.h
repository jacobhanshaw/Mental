//
//  RootViewController.h
//  Mental
//
//  Created by Jacob Hanshaw on 9/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"
#import "LevelViewController.h"

#define SCREEN_HEIGHT 480
#define SCREEN_WIDTH 320

@interface RootViewController : UIViewController

+ (RootViewController *)sharedRootViewController;

- (void) newGame;

@end
