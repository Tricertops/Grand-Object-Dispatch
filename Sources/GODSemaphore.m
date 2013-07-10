//
//  GODSemaphore.m
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 9.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "GODSemaphore.h"





@interface GODSemaphore ()


@property (nonatomic, readwrite, strong) dispatch_semaphore_t dispatchSemaphore;


@end










@implementation GODSemaphore





#pragma mark Superclass Overrides


- (dispatch_object_t)dispatchObject {
    return self.dispatchSemaphore;
}





#pragma mark Creating Semaphores


- (instancetype)initWithValue:(NSInteger)value {
    return [self initWithDispatchSemaphore:dispatch_semaphore_create(value)];
}





#pragma mark Using Semaphores


- (NSInteger)signal {
    return dispatch_semaphore_signal(self.dispatchSemaphore);
}


- (NSInteger)wait:(NSTimeInterval)timeout {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC));
    return dispatch_semaphore_wait(self.dispatchSemaphore, time);
}


- (void)wait {
    dispatch_semaphore_wait(self.dispatchSemaphore, DISPATCH_TIME_FOREVER);
    // No return value, because it can only succeed. Or lock forever.
}


- (NSInteger)waitDate:(NSDate *)date {
    return [self wait:date.timeIntervalSinceNow];
}





#pragma mark Protected Methods


- (instancetype)initWithDispatchSemaphore:(dispatch_semaphore_t)dispatchSemaphore {
    self = [super init];
    if (self) {
        NSParameterAssert(dispatchSemaphore != nil);
        if ( ! dispatchSemaphore) return nil;
        
        self.dispatchSemaphore = dispatchSemaphore;
    }
    return self;
}





@end
