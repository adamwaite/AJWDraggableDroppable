//
//  MNKDraggableDroppableController.m
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 23/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "MNKDraggableDroppableController.h"
#import "UIView+MNKDraggable.h"
#import "UIView+MNKDroppable.h"

@implementation MNKDraggableDroppableController

#pragma mark View Registration

- (UIPanGestureRecognizer *)registerDraggableView:(id<MNKDraggableView>)view
{
    return [(UIView *)view mnk_makeDraggable];
}

- (void)registerDroppableView:(id<MNKDroppableView>)view
{
}

@end
