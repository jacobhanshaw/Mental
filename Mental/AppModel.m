//
//  AppModel.m
//  Mental
//
//  Created by Jacob Hanshaw on 9/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppModel.h"

@interface NSMutableArray (MultidimensionalAdditions)

+ (NSMutableArray *) arrayOfWidth:(NSInteger) width andHeight:(NSInteger) height andValue:(NSObject *)value;

+ (NSMutableArray *) arrayOfArraysOfWidth:(NSInteger) width andHeight:(NSInteger) height;

- (id) initWithWidth:(NSInteger) width andHeight:(NSInteger) height andValue:(NSObject *)value;

- (id) initWithWidth:(NSInteger) width andHeight:(NSInteger) height;

@end

@implementation NSMutableArray (MultidimensionalAdditions)

+ (NSMutableArray *) arrayOfWidth:(NSInteger) width andHeight:(NSInteger) height andValue:(NSObject *)value{
    return [[self alloc] initWithWidth:width andHeight:height andValue:value];
}

- (id) initWithWidth:(NSInteger) width andHeight:(NSInteger) height andValue:(NSObject *)value{
    if((self = [self initWithCapacity:height])) {
        for(int i = 0; i < height; i++) {
            NSMutableArray *inner = [[NSMutableArray alloc] initWithCapacity:width];
            for(int j = 0; j < width; j++)
                if(value != nil)[inner addObject:value];
            [self addObject:inner];
        }
    }
    return self;
}

+ (NSMutableArray *) arrayOfArraysOfWidth:(NSInteger) width andHeight:(NSInteger) height{
    return [[self alloc] initWithWidth:width andHeight:height];
}

- (id) initWithWidth:(NSInteger) width andHeight:(NSInteger) height{
    if((self = [self initWithCapacity:height])) {
        for(int i = 0; i < height; i++) {
            NSMutableArray *inner = [[NSMutableArray alloc] initWithCapacity:width];
            for(int j = 0; j < width; j++)
                [inner addObject:[[NSMutableArray alloc] init]];
            [self addObject:inner];
        }
    }
    return self;
}


@end

@implementation AppModel

@synthesize screenWidth, screenHeight, worldArray, currentRoom, nextRoom, currentWorld, currentRoomRow, currentRoomColumn;

+ (id)sharedAppModel
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark Init/dealloc
-(id)init {
    self = [super init];
    if (self) {
		//Init UserDefaults
		defaults = [NSUserDefaults standardUserDefaults];
        self.screenWidth = [[UIScreen mainScreen] bounds].size.height;
        self.screenHeight = [[UIScreen mainScreen] bounds].size.width;
        NSLog(@"Screen Width: %d", self.screenWidth);
        NSLog(@"Screen Height: %d", self.screenHeight);
        // NSNotificationCenter *dispatcher = [NSNotificationCenter defaultCenter];
        // [dispatcher addObserver:self selector:@selector(clearGameLists) name:@"NewGameSelected" object:nil];
        
        NSMutableArray *worldArrayAlloc = [[NSMutableArray alloc] init];
        self.worldArray = worldArrayAlloc;
        
        [self createAllWorlds];
        
        [self moveToWorld:0];
        
        self.currentRoomRow = 0;
        self.currentRoomColumn = 0;
        
        self.currentRoom = [self.currentWorld fetchRoomInRow: self.currentRoomRow andColumn: self.currentRoomColumn];
        
        self.nextRoom = [self.currentWorld fetchRoomInRow: self.currentRoomRow andColumn: self.currentRoomColumn]; 
	}
    return self;
}

- (void) createAllWorlds
{
    //World Inits
    World *world1 = [[World alloc] initWorld:1 withRooms:9 andHeight:3 andWidth:3];
    
    //Add Objects
    UIImage *objectImage;
    if(!(objectImage = [UIImage imageNamed:@"object_1_5_1.png"])) NSLog(@"ERROR loading image: object_1_5_1.png");
    Object *objectButton = [[Object alloc] initWithFrame:CGRectMake(100, 100, 100, 100) Title: @"Object" Image: objectImage Tag: 0];
    [[world1 fetchRoomInRow:0 andColumn:1].objects addObject:objectButton];
    
    //Close off rooms
    //[world1 fetchRoomInRow:0 andColumn:1].isAvailable = NO;
    
    [self.worldArray insertObject:world1 atIndex:0];
} 

