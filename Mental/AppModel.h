//
//  AppModel.h
//  Mental
//
//  Created by Jacob Hanshaw on 9/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreData/CoreData.h>

#import "World.h"
#import "Object.h"

#define NUMBEROFWORLDS 7
#define MAXOBJECTSPERROOM 8

extern NSDictionary *InventoryElements;

@interface AppModel : NSObject {
    NSUserDefaults *defaults;
    int screenWidth;
    int screenHeight;
    
    NSMutableArray *worldArray;
    
    World *currentWorld;
    
    Room *currentRoom;
    Room *nextRoom; //depracated
    
    int currentRoomRow;
    int currentRoomColumn;
    
    //CORE Data
   // NSManagedObjectModel *managedObjectModel;
  //  NSManagedObjectContext *managedObjectContext;	    
  //  NSPersistentStoreCoordinator *persistentStoreCoordinator;
   // MediaCache *mediaCache;
}

// CORE Data
//@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
//@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//@property(nonatomic) MediaCache *mediaCache;

@property (nonatomic) int screenWidth;
@property (nonatomic) int screenHeight;

@property (nonatomic) NSMutableArray *worldArray;

@property (nonatomic) World *currentWorld;

@property (nonatomic) Room *currentRoom;
@property (nonatomic) Room *nextRoom; //depracated

@property (nonatomic) int currentRoomRow;
@property (nonatomic) int currentRoomColumn;

+ (AppModel *)sharedAppModel;

- (id)init;	
- (void)initUserDefaults;
- (void)saveUserDefaults;
- (void)loadUserDefaults;
- (void)clearUserDefaults;
//- (void)saveCOREData;


@end

