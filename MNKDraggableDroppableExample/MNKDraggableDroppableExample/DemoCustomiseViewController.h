//
//  DemoSettingsViewController.h
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 25/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNKDraggableDroppable;
@class Draggable;
@class Droppable;

@interface DemoCustomiseViewController : UIViewController

@property (strong, nonatomic) MNKDraggableDroppable *dragDropController;
@property (strong, nonatomic) Draggable *draggable;
@property (strong, nonatomic) Droppable *droppable;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISwitch *snapsDraggablesOnMissSwitch;

@end
