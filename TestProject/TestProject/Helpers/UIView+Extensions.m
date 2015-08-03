//
//  UIView+Extensions.m
//  FaceToFace
//
//  Created by Svyatoslav on 12/10/14.
//  Copyright (c) 2014 Franklin Ross. All rights reserved.
//

#import "UIView+Extensions.h"

@implementation UIView (Extensions)

- (void) setWidth: (CGFloat) width
{
    self.frame = CGRectMake(self.x , self.y, width, self.height);
}

- (CGFloat) width
{
    return self.frame.size.width;
}

- (void) setHeight: (CGFloat) height
{
    self.frame = CGRectMake(self.x , self.y, self.width, height);
}

- (CGFloat) height
{
    return self.frame.size.height;
}

- (void) setX: (CGFloat) x
{
    self.frame = CGRectMake(x , self.y, self.width, self.height);
}

- (CGFloat) x
{
    return self.frame.origin.x;
}

- (void) setY: (CGFloat) y
{
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat) y
{
    return self.frame.origin.y;
}

- (void) setMaxX: (CGFloat) maxX
{
    self.frame = CGRectMake(maxX - self.width, self.y, self.width, self.height);
}

- (CGFloat) maxX
{
    return CGRectGetMaxX(self.frame);
}

- (void) setMaxY: (CGFloat) maxY
{
    self.frame = CGRectMake(self.x, maxY - self.height, self.width, self.height);
}

- (CGFloat) maxY
{
    return CGRectGetMaxY(self.frame);
}

- (void) setMidX: (CGFloat) midX
{
    self.frame = CGRectMake(midX - self.width / 2, self.y, self.width, self.height);
}

- (CGFloat) midX
{
    return CGRectGetMidX(self.frame);
}

- (void) setMidY: (CGFloat) midY
{
    self.frame = CGRectMake(self.x, midY - self.height / 2, self.width, self.height);
}

- (CGFloat) midY
{
    return CGRectGetMidY(self.frame);
}

- (void) setMinX: (CGFloat) minX
{
    self.frame = CGRectMake(minX, self.y, self.width, self.height);
}

- (CGFloat) minX
{
    return CGRectGetMinX(self.frame);
}

- (void) setMinY: (CGFloat) minY
{
    self.frame = CGRectMake(self.x, minY, self.width, self.height);
}

- (CGFloat) minY
{
    return CGRectGetMinY(self.frame);
}

+ (UIViewAnimationOptions) animationOptionsFromCurve: (UIViewAnimationCurve) curve
{
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
    
    switch (curve)
    {
        case UIViewAnimationCurveEaseInOut:
            options = UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            options = UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            options = UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            options = UIViewAnimationOptionCurveLinear;
            break;
        default:
            break;
    }
    
    return options;
}


@end

