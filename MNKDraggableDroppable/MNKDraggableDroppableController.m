//
//  MNKDraggableDroppableController.m
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 23/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "MNKDraggableDroppableController.h"

@implementation MNKDraggableDroppableController

#pragma mark Init

+ (instancetype)draggableDroppableController
{
    return [MNKDraggableDroppableController new];
}

#pragma mark View Registration

- (UIPanGestureRecognizer *)registerDraggableView:(UIView *)view
{
    return nil;
}

- (void)registerDroppableView:(UIView *)view
{
    
}

@end
