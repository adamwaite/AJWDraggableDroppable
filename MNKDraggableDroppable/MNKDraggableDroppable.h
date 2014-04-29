/*
 
 MNKDraggableDroppable.h
 MNKDraggableDroppable
 
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
#import "MNKDraggableView.h"
#import "MNKDroppableView.h"
#import "MNKDraggableDroppableDelegate.h"
#import "UIView+MNKDraggable.h"
#import "UIView+MNKDroppable.h"

#pragma mark Constants and Type Defines

///--------------------
/// @name Constants and Type Defines
///--------------------

/**
 *  Draggable events
 */
typedef NS_ENUM(NSUInteger, MNKDraggableEvent) {
    /**
     *  Drag gesture started
     */
    MNKDraggableEventDragStarted,
    /**
     *  Drag gesture ended
     */
    MNKDraggableEventDragEnded
};

/**
 *  Draggable States
 */
typedef NS_ENUM(NSUInteger, MNKDraggableState) {
    /**
     *  Resting
     */
    MNKDraggableStateRegular,
    /**
     *  Gesture in motion
     */
    MNKDraggableStateDragging,
    /**
     *  Gesture in motion, centre hovering over droppable bounds
     */
    MNKDraggableStateHovering
};

/**
 *  Droppable States
 */
typedef NS_ENUM(NSUInteger, MNKDroppableState) {
    /**
     *  Resting
     */
    MNKDroppableStateRegular,
    /**
     *  Pending a draggable
     */
    MNKDroppableStatePending,
    /**
     *  Draggable hovering over bounds
     */
    MNKDroppableStatePendingDrop
};

#pragma mark MNKDraggableDroppable

///--------------------
/// @name MNKDraggableDroppable
///--------------------

/**
 *  `MNKDraggableDroppable` manages a collection of draggable views and a collection of droppable views, and provides a mechanism for handling events involving the two.
 */
@interface MNKDraggableDroppable : NSObject


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
 *  Conforms to <MNKDraggableDroppableDelegate> to recieve events involving draggables and droppables
 *
 *  @see MNKDraggableDroppableDelegate
 *
 */
@property (weak, nonatomic) IBOutlet id<MNKDraggableDroppableDelegate> delegate;

/**
 *  If YES the draggable will snap back to it's initial location if not dropped in a droppable. Default: NO.
 */
@property (nonatomic) BOOL snapsDraggablesBackToDragStartOnMiss;

/**
 *  If YES the draggable will snap to the snap point of a droppable if dropped in it's bounds. The snap point is either the view's centre coordinate, or sepcified by the <MNKDroppableView> droppableSnapPoint method. Default: YES.
 *
 *  @see <MNKDroppableView>
 *
 */
@property (nonatomic) BOOL snapsDraggablesToDroppableSnapPointOnHit;

/**
 *  Returns an MNKDraggableDroppable instance with a specified view as it's reference view. Returns an allocated `MNKDraggableDroppable` initialised through `initWithRefernceView:`.
 *
 *  @param view: The view to serve as a reference for drag drop behaviour.
 *
 *  @return MNKDraggableDroppable instance
 */
+ (instancetype)controllerWithReferenceView:(UIView *)view;

/**
 *  Designated initialiser
 *
 *  @param  view: The view to serve as a reference for drag drop behaviour.
 *
 *  @return MNKDraggableDroppable instance
 */
- (instancetype)initWithReferenceView:(UIView *)view;

@end

#pragma mark MNKDraggableDroppable+ViewRegistration

///--------------------
/// @name MNKDraggableDroppable+ViewRegistration
///--------------------

@interface MNKDraggableDroppable (ViewRegistration)

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