/*
 
 MNKDraggableView.h
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

///--------------------
/// @name MNKDraggableView
///--------------------

/**
 *  The MNKDraggableView protocol is adopted to customise draggable view behaviour.
 */
@protocol MNKDraggableView <NSObject>

@optional

/**
 *  Applies a resting state for the view once a drag gesture is no longer in motion.
 */
- (void)draggableViewApplyAppearanceStateRegular;

/**
 *  Applies a dragging state for the view once a drag gesture is in motion but hasn't yet entered a droppable bounds.
 */
- (void)draggableViewApplyAppearanceStateDragging;

/**
 *  Applies a state indicating that ending the current drag gesture will drop the view into a droppable bounds.
 */
- (void)draggableViewApplyAppearanceStateHovering;

/**
 *  The bounds relative to the screen in which the view's center may not exit during drag gesture. Defaults to infinite surface area.
 *
 *  @return CGRect describing the bounds limit (perhaps a superview bounds?)
 */
- (CGRect)draggableViewDragBounds;

@end