/*
 
 AJWDraggableDroppable.m
 AJWDraggableDroppable
 
 Created by @adamwaite.
 
 Copyright (c) 2014 Adam Waite. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "AJWDraggableDroppable.h"
#import "AJWDraggableGestureRecognizer.h"
#import "UIView+AJWDraggablePrivate.h"
#import "UIView+AJWDroppablePrivate.h"

@interface AJWDraggableDroppable () <UIDynamicAnimatorDelegate>

{
    struct {
        unsigned int draggableGestureDidBegin : 1;
        unsigned int draggableGestureDidEnd : 1;
    } _delegateSelectorResponseFlags;
}

@property (strong, nonatomic) NSMutableSet *mutableDraggables;
@property (strong, nonatomic) NSMutableSet *mutableDroppables;
@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (strong, nonatomic) UISnapBehavior *dragSnapBackBehaviour;

@end

@implementation AJWDraggableDroppable

#pragma mark Initialisation

- (id)init
{
    self = [super init];
    if (self) {
        NSAssert(NO, @"Use initWithReferenceView");
    }
    return self;
}

- (instancetype)initWithReferenceView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.referenceView = view;
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

- (void)setDelegate:(id<AJWDraggableDroppableDelegate>)delegate
{
    _delegate = delegate;
    _delegateSelectorResponseFlags.draggableGestureDidBegin = [delegate respondsToSelector:@selector(draggableDroppable:draggableGestureDidBegin:draggable:)];
    _delegateSelectorResponseFlags.draggableGestureDidEnd = [delegate respondsToSelector:@selector(draggableDroppable:draggableGestureDidEnd:draggable:droppable:)];
}

#pragma mark View Registration

- (UIPanGestureRecognizer *)registerDraggableView:(UIView *)view
{
    if ([self.mutableDraggables containsObject:view]) {
        return nil;
    }
    
    AJWDraggableGestureRecognizer *drag = [[AJWDraggableGestureRecognizer alloc] initWithTarget:self action:@selector(draggableDragged:) referenceView:self.referenceView];
    [view addGestureRecognizer:drag];
    [self.mutableDraggables addObject:view];
    
    return drag;
}

- (void)deregisterDraggableView:(UIView *)view
{
    [view.gestureRecognizers enumerateObjectsUsingBlock:^(UIGestureRecognizer *recognizer, NSUInteger idx, BOOL *stop) {
        if ([recognizer isKindOfClass:[AJWDraggableGestureRecognizer class]]) {
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

- (void)draggableDragged:(AJWDraggableGestureRecognizer *)sender
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

- (void)draggableDragGestureDidStart:(AJWDraggableGestureRecognizer *)sender
{
    if (_delegateSelectorResponseFlags.draggableGestureDidBegin) {
        [self.delegate draggableDroppable:self draggableGestureDidBegin:sender draggable:sender.view];
    }
    
    [self applyAppearanceState:AJWDraggableStateDragging toDraggable:sender.draggable];
    [self applyAppearanceStateToAllRegisteredDroppables:AJWDroppableStatePending];

}

- (void)draggableDragGestureDidContinue:(AJWDraggableGestureRecognizer *)sender
{
    [self applyAppearanceStateToAllRegisteredDroppables:AJWDroppableStatePending];
    
    UIView *droppableUnderDraggable = [self droppableUnderDraggable:sender.draggable];
    
    if (droppableUnderDraggable) {
        [self applyAppearanceState:AJWDraggableStateHovering toDraggable:sender.draggable];
        [self applyAppearanceState:AJWDroppableStatePendingDrop toDroppable:droppableUnderDraggable];
    }
    
    else {
        [self applyAppearanceState:AJWDraggableStateDragging toDraggable:sender.draggable];
    }
}

- (void)draggableDragGestureDidEnd:(AJWDraggableGestureRecognizer *)sender
{
    UIView *droppableUnderDraggable = [self droppableUnderDraggable:sender.draggable];
    
    if (_delegateSelectorResponseFlags.draggableGestureDidEnd) {
        [self.delegate draggableDroppable:self draggableGestureDidEnd:sender draggable:sender.view droppable:droppableUnderDraggable];
    }
    
    if (droppableUnderDraggable != nil) {
        if (self.snapsDraggablesToDroppableSnapPointOnHit) {
            [self snapDragabbleToDroppableSnapPointFromGesture:sender droppable:droppableUnderDraggable];
        }
    }
    
    else {
        if (self.snapsDraggablesBackToDragStartOnMiss) {
            [self snapDraggableToStartingLocationFromGesture:sender];
        }
    }
    
    [self applyAppearanceStateToAllRegisteredDroppables:AJWDroppableStateRegular];

    [self applyAppearanceState:AJWDraggableStateRegular toDraggable:sender.draggable];
    
}

#pragma mark Calculations and Utilities

- (UIView *)droppableUnderDraggable:(UIView *)draggable
{
    __block UIView *droppableUnderDraggable;
    
    [self.droppables enumerateObjectsUsingBlock:^(id droppable, BOOL *stop) {
        CGPoint draggableCenterRelativeToWindow = [draggable.superview convertPoint:draggable.center toView:droppable];
        if (CGRectContainsPoint([(UIView *)droppable bounds], draggableCenterRelativeToWindow)) {
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

#pragma mark Appearance State Application

- (void)applyAppearanceState:(AJWDraggableState)state toDraggable:(UIView *)draggable
{
    switch (state) {
        case AJWDraggableStateRegular: {
            if ([draggable respondsToSelector:@selector(draggableViewApplyAppearanceStateRegular)]) {
                [(id<AJWDraggableView>)draggable draggableViewApplyAppearanceStateRegular];
            }
            break;
        }
        case AJWDraggableStateDragging: {
            if ([draggable respondsToSelector:@selector(draggableViewApplyAppearanceStateDragging)]) {
                [(id<AJWDraggableView>)draggable draggableViewApplyAppearanceStateDragging];
            }
            break;
        }
        case AJWDraggableStateHovering: {
            if ([draggable respondsToSelector:@selector(draggableViewApplyAppearanceStateHovering)]) {
                [(id<AJWDraggableView>)draggable draggableViewApplyAppearanceStateHovering];
            }
            break;
        }
    }
}

- (void)applyAppearanceState:(AJWDroppableState)state toDroppable:(UIView *)droppable
{
    switch (state) {
        case AJWDroppableStateRegular: {
            if ([droppable respondsToSelector:@selector(droppableViewApplyAppearanceStateRegular)]) {
                [(id<AJWDroppableView>)droppable droppableViewApplyAppearanceStateRegular];
            }
            break;
        }
        case AJWDroppableStatePending: {
            if ([droppable respondsToSelector:@selector(droppableViewApplyAppearanceStatePending)]) {
                [(id<AJWDroppableView>)droppable droppableViewApplyAppearanceStatePending];
            }
            break;
        }
        case AJWDroppableStatePendingDrop: {
            if ([droppable respondsToSelector:@selector(droppableViewApplyAppearanceStatePendingDrop)]) {
                [(id<AJWDroppableView>)droppable droppableViewApplyAppearanceStatePendingDrop];
            }
            break;
        }
    }
}

- (void)applyAppearanceStateToAllRegisteredDroppables:(AJWDroppableState)state
{
    [self.droppables enumerateObjectsUsingBlock:^(id droppable, BOOL *stop) {
        
        switch (state) {
            case AJWDroppableStateRegular: {
                [self applyAppearanceState:AJWDroppableStateRegular toDroppable:droppable];
                break;
            }
            case AJWDroppableStatePending: {
                [self applyAppearanceState:AJWDroppableStatePending toDroppable:droppable];
                break;
            }
            case AJWDroppableStatePendingDrop: {
                [self applyAppearanceState:AJWDroppableStatePendingDrop toDroppable:droppable];
                break;
            }
        }
        
    }];
}

#pragma mark Snaps

- (void)snapDraggableToStartingLocationFromGesture:(UIPanGestureRecognizer *)gesture
{
    [self.dynamicAnimator addBehavior:[(AJWDraggableGestureRecognizer *)gesture snapBackBehaviour]];
}

- (void)snapDragabbleToDroppableSnapPointFromGesture:(UIPanGestureRecognizer *)gesture droppable:(UIView *)droppable
{
    [self.dynamicAnimator addBehavior:[droppable AJW_dropSnapBehaviour:[(AJWDraggableGestureRecognizer *)gesture draggable] referenceView:self.referenceView]];
}

#pragma mark UIDynamicAnimatorDelegate

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self.dynamicAnimator removeAllBehaviors];
}

@end