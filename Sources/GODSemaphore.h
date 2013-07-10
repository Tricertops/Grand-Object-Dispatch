//
//  GODSemaphore.h
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 9.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "GODObject.h"





/// Wrapper for dispatch_semaphore_t.
/// A dispatch semaphore is an efficient implementation of a traditional counting semaphore. Dispatch semaphores call down to the kernel only when the calling thread needs to be blocked. If the calling semaphore does not need to block, no kernel call is made.
@interface GODSemaphore : GODObject



#pragma mark Creating Semaphores

/// Creates new counting semaphore with an initial value.
- (instancetype)initWithValue:(NSInteger)value;



#pragma mark Using Semaphores

/// Signals (increments) a semaphore.
- (NSInteger)signal;

/// Waits for (decrements) a semaphore for given time.
- (NSInteger)wait:(NSTimeInterval)timeout;

/// Waits for (decrements) a semaphore forever.
- (void)wait;

/// Waits for (decrements) a semaphore until given date.
- (NSInteger)waitDate:(NSDate *)date;



#pragma mark Protected Methods
/// You should try to avoid using these methods, since this abtraction is trying to cover them. They may become private in future.

/// Designated initializer.
- (instancetype)initWithDispatchSemaphore:(dispatch_semaphore_t)dispatchSemaphore;

/// Underlaying dispatch semaphore.
- (dispatch_semaphore_t)dispatchSemaphore;



@end
