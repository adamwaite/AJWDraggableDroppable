//
//  MNKDraggableDroppableController.h
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 23/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const MNKDraggableDroppableNotificationDraggingDidBegin;
extern NSString * const MNKDraggableDroppableNotificationDraggingDidEnd;

typedef NS_ENUM(NSUInteger, MNKDraggableEvent) {
    MNKDraggableEventDragStarted,
    MNKDraggableEventDragEnded
};

@protocol MNKDraggableView <NSObject>
@optional
- (CGRect)mnk_draggableViewDragBounds;
@end

@protocol MNKDroppableView <NSObject>
@optional
- (void)mnk_droppableViewApplyRegularState;
- (void)mnk_droppableViewApplyPendingDropState;
@end

@interface MNKDraggableDroppableController : NSObject

- (UIPanGestureRecognizer *)registerDraggableView:(UIView *)view;
- (void)registerDroppableView:(UIView *)view;

@end
