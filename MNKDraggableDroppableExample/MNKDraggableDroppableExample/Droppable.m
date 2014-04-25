//
//  Droppable.m
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 24/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "Droppable.h"
#import "MNKDraggableDroppable.h"

@interface Droppable () <MNKDroppableView>
@end

@implementation Droppable

#pragma mark Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [self restingColor];
    }
    return self;
}

#pragma mark MNKDroppableView

- (void)droppableViewApplyRegularState
{
    self.backgroundColor = [self restingColor];
}

- (void)droppableViewApplyPendingState
{
    self.backgroundColor = [self pendingColor];
}

- (void)droppableViewApplyPendingDropState
{
    self.backgroundColor = [self hoverColor];
}

#pragma mark Colors

- (UIColor *)restingColor
{
    return [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
}

- (UIColor *)pendingColor
{
    return [UIColor colorWithRed:0.09 green:0.56 blue:0.09 alpha:0.4];
}

- (UIColor *)hoverColor
{
    return [UIColor colorWithRed:0.09 green:0.56 blue:0.09 alpha:0.8];
}

@end
