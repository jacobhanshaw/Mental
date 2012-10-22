//
//  Room.m
//  Mental
//
//  Created by Jacob Hanshaw on 9/27/12.
//
//

#import "Room.h"

@implementation Room

@synthesize image, objects, isAvailable;

-(Room *) initWithImage: (UIImage*)inputImage{
    self.image = inputImage;
    self.objects = [[NSMutableArray alloc] init];
    self.isAvailable = YES;
    
    return self;
}

@end
