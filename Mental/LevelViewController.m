//
//  LevelViewController.m
//  Mental
//
//  Created by Jacob Hanshaw on 9/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelViewController.h"

@implementation LevelViewController

@synthesize currentImageView, nextImageView, floatingView, characterState, loops, directionHorizontal, directionVertical, goalRoomRow, goalRoomCol, isAnimating, hasBeenPressed, objectTest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isAnimating = NO;
    }
    return self;
}

- (void)viewDidLoad
{
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
    [self setupRecognizers];

    self.currentImageView = [[UIImageView alloc] initWithImage:[AppModel sharedAppModel].currentRoom.image];
    self.currentImageView.frame = CGRectMake(0, 0, [AppModel sharedAppModel].screenWidth, [AppModel sharedAppModel].screenHeight);;
    [self.view addSubview:self.currentImageView];
    
    self.nextImageView = [[UIImageView alloc] initWithImage:[AppModel sharedAppModel].nextRoom.image];
    self.nextImageView.frame = CGRectMake(-480, -480, [AppModel sharedAppModel].screenWidth, [AppModel sharedAppModel].screenHeight);;
    [self.view addSubview:self.nextImageView];
    
    UIImage *objectImage;
    if(!(objectImage = [UIImage imageNamed:@"object_1_5_1.png"])) NSLog(@"ERROR loading image: object_1_5_1.png");
    UIImageView *imageView = [[UIImageView alloc] initWithImage:objectImage];
    imageView.frame = CGRectMake(50, 50, 200, 200);
    self.objectTest = imageView;
    self.objectTest.bounds = self.objectTest.frame;
    self.objectTest.userInteractionEnabled = YES;
    [self.view addSubview: self.objectTest];
    
    UIView *floatingViewFrameAlloc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [AppModel sharedAppModel].screenWidth, [AppModel sharedAppModel].screenHeight)];
    self.floatingView = floatingViewFrameAlloc;
    self.floatingView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.floatingView];
    
    for(int i = 0; i < [[AppModel sharedAppModel].currentRoom.objects count]; i++){
        UIButton *objectButton = [[AppModel sharedAppModel].currentRoom.objects objectAtIndex:i];
        [objectButton addTarget: self
                         action: @selector(buttonClicked:)
               forControlEvents: UIControlEventTouchDown];
        [self.currentImageView addSubview:objectButton];
        [self.floatingView addSubview:objectButton];
         }
    
    for(int i = 0; i < [[AppModel sharedAppModel].currentWorld.floatingObjects count]; i++){
        UIButton *objectButton = [[AppModel sharedAppModel].currentWorld.floatingObjects objectAtIndex:i];
        [objectButton addTarget: self
                         action: @selector(buttonClicked:)
               forControlEvents: UIControlEventTouchDown];
        [self.floatingView addSubview: objectButton];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [AppModel sharedAppModel].currentWorld.lastLocationRow = [AppModel sharedAppModel].currentRoomRow;
    [AppModel sharedAppModel].currentWorld.lastLocationColumn = [AppModel sharedAppModel].currentRoomColumn;
}

