//
//  Object.m
//  Mental
//
//  Created by Jacob Hanshaw on 10/13/12.
//
//

#import "Object.h"

@implementation Object

@synthesize animationImages;

- (id)initWithFrame:(CGRect)inputFrame Title: (NSString *) inputTitle Image: (UIImage *)inputImage Tag: (int)floatingFlag
{
    self = [super initWithFrame:inputFrame];
    if (self) {
        [self setTitle:inputTitle forState:UIControlStateNormal];
        [self setImage:inputImage forState:UIControlStateNormal];
        self.tag = floatingFlag; //0 means non-floating, 1 means floating
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
