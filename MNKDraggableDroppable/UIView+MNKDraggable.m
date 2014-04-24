//
//  UIView+MNKDraggable.m
//  
//
//  Created by Adam Waite on 23/04/2014.
//
//

#import "UIView+MNKDraggable.h"
#import "MNKDraggableDroppable.h"

NSString * const MNKDraggableDroppableNotificationDraggingDidBegin = @"MNKDraggableDroppableNotificationDraggingDidBegin";
NSString * const MNKDraggableDroppableNotificationDraggingDidEnd = @"MNKDraggableDroppableNotificationDraggingDidEnd";

@implementation UIView (MNKDraggable)

#pragma mark Add Draggable Behaviour

- (UIPanGestureRecognizer *)mnk_makeDraggable
{
    UIPanGestureRecognizer *dragPanGestureRecogniser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mnk_draggableDragged:)];
    [self addGestureRecognizer:dragPanGestureRecogniser];
    return dragPanGestureRecogniser;
}

#pragma mark Draggable Handler

- (void)mnk_draggableDragged:(UIPanGestureRecognizer *)sender
{
    CGRect dragBounds = CGRectInfinite;
    
    if ([self respondsToSelector:@selector(mnk_draggableViewDragBounds)]) {
        dragBounds = [(id<MNKDraggableView>)self mnk_draggableViewDragBounds];
    }
    
    /*
     CGFloat innerStopBlockPadding = 5;
     
     if ((touchLocation.x < innerStopBlockPadding) || (touchLocation.x > self.width - innerStopBlockPadding) || (touchLocation.y < innerStopBlockPadding) || (touchLocation.y > self.height - innerStopBlockPadding)) {
     return;
     }
     */
    
    static CGPoint startTouchLocation;
    CGPoint touchLocation;
    
    switch (sender.state) {
            
        case UIGestureRecognizerStateBegan: {
            [self notifyDragEvent:MNKDraggableEventDragStarted];
            startTouchLocation = [sender locationInView:nil];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            touchLocation = [sender locationInView:nil];
            sender.view.center = CGPointMake(touchLocation.x, touchLocation.y);
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self notifyDragEvent:MNKDraggableEventDragEnded];
            startTouchLocation = CGPointZero;
            break;
        }
            
        default:
            break;
    }
}

- (void)notifyDragEvent:(MNKDraggableEvent)event
{
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    switch (event) {
        case MNKDraggableEventDragStarted: {
            [notificationCenter postNotificationName:MNKDraggableDroppableNotificationDraggingDidBegin object:self userInfo:@{}];
            return;
        }
        case MNKDraggableEventDragEnded: {
            [notificationCenter postNotificationName:MNKDraggableDroppableNotificationDraggingDidEnd object:self userInfo:@{}];
            break;
        }
        default: {
            break;
        }
    }
}

@end
