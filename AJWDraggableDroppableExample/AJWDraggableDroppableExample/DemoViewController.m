//
//  ViewController.m
//  AJWDraggableDroppableExample
//
//  Created by Adam Waite on 23/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "AJWDraggableDroppable.h"
#import "DemoViewController.h"
#import "Draggable.h"
#import "Droppable.h"
#import "DemoCustomiseViewController.h"

@interface DemoViewController () <AJWDraggableDroppableDelegate>
@property (strong, nonatomic) AJWDraggableDroppable *dragDropController;
@property (weak, nonatomic) IBOutlet Draggable *draggable;
@property (weak, nonatomic) IBOutlet Droppable *droppable;
@end

@implementation DemoViewController

#pragma mark Accessors

- (AJWDraggableDroppable *)dragDropController
{
    if (!_dragDropController) {
        _dragDropController = [[AJWDraggableDroppable alloc] initWithReferenceView:self.view];
    }
    return _dragDropController;
}

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.dragDropController registerDraggableView:self.draggable];
    [self.dragDropController registerDroppableView:self.droppable];
}

#pragma mark AJWDraggableDroppableDelegate

- (void)draggableDroppable:(AJWDraggableDroppable *)draggableDroppable
  draggableGestureDidBegin:(UIPanGestureRecognizer *)gestureRecognizer
                 draggable:(UIView *)draggable
{
    NSDictionary *log = @{
        @"AJWDraggableDroppable:": draggableDroppable,
        @"Getsure:": gestureRecognizer,
        @"Draggable": draggable
    };
    
    NSLog(@"Draggable drag gesture started: %@", log);
}

- (void)draggableDroppable:(AJWDraggableDroppable *)draggableDroppable
    draggableGestureDidEnd:(UIPanGestureRecognizer *)gestureRecognizer
                 draggable:(UIView *)draggable
                 droppable:(UIView *)droppable
{
    NSDictionary *log = @{
        @"AJWDraggableDroppable:": draggableDroppable,
        @"Getsure:": gestureRecognizer,
        @"Draggable": draggable,
        @"Droppable": (droppable) ? droppable : [NSNull null]
    };
    
    NSLog(@"Draggable drag gesture ended: %@", log);
    
    if (droppable) {
        NSLog(@"Dropped!");
    }
    
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Customise"]) {
        DemoCustomiseViewController *dest = [[(UINavigationController *)segue.destinationViewController viewControllers] firstObject];
        dest.dragDropController = self.dragDropController;
        dest.draggable = self.draggable;
        dest.droppable = self.droppable;
    }
}

@end
