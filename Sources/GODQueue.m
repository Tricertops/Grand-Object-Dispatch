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
    GODOnceReturn( [[self alloc] initWithDispatchQueue:dispatch_get_main_queue()] );
}


- (instancetype)initWithName:(NSString *)name concurrent:(BOOL)isConcurrent {
    NSString *applicationIdentifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSString *label = [applicationIdentifier stringByAppendingFormat:@".%@", name];
    return [self initWithLabel:(label ?: name) concurrent:isConcurrent];
}


+ (instancetype)queueWithName:(NSString *)name concurrent:(BOOL)isConcurrent target:(GODQueue *)target {
    GODQueue *queue = [[self alloc] initWithName:name concurrent:isConcurrent];
    [queue setTargetQueue:target];
    return queue;
}


- (instancetype)init {
    return [self initWithName:nil concurrent:NO];
}


+ (instancetype)userQueue {
    GODOnceReturn( [[self alloc] initWithDispatchQueue:dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)] );
}


+ (instancetype)utilityQueue {
    GODOnceReturn( [[self alloc] initWithDispatchQueue:dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)] );
}


+ (instancetype)backgroundQueue {
    GODOnceReturn( [[self alloc] initWithDispatchQueue:dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)] );
}


+ (instancetype)highPriorityQueue {
    return [self userQueue];
}


+ (instancetype)defaultQueue {
    return [self utilityQueue];
}


+ (instancetype)lowPriorityQueue {
    return [self backgroundQueue];
}


- (GODQueue *)createSerialQueueWithName:(NSString *)name {
    GODQueue *queue = [[GODQueue alloc] initWithName:name concurrent:NO];
    [queue setTargetQueue:self];
    return queue;
}





#pragma mark Queuing Tasks for Dispatch


- (void)async:(GODBlock)block {
    NSParameterAssert(block);
    dispatch_async(self.dispatchQueue, block);
}


- (void)sync:(GODBlock)block {
    NSParameterAssert(block);
    if (self.isCurrent) {
        block();
    }
    else {
        dispatch_sync(self.dispatchQueue, block);
    }
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
    dispatch_apply((size_t)count, self.dispatchQueue, (void(^)(size_t))block);
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
    return [NSString stringWithFormat:@"<%@ %p; %@>", self.class, self, [self.dispatchQueue debugDescription]];
}


- (BOOL)isCurrent {
    return ([self.class specificForKey:GODQueueSpecificKey] == [self specificForKey:GODQueueSpecificKey]);
}





#pragma mark Protected Methods


- (instancetype)initWithDispatchQueue:(dispatch_queue_t)dispatchQueue {
    self = [super init];
    if (self) {
        NSParameterAssert(dispatchQueue != nil);
        if ( ! dispatchQueue) return nil;
        
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
