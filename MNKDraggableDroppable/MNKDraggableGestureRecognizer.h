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
@property (nonatomic) CGPoint viewDragStartCenterInReference;
@property (weak, nonatomic, readonly) UIView *draggable;
@property (strong, nonatomic, readonly) UIView *referenceView;

- (id)initWithTarget:(id)target action:(SEL)action referenceView:(UIView *)referenceView;
- (void)resetState;
- (UISnapBehavior *)snapBackBehaviour;

@end
