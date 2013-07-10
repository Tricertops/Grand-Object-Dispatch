//
//  GODObject.m
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 8.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "GODObject.h"
#import "GODQueue.h"
#import "GODSource.h"



#ifdef DEBUG
uint64_t dispatch_benchmark(size_t count, void (^block)(void));
#endif





@implementation GODObject





#pragma mark Creating and Managing Queues


- (void)setTargetQueue:(GODQueue *)queue {
    NSParameterAssert(queue);
    dispatch_set_target_queue(self.dispatchObject, queue.dispatchQueue);
}





#pragma mark Managing Dispatch Objects


- (void)suspend {
    NSAssert(self.class == GODQueue.class || self.class == GODSource.class, @"You cannot suspend other types of dispatch objects than Queues or Sources.");
    dispatch_suspend(self.dispatchObject);
}


- (void)resume {
    dispatch_resume(self.dispatchObject);
}


- (void)setFinalizer:(dispatch_function_t)finalizer {
    NSParameterAssert(finalizer);
    dispatch_set_finalizer_f(self.dispatchObject, finalizer);
}





#pragma mark Debugging Objects


- (void)log:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2) {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    NSLog(@"%@: %@", [self.dispatchObject debugDescription], message);
}


#ifdef DEBUG
+ (NSTimeInterval)benchmark:(NSUInteger)count block:(GODBlock)block {
    NSParameterAssert(block);
    NSParameterAssert(count > 0);
    return dispatch_benchmark(count, block) * 1.0 / NSEC_PER_SEC;
}
#endif





#pragma mark Protected Methods


- (void *)context {
    return dispatch_get_context(self.dispatchObject);
}


- (void)setContext:(void *)context {
    dispatch_set_context(self.dispatchObject, context);
}


- (dispatch_object_t)dispatchObject {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%s is abstract", __PRETTY_FUNCTION__] userInfo:nil];
}





@end




