//
//  MNKDraggableDroppableController.m
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 23/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "MNKDraggableDroppable.h"
#import "MNKDraggableGestureRecognizer.h"

@interface MNKDraggableDroppable () <UIDynamicAnimatorDelegate>

@property (strong, nonatomic) NSMutableSet *mutableDraggables;
@property (strong, nonatomic) NSMutableSet *mutableDroppables;
@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

@property (nonatomic) CGPoint dragTouchStart;
@property (nonatomic) CGPoint draggableStartCenter;
@property (strong, nonatomic) UISnapBehavior *dragSnapBackBehaviour;

@end

@implementation MNKDraggableDroppable

#pragma mark Init

+ (instancetype)controllerWithReferenceView:(UIView *)view
{
    return [[[self class] alloc] initWithReferenceView:view];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithReferenceView:(UIView *)view
{
    self = [super init];
    if (self) {
        _referenceView = view;
        [self configure];
    }
    return self;
}

- (void)configure
{
    _mutableDraggables = [NSMutableSet set];
    _mutableDroppables = [NSMutableSet set];
}

- (void)setReferenceView:(UIView *)referenceView
{
    _referenceView = referenceView;
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.referenceView];
    self.dynamicAnimator.delegate = self;
}

#pragma mark Description

- (NSString *)description
{
    NSDictionary *output = @{
        @"Reference view": (self.referenceView) ? self.referenceView : [NSNull null],
        @"Delegate": (self.delegate) ? (id)self.delegate : [NSNull null],
        @"Draggables count": @([self.draggables count]),
        @"Droppables count": @([self.droppables count]),
    };
    return [NSString stringWithFormat:@"%@ %p: %@", [self class], self, output];
}

- (NSString *)debugDescription
{
    return [self description];
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
    CGPoint touchLocation;
    
    UIView *draggable = sender.view;
    self.draggableStartCenter = draggable.center;
    
    CGRect dragBounds = ([draggable respondsToSelector:@selector(draggableViewDragBounds)]) ? [(id<MNKDraggableView>)draggable draggableViewDragBounds] : CGRectInfinite;
    
    switch (sender.state) {
            
        case UIGestureRecognizerStateBegan: {
            self.dragTouchStart = [sender locationInView:nil];
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
            self.dragTouchStart = CGPointZero;
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
    
    if (self.snapsDraggablesBackToDragStartOnMiss) {
        self.dragSnapBackBehaviour = [[UISnapBehavior alloc] initWithItem:sender.view snapToPoint:self.draggableStartCenter];
        self.dragSnapBackBehaviour.damping = 0.65;
    }
    
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
    
    if (self.dragSnapBackBehaviour) {
        [self.dynamicAnimator addBehavior:self.dragSnapBackBehaviour];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableDroppable:draggableGestureDidEnd:draggable:)]) {
        [self.delegate draggableDroppable:self draggableGestureDidEnd:sender draggable:sender.view];
    }
    
    [self.droppables enumerateObjectsUsingBlock:^(id droppable, BOOL *stop) {
        if ([droppable respondsToSelector:@selector(droppableViewApplyRegularState)]) {
            [(id<MNKDroppableView>)droppable droppableViewApplyRegularState];
        }
    }];
   
}

#pragma mark UIDynamicAnimatorDelegate

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self.dynamicAnimator removeAllBehaviors];
}

@end