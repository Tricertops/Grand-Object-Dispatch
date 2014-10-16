//
//  GODQueue.h
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 8.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "GODObject.h"



typedef void (^GODApplyBlock)(NSUInteger index);





/// Object wrapper around dispatch_queue_t.
/// Grand Object Dispatch provides and manages FIFO queues to which your application can submit tasks in the form of block objects. Blocks submitted to queues are executed on a pool of threads fully managed by the system. No guarantee is made as to the thread on which a task executes.
@interface GODQueue : GODObject



#pragma mark Creating and Managing Queues

/// Returns the serial queue associated with the application’s main thread.
+ (GODQueue *)mainQueue;

/// Creates a new queue. Name will be appended to application's identifier to create reverse-DNS label.
- (instancetype)initWithName:(NSString *)name concurrent:(BOOL)isConcurrent;

/// Creates a new queue targeted to other queue. Name will be appended to application's identifier to create reverse-DNS label.
+ (instancetype)queueWithName:(NSString *)name concurrent:(BOOL)isConcurrent target:(GODQueue *)target;

/// Creates a new serial queue with generic name.
- (instancetype)init;

/// Returns a well-known global concurrent queue of a given priority level.
+ (instancetype)userQueue;
+ (instancetype)utilityQueue;
+ (instancetype)backgroundQueue;

+ (instancetype)highPriorityQueue __deprecated_msg("Use +userQueue");
+ (instancetype)defaultQueue __deprecated_msg("Use +utilityQueue");
+ (instancetype)lowPriorityQueue __deprecated_msg("Use +utilityQueue or +backgroundQueue");

/// Shortcut for creating serial queues from existing queues.
- (GODQueue *)createSerialQueueWithName:(NSString *)name;



#pragma mark Queuing Tasks for Dispatch

/// Submits a block for asynchronous execution on a queue and returns immediately.
- (void)async:(GODBlock)block;

/// Submits a block object for execution on a queue and waits until that block completes.
- (void)sync:(GODBlock)block;

/// Enqueue a block for execution after specified time.
- (void)after:(NSTimeInterval)interval block:(GODBlock)block;

/// Enqueue a block for execution at specified date.
- (void)afterDate:(NSDate *)date block:(GODBlock)block;

/// Submits a block to a dispatch queue for multiple invocations.
- (void)apply:(NSUInteger)count block:(GODApplyBlock)block;



#pragma mark Using Barriers

/// Submits a barrier block for asynchronous execution and returns immediately.
- (void)barrierAsync:(GODBlock)block;

/// Submits a barrier block object for execution and waits until that block completes.
- (void)barrierSync:(GODBlock)block;



#pragma mark Debugging Queues

/// Returns YES, when it block submitted to receiver queue are executed on current queue, otherwise NO. Compares queue-specific context data.
- (BOOL)isCurrent;



#pragma mark Protected Methods
/// You should try to avoid using these methods, since this abtraction is trying to cover them. They may become private in future.

/// Designated initializer.
- (instancetype)initWithDispatchQueue:(dispatch_queue_t)dispatchQueue;

/// Creates a new dispatch queue to which blocks can be submitted.
- (instancetype)initWithLabel:(NSString *)label concurrent:(BOOL)isConcurrent;

/// Returns the label specified for the queue when the queue was created.
- (NSString *)label;

/// Returns the value for the key associated with the current dispatch queue.
+ (void *)specificForKey:(void *)key;

/// Returns the value for the key associated with the specified dispatch queue.
- (void *)specificForKey:(void *)key;

///Sets the key/value data for the specified dispatch queue.
- (void)setSpecific:(void *)specific forKey:(void *)key destructor:(dispatch_function_t)destructor;

/// Executes blocks submitted to the main queue. This function never returns.
+ (void)runMain;

/// Underlaying GCD queue.
- (dispatch_queue_t)dispatchQueue;



@end




