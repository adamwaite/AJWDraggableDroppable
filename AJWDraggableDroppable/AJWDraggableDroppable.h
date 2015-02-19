/*
 
 AJWDraggableDroppable.h
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

#import <Foundation/Foundation.h>
#import "AJWDraggableView.h"
#import "AJWDroppableView.h"
#import "AJWDraggableDroppableDelegate.h"
#import "UIView+AJWDraggable.h"
#import "UIView+AJWDroppable.h"

#pragma mark Constants and Type Defines

///--------------------
/// @name Constants and Type Defines
///--------------------

/**
 *  Draggable events
 */
typedef NS_ENUM(NSUInteger, AJWDraggableEvent) {
    /**
     *  Drag gesture started
     */
    AJWDraggableEventDragStarted,
    /**
     *  Drag gesture ended
     */
    AJWDraggableEventDragEnded
};

/**
 *  Draggable States
 */
typedef NS_ENUM(NSUInteger, AJWDraggableState) {
    /**
     *  Resting
     */
    AJWDraggableStateRegular,
    /**
     *  Gesture in motion
     */
    AJWDraggableStateDragging,
    /**
     *  Gesture in motion, centre hovering over droppable bounds
     */
    AJWDraggableStateHovering
};

/**
 *  Droppable States
 */
typedef NS_ENUM(NSUInteger, AJWDroppableState) {
    /**
     *  Resting
     */
    AJWDroppableStateRegular,
    /**
     *  Pending a draggable
     */
    AJWDroppableStatePending,
    /**
     *  Draggable hovering over bounds
     */
    AJWDroppableStatePendingDrop
};

#pragma mark AJWDraggableDroppable

///--------------------
/// @name AJWDraggableDroppable
///--------------------

/**
 *  `AJWDraggableDroppable` manages a collection of draggable views and a collection of droppable views, and provides a mechanism for handling events involving the two.
 */
@interface AJWDraggableDroppable : NSObject


/**
 *  The reference view containing draggables and droppables, typically a UIViewController view.
 */
@property (weak, nonatomic) IBOutlet UIView *referenceView;

/**
 *  A collection of draggable views.
 */
@property (copy, nonatomic, readonly) NSSet *draggables;

/**
 *  A collection of droppable views.
 */
@property (copy, nonatomic, readonly) NSSet *droppables;

/**
 *  Conforms to <AJWDraggableDroppableDelegate> to recieve events involving draggables and droppables
 *
 *  @see AJWDraggableDroppableDelegate
 *
 */
@property (weak, nonatomic) IBOutlet id<AJWDraggableDroppableDelegate> delegate;

/**
 *  If YES the draggable will snap back to it's initial location if not dropped in a droppable. Default: NO.
 */
@property (nonatomic) BOOL snapsDraggablesBackToDragStartOnMiss;

/**
 *  If YES the draggable will snap to the snap point of a droppable if dropped in it's bounds. The snap point is either the view's centre coordinate, or sepcified by the <AJWDroppableView> droppableSnapPoint method. Default: YES.
 *
 *  @see <AJWDroppableView>
 *
 */
@property (nonatomic) BOOL snapsDraggablesToDroppableSnapPointOnHit;

/**
 *  Designated initialiser
 *
 *  @param  view: The view to serve as a reference for drag drop behaviour.
 *
 *  @return AJWDraggableDroppable instance
 */
- (instancetype)initWithReferenceView:(UIView *)view;

/**
 *  Snaps the draggable back to it's initial location at the beginning of the pan gesture
 *
 *  @param gesture Gesture used to pan the draggable
 */
- (void)snapDraggableToStartingLocationFromGesture:(UIPanGestureRecognizer *)gesture;

/**
 *  Snaps the draggable back to the snapPointLocation defined in the <AJWDroppableView> view conforming droppable
 *
 *  @param gesture   Gesture used to pan the draggable
 *  @param droppable Droppable to snap to
 */
- (void)snapDragabbleToDroppableSnapPointFromGesture:(UIPanGestureRecognizer *)gesture droppable:(UIView *)droppable;


@end

#pragma mark AJWDraggableDroppable+ViewRegistration

///--------------------
/// @name AJWDraggableDroppable+ViewRegistration
///--------------------

@interface AJWDraggableDroppable (ViewRegistration)

/**
 *  Adds draggable behaviour to the UIView and adds the view to the draggables collection.
 *
 *  @param view: a UIView to add draggable bahaviour to.
 *
 *  @return UIPanGestureRecogniser providing drag behaviour.
 */
- (UIPanGestureRecognizer *)registerDraggableView:(UIView *)view;

/**
 *  Removes draggable behaviour from the UIView and removes the view from the draggables collection.
 *
 *  @param view: the view to remove the draggable behaviour from.
 */
- (void)deregisterDraggableView:(UIView *)view;

/**
 *  Adds droppable behaviour to the UIView and adds the view to the droppables collection.
 *
 *  @param view: a UIView to add droppable bahaviour to.
 */
- (void)registerDroppableView:(UIView *)view;

/**
 *  Removes droppable behaviour from the UIView and removes the view from the droppables collection.
 *
 *  @param view: the view to remove the droppable behaviour from.
 */
- (void)deregisterDroppableView:(UIView *)view;

@end