//
//  UIView+MNKDroppable.m
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 28/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "UIView+MNKDroppable.h"
#import "MNKDroppableView.h"

@implementation UIView (MNKDroppable)

- (UISnapBehavior *)mnk_dropSnapBehaviour:(UIView *)draggable
{
    CGPoint snapPoint = self.center;
    
    if ([self respondsToSelector:@selector(droppableSnapPoint)]) {
        snapPoint = [(id<MNKDroppableView>)self droppableSnapPoint];
    }
    
    return [[UISnapBehavior alloc] initWithItem:draggable snapToPoint:snapPoint];
}

@end
