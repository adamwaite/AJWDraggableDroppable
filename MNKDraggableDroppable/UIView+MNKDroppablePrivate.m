//
//  UIView+MNKDroppablePrivate.m
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 29/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "UIView+MNKDroppablePrivate.h"
#import "MNKDroppableView.h"

@implementation UIView (MNKDroppablePrivate)

- (UISnapBehavior *)mnk_dropSnapBehaviour:(UIView *)draggable referenceView:(UIView *)referenceView
{
    CGPoint snapPoint = [self convertPoint:self.center toView:referenceView];
    
    if ([self respondsToSelector:@selector(droppableViewSnapPoint)]) {
        snapPoint = [self convertPoint:[(id<MNKDroppableView>)self droppableViewSnapPoint] toView:referenceView];
    }
    
    return [[UISnapBehavior alloc] initWithItem:draggable snapToPoint:snapPoint];
}

@end