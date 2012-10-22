//
//  World.m
//  Mental
//
//  Created by Jacob Hanshaw on 9/27/12.
//
//

#import "World.h"

@interface NSMutableArray (MultidimensionalAdditions)

+ (NSMutableArray *) arrayOfWidth:(NSInteger) width andHeight:(NSInteger) height andValue:(NSObject *)value;

- (id) initWithWidth:(NSInteger) width andHeight:(NSInteger) height andValue:(NSObject *)value;

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

@end

@implementation World

@synthesize rooms, floatingObjects, lastLocationRow, lastLocationColumn;

-(World *) initWorld: (int)worldNumber withRooms: (int)roomNumber andHeight: (int)height andWidth:(int)width
{
    self.rooms = [NSMutableArray arrayOfWidth:width andHeight:height andValue:nil];
    int initRoomRow = 0;
    int initRoomCol = 0;
    for(int i = 1; i <= roomNumber; i++){
        NSString *imageName = [NSString stringWithFormat:@"room_%d_%d.png", worldNumber, i];
        UIImage *roomImage;
        if((roomImage = [UIImage imageNamed:imageName])){
            Room *room = [[Room alloc] initWithImage:roomImage];
            [[self.rooms objectAtIndex:initRoomRow] addObject:room];
        }
        else NSLog(@"ERROR MISSING PHOTO: WORLD: %d Room Number: %d", worldNumber, i);
        
        initRoomCol++;
        if(initRoomCol >= width){
            initRoomCol = 0;
            initRoomRow++;
        }
    }
    [self.rooms description];
    return self;
}

-(Room *) fetchRoomInRow: (int)row andColumn: (int)column
{
    return [[self.rooms objectAtIndex:row] objectAtIndex:column];
}

@end
