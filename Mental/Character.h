//
//  Character.h
//  Mental
//
//  Created by Jacob Hanshaw on 10/13/12.
//
//

#import <UIKit/UIKit.h>

@interface Character : UIButton{

NSMutableArray *animationImagesArray;
}

@property(nonatomic) NSMutableArray *animationImagesArray;

- (id)initWithFrame:(CGRect)inputFrame Title: (NSString *) inputTitle Image: (UIImage *)inputImage Tag: (int)floatingFlag;

@end