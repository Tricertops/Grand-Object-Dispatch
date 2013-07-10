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


- (instancetype)initWithDate:(NSDate *)date interval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway queue:(GODQueue *)queue handler:(GODBlock)block {
    self = [super initWithType:GODSourceTypeTimer handle:0 mask:0 queue:queue];
    if (self) {
        [self setTimerStart:date interval:interval leeway:leeway];
        [self setEventHandler:block];
    }
    return self;
}


+ (instancetype)startedTimerWithInterval:(NSTimeInterval)interval queue:(GODQueue *)queue handler:(GODBlock)block {
    return [self startedTimerWithDate:nil interval:interval leeway:0 queue:queue handler:block];
}


+ (instancetype)startedTimerWithInterval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway queue:(GODQueue *)queue handler:(GODBlock)block {
    return [self startedTimerWithDate:nil interval:interval leeway:leeway queue:queue handler:block];
}


+ (instancetype)startedTimerWithDate:(NSDate *)date interval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway queue:(GODQueue *)queue handler:(GODBlock)block {
    GODTimer *timer = [[self alloc] initWithDate:date interval:interval leeway:leeway queue:queue handler:block];
    [timer start];
    return timer;
}





@end
