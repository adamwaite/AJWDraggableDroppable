//
//  MNKDraggableDroppableSpec.m
//  MNKDraggableDroppableExample
//
//  Created by Adam Waite on 24/04/2014.
//  Copyright (c) 2014 maneki. All rights reserved.
//

#import "Kiwi.h"
#import "MNKDraggableDroppable.h"
#import "MNKDraggableDroppable+Test.h"
#import "MNKDraggableGestureRecognizer.h"

@interface Draggable : UIView <MNKDraggableView>
@end

@interface Droppable : UIView <MNKDroppableView>
@end

SPEC_BEGIN(MNKDraggableDroppableSpec)

describe(@"MNKDraggableDroppable", ^{
    
    __block MNKDraggableDroppable *subject;
    
    beforeEach(^{
        subject = [MNKDraggableDroppable new];
    });
    
    specify(^{
        [[subject should] beKindOfClass:[MNKDraggableDroppable class]];
    });
    
    specify(^{
        [[subject should] respondToSelector:@selector(setDelegate:)];
    });
    
    #pragma mark Draggable Registration
    
    describe(@"Draggable registration", ^{
        
        context(@"Initial", ^{
            
            specify(^{
                [[subject.draggables should] beKindOfClass:[NSSet class]];
            });
            
            specify(^{
                [[subject.draggables shouldNot] beKindOfClass:[NSMutableSet class]];
            });
            
        });
        
        describe(@"Adding draggables", ^{
            
            context(@"single", ^{
                
                __block UIView *view;
                
                beforeEach(^{
                    view = [UIView new];
                    [subject registerDraggableView:view];
                });
                
                specify(^{
                    [[theValue([subject.draggables count]) should] equal:theValue(1)];
                });
                
            });
            
            context(@"multiple", ^{
                
                beforeEach(^{
                    for (NSUInteger i = 0; i < 5; i++) [subject registerDraggableView:[UIView new]];
                });
                
                specify(^{
                    [[theValue([subject.draggables count]) should] equal:theValue(5)];
                });
                
            });
            
            describe(@"registerDraggableView gestures", ^{
                
                __block id returnValue;
                __block UIView *view;

                beforeEach(^{
                    view = [UIView new];
                    returnValue = [subject registerDraggableView:view];
                });
                
                specify(^{
                    [[returnValue should] beKindOfClass:[MNKDraggableGestureRecognizer class]];
                });
                
                specify(^{
                    [[theValue([view.gestureRecognizers count]) should] equal:theValue(1)];
                });
                
                specify(^{
                    [[[view.gestureRecognizers firstObject] should] beKindOfClass:[MNKDraggableGestureRecognizer class]];
                });
                
            });
            
        });
        
        describe(@"Removing draggables", ^{
            
            describe(@"single", ^{
                
                __block UIView *view;
                
                beforeEach(^{
                    view = [UIView new];
                    [view addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:nil action:nil]];
                    [view addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:nil action:nil]];
                    [subject registerDraggableView:view];
                    [subject deregisterDraggableView:view];
                });
                
                specify(^{
                    [[theValue([subject.draggables count]) should] equal:theValue(0)];
                });
                
                specify(^{
                    [[theValue([view.gestureRecognizers count]) should] equal:theValue(2)];
                });
                
            });
            
            describe(@"multiple", ^{
                
                UIView *one = [UIView new];
                UIView *two = [UIView new];
                UIView *three = [UIView new];
                
                beforeEach(^{
                    [@[one, two, three] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [subject registerDraggableView:obj];
                    }];
                    [subject deregisterDraggableView:two];
                });
                
                specify(^{
                    [[theValue([subject.draggables containsObject:one]) should] beYes];
                });
                
                specify(^{
                    [[theValue([subject.draggables containsObject:two]) should] beNo];
                });
                
                specify(^{
                    [[theValue([subject.draggables count]) should] equal:theValue(2)];
                });
                
            });
            
        });
            
    });
    
    #pragma mark Droppable Registration
    
    describe(@"Droppable registration", ^{
        
        context(@"Initial", ^{
            
            specify(^{
                [[subject.droppables should] beKindOfClass:[NSSet class]];
            });
            
            specify(^{
                [[subject.droppables shouldNot] beKindOfClass:[NSMutableSet class]];
            });
            
        });
        
        describe(@"Adding droppables", ^{
            
            context(@"single", ^{
                
                __block UIView *view;
                
                beforeEach(^{
                    view = [UIView new];
                    [subject registerDroppableView:view];
                });
                
                specify(^{
                    [[theValue([subject.droppables count]) should] equal:theValue(1)];
                });
                
            });
            
            context(@"multiple", ^{
                
                beforeEach(^{
                    for (NSUInteger i = 0; i < 5; i++) [subject registerDroppableView:[UIView new]];
                });
                
                specify(^{
                    [[theValue([subject.droppables count]) should] equal:theValue(5)];
                });
                
            });
            
        });
        
        describe(@"Removing draggables", ^{
            
            describe(@"single", ^{
                
                __block UIView *view;
                
                beforeEach(^{
                    view = [UIView new];
                    [subject registerDroppableView:view];
                    [subject deregisterDroppableView:view];
                });
                
                specify(^{
                    [[theValue([subject.droppables count]) should] equal:theValue(0)];
                });
                
            });
            
            describe(@"multiple", ^{
                
                UIView *one = [UIView new];
                UIView *two = [UIView new];
                UIView *three = [UIView new];
                
                beforeEach(^{
                    [@[one, two, three] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [subject registerDroppableView:obj];
                    }];
                    [subject deregisterDroppableView:two];
                });
                
                specify(^{
                    [[theValue([subject.droppables containsObject:one]) should] beYes];
                });
                
                specify(^{
                    [[theValue([subject.droppables containsObject:two]) should] beNo];
                });
                
                specify(^{
                    [[theValue([subject.droppables count]) should] equal:theValue(2)];
                });
                
            });
            
        });
        
    });
    
    describe(@"Drag gesture", ^{
        
        KWMock *mockDelegate = [KWMock nullMockForProtocol:@protocol(MNKDraggableDroppableDelegate)];
        
        Droppable *mockDroppable = [Droppable new];
        
        beforeEach(^{
            subject.delegate = (id<MNKDraggableDroppableDelegate>)mockDelegate;
        });
        
        describe(@"Gesture start", ^{
            
            describe(@"delegate communication", ^{
                
                it(@"should notify the delegate on gesture start", ^{
                    [[mockDelegate shouldEventually] receive:@selector(draggableDroppable:draggableGestureDidBegin:draggable:)];
                    [subject draggableDragGestureDidStart:[KWMock nullMockForClass:[UIPanGestureRecognizer class]]];
                });
                
            });
            
            describe(@"MKDroppableView state communication", ^{
                
                beforeEach(^{
                    [mockDroppable stub:@selector(droppableViewApplyPendingState) andReturn:nil];
                    [subject registerDroppableView:(id)mockDroppable];
                });
                
                it(@"receieves the pending state", ^{
                    [[mockDroppable shouldEventually] receive:@selector(droppableViewApplyPendingState)];
                    [subject draggableDragGestureDidStart:[KWMock nullMockForClass:[UIPanGestureRecognizer class]]];
                });
                
            });
            
        });
        
        describe(@"Gesture end", ^{
            
            describe(@"delegate communication", ^{
                
                it(@"should notify the delegate on gesture start", ^{
                    [[mockDelegate shouldEventually] receive:@selector(draggableDroppable:draggableGestureDidEnd:draggable:)];
                    [subject draggableDragGestureDidEnd:[KWMock nullMockForClass:[UIPanGestureRecognizer class]]];
                });
                
            });
            
            describe(@"MKDroppableView state communication", ^{
                
                beforeEach(^{
                    [mockDroppable stub:@selector(droppableViewApplyRegularState) andReturn:nil];
                    [subject registerDroppableView:(id)mockDroppable];
                });
                
                it(@"receieves the pending state", ^{
                    [[mockDroppable shouldEventually] receive:@selector(droppableViewApplyRegularState)];
                    [subject draggableDragGestureDidEnd:[KWMock nullMockForClass:[UIPanGestureRecognizer class]]];
                });
                
            });
            
        });
        
    });
    
});

SPEC_END
