//
//  DemoSettingsViewController.m
//  AJWDraggableDroppableExample
//
//  Created by Adam Waite on 25/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "DemoCustomiseViewController.h"
#import "AJWDraggableDroppable.h"
#import "Draggable.h"
#import "Droppable.h"

@interface DemoCustomiseViewController ()

@end

@implementation DemoCustomiseViewController

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark Actions

- (IBAction)snapsDraggablsBackToggleAction:(UISwitch *)sender
{
    self.dragDropController.snapsDraggablesBackToDragStartOnMiss = sender.isOn;
}

- (IBAction)leftBarButtonItemAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
