//
//  MNKDraggableView.h
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 26/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import <Foundation/Foundation.h>

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