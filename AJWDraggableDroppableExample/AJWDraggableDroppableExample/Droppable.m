//
//  Droppable.m
//  AJWDraggableDroppableExample
//
//  Created by Adam Waite on 24/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "Droppable.h"
#import "AJWDraggableDroppable.h"

@interface Droppable () <AJWDroppableView>
@end

@implementation Droppable

#pragma mark Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [self standardColor];
    }
    return self;
}

#pragma mark AJWDroppableView

- (void)droppableViewApplyAppearanceStateRegular
{
    self.backgroundColor = [self standardColor];
}

- (void)droppableViewApplyAppearanceStatePending
{
    self.backgroundColor = [self pendingColor];
}

- (void)droppableViewApplyAppearanceStatePendingDrop
{
    self.backgroundColor = [self pendingDropColor];
}

- (CGPoint)droppableViewSnapPoint
{
    return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

#pragma mark Colors

- (UIColor *)standardColor
{
    return [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
}

- (UIColor *)pendingColor
{
    return [UIColor colorWithRed:0.66 green:0.1 blue:0.2 alpha:0.5];
}

- (UIColor *)pendingDropColor
{
    return [UIColor colorWithRed:0.66 green:0.1 blue:0.2 alpha:1];
}

@end
