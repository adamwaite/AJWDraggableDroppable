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

- (UISnapBehavior *)mnk_dropSnapBehaviour:(UIView *)draggable
{
    CGPoint snapPoint = self.center;
    
    if ([self respondsToSelector:@selector(droppableSnapPoint)]) {
        snapPoint = [(id<MNKDroppableView>)self droppableViewSnapPoint];
    }
    
    return [[UISnapBehavior alloc] initWithItem:draggable snapToPoint:snapPoint];
}

@end