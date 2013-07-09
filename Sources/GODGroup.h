//
//  GODGroup.h
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 9.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "GODObject.h"





@class GODQueue;

/// Object wrapper around dispatch_group_t.
@interface GODGroup : GODObject



#pragma mark Creating Groups

/// Creates a new group with which block objects can be associated.
- (instancetype)init;



#pragma mark Group Tasks

/// Submits a block to a dispatch queue and associates the block with the specified dispatch group.
- (void)asyncQueue:(GODQueue *)queue block:(GODBlock)block;

/// Explicitly indicates that a block has entered the group.
- (void)enter;

/// Explicitly indicates that a block in the group has completed.
- (void)leave;

/// Schedules a block object to be submitted to a queue when a group of previously submitted block objects have completed.
- (void)notifyQueue:(GODQueue *)queue block:(GODBlock)block;

/// Waits synchronously for the previously submitted block objects to complete; returns if the blocks do not complete before the specified timeout period has elapsed.
- (NSInteger)wait:(NSTimeInterval)timeout;

/// Waits synchronously for the previously submitted block objects to complete; returns if the blocks do not complete before the specified date has passed.
- (NSInteger)waitDate:(NSDate *)date;



#pragma mark Protected Methods
/// You should try to avoid using these methods, since this abtraction is trying to cover them. They may become private in future.

/// Designated initializer.
- (instancetype)initWithDispatchGroup:(dispatch_group_t)dispatchGroup;

/// Underlaying dispatch group.
- (dispatch_group_t)dispatchGroup;



@end
