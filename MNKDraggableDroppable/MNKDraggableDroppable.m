//
//  MNKDraggableDroppableController.m
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 23/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "MNKDraggableDroppable.h"
#import "MNKDraggableGestureRecognizer.h"

@interface MNKDraggableDroppable ()

@property (strong, nonatomic) NSMutableSet *mutableDraggables;

@property (strong, nonatomic) NSMutableSet *mutableDroppables;

@end

@implementation MNKDraggableDroppable

#pragma mark Init

+ (instancetype)controller
{
    return [[[self class] alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mutableDraggables = [NSMutableSet set];
        self.mutableDroppables = [NSMutableSet set];
    }
    return self;
}

#pragma mark Accessors

- (NSSet *)draggables
{
    return [NSSet setWithSet:self.mutableDraggables];
}

- (NSSet *)droppables
{
    return [NSSet setWithSet:self.mutableDroppables];
}

#pragma mark Draggable Registration

- (UIPanGestureRecognizer *)registerDraggableView:(UIView *)view
{
    if ([self.mutableDraggables containsObject:view]) {
        return nil;
    }
    
    MNKDraggableGestureRecognizer *drag = [[MNKDraggableGestureRecognizer alloc] initWithTarget:self action:@selector(draggableDragged:)];
    [view addGestureRecognizer:drag];
    [self.mutableDraggables addObject:view];
    
    return drag;
}

- (void)deregisterDraggableView:(UIView *)view
{
    [view.gestureRecognizers enumerateObjectsUsingBlock:^(UIGestureRecognizer *recognizer, NSUInteger idx, BOOL *stop) {
        if ([recognizer isKindOfClass:[MNKDraggableGestureRecognizer class]]) {
            [view removeGestureRecognizer:recognizer];
        }
    }];
    
    [self.mutableDraggables removeObject:view];
}

#pragma mark Droppable Registration

- (void)registerDroppableView:(UIView *)view
{
    [self.mutableDroppables addObject:view];
}

- (void)deregisterDroppableView:(UIView *)view
{
    [self.mutableDroppables removeObject:view];
}

#pragma mark Draggable Gesture Handling

- (void)draggableDragged:(UIPanGestureRecognizer *)sender
{
    static CGPoint startTouchLocation;
    CGPoint touchLocation;
    
    UIView *draggable = sender.view;
    
    CGRect dragBounds = ([draggable respondsToSelector:@selector(draggableViewDragBounds)]) ? [(id<MNKDraggableView>)draggable draggableViewDragBounds] : CGRectInfinite;
    
    switch (sender.state) {
            
        case UIGestureRecognizerStateBegan: {
            startTouchLocation = [sender locationInView:nil];
            [self draggableDragGestureDidStart:sender];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            // TODO: grab location of the touch in the view relative to window and return if the touch point is outside the bounds
            touchLocation = [sender locationInView:nil];
            sender.view.center = CGPointMake(touchLocation.x, touchLocation.y);
            [self draggableDragGestureDidContinue:sender];
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            startTouchLocation = CGPointZero;
            [self draggableDragGestureDidEnd:sender];
            break;
        }
            
        default: {
            break;
        }
            
    }
    
}

- (void)draggableDragGestureDidStart:(UIPanGestureRecognizer *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableDroppable:draggableGestureDidBegin:draggable:)]) {
        [self.delegate draggableDroppable:self draggableGestureDidBegin:sender draggable:sender.view];
    }
    
    [self.droppables enumerateObjectsUsingBlock:^(id droppable, BOOL *stop) {
        if ([droppable respondsToSelector:@selector(droppableViewApplyPendingState)]) {
            [(id<MNKDroppableView>)droppable droppableViewApplyPendingState];
        }
    }];
}

- (void)draggableDragGestureDidContinue:(UIPanGestureRecognizer *)sender
{
    UIView *draggable = sender.view;
    __block UIView *hoveringDropZone;

    [self.droppables enumerateObjectsUsingBlock:^(id droppable, BOOL *stop) {
        
        CGPoint draggableCenterRelativeToWindow = [draggable.superview convertPoint:draggable.center toView:droppable];
    
        if (CGRectContainsPoint([(UIView *)droppable bounds], draggableCenterRelativeToWindow)) {
            
            if ([droppable respondsToSelector:@selector(droppableViewApplyPendingDropState)]) {
                [droppable droppableViewApplyPendingDropState];
            }
            
            hoveringDropZone = droppable;
            *stop = YES;
            
        }
        
        else {
            
            [self.droppables enumerateObjectsUsingBlock:^(id droppable, BOOL *stop) {
                if ([droppable respondsToSelector:@selector(droppableViewApplyPendingState)]) {
                    [(id<MNKDroppableView>)droppable droppableViewApplyPendingState];
                }
            }];
            
        }
        
    }];
}

- (void)draggableDragGestureDidEnd:(UIPanGestureRecognizer *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableDroppable:draggableGestureDidEnd:draggable:)]) {
        [self.delegate draggableDroppable:self draggableGestureDidEnd:sender draggable:sender.view];
    }
    
    [self.droppables enumerateObjectsUsingBlock:^(id droppable, BOOL *stop) {
        if ([droppable respondsToSelector:@selector(droppableViewApplyRegularState)]) {
            [(id<MNKDroppableView>)droppable droppableViewApplyRegularState];
        }
    }];
}

@end