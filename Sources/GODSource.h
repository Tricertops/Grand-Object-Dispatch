//
//  GODSource.h
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 10.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "GODObject.h"



/// An identifier for the type system object being monitored by a dispatch source.
typedef enum GODSourceType : NSInteger {
    GODSourceTypeDataAdd,
    GODSourceTypeDataOr,
    
    GODSourceTypeMachSend,
    GODSourceTypeMachReceive,
    
    GODSourceTypeSignal,
    GODSourceTypeProcess,
    
    GODSourceTypeRead,
    GODSourceTypeVNode,
    GODSourceTypeWrite,
    
    GODSourceTypeTimer,
} GODSourceType;





/// Wrapper for dispatch_semaphore_t.
/// A suite of sources—interfaces for monitoring (low-level system objects such as Unix descriptors, Mach ports, Unix signals, VFS nodes, and so forth) for activity, and submitting event handlers to dispatch queues when such activity occurs. When an event occurs, the dispatch source submits your task code asynchronously to the specified dispatch queue for processing.
@interface GODSource : GODObject



#pragma mark Cancelling Sources

/// Asynchronously cancels the dispatch source, preventing any further invocation of its event handler block.
- (void)cancel;

/// Tests whether the given dispatch source has been canceled.
- (BOOL)isCancelled;



#pragma mark Handling Sources

/// Sets the registration handler block for the given dispatch source.
- (void)setRegistrationHandler:(GODBlock)block;

/// Sets the cancellation handler block for the given dispatch source.
- (void)setCancellationHandler:(GODBlock)block;

/// Sets the event handler block for the given dispatch source.
- (void)setEventHandler:(GODBlock)block;



#pragma mark Protected Methods
/// You should try to avoid using these methods, since this abtraction is trying to cover them. They may become private in future.

/// Designated initializer.
- (instancetype)initWithDispatchSource:(dispatch_source_t)dispatchSource;

/// Underlaying dispatch source.
- (dispatch_source_t)dispatchSource;

/// Creates a new dispatch source to monitor low-level system objects and automatically submit a handler block to a dispatch queue in response to events.
- (instancetype)initWithType:(GODSourceType)type handle:(uintptr_t)handle mask:(unsigned long)mask queue:(GODQueue *)queue;

/// Returns the underlying system handle associated with the specified dispatch source.
- (uintptr_t)handle;

/// Returns the mask of events monitored by the dispatch source.
- (unsigned long)mask;

/// Returns pending data for the dispatch source.
- (unsigned long)data;

/// Sets a start time, interval, and leeway value for a timer source.
- (void)setTimerStart:(NSDate *)date interval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway;

/// Merges data into a dispatch source of type DISPATCH_SOURCE_TYPE_DATA_ADD or DISPATCH_SOURCE_TYPE_DATA_OR and submits its event handler block to its target queue.
- (void)mergeData:(NSUInteger)value;



@end




