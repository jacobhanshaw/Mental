//
//  LevelViewController.h
//  Mental
//
//  Created by Jacob Hanshaw on 9/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"

typedef enum
{
	AnimationStyleScrollLeft = 0,
	AnimationStyleScrollRight = 1,
    AnimationStyleScrollUp = 2,
    AnimationStyleScrollDown = 3
}
kAnimationStyle;
#define kAnimationStyleArray @"AnimationStyleScrollLeft", @" AnimationStyleScrollRight", @"AnimationStyleScrollUp", @"AnimationStyleScrollDown", nil

@interface LevelViewController : UIViewController<UIGestureRecognizerDelegate>
{
    UIImageView *currentImageView;
    UIImageView *nextImageView;
    UIImageView *objectTest;
    UIView *floatingView;
    
    int characterState;
    int loops;
    int directionHorizontal;
    int directionVertical;
    int goalRoomRow;
    int goalRoomCol;
    BOOL isAnimating;
    BOOL hasBeenPressed;
}

@property (nonatomic) UIImageView *currentImageView;
@property (nonatomic) UIImageView *nextImageView;
@property (nonatomic) UIImageView *objectTest;
@property (nonatomic) UIView *floatingView;

@property (readwrite) int characterState;
@property (readwrite) int loops;
@property (readwrite) int directionHorizontal;
@property (readwrite) int directionVertical;
@property (readwrite) int goalRoomRow;
@property (readwrite) int goalRoomCol;
@property (readwrite) BOOL isAnimating;
@property (readwrite) BOOL hasBeenPressed;

- (void)leftSwipe;
- (void)rightSwipe;
- (void)upSwipe;
- (void)downSwipe;
- (void)animate:(int)direction;
- (void) animationLoop;

@end
