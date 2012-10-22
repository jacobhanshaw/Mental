//
//  Object.h
//  Mental
//
//  Created by Jacob Hanshaw on 10/13/12.
//
//

#import <UIKit/UIKit.h>

@interface Object : UIButton {
    
    NSMutableArray *animationImages;
}

@property(nonatomic) NSMutableArray *animationImages;

- (id)initWithFrame:(CGRect)inputFrame Title: (NSString *) inputTitle Image: (UIImage *)inputImage Tag: (int)floatingFlag;

@end
