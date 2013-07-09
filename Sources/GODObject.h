//
//  GODObject.h
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 8.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef dispatch_block_t GODBlock;



#define GODOnceReturn(EXPRESSION)\
    static id onceObject = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        onceObject = EXPRESSION;\
    });\
    return onceObject;





@class GODQueue;

/// Object wrapper around dispatch_object_t. This is abstract class, you can instantinate of of subclasses: GODQueue, GODGroup.
/// GCD provides dispatch object interfaces to allow your application to manage aspects of processing such as memory management, pausing and resuming execution, defining object context, and logging task data. Dispatch objects must be manually retained and released and are not garbage collected.
@interface GODObject : NSObject



#pragma mark Creating and Managing Queues

/// Sets the target queue for the given object.
- (void)setTargetQueue:(GODQueue *)queue;



#pragma mark Managing Dispatch Objects

/// Suspends the invocation of block objects on a dispatch object.
- (void)suspend;

/// Resume the invocation of block objects on a dispatch object.
- (void)resume;



#pragma mark Debugging Objects

/// Programmatically logs debug information about a dispatch object.
- (void)log:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);



#pragma mark Protected Methods
/// You should try to avoid using these methods, since this abtraction is trying to cover them. They may become private in future.

/// Returns the application-defined context of an object.
- (void *)context;

/// Associates an application-defined context with the object.
- (void)setContext:(void *)context;

/// Sets the finalizer function for a dispatch object.
- (void)setFinalizer:(dispatch_function_t)finalizer;

/// Underlaying GCD object.
- (dispatch_object_t)dispatchObject;



@end