- (void) setGoal{
    int totalNumberOfRows = [[AppModel sharedAppModel].currentWorld.rooms count];
    int totalNumberOfColumns = [[[AppModel sharedAppModel].currentWorld.rooms objectAtIndex:0] count];
    self.goalRoomRow = (arc4random()%totalNumberOfRows);
    self.goalRoomCol = (arc4random()%totalNumberOfColumns);
    while((self.goalRoomRow == [AppModel sharedAppModel].currentRoomRow) && (self.goalRoomCol == [AppModel sharedAppModel].currentRoomColumn)){
        self.goalRoomRow = (arc4random()%totalNumberOfRows);
        self.goalRoomCol = (arc4random()%totalNumberOfColumns);
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Temporary Portal Active"
                                                    message:[NSString stringWithFormat:@"You must move the door to the room in row %d and column %d", self.goalRoomRow +1, self.goalRoomCol + 1]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) goalAchieved{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                    message:@"Congratulations! We will now teleport you to a world that looks exactly the same!"
                                                   delegate:nil
                                          cancelButtonTitle:@"Shit"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) goalFailed{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail"
                                                    message:@"How did you screw that one up genius?"
                                                   delegate:nil
                                          cancelButtonTitle:@"I... just don't know."
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)setupRecognizers
{
    UISwipeGestureRecognizer *leftSwipe  =  [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe)];
    [leftSwipe setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    leftSwipe.delegate = self; 
    [self.view addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe  =  [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe)];
    [rightSwipe setDirection:(UISwipeGestureRecognizerDirectionRight)];
    rightSwipe.delegate = self;
    [self.view addGestureRecognizer:rightSwipe];
    
    UISwipeGestureRecognizer *upSwipe  =  [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(upSwipe)];
    [upSwipe setDirection:(UISwipeGestureRecognizerDirectionUp)];
    upSwipe.delegate = self;
    [self.view addGestureRecognizer:upSwipe];
    
    UISwipeGestureRecognizer *downSwipe  =  [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(downSwipe)];
    [downSwipe setDirection:(UISwipeGestureRecognizerDirectionDown)];
    downSwipe.delegate = self;
    [self.view addGestureRecognizer:downSwipe];
    
    UITapGestureRecognizer *tap  =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    //[self.objectTest addGestureRecognizer:tap];
}

-(void)tap:(UIGestureRecognizer *)gestureRecognizer{
    NSLog(@"Got tap");
    CGPoint centerOfTap = [gestureRecognizer locationInView:self.view];
    NSLog(@"%@", [self.objectTest pointInside:centerOfTap withEvent:nil] ? @"YES":@"NO");
    NSLog(@"%@", [self.objectTest pointInside:centerOfTap withEvent:nil] ? @"YES":@"NO");
}

- (void)leftSwipe
{
    NSLog(@"LevelViewController: Left Swipe Recognized");
    if(!self.isAnimating){
    if([[[AppModel sharedAppModel].currentWorld.rooms objectAtIndex:[AppModel sharedAppModel].currentRoomRow] count] - 1 > [AppModel sharedAppModel].currentRoomColumn){
    if([[AppModel sharedAppModel].currentWorld fetchRoomInRow:[AppModel sharedAppModel].currentRoomRow andColumn:([AppModel sharedAppModel].currentRoomColumn + 1)].isAvailable){
    [self animate:AnimationStyleScrollLeft];
    }
    else{
       NSLog(@"Room Not Available"); 
    }
    }
    else{
        NSLog(@"Index Out of Bounds"); 
    }
    }
}

- (void)rightSwipe
{
    NSLog(@"LevelViewController: Right Swipe Recognized");
    if(!self.isAnimating){
    if([AppModel sharedAppModel].currentRoomColumn > 0){
    if([[AppModel sharedAppModel].currentWorld fetchRoomInRow:[AppModel sharedAppModel].currentRoomRow andColumn:([AppModel sharedAppModel].currentRoomColumn - 1)].isAvailable){
        [self animate:AnimationStyleScrollRight];
    }
    else{
        NSLog(@"Room Not Available"); 
    }
    }
    else{
        NSLog(@"Index Out of Bounds"); 
    }
    }
}

- (void)upSwipe
{
    NSLog(@"LevelViewController: Up Swipe Recognized");
    if(!self.isAnimating){
    if([[AppModel sharedAppModel].currentWorld.rooms count] - 1 > [AppModel sharedAppModel].currentRoomRow){
            if([[AppModel sharedAppModel].currentWorld fetchRoomInRow:([AppModel sharedAppModel].currentRoomRow + 1) andColumn:[AppModel sharedAppModel].currentRoomColumn].isAvailable){
            [self animate:AnimationStyleScrollUp];
        }
        else{
            NSLog(@"Room Not Available"); 
        }
    }
    else{
        NSLog(@"Index Out of Bounds"); 
    }
    }
}

- (void)downSwipe
{
    NSLog(@"LevelViewController: Down Swipe Recognized");
    if(!self.isAnimating){
    if([AppModel sharedAppModel].currentRoomRow > 0){
            if([[AppModel sharedAppModel].currentWorld fetchRoomInRow:([AppModel sharedAppModel].currentRoomRow - 1) andColumn:[AppModel sharedAppModel].currentRoomColumn].isAvailable){
            [self animate:AnimationStyleScrollDown];
        }
        else{
            NSLog(@"Room Not Available"); 
        }
    }
    else{
        NSLog(@"Index Out of Bounds"); 
    }
    }
}

/*-(void) objectTapped:(UIGestureRecognizer *)gestureRecognizer{
    UIImageView *objectTapped = gestureRecognizer.view;
    [objectTapped removeFromSuperview];
    [self.floatingView addSubview:objectTapped];
} */

-(void) buttonClicked:(id)sender{
    NSLog(@"Current Row Button: %d",[AppModel sharedAppModel].currentRoomRow);
    NSLog(@"Current Column Button: %d",[AppModel sharedAppModel].currentRoomColumn);
    UIButton *button = (UIButton*)sender;
    if(button.tag == 0){ //0 means non-floating, 1 means floating
        [self setGoal];
       button.tag = 1;
        [[AppModel sharedAppModel].currentRoom.objects removeObject:button];
    }
    else {
      button.tag = 0;
      [[AppModel sharedAppModel].currentRoom.objects addObject:button];
        if([AppModel sharedAppModel].currentRoomRow == self.goalRoomRow && [AppModel sharedAppModel].currentRoomColumn == self.goalRoomCol) [self goalAchieved];
        else [self goalFailed];
    }
   /* if(self.hasBeenPressed){
        [button removeFromSuperview];
        [self.currentImageView addSubview:button];
        [[AppModel sharedAppModel].currentRoom.objects addObject:button];
    }
    else{
        [[AppModel sharedAppModel].currentRoom.objects removeAllObjects];
    }
    self.hasBeenPressed = !self.hasBeenPressed; */
   /* if(button.superview == self.floatingView){
        [button removeFromSuperview];
        [self.currentImageView addSubview:button];
    }
    else{
        [button removeFromSuperview];
        [self.floatingView addSubview:button];
    }*/
     
}

- (void)animate:(int)style
{
    switch(style){
        case AnimationStyleScrollLeft:
            self.directionHorizontal = -1;
            self.directionVertical = 0;
            self.loops = [AppModel sharedAppModel].screenWidth;
            break;
        case AnimationStyleScrollRight:
            self.directionHorizontal = 1;
            self.directionVertical = 0;
            self.loops = [AppModel sharedAppModel].screenWidth;
            break;
        case AnimationStyleScrollUp:
            self.directionHorizontal = 0;
            self.directionVertical = -1;
            self.loops = [AppModel sharedAppModel].screenHeight;
            break;
        case AnimationStyleScrollDown:
            self.directionHorizontal = 0;
            self.directionVertical = 1;
            self.loops = [AppModel sharedAppModel].screenHeight;
            break;
    }
    [AppModel sharedAppModel].nextRoom = [[AppModel sharedAppModel].currentWorld fetchRoomInRow:([AppModel sharedAppModel].currentRoomRow - self.directionVertical) andColumn:([AppModel sharedAppModel].currentRoomColumn - self.directionHorizontal)];
    UIImage *nextImage = [AppModel sharedAppModel].nextRoom.image;
    self.nextImageView.frame = CGRectMake(([AppModel sharedAppModel].screenWidth * -(self.directionHorizontal)), ([AppModel sharedAppModel].screenHeight * -(self.directionVertical)), [AppModel sharedAppModel].screenWidth, [AppModel sharedAppModel].screenHeight);
    self.nextImageView.image = nextImage;
    
    //if the button hasn't been made floating then remove it
    for(int i = 0; i < [[self.floatingView subviews] count]; i++){
        UIButton *button = [[self.floatingView subviews] objectAtIndex:i];
        if(button.tag != 1){ //0 means non-floating, 1 means floating
        [self.currentImageView addSubview:button];
            i--;
        }
    }
    
    //prepare the next views buttons
    for(int i = 0; i < [[AppModel sharedAppModel].nextRoom.objects count]; i++){
        UIButton *objectButton = [[AppModel sharedAppModel].nextRoom.objects objectAtIndex:i];
        [objectButton addTarget: self
                         action: @selector(buttonClicked:)
               forControlEvents: UIControlEventTouchDown];
        [self.nextImageView addSubview:objectButton];
    }

    self.isAnimating = YES;
 //   self.loops -=1;
    [self animationLoop];
    
}

- (void) animationLoop
{
    self.loops--;
    if(self.loops >= 0){ //check if needs to be greater than or equal to 0
        [UIView beginAnimations:@"ScrollAnimation" context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.2];
        self.currentImageView.frame = CGRectMake((self.currentImageView.frame.origin.x + self.directionHorizontal), (self.currentImageView.frame.origin.y + self.directionVertical), [AppModel sharedAppModel].screenWidth, [AppModel sharedAppModel].screenHeight);
        self.nextImageView.frame = CGRectMake((self.nextImageView.frame.origin.x + self.directionHorizontal), (self.nextImageView.frame.origin.y + self.directionVertical), [AppModel sharedAppModel].screenWidth, [AppModel sharedAppModel].screenHeight);
        [UIView commitAnimations];
        [self performSelector:@selector(animationLoop) withObject:nil afterDelay:0.01];
    }
    if(self.loops == 0){
        
        //remove all subviews from the now offscreen current image view
        int currentRoomSubviews = [[self.currentImageView subviews] count];
        for(int i = 0; i < currentRoomSubviews; i++){
            [[[self.currentImageView subviews] objectAtIndex:0] removeFromSuperview];
        }
        
        //make the the current image view be the next image view that has been scrolled in
        UIImageView *tempCurrent = self.currentImageView;
        self.currentImageView =  self.nextImageView;
        self.nextImageView = tempCurrent;
        for(int i = 0; i < [[self.currentImageView subviews] count]; i++){
            [self.floatingView addSubview:[[self.currentImageView subviews] objectAtIndex:i]];
        }
        NSLog(@"Current Row Before Add: %d", [AppModel sharedAppModel].currentRoomRow);
        NSLog(@"Current Column Before Add: %d", [AppModel sharedAppModel].currentRoomColumn);
        [AppModel sharedAppModel].currentRoom = [[AppModel sharedAppModel].currentWorld fetchRoomInRow:([AppModel sharedAppModel].currentRoomRow - self.directionVertical) andColumn:([AppModel sharedAppModel].currentRoomColumn - self.directionHorizontal)];
        [AppModel sharedAppModel].currentRoomRow -= self.directionVertical;
        [AppModel sharedAppModel].currentRoomColumn -= self.directionHorizontal;
        NSLog(@"Current Row After Add: %d", [AppModel sharedAppModel].currentRoomRow);
        NSLog(@"Current Column After Add: %d", [AppModel sharedAppModel].currentRoomColumn);
        self.isAnimating = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return YES;
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
/*
// A method to convert an enum to string
-(NSString*) imageTypeEnumToString:(kAnimationStyle)enumVal
{
    NSArray *AnimationStyleArray = [[NSArray alloc] initWithObjects:kAnimationStyleArray];
    return [AnimationStyleArray objectAtIndex:enumVal];
}

// A method to retrieve the int value from the NSArray of NSStrings
-(kAnimationStyle) imageTypeStringToEnum:(NSString*)strVal
{
    NSArray *AnimationStyleArray = [[NSArray alloc] initWithObjects:kAnimationStyleArray];
    NSUInteger n = [AnimationStyleArray indexOfObject:strVal];
    return (kAnimationStyle) n;
} */

@end
