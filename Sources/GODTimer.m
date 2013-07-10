//
//  GODTimer.m
//  Grand Object Dispatch
//
//  Created by Martin Kiss on 10.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "GODTimer.h"
#import "GODQueue.h"





@implementation GODTimer






#pragma mark Creating Timer


- (instancetype)initWithDate:(NSDate *)date interval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway queue:(GODQueue *)queue handler:(GODTimerHandler)block {
    self = [super initWithType:GODSourceTypeTimer handle:0 mask:0 queue:queue];
    if (self) {
        [self setTimerStart:date interval:interval leeway:leeway];
        [self setEventTimerHandler:block];
    }
    return self;
}


+ (instancetype)startedTimerWithInterval:(NSTimeInterval)interval queue:(GODQueue *)queue handler:(GODTimerHandler)block {
    return [self startedTimerWithDate:nil interval:interval leeway:0 queue:queue handler:block];
}


+ (instancetype)startedTimerWithInterval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway queue:(GODQueue *)queue handler:(GODTimerHandler)block {
    return [self startedTimerWithDate:nil interval:interval leeway:leeway queue:queue handler:block];
}


+ (instancetype)startedTimerWithDate:(NSDate *)date interval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway queue:(GODQueue *)queue handler:(GODTimerHandler)block {
    GODTimer *timer = [[self alloc] initWithDate:date interval:interval leeway:leeway queue:queue handler:block];
    [timer start];
    return timer;
}





#pragma mark Handling Timer


- (void)setEventTimerHandler:(GODTimerHandler)block {
    __weak typeof(self) weakSelf = self;
    [self setEventHandler:^{
        // number of times the timer has fired since the last handler invocation
        NSUInteger fireCount = weakSelf.data;
        block(fireCount);
    }];
}





@end
