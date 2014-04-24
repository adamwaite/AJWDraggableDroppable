//
//  UIView+MNKDraggable.h
//  
//
//  Created by Adam Waite on 23/04/2014.
//
//

#import <UIKit/UIKit.h>

@interface UIView (MNKDraggable)

/**
 *  Adds draggable behaviour. Customise the behaviour using the MNKDraggable protocol.
 *
 *  @return UIPAnGestureRecogniser attached to allow draggable behaviour
 */
- (UIPanGestureRecognizer *)mnk_makeDraggable;

@end
