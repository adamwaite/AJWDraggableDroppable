//
//  ViewController.m
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 23/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "DemoViewController.h"
#import "Draggable.h"
#import "Droppable.h"
#import "MNKDraggableDroppable.h"
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
