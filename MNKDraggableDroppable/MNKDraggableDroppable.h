//
//  MNKDraggableDroppableController.h
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 23/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MNKDraggableDroppable;


#pragma mark Constants and Types

///--------------------
/// @name Constants
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


#pragma mark MNKDraggableDroppableDelegate Protocol

///--------------------
/// @name MNKDraggableDroppableDelegate
///--------------------

/**
 *  The MNKDraggableView protocol is adopted to customise draggable view behaviour.
 */
@protocol MNKDraggableDroppableDelegate <NSObject>

@optional

/**
 *  Notifies the delegate that a draggable drag gesture was started
 *
 *  @param draggableDroppable: delegating instance
 *  @param gestureRecognizer:  active gesture recogniser on the draggable
 *  @param draggable:          the draggable subject to user touch
 */
- (void)draggableDroppable:(MNKDraggableDroppable *)draggableDroppable draggableGestureDidBegin:(UIPanGestureRecognizer *)gestureRecognizer draggable:(UIView *)draggable;

/**
 *  Notifies the delegate that a draggable drag gesture ended
 *
 *  @param draggableDroppable: delegating instance
 *  @param gestureRecognizer:  active gesture recogniser on the draggable
 *  @param draggable:          the draggable subject to user touch
 */
- (void)draggableDroppable:(MNKDraggableDroppable *)draggableDroppable draggableGestureDidEnd:(UIPanGestureRecognizer *)gestureRecognizer draggable:(UIView *)draggable;

@end


#pragma mark MNKDraggableView Protocol

///--------------------
/// @name MNKDraggableView
///--------------------

/**
 *  The MNKDraggableView protocol is adopted to customise draggable view behaviour.
 */
@protocol MNKDraggableView <NSObject>

@optional

/**
 *  The bounds relative to the screen in which the view's center may not exit during drag gesture. Defaults to infinite surface area.
 *
 *  @return CGRect describing the bounds limit (perhaps a superview bounds?)
 */
- (CGRect)draggableViewDragBounds;

@end


#pragma mark MNKDroppableView Protocol

///--------------------
/// @name MNKDroppableView
///--------------------

/**
 *  The MNKDroppableView protocol is adopted to customise droppable view behaviour.
 */
@protocol MNKDroppableView <NSObject>

@optional

/**
 *  Applies a resting state for the view once a drag gesture is no longer in motion.
 */
- (void)droppableViewApplyRegularState;

/**
 *  Applies a pending state for the view once a drag gesture is in motion but no draggable has entered the droppable bounds.
 */
- (void)droppableViewApplyPendingState;

/**
 *  Applies a state indicating that ending the current drag gesture will drop a draggable into the droppable bounds.
 */
- (void)droppableViewApplyPendingDropState;

@end


#pragma mark MNKDraggableDroppable Class

///--------------------
/// @name MNKDraggableDroppable
///--------------------

/**
 *  `MNKDraggableDroppable` manages a collection of draggable views and a collection of droppable views, and provides a mechanism for handling events involving the two.
 */
@interface MNKDraggableDroppable : NSObject

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
@property (weak, nonatomic) id<MNKDraggableDroppableDelegate> delegate;

/**
 *  Returns an MNKDraggableDroppable instance. Written in the interest of code readability.
 *
 *  @return MNKDraggableDroppable instance
 */
+ (instancetype)controller;

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