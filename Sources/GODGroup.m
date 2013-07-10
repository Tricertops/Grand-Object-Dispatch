//
//  GODGroup.m
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 9.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "GODGroup.h"
#import "GODQueue.h"





@interface GODGroup ()


@property (nonatomic, readwrite, strong) dispatch_group_t dispatchGroup;


@end










@implementation GODGroup





#pragma mark Superclass Overrides


- (dispatch_object_t)dispatchObject {
    return self.dispatchGroup;
}





#pragma mark Creating Groups


- (instancetype)init {
    return [self initWithDispatchGroup:dispatch_group_create()];
}





#pragma mark Group Tasks


- (void)asyncQueue:(GODQueue *)queue block:(GODBlock)block {
    NSParameterAssert(queue);
    NSParameterAssert(block);
    dispatch_group_async(self.dispatchGroup, queue.dispatchQueue, block);
}


- (void)enter {
    dispatch_group_enter(self.dispatchGroup);
}


- (void)leave {
    dispatch_group_leave(self.dispatchGroup);
}


- (void)notifyQueue:(GODQueue *)queue block:(GODBlock)block {
    NSParameterAssert(queue);
    NSParameterAssert(block);
    dispatch_group_notify(self.dispatchGroup, queue.dispatchQueue, block);
}


- (NSInteger)wait:(NSTimeInterval)timeout {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC));
    return dispatch_group_wait(self.dispatchGroup, time);
}


- (void)wait {
    dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER);
    // No return value, because it can only succeed. Or lock forever.
}


- (NSInteger)waitDate:(NSDate *)date {
    return [self wait:date.timeIntervalSinceNow];
}





#pragma mark Protected Methods


- (instancetype)initWithDispatchGroup:(dispatch_group_t)dispatchGroup {
    self = [super init];
    if (self) {
        NSParameterAssert(dispatchGroup != nil);
        if ( ! dispatchGroup) return nil;
        
        self.dispatchGroup = dispatchGroup;
    }
    return self;
}





@end
