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
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

#pragma mark MNKDroppableView

- (void)droppableViewApplyRegularState
{
    self.backgroundColor = [UIColor lightGrayColor];
}

- (void)droppableViewApplyPendingState
{
    self.backgroundColor = [UIColor colorWithRed:0.09 green:0.56 blue:0.09 alpha:0.4];
}

- (void)droppableViewApplyPendingDropState
{
    self.backgroundColor = [UIColor colorWithRed:0.09 green:0.56 blue:0.09 alpha:0.65];
}

@end
