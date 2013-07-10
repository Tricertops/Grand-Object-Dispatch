//
//  GODSource.m
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 10.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "GODSource.h"
#import "GODQueue.h"





@interface GODSource ()


@property (nonatomic, readwrite, strong) dispatch_source_t dispatchSource;


@end










@implementation GODSource





#pragma mark Overriding Superclass


- (dispatch_object_t)dispatchObject {
    return self.dispatchSource;
}





#pragma mark Managing Sources


- (void)start {
    [self resume];
}


- (void)cancel {
    dispatch_source_cancel(self.dispatchSource);
}


- (BOOL)isCancelled {
    return (dispatch_source_testcancel(self.dispatchSource) != 0);
}





#pragma mark Handling Sources


- (void)setRegistrationHandler:(GODBlock)block {
    NSParameterAssert(block);
    dispatch_source_set_registration_handler(self.dispatchSource, block);
}


- (void)setCancelHandler:(GODBlock)block {
    NSParameterAssert(block);
    dispatch_source_set_cancel_handler(self.dispatchSource, block);
}


- (void)setEventHandler:(GODBlock)block {
    NSParameterAssert(block);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}





#pragma mark Protected Methods


- (instancetype)initWithDispatchSource:(dispatch_source_t)dispatchSource {
    self = [super init];
    if (self) {
        NSParameterAssert(dispatchSource != nil);
        if ( ! dispatchSource) return nil;
        
        self.dispatchSource = dispatchSource;
    }
    return self;
}


- (instancetype)initWithType:(GODSourceType)type handle:(uintptr_t)handle mask:(unsigned long)mask queue:(GODQueue *)queue {
    dispatch_source_type_t dispatchType;
    switch (type) {
        case GODSourceTypeDataAdd: dispatchType = DISPATCH_SOURCE_TYPE_DATA_ADD; break;
        case GODSourceTypeDataOr: dispatchType = DISPATCH_SOURCE_TYPE_DATA_OR; break;
        case GODSourceTypeMachSend: dispatchType = DISPATCH_SOURCE_TYPE_MACH_SEND; break;
        case GODSourceTypeMachReceive: dispatchType = DISPATCH_SOURCE_TYPE_MACH_RECV; break;
        case GODSourceTypeSignal: dispatchType = DISPATCH_SOURCE_TYPE_SIGNAL; break;
        case GODSourceTypeProcess: dispatchType = DISPATCH_SOURCE_TYPE_PROC; break;
        case GODSourceTypeRead: dispatchType = DISPATCH_SOURCE_TYPE_READ; break;
        case GODSourceTypeWrite: dispatchType = DISPATCH_SOURCE_TYPE_WRITE; break;
        case GODSourceTypeVNode: dispatchType = DISPATCH_SOURCE_TYPE_VNODE; break;
        case GODSourceTypeTimer: dispatchType = DISPATCH_SOURCE_TYPE_TIMER; break;
    }
    return [self initWithDispatchSource:dispatch_source_create(dispatchType, handle, mask, queue.dispatchQueue)];
}


- (uintptr_t)handle {
    return dispatch_source_get_handle(self.dispatchSource);
}


- (unsigned long)mask {
    return dispatch_source_get_mask(self.dispatchSource);
}


- (unsigned long)data {
    return dispatch_source_get_data(self.dispatchSource);
}


- (void)setTimerStart:(NSDate *)date interval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway {
    NSParameterAssert(date.timeIntervalSinceNow >= 0);
    NSParameterAssert(interval > 0);
    NSParameterAssert(leeway >= 0);
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(date.timeIntervalSinceNow * NSEC_PER_SEC));
    dispatch_source_set_timer(self.dispatchSource, time, interval / NSEC_PER_SEC, leeway / NSEC_PER_SEC);
}


- (void)mergeData:(NSUInteger)value {
    dispatch_source_merge_data(self.dispatchSource, value);
}





@end
