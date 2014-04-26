//
//  MNKDraggableGestureRecognizer.h
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 25/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface MNKDraggableGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic) CGPoint dragTouchStartPoint;
@property (nonatomic) CGPoint viewDragStartCenter;

- (UISnapBehavior *)snapBackBehaviour;
- (void)resetState;

@end