- (void) moveToWorld: (int)worldNumber
{
    self.currentWorld = [self.worldArray objectAtIndex:worldNumber];
    self.currentRoomRow = self.currentWorld.lastLocationRow;
    self.currentRoomColumn = self.currentWorld.lastLocationColumn;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark User Defaults

-(void)initUserDefaults {
	
	//Load the settings bundle data into an array
	NSString *pathStr = [[NSBundle mainBundle] bundlePath];
	NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
	NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
	NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
	NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
	
	//Find the Defaults
	NSString *baseAppURLDefault = @"Unknown Default";
    NSNumber *showGamesInDevelopmentDefault,*showPlayerOnMapDefault;
	NSDictionary *prefItem;
	for (prefItem in prefSpecifierArray)
	{
		NSString *keyValueStr = [prefItem objectForKey:@"Key"];
		
		if ([keyValueStr isEqualToString:@"baseServerString"])
		{
            baseAppURLDefault = [prefItem objectForKey:@"DefaultValue"];
		}
        if ([keyValueStr isEqualToString:@"showGamesInDevelopment"])
		{
			showGamesInDevelopmentDefault = [prefItem objectForKey:@"DefaultValue"];
		}
        if ([keyValueStr isEqualToString:@"showPlayerOnMap"])
		{
			showPlayerOnMapDefault = [prefItem objectForKey:@"DefaultValue"];
		}
        
		//More defaults would go here
	}
	
	// since no default values have been set (i.e. no preferences file created), create it here
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
								 baseAppURLDefault,  @"baseServerString",
                                 showGamesInDevelopmentDefault , @"showGamesInDevelopment",
                                 showPlayerOnMapDefault,@"showPlayerOnMap",
								 nil];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    // mediaCache = [[MediaCache alloc]init];
    
}

-(void)saveUserDefaults {
	NSLog(@"Model: Saving User Defaults");
	
	[defaults setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"appVerison"];
	[defaults setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBuildNumber"] forKey:@"buildNum"];
    
	//[defaults setBool:hasSeenNearbyTabTutorial forKey:@"hasSeenNearbyTabTutorial"];
    //[defaults setValue:userName forKey:@"userName"];
	[defaults synchronize];
}

-(void)loadUserDefaults {
	NSLog(@"Model: Loading User Defaults");
	[defaults synchronize];
    
	//Load the base App URL
	//NSString *baseServerString = [defaults stringForKey:@"baseServerString"];
    
    //self.showPlayerOnMap = [defaults boolForKey:@"showPlayerOnMap"];
    /*if(!loggedIn && (self.showGamesInDevelopment == [defaults boolForKey:@"showGamesInDevelopment"]) && [currServ isEqual:self.serverURL] && (self.serverURL != nil)) {
     self.userName = [defaults objectForKey:@"userName"];
     self.playerId = [defaults integerForKey:@"playerId"];
     } */
    
    //  [defaults setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:updatedURL] forKey:@"baseServerString"];
    
	/*if ([defaults boolForKey:@"resetTutorial"]) {
     self.hasSeenNearbyTabTutorial = NO;
     self.hasSeenQuestsTabTutorial = NO;
     self.hasSeenMapTabTutorial = NO;
     self.hasSeenInventoryTabTutorial = NO;
     [defaults setBool:hasSeenNearbyTabTutorial forKey:@"hasSeenNearbyTabTutorial"];
     [defaults setBool:hasSeenQuestsTabTutorial forKey:@"hasSeenQuestsTabTutorial"];
     [defaults setBool:hasSeenMapTabTutorial forKey:@"hasSeenMapTabTutorial"];
     [defaults setBool:hasSeenInventoryTabTutorial forKey:@"hasSeenInventoryTabTutorial"];
     [defaults setBool:NO forKey:@"resetTutorial"];
     
     }
     else {
     self.hasSeenNearbyTabTutorial = [defaults boolForKey:@"hasSeenNearbyTabTutorial"];
     self.hasSeenQuestsTabTutorial = [defaults boolForKey:@"hasSeenQuestsTabTutorial"];
     self.hasSeenMapTabTutorial = [defaults boolForKey:@"hasSeenMapTabTutorial"];
     self.hasSeenInventoryTabTutorial = [defaults boolForKey:@"hasSeenInventoryTabTutorial"];
     } */
    
}

-(void)clearUserDefaults {
	NSLog(@"Model: Clearing User Defaults");
    //[defaults setInteger:playerId forKey:@"playerId"];
    
	[defaults synchronize];
}
/*
 #pragma mark Core Data
 
 -(void)saveCOREData {
 NSError *error = nil;
 if (managedObjectContext != nil) {
 if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
 
 Replace this implementation with code to handle the error appropriately.
 
 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
 
 NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
 abort();
 }
 }
 } */

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 
 - (NSManagedObjectContext *) managedObjectContext {
 
 if (managedObjectContext != nil) {
 return managedObjectContext;
 }
 
 NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
 if (coordinator != nil) {
 managedObjectContext = [[NSManagedObjectContext alloc] init];
 [managedObjectContext setPersistentStoreCoordinator: coordinator];
 }
 return managedObjectContext;
 } */

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 
 - (NSManagedObjectModel *)managedObjectModel {
 
 if (managedObjectModel != nil) {
 return managedObjectModel;
 }
 managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
 return managedObjectModel;
 } */


/**
 Returns the path to the application's Documents directory.
 
 - (NSString *)applicationDocumentsDirectory {
 return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
 }*/

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 
 - (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
 
 if (persistentStoreCoordinator != nil) {
 return persistentStoreCoordinator;
 }
 
 NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"UploadContent.sqlite"]];
 NSError *error = nil;
 
 NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
 persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
 if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
 NSLog(@"AppModel: Error getting the persistentStoreCoordinator");
 }
 
 return persistentStoreCoordinator;
 } */

@end
