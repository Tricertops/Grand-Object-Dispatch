//
//  GODTimer.h
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 10.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "GODSource.h"




/// Convenience wrapper for creating dispatch sources of type `timer'.
@interface GODTimer : GODSource



#pragma mark Creating Timer

/// Creates a new configured timer Source.
- (instancetype)initWithDate:(NSDate *)date interval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway queue:(GODQueue *)queue handler:(GODBlock)block;

/// Returns started timer Source with given arguments.
+ (instancetype)startedTimerWithInterval:(NSTimeInterval)interval queue:(GODQueue *)queue handler:(GODBlock)block;
+ (instancetype)startedTimerWithInterval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway queue:(GODQueue *)queue handler:(GODBlock)block;
+ (instancetype)startedTimerWithDate:(NSDate *)date interval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway queue:(GODQueue *)queue handler:(GODBlock)block;



@end
