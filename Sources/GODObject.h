//
//  GODObject.h
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 8.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef dispatch_block_t GODBlock;





@class GODQueue;

/// Object wrapper around dispatch_object_t. This is abstract class, you can instantinate of of subclasses: GODQueue.
@interface GODObject : NSObject



#pragma mark Creating and Managing Queues

/// Sets the target queue for the given object.
- (void)setTargetQueue:(GODQueue *)queue;



#pragma mark Managing Dispatch Objects

/// Suspends the invocation of block objects on a dispatch object.
- (void)suspend;

/// Resume the invocation of block objects on a dispatch object.
- (void)resume;

/// Sets the finalizer block for a dispatch object.
- (void)setFinalizer:(GODBlock)block;




#pragma mark Debugging Objects

/// Programmatically logs debug information about a dispatch object.
- (void)log:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);








#pragma mark Protected Methods
/// You should try to avoid using these methods, since this abtraction is trying to cover them. They may become private in future.

/// Returns the application-defined context of an object.
- (void *)context;

/// Associates an application-defined context with the object.
- (void)setContext:(void *)context;

/// Underlaying GCD object.
- (dispatch_object_t)dispatchObject;



@end
