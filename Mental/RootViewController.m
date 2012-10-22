//
//  RootViewController.m
//  Mental
//
//  Created by Jacob Hanshaw on 9/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

+ (id)sharedRootViewController
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initWithNibName:nil bundle:nil];//[UIScreen mainScreen].bounds]; // or some other init method
    });
    return _sharedObject;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *newGameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [newGameButton addTarget:self 
                   action:@selector(newGame)
         forControlEvents:UIControlEventTouchDown];
        [newGameButton setTitle:@"New Game" forState:UIControlStateNormal];
        newGameButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
        UIImage *originalImage = [UIImage imageNamed:@"brain.jpeg"];
        UIImage *scaledImage =
        [UIImage imageWithCGImage:[originalImage CGImage]
                            scale:0.75 orientation:UIImageOrientationUp];
        self.view.backgroundColor = [UIColor colorWithPatternImage:scaledImage];
        [self.view addSubview:newGameButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
     return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
     } else {
     return YES;
     }*/
    //return YES;
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void) newGame
{
    LevelViewController *level = [[LevelViewController alloc] init];
    NSLog(@"%f", [[[UIDevice currentDevice] systemVersion] floatValue]);
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 4.5)
    [self presentViewController:level animated:NO completion:nil];
    else [self presentModalViewController:level animated:NO];
}


@end
