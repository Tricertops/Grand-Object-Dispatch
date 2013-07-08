//
//  GODQueue.m
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 8.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "GODQueue.h"



static void * GODQueueSpecificKey = &GODQueueSpecificKey;





@interface GODQueue ()


@property (nonatomic, readwrite, strong) dispatch_queue_t dispatchQueue;


@end










@implementation GODQueue





#pragma mark Superclass Overrides


- (dispatch_object_t)dispatchObject {
    return self.dispatchQueue;
}





#pragma mark Creating and Managing Queues


+ (GODQueue *)mainQueue {
    GODOnceReturn( [[GODQueue alloc] initWithDispatchQueue:dispatch_get_main_queue()] );
}


- (instancetype)initWithName:(NSString *)name concurrent:(BOOL)isConcurrent {
    NSString *applicationIdentifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSString *label = [applicationIdentifier stringByAppendingFormat:@".%@", name];
    return [self initWithLabel:(label ?: name) concurrent:isConcurrent];
}


- (instancetype)init {
    return [self initWithName:nil concurrent:NO];
}


+ (instancetype)highPriorityQueue {
    GODOnceReturn( [[GODQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)] );
}


+ (instancetype)defaultQueue {
    GODOnceReturn( [[GODQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)] );
}


+ (instancetype)lowPriorityQueue {
    GODOnceReturn( [[GODQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)] );
}


+ (instancetype)backgroundQueue {
    GODOnceReturn( [[GODQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)] );
}





#pragma mark Queuing Tasks for Dispatch


- (void)async:(GODBlock)block {
    NSParameterAssert(block);
    dispatch_async(self.dispatchQueue, block);
}


- (void)sync:(GODBlock)block {
    NSParameterAssert(block);
    dispatch_sync(self.dispatchQueue, block);
}


- (void)after:(NSTimeInterval)interval block:(GODBlock)block {
    NSParameterAssert(block);
    NSParameterAssert(interval >= 0);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC));
    dispatch_after(popTime, self.dispatchQueue, block);
}


- (void)afterDate:(NSDate *)date block:(GODBlock)block {
    NSParameterAssert(block);
    NSParameterAssert(date.timeIntervalSinceNow >= 0);
    [self after:date.timeIntervalSinceNow block:block];
}


- (void)apply:(NSUInteger)count block:(GODApplyBlock)block {
    NSParameterAssert(block);
    dispatch_apply((size_t)count, self.dispatchQueue, block);
}





#pragma mark Using Barriers


- (void)barrierAsync:(GODBlock)block {
    NSParameterAssert(block);
    dispatch_barrier_async(self.dispatchQueue, block);
}


- (void)barrierSync:(GODBlock)block {
    NSParameterAssert(block);
    dispatch_barrier_sync(self.dispatchQueue, block);
}





#pragma mark Debugging Queues


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p; %@", self.class, self, [self.dispatchQueue debugDescription]];
}


- (BOOL)isCurrent {
    return ([GODQueue specificForKey:GODQueueSpecificKey] == [self specificForKey:GODQueueSpecificKey]);
}





#pragma mark Protected Methods


- (instancetype)initWithDispatchQueue:(dispatch_queue_t)dispatchQueue {
    self = [super init];
    if (self) {
        self.dispatchQueue = dispatchQueue;
        [self setSpecific:(__bridge void *)self forKey:GODQueueSpecificKey destructor:nil];
    }
    return self;
}


- (instancetype)initWithLabel:(NSString *)label concurrent:(BOOL)isConcurrent {
    dispatch_queue_t queue = dispatch_queue_create(label.UTF8String, (isConcurrent? DISPATCH_QUEUE_CONCURRENT : DISPATCH_QUEUE_SERIAL ));
    return [self initWithDispatchQueue:queue];
}


- (NSString *)label {
    return [NSString stringWithUTF8String:dispatch_queue_get_label(self.dispatchQueue)];
}


+ (void *)specificForKey:(void *)key {
    return dispatch_get_specific(key);
}


- (void *)specificForKey:(void *)key {
    return dispatch_queue_get_specific(self.dispatchQueue, key);
}


- (void)setSpecific:(void *)specific forKey:(void *)key destructor:(dispatch_function_t)destructor {
    dispatch_queue_set_specific(self.dispatchQueue, key, specific, destructor);
}


+ (void)runMain {
    // To the infinity...
    dispatch_main();
    // ... and beyond!
}





@end
