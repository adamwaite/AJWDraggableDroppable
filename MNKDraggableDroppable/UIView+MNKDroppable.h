//
//  UIView+MNKDroppable.h
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 28/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MNKDroppable)

- (UISnapBehavior *)mnk_dropSnapBehaviour:(UIView *)draggable;

@end
