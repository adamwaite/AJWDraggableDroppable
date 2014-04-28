//
//  MNKDraggableDroppable.m
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 23/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "MNKDraggableDroppable.h"
#import "MNKDraggableGestureRecognizer.h"
#import "UIView+MNKDroppable.h"

@interface MNKDraggableDroppable () <UIDynamicAnimatorDelegate>

{
    struct {
        unsigned int draggableGestureDidBegin : 1;
        unsigned int draggableGestureDidEnd : 1;
        unsigned int draggableDroppedInDroppable : 1;
    } _delegateSelectorResponseFlags;
}

@property (strong, nonatomic) NSMutableSet *mutableDraggables;
@property (strong, nonatomic) NSMutableSet *mutableDroppables;
@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (strong, nonatomic) UISnapBehavior *dragSnapBackBehaviour;

@end

@implementation MNKDraggableDroppable

#pragma mark Initialisation

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
    _snapsDraggablesToDroppableSnapPointOnHit = YES;
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

- (void)setDelegate:(id<MNKDraggableDroppableDelegate>)delegate
{
    _delegate = delegate;
    _delegateSelectorResponseFlags.draggableGestureDidBegin = [delegate respondsToSelector:@selector(draggableDroppable:draggableGestureDidBegin:draggable:)];
    _delegateSelectorResponseFlags.draggableGestureDidEnd = [delegate respondsToSelector:@selector(draggableDroppable:draggableGestureDidEnd:draggable:)];
    _delegateSelectorResponseFlags.draggableDroppedInDroppable = [delegate respondsToSelector:@selector(draggableDroppable:draggable:didDropIntoDroppable:gesture:)];
}

#pragma mark View Registration

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

- (void)registerDroppableView:(UIView *)view
{
    [self.mutableDroppables addObject:view];
}

- (void)deregisterDroppableView:(UIView *)view
{
    [self.mutableDroppables removeObject:view];
}

#pragma mark Draggable Gesture Handling

- (void)draggableDragged:(MNKDraggableGestureRecognizer *)sender
{
  
    switch (sender.state) {
            
        case UIGestureRecognizerStateBegan: {
            [self draggableDragGestureDidStart:sender];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            [self draggableDragGestureDidContinue:sender];
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self draggableDragGestureDidEnd:sender];
            break;
        }
            
        default: {
            break;
        }
            
    }
    
}

- (void)draggableDragGestureDidStart:(MNKDraggableGestureRecognizer *)sender
{
    if (_delegateSelectorResponseFlags.draggableGestureDidBegin) {
        [self.delegate draggableDroppable:self draggableGestureDidBegin:sender draggable:sender.view];
    }
    
    [self.droppables enumerateObjectsUsingBlock:^(id droppable, BOOL *stop) {
        if ([droppable respondsToSelector:@selector(droppableViewApplyPendingState)]) {
            [(id<MNKDroppableView>)droppable droppableViewApplyPendingState];
        }
    }];
}

- (void)draggableDragGestureDidContinue:(MNKDraggableGestureRecognizer *)sender
{
    UIView *draggable = sender.view;
    
    UIView *droppableUnderDraggable = [self droppableUnderDraggable:draggable];
    
    if (droppableUnderDraggable && [droppableUnderDraggable respondsToSelector:@selector(droppableViewApplyPendingDropState)]) {
        [(id<MNKDroppableView>)droppableUnderDraggable droppableViewApplyPendingDropState];
    }

}

- (void)draggableDragGestureDidEnd:(MNKDraggableGestureRecognizer *)sender
{
    
    UIView *droppableUnderDraggable = [self droppableUnderDraggable:sender.draggable];
    if (droppableUnderDraggable != nil) {
        
        if (_delegateSelectorResponseFlags.draggableGestureDidEnd) {
            [self.delegate draggableDroppable:self draggable:sender.draggable didDropIntoDroppable:droppableUnderDraggable gesture:sender];
        }
    
        if (self.snapsDraggablesToDroppableSnapPointOnHit) {
            [self snapDragabbleToDroppableSnapPoint:sender droppable:droppableUnderDraggable];
        }
        
    }
    
    else {
        
        if (self.snapsDraggablesBackToDragStartOnMiss) {
            [self snapDraggableToStart:sender];
        }
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableDroppable:draggableGestureDidEnd:draggable:)]) {
        [self.delegate draggableDroppable:self draggableGestureDidEnd:sender draggable:sender.view];
    }
    
    [self applyRegularStateOnDroppables];
    
    [sender resetState];
}

#pragma mark Calculations and Utilities

- (UIView *)droppableUnderDraggable:(UIView *)draggable
{
    __block UIView *droppableUnderDraggable;
    
    [self.droppables enumerateObjectsUsingBlock:^(id droppable, BOOL *stop) {
        CGPoint draggableCenterRelativeToWindow = [draggable.superview convertPoint:draggable.center toView:droppable];
        if (CGRectContainsPoint([(UIView *)droppable bounds], draggableCenterRelativeToWindow)) {
            if ([droppable respondsToSelector:@selector(droppableViewApplyPendingDropState)]) {
                [droppable droppableViewApplyPendingDropState];
            }
            droppableUnderDraggable = droppable;
            *stop = YES;
        }
    }];
    
    return droppableUnderDraggable;
    
}

- (BOOL)isDraggableOnADroppable:(UIView *)draggable
{
    return ([self droppableUnderDraggable:draggable] != nil);
}

#pragma mark Draggable State Application

- (void)applyPendingStateOnDroppables
{
    [self.droppables enumerateObjectsUsingBlock:^(id droppable, BOOL *stop) {
        if ([droppable respondsToSelector:@selector(droppableViewApplyPendingState)]) {
            [(id<MNKDroppableView>)droppable droppableViewApplyPendingState];
        }
    }];
}

- (void)applyRegularStateOnDroppables
{
    [self.droppables enumerateObjectsUsingBlock:^(id droppable, BOOL *stop) {
        if ([droppable respondsToSelector:@selector(droppableViewApplyRegularState)]) {
            [(id<MNKDroppableView>)droppable droppableViewApplyRegularState];
        }
    }];
}

#pragma mark Snaps

- (void)snapDraggableToStart:(MNKDraggableGestureRecognizer *)gesture
{
    [self.dynamicAnimator addBehavior:[gesture snapBackBehaviour]];
}

- (void)snapDragabbleToDroppableSnapPoint:(MNKDraggableGestureRecognizer *)gesture droppable:(UIView *)droppable
{
    [self.dynamicAnimator addBehavior:[droppable mnk_dropSnapBehaviour:gesture.draggable]];    
}

#pragma mark UIDynamicAnimatorDelegate

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self.dynamicAnimator removeAllBehaviors];
}

@end