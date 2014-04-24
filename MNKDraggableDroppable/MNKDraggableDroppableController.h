//
//  MNKDraggableDroppableController.h
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 23/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNKDraggableDroppableController : NSObject

+ (instancetype)draggableDroppableController;

- (UIPanGestureRecognizer *)registerDraggableView:(UIView *)view;
- (void)registerDroppableView:(UIView *)view;

@end
