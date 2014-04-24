//
//  ViewController.m
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 23/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "ViewController.h"
#import "Draggable.h"
#import "Droppable.h"
#import "MNKDraggableDroppable.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet Draggable *draggable;
@property (weak, nonatomic) IBOutlet Droppable *droppable;
@property (strong, nonatomic) IBOutlet MNKDraggableDroppableController *dragDropController;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.dragDropController registerDraggableView:self.draggable];
    [self.dragDropController registerDroppableView:self.droppable];
}

@end
