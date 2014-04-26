//
//  MNKDroppableView.h
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 26/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import <Foundation/Foundation.h>

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
