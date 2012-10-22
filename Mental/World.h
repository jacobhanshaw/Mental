//
//  World.h
//  Mental
//
//  Created by Jacob Hanshaw on 9/27/12.
//
//

#import <Foundation/Foundation.h>

#import "Room.h"

@interface World : NSObject{
    NSMutableArray *rooms;
    NSMutableArray *floatingObjects;
    int lastLocationRow;
    int lastLocationColumn;
}

@property(nonatomic) NSMutableArray *rooms;
@property(nonatomic) NSMutableArray *floatingObjects;
@property(readwrite) int lastLocationRow;
@property(readwrite) int lastLocationColumn;

-(World *) initWorld: (int)worldNumber withRooms: (int)roomNumber andHeight: (int)height andWidth:(int)width;
-(Room *) fetchRoomInRow: (int)row andColumn: (int)column;

@end
