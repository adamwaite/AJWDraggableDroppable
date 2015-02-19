//
//  UIView+AJWDroppablePrivate.h
//  AJWDraggableDroppableExample
//
//  Created by Adam Waite on 29/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AJWDroppablePrivate)

- (UISnapBehavior *)AJW_dropSnapBehaviour:(UIView *)draggable referenceView:(UIView *)referenceView;

@end
