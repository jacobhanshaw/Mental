//
//  Room.h
//  Mental
//
//  Created by Jacob Hanshaw on 9/27/12.
//
//

#import <Foundation/Foundation.h>

@interface Room : NSObject{
    UIImage        *image;
    NSMutableArray *objects;
    BOOL           isAvailable;
}

@property(nonatomic) UIImage        *image;
@property(nonatomic) NSMutableArray *objects;
@property(readwrite) BOOL           isAvailable;

-(Room *) initWithImage: (UIImage*)image;

@end
