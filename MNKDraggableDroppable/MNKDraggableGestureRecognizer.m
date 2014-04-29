//
//  MNKDraggableGestureRecognizer.m
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 25/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "MNKDraggableGestureRecognizer.h"

@implementation MNKDraggableGestureRecognizer

#pragma mark Init

- (id)initWithTarget:(id)target action:(SEL)action referenceView:(UIView *)referenceView
{
    self = [super initWithTarget:target action:action];
    if (self) {
        _referenceView = referenceView;
        self.maximumNumberOfTouches = 1;
    }
    return self;
}

#pragma mark Additional Tracking

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    self.dragTouchStartPoint = [touch locationInView:nil];
    self.viewDragStartCenter = self.view.center;
    self.viewDragStartCenterInReference = [self.view convertPoint:self.view.center toView:self.referenceView];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    self.view.center = [touch locationInView:self.view.superview];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark Accessors

- (UIView *)draggable
{
    return self.view;
}

#pragma mark State Reset

- (void)resetState
{
    self.dragTouchStartPoint = CGPointZero;
    self.viewDragStartCenter = CGPointZero;
    self.viewDragStartCenterInReference = CGPointZero;
}

#pragma mark Snaps

- (UISnapBehavior *)snapBackBehaviour
{
    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.view snapToPoint:self.viewDragStartCenterInReference];
    snapBehaviour.damping = 0.65;
    return snapBehaviour;
}

@end
