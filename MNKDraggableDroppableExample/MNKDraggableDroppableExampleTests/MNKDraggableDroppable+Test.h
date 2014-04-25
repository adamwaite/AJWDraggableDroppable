//
//  MNKDraggableDroppable+Test.h
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 25/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "MNKDraggableDroppable.h"

@interface MNKDraggableDroppable (Test)

- (void)draggableDragGestureDidStart:(UIPanGestureRecognizer *)sender;
- (void)draggableDragGestureDidContinue:(UIPanGestureRecognizer *)sender;
- (void)draggableDragGestureDidEnd:(UIPanGestureRecognizer *)sender;

@end
