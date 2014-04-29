//
//  Draggable.m
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 24/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "Draggable.h"
#import "MNKDraggableDroppable.h"

@interface Draggable () <MNKDraggableView>

@end

@implementation Draggable

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 5.0f;
        self.layer.shadowOpacity = 0;
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }
    return self;
}

#pragma mark MNKDraggableView

- (void)draggableViewApplyAppearanceStateRegular
{
    self.transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.layer.shadowOpacity = 0;
}

- (void)draggableViewApplyAppearanceStateDragging
{
    self.transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.layer.shadowOpacity = 0.6;
}

- (void)draggableViewApplyAppearanceStateHovering
{
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
}

@end
