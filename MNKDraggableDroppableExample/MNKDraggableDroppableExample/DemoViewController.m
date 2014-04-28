//
//  ViewController.m
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 23/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "MNKDraggableDroppable.h"
#import "DemoViewController.h"
#import "Draggable.h"
#import "Droppable.h"
#import "DemoCustomiseViewController.h"

@interface DemoViewController () <MNKDraggableDroppableDelegate>
@property (weak, nonatomic) IBOutlet Draggable *draggable;
@property (weak, nonatomic) IBOutlet Droppable *droppable;
@property (strong, nonatomic) IBOutlet MNKDraggableDroppable *dragDropController;
@end

@implementation DemoViewController

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.dragDropController registerDraggableView:self.draggable];
    [self.dragDropController registerDroppableView:self.droppable];
}

#pragma mark MNKDraggableDroppableDelegate

- (void)draggableDroppable:(MNKDraggableDroppable *)draggableDroppable draggableGestureDidBegin:(UIPanGestureRecognizer *)gestureRecognizer draggable:(UIView *)draggable
{
    NSDictionary *log = @{
        @"MNKDraggableDroppable:": draggableDroppable,
        @"Getsure:": gestureRecognizer,
        @"Draggable": draggable
    };
    
    NSLog(@"Draggable drag gesture started: %@", log);
}

- (void)draggableDroppable:(MNKDraggableDroppable *)draggableDroppable draggableGestureDidEnd:(UIPanGestureRecognizer *)gestureRecognizer draggable:(UIView *)draggable
{
    NSDictionary *log = @{
        @"MNKDraggableDroppable:": draggableDroppable,
        @"Getsure:": gestureRecognizer,
        @"Draggable": draggable
    };
    
    NSLog(@"Draggable drag gesture ended: %@", log);
}

- (void)draggableDroppable:(MNKDraggableDroppable *)draggableDroppable draggable:(UIView *)draggable didDropIntoDroppable:(UIView *)droppable gesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Draggable %@ was dropped into droppable: %@", nil), draggable, droppable];
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"💣" otherButtonTitles:nil] show];
    
    NSDictionary *log = @{
        @"MNKDraggableDroppable:": draggableDroppable,
        @"Getsure:": gestureRecognizer,
        @"Draggable": draggable,
        @"Droppable": droppable
    };
    
    NSLog(@"Draggable was dropped into droppable: %@", log);   
}

#pragma mark Actions

- (IBAction)rightBarButtonItemAction:(id)sender
{
    [self performSegueWithIdentifier:@"Customise" sender:self];
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
