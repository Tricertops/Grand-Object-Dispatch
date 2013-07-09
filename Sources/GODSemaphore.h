//
//  GODSemaphore.h
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 9.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "GODObject.h"





@interface GODSemaphore : GODObject


- (instancetype)initWithValue:(NSUInteger)value;

- (NSUInteger)signal;
- (NSUInteger)wait:(NSTimeInterval)timeout;
- (NSUInteger)waitDate:(NSTimeInterval)timeout;

- (instancetype)initWithDispatchSemaphore:(dispatch_semaphore_t)dispatchSemaphore;
- (dispatch_semaphore_t)dispatchSemaphore;


@end
